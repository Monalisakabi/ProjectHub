package com.projecthub.controller;

import com.projecthub.service.FollowService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.projecthub.entity.User;
import java.util.List;

import java.io.IOException;

@WebServlet("/follow")
public class FollowServlet extends HttpServlet {

    private FollowService followService;

    @Override
    public void init() throws ServletException {
        followService = new FollowService();
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        // User must be logged in.
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login"
            );
            return;
        }

        Long followerId;

        try {
            Object sessionUserId = session.getAttribute("userId");

            if (!(sessionUserId instanceof Number)) {
                response.sendError(
                        HttpServletResponse.SC_UNAUTHORIZED,
                        "Invalid login session."
                );
                return;
            }

            followerId = ((Number) sessionUserId).longValue();

        } catch (Exception e) {
            response.sendError(
                    HttpServletResponse.SC_UNAUTHORIZED
            );
            return;
        }

        String followedIdParameter =
                request.getParameter("followedId");

        String action = request.getParameter("action");

        if (followedIdParameter == null ||
                followedIdParameter.isBlank()) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Target user ID is required."
            );
            return;
        }

        Long followedId;

        try {
            followedId = Long.parseLong(followedIdParameter);

            if (followedId <= 0) {
                throw new NumberFormatException();
            }

        } catch (NumberFormatException e) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid target user ID."
            );
            return;
        }

        try {
            if ("follow".equals(action)) {
                followService.followUser(followerId, followedId);

            } else if ("unfollow".equals(action)) {
                followService.unfollowUser(followerId, followedId);

            } else {
                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Invalid action."
                );
                return;
            }

            // Redirect to a fixed, local page.
            response.sendRedirect(
                    request.getContextPath() + "/dashboard.jsp"
            );

        } catch (IllegalArgumentException e) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    e.getMessage()
            );
        } catch (RuntimeException e) {
            throw new ServletException(
                    "Unable to process follow request.", e
            );
        }
    }
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || !(session.getAttribute("userId") instanceof Number)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Long currentUserId =
                ((Number) session.getAttribute("userId")).longValue();

        try {
            List<User> users = followService.getOtherUsers(currentUserId);

            request.setAttribute("otherUsers", users);

            request.getRequestDispatcher("/dashboard.jsp")
                    .forward(request, response);

        } catch (RuntimeException e) {
            throw new ServletException("Unable to load developers.", e);
        }
    }
}
