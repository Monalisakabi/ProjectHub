package com.projecthub.controller;

import com.projecthub.entity.User;
import com.projecthub.service.FollowService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/search-developers")
public class DeveloperSearchServlet extends HttpServlet {

    private final FollowService followService = new FollowService();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Login required
        if (session == null ||
                !(session.getAttribute("userId") instanceof Number)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Long currentUserId =
                ((Number) session.getAttribute("userId")).longValue();

        String searchName = request.getParameter("name");

        if (searchName == null) {
            searchName = "";
        }

        searchName = searchName.trim();

        request.setAttribute("searchName", searchName);

        if (searchName.isEmpty()) {
            request.setAttribute("searchResults", java.util.Collections.emptyList());
        } else {
            List<User> searchResults =
                    followService.searchDevelopers(searchName, currentUserId);

            request.setAttribute("searchResults", searchResults);
        }

        request.getRequestDispatcher("/search-developers.jsp")
                .forward(request, response);
    }
}
