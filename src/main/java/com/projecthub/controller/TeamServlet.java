package com.projecthub.controller;

import com.projecthub.entity.Project;
import com.projecthub.entity.User;
import com.projecthub.service.ProjectMemberService;
import com.projecthub.dao.ProjectDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/team")
public class TeamServlet extends HttpServlet {

    private final ProjectDAO projectDAO = new ProjectDAO();
    private final ProjectMemberService projectMemberService =
            new ProjectMemberService();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            Long projectId = Long.parseLong(request.getParameter("projectId"));

            Project project = projectDAO.findById(projectId).orElse(null);
            if (project == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND,
                        "Project not found");
                return;
            }

            request.setAttribute("project", project);
            request.setAttribute("teamMembers",
                    projectMemberService.getProjectMembers(projectId));

            request.getRequestDispatcher("/team-dashboard.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid project ID");
        }
    }
}