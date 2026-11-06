package com.projecthub.controller;

import com.projecthub.entity.JoinRequest;
import com.projecthub.entity.Project;
import com.projecthub.entity.User;
import com.projecthub.service.JoinRequestService;
import com.projecthub.service.ProjectService;
import com.projecthub.util.HibernateUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.hibernate.Session;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet("/join-requests")
public class JoinRequestServlet extends HttpServlet {

    private final JoinRequestService joinRequestService =
            new JoinRequestService();

    private final ProjectService projectService =
            new ProjectService();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession httpSession = request.getSession(false);

        if (httpSession == null ||
                httpSession.getAttribute("userId") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if (!"list".equals(action)) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid join request action.");
            return;
        }

        try {
            Long projectId = Long.parseLong(
                    request.getParameter("projectId"));

            Long currentUserId =
                    ((Number) httpSession.getAttribute("userId")).longValue();

            Optional<Project> optionalProject =
                    projectService.getProjectById(projectId);

            if (optionalProject.isEmpty()) {
                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "Project not found.");
                return;
            }

            Project project = optionalProject.get();

            if (!currentUserId.equals(project.getOwner().getId())) {
                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN,
                        "Only the project owner can view join requests.");
                return;
            }

            List<JoinRequest> requests =
                    joinRequestService.getRequestsForProject(projectId);

            request.setAttribute("project", project);
            request.setAttribute("joinRequests", requests);

            request.getRequestDispatcher("/join-requests.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid project ID.");
        } catch (IllegalArgumentException e) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession httpSession = request.getSession(false);

        if (httpSession == null ||
                httpSession.getAttribute("userId") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        Long currentUserId =
                ((Number) httpSession.getAttribute("userId")).longValue();

        String action = request.getParameter("action");

        try {
            if ("create".equals(action)) {
                createRequest(request, response, currentUserId);
            } else if ("process".equals(action)) {
                processRequest(request, response, currentUserId);
            } else {
                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Invalid join request action.");
            }

        } catch (NumberFormatException e) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid ID.");
        } catch (IllegalArgumentException e) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    e.getMessage());
        } catch (RuntimeException e) {
            throw new ServletException(
                    "Unable to process join request.", e);
        }
    }

    private void createRequest(HttpServletRequest request,
                               HttpServletResponse response,
                               Long currentUserId)
            throws IOException {

        Long projectId = Long.parseLong(
                request.getParameter("projectId"));

        Optional<Project> optionalProject =
                projectService.getProjectById(projectId);

        if (optionalProject.isEmpty()) {
            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Project not found.");
            return;
        }

        Project project = optionalProject.get();

        User user;

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {
            user = session.get(User.class, currentUserId);
        }

        if (user == null) {
            response.sendError(
                    HttpServletResponse.SC_UNAUTHORIZED,
                    "User not found. Please log in again.");
            return;
        }

        JoinRequest joinRequest = new JoinRequest();
        joinRequest.setProject(project);
        joinRequest.setUser(user);

        if (joinRequestService.hasPendingRequest(projectId, currentUserId)) {

            joinRequestService.cancelRequest(projectId, currentUserId);

        } else {

            joinRequestService.createRequest(joinRequest);
        }

        response.sendRedirect(
                request.getContextPath() + "/projects?action=view&id="
                        + projectId);
    }

    private void processRequest(HttpServletRequest request,
                                HttpServletResponse response,
                                Long currentUserId)
            throws IOException {

        Long requestId = Long.parseLong(
                request.getParameter("requestId"));

        String decision = request.getParameter("decision");

        joinRequestService.processRequest(
                requestId, currentUserId, decision);

        response.sendRedirect(
                request.getContextPath() + "/projects");
    }
}

