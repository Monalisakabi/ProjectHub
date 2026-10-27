package com.projecthub.controller;

import com.projecthub.dao.UserDAO;
import com.projecthub.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/public-profile")
public class PublicProfileServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Login required
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String idParameter = request.getParameter("id");

        // Validate profile ID
        if (idParameter == null || !idParameter.matches("\\d+")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid developer ID.");
            return;
        }

        Long developerId;

        try {
            developerId = Long.parseLong(idParameter);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid developer ID.");
            return;
        }

        User developer = userDAO.findById(developerId);

        if (developer == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND,
                    "Developer not found.");
            return;
        }

        request.setAttribute("profileUser", developer);

        request.getRequestDispatcher("/public-profile.jsp")
                .forward(request, response);
    }
}
