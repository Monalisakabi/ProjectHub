package com.projecthub.service;

import com.projecthub.dao.NotificationDAO;
import com.projecthub.entity.Notification;
import com.projecthub.entity.User;

import java.util.List;

public class NotificationService {

    private final NotificationDAO notificationDAO =
            new NotificationDAO();

    public void createNotification(User user, String message) {
        if (user == null || user.getId() == null) {
            throw new IllegalArgumentException(
                    "A valid notification recipient is required.");
        }

        if (message == null || message.trim().isEmpty()) {
            throw new IllegalArgumentException(
                    "Notification message is required.");
        }

        Notification notification =
                new Notification(user, message.trim());

        notificationDAO.save(notification);
    }

    public List<Notification> getNotifications(Long userId) {
        if (userId == null) {
            throw new IllegalArgumentException("User ID is required.");
        }

        return notificationDAO.findByUserId(userId);
    }

    public long getUnreadCount(Long userId) {
        if (userId == null) {
            throw new IllegalArgumentException("User ID is required.");
        }

        return notificationDAO.countUnreadByUserId(userId);
    }
    public void markAsRead(Long notificationId, Long userId) {
        if (notificationId == null || userId == null) {
            throw new IllegalArgumentException(
                    "Notification ID and user ID are required.");
        }

        notificationDAO.markAsRead(notificationId, userId);
    }
}

