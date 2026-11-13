package com.projecthub.controller;

import com.projecthub.dao.UserDAO;
import com.projecthub.entity.User;
import com.projecthub.service.FollowService;
import com.projecthub.service.SkillService;
import com.projecthub.entity.Skill;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final SkillService skillService = new SkillService();
    private final FollowService followService = new FollowService();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Long userId = ((Number) session.getAttribute("userId")).longValue();

        User user = userDAO.findById(userId);

        if (user == null) {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        request.setAttribute("profileUser", user);

        // Skills
        List<Skill> allSkills = skillService.getAllSkills();
        request.setAttribute("allSkills", allSkills);
        request.setAttribute("mySkills", user.getSkills());

        // Followers / Following
        Long followerCount = followService.getFollowerCount(userId);
        Long followingCount = followService.getFollowingCount(userId);

        request.setAttribute("followerCount", followerCount);
        request.setAttribute("followingCount", followingCount);

        request.getRequestDispatcher("/profile.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Long userId = ((Number) session.getAttribute("userId")).longValue();

        String action = request.getParameter("action");

        // Add skill
        if ("addSkill".equals(action)) {

            String skillIdValue = request.getParameter("skillId");

            try {
                Long skillId = Long.parseLong(skillIdValue);

                if (skillId <= 0) {
                    response.sendError(
                            HttpServletResponse.SC_BAD_REQUEST,
                            "Invalid skill selected."
                    );
                    return;
                }

                boolean added = userDAO.addSkillToUser(userId, skillId);

                if (!added) {
                    response.sendError(
                            HttpServletResponse.SC_BAD_REQUEST,
                            "Invalid skill or user."
                    );
                    return;
                }

                response.sendRedirect(
                        request.getContextPath()
                                + "/profile?skillAdded=true"
                );
                return;

            } catch (NumberFormatException e) {

                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Invalid skill selected."
                );
                return;
            }
        }

        // Update profile
        String name = request.getParameter("name");
        String bio = request.getParameter("bio");
        String githubUrl = request.getParameter("githubUrl");
        String linkedinUrl = request.getParameter("linkedinUrl");

        if (name == null || name.isBlank()) {

            request.setAttribute(
                    "error",
                    "Name is required."
            );

            doGet(request, response);
            return;
        }

        if (name.trim().length() > 100
                || (bio != null && bio.length() > 1000)
                || (githubUrl != null && githubUrl.length() > 255)
                || (linkedinUrl != null && linkedinUrl.length() > 255)) {

            request.setAttribute(
                    "error",
                    "One or more fields exceed the allowed length."
            );

            doGet(request, response);
            return;
        }

        User user = userDAO.findById(userId);

        if (user == null) {

            session.invalidate();

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );

            return;
        }

        user.setName(name.trim());
        user.setBio(clean(bio));
        user.setGithubUrl(clean(githubUrl));
        user.setLinkedinUrl(clean(linkedinUrl));

        userDAO.update(user);

        session.setAttribute(
                "userName",
                user.getName()
        );

        response.sendRedirect(
                request.getContextPath()
                        + "/profile?updated=true"
        );
    }

    private String clean(String value) {

        if (value == null || value.isBlank()) {
            return null;
        }

        return value.trim();
    }
}