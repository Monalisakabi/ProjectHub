package com.projecthub.controller;

import com.projecthub.entity.Notification;
import com.projecthub.service.NotificationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/notifications")
public class NotificationServlet extends HttpServlet {

    private final NotificationService notificationService =
            new NotificationService();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        Long userId = Long.valueOf(
                session.getAttribute("userId").toString());

        List<Notification> notifications =
                notificationService.getNotifications(userId);

        long unreadCount =
                notificationService.getUnreadCount(userId);

        request.setAttribute("notifications", notifications);
        request.setAttribute("unreadCount", unreadCount);

        request.getRequestDispatcher("/notifications.jsp")
                .forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if (!"markAsRead".equals(action)) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid notification action.");
            return;
        }

        try {
            Long notificationId = Long.valueOf(
                    request.getParameter("notificationId"));

            Long userId = Long.valueOf(
                    session.getAttribute("userId").toString());

            notificationService.markAsRead(notificationId, userId);

            response.sendRedirect(
                    request.getContextPath() + "/notifications");

        } catch (NumberFormatException e) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid notification ID.");
        }
    }
}