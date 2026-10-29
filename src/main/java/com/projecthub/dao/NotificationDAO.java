package com.projecthub.dao;

import com.projecthub.entity.Notification;
import com.projecthub.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class NotificationDAO {

    public void save(Notification notification) {
        Transaction transaction = null;

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            transaction = session.beginTransaction();
            session.persist(notification);
            transaction.commit();

        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }

            throw new RuntimeException(
                    "Unable to save notification.", e);
        }
    }

    public List<Notification> findByUserId(Long userId) {
        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            return session.createQuery(
                            "FROM Notification n " +
                                    "WHERE n.user.id = :userId " +
                                    "ORDER BY n.createdAt DESC",
                            Notification.class)
                    .setParameter("userId", userId)
                    .getResultList();
        }
    }

    public long countUnreadByUserId(Long userId) {
        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            return session.createQuery(
                            "SELECT COUNT(n) FROM Notification n " +
                                    "WHERE n.user.id = :userId " +
                                    "AND n.read = false",
                            Long.class)
                    .setParameter("userId", userId)
                    .getSingleResult();
        }
    }
    public void markAsRead(Long notificationId, Long userId) {
        Transaction transaction = null;

        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();

            Notification notification = session.createQuery(
                            "FROM Notification n " +
                                    "WHERE n.id = :notificationId " +
                                    "AND n.user.id = :userId",
                            Notification.class)
                    .setParameter("notificationId", notificationId)
                    .setParameter("userId", userId)
                    .uniqueResult();

            if (notification == null) {
                throw new IllegalArgumentException(
                        "Notification not found or access denied.");
            }

            notification.setRead(true);

            transaction.commit();

        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }

            throw new RuntimeException(
                    "Unable to mark notification as read.", e);
        }
    }
}

