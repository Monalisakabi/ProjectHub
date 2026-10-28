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

@WebServlet("/followers")
public class FollowersServlet extends HttpServlet {

    private final FollowService followService = new FollowService();

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

        Long userId;

        try {
            userId = Long.valueOf(session.getAttribute("userId").toString());
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid user session.");
            return;
        }

        List<User> followers = followService.getFollowers(userId);

        request.setAttribute("followers", followers);

        request.getRequestDispatcher("/followers.jsp")
                .forward(request, response);
    }

}
