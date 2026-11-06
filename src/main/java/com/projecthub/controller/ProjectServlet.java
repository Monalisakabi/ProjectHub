package com.projecthub.controller;

import com.projecthub.entity.Project;
import com.projecthub.entity.User;
import com.projecthub.service.ProjectService;
import com.projecthub.util.HibernateUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.projecthub.service.SkillService;
import com.projecthub.entity.Skill;
import com.projecthub.service.JoinRequestService;

import java.util.HashSet;
import java.util.Set;

import org.hibernate.Session;

import java.io.IOException;
import java.util.List;
import java.util.Optional;
import com.projecthub.service.ProjectMemberService;

@WebServlet("/projects")
public class ProjectServlet extends HttpServlet {

    private final ProjectService projectService = new ProjectService();
    private final SkillService skillService = new SkillService();
    private final JoinRequestService joinRequestService =
            new JoinRequestService();
    private final ProjectMemberService projectMemberService =
            new ProjectMemberService();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if ("create".equals(action)) {
                if (!isLoggedIn(request)) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }

                loadAvailableSkills(request);

                request.getRequestDispatcher("/create-project.jsp")
                        .forward(request, response);
            }

             else if ("view".equals(action)) {
                viewProject(request, response);

            } else if ("edit".equals(action)) {
                editProject(request, response);

            } else {
                listProjects(request, response);
            }

        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        } catch (Exception e) {
            throw new ServletException("Unable to process project request.", e);
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        if (!isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        try {
            if ("create".equals(action)) {
                createProject(request, response);

            } else if ("update".equals(action)) {
                updateProject(request, response);

            } else if ("delete".equals(action)) {
                deleteProject(request, response);

            } else {
                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Invalid project action."
                );
            }

        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", e.getMessage());

            if ("update".equals(action)) {
                editProject(request, response);
            } else {
            loadAvailableSkills(request);

            request.getRequestDispatcher("/create-project.jsp")
                    .forward(request, response);
        }

        } catch (Exception e) {
            throw new ServletException("Unable to process project request.", e);
        }
    }

    private void listProjects(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");

        List<Project> projects;

        if (keyword != null && !keyword.trim().isEmpty()) {
            projects = projectService.searchProjects(keyword.trim());
            request.setAttribute("keyword", keyword);
        } else {
            projects = projectService.getAllProjects();
        }

        request.setAttribute("projects", projects);

        request.getRequestDispatcher("/projects.jsp")
                .forward(request, response);
    }

    private void viewProject(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        Long projectId = parseProjectId(request);

        Optional<Project> result =
                projectService.getProjectById(projectId);

        if (result.isEmpty()) {
            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Project not found.");
            return;
        }

        Project project = result.get();

        request.setAttribute("project", project);
        Long memberCount =
                projectMemberService.getMemberCount(projectId);

        int remainingMembers =
                project.getRequiredMembers() - memberCount.intValue();

        if (remainingMembers < 0) {
            remainingMembers = 0;
        }

        request.setAttribute(
                "remainingMembers",
                remainingMembers);

        // Check whether the logged-in user has a pending join request
        if (isLoggedIn(request)) {

            Long currentUserId = getCurrentUserId(request);

            boolean hasPendingRequest =
                    joinRequestService.hasPendingRequest(
                            projectId,
                            currentUserId);

            request.setAttribute(
                    "hasPendingJoinRequest",
                    hasPendingRequest);
        }
        if (isLoggedIn(request)) {
            Long currentUserId = getCurrentUserId(request);

            boolean isMember =
                    projectMemberService.isMember(projectId, currentUserId);

            request.setAttribute(
                    "isProjectMember",
                    isMember);
        }

        request.getRequestDispatcher("/project-details.jsp")
                .forward(request, response);
    }

    private void editProject(

            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        Long projectId = parseProjectId(request);
        Long currentUserId = getCurrentUserId(request);

        Project project = projectService.getProjectById(projectId)
                .orElseThrow(() -> new IllegalArgumentException("Project not found."));

        if (project.getOwner() == null
                || !currentUserId.equals(project.getOwner().getId())) {
            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "You can only edit your own projects."
            );
            return;
        }

        request.setAttribute("project", project);

        loadAvailableSkills(request);
        request.getRequestDispatcher("/create-project.jsp")
                .forward(request, response);
    }

    private void createProject(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        Long userId = getCurrentUserId(request);
        User owner = findUserById(userId);

        if (owner == null) {
            request.getSession().invalidate();
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        projectService.createProject(
                owner,
                request.getParameter("title"),
                request.getParameter("description"),
                request.getParameter("techStack"),
                request.getParameter("projectType"),
                Integer.parseInt(request.getParameter("requiredMembers")),
                request.getParameter("status"),
                request.getParameter("githubUrl"),
                request.getParameter("demoUrl"),
                parseSkillIds(request.getParameterValues("requiredSkillIds"))
        );

        response.sendRedirect(request.getContextPath() + "/projects");
    }

    private void updateProject(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        Long projectId = parseProjectId(request);
        Long currentUserId = getCurrentUserId(request);

        projectService.updateProject(
                projectId,
                currentUserId,
                request.getParameter("title"),
                request.getParameter("description"),
                request.getParameter("techStack"),
                request.getParameter("projectType"),
                Integer.parseInt(request.getParameter("requiredMembers")),
                request.getParameter("status"),
                request.getParameter("githubUrl"),
                request.getParameter("demoUrl"),
                parseSkillIds(request.getParameterValues("requiredSkillIds"))
        );

        response.sendRedirect(
                request.getContextPath() + "/projects?action=view&id=" + projectId
        );
    }

    private void deleteProject(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        Long projectId = parseProjectId(request);
        Long currentUserId = getCurrentUserId(request);

        projectService.deleteProject(projectId, currentUserId);

        response.sendRedirect(request.getContextPath() + "/projects");
    }
    private void loadAvailableSkills(HttpServletRequest request) {
        request.setAttribute("availableSkills", skillService.getAllSkills());
    }
    private Set<Long> parseSkillIds(String[] skillIds) {
        Set<Long> result = new HashSet<>();

        if (skillIds != null) {
            for (String id : skillIds) {
                result.add(Long.parseLong(id));
            }
        }

        return result;
    }

    private User findUserById(Long userId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(User.class, userId);
        }
    }

    private boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        return session != null && session.getAttribute("userId") != null;
    }

    private Long getCurrentUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            throw new IllegalArgumentException("Please log in first.");
        }

        Object value = session.getAttribute("userId");

        if (value instanceof Number) {
            return ((Number) value).longValue();
        }

        return Long.parseLong(value.toString());
    }

    private Long parseProjectId(HttpServletRequest request) {
        String id = request.getParameter("id");

        if (id == null || id.trim().isEmpty()) {
            throw new IllegalArgumentException("Project ID is required.");
        }

        try {
            return Long.parseLong(id);
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid project ID.");
        }
    }
}