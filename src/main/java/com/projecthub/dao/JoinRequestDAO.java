package com.projecthub.dao;

import com.projecthub.entity.JoinRequest;
import com.projecthub.entity.ProjectMember;
import com.projecthub.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import com.projecthub.entity.Notification;
import com.projecthub.entity.Project;
import com.projecthub.entity.User;

import java.util.List;

public class JoinRequestDAO {

    public void save(JoinRequest joinRequest) {
        Transaction transaction = null;

        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();

            // Get the project and requester IDs
            Long projectId = joinRequest.getProject().getId();
            Long requesterId = joinRequest.getUser().getId();

            // Load the project and its owner
            Project project = session.createQuery(
                            "FROM Project p JOIN FETCH p.owner WHERE p.id = :projectId",
                            Project.class)
                    .setParameter("projectId", projectId)
                    .uniqueResult();

            if (project == null) {
                throw new IllegalArgumentException("Project not found.");
            }

            // Load the user who submitted the request
            User requester = session.get(User.class, requesterId);

            if (requester == null) {
                throw new IllegalArgumentException("Requesting user not found.");
            }

            // Save the join request using managed entities
            joinRequest.setProject(project);
            joinRequest.setUser(requester);
            session.persist(joinRequest);

            // Create a notification for the project owner
            Notification notification = new Notification();

            notification.setUser(project.getOwner());

            notification.setMessage(
                    requester.getName()
                            + " has requested to join your project '"
                            + project.getTitle()
                            + "'."
            );

            session.persist(notification);

            // Save both operations together
            transaction.commit();

        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }

            throw new RuntimeException(
                    "Unable to save join request and notification.", e);
        }
    }

    public List<JoinRequest> findByProjectId(Long projectId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery(
                            "FROM JoinRequest jr " +
                                    "JOIN FETCH jr.user " +
                                    "JOIN FETCH jr.project " +
                                    "WHERE jr.project.id = :projectId " +
                                    "ORDER BY jr.createdAt DESC",
                            JoinRequest.class)
                    .setParameter("projectId", projectId)
                    .getResultList();
        }
    }

    public boolean hasPendingRequest(Long projectId, Long userId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Long count = session.createQuery(
                            "SELECT COUNT(jr) FROM JoinRequest jr " +
                                    "WHERE jr.project.id = :projectId " +
                                    "AND jr.user.id = :userId " +
                                    "AND jr.status = 'PENDING'",
                            Long.class)
                    .setParameter("projectId", projectId)
                    .setParameter("userId", userId)
                    .getSingleResult();

            return count > 0;
        }
    }

    public void cancelPendingRequest(Long projectId, Long userId) {

        Transaction transaction = null;

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            transaction = session.beginTransaction();

            JoinRequest request = session.createQuery(
                            "FROM JoinRequest jr " +
                                    "WHERE jr.project.id = :projectId " +
                                    "AND jr.user.id = :userId " +
                                    "AND jr.status = 'PENDING'",
                            JoinRequest.class)
                    .setParameter("projectId", projectId)
                    .setParameter("userId", userId)
                    .uniqueResult();

            if (request == null) {
                throw new IllegalArgumentException(
                        "No pending request found.");
            }

            request.setStatus("CANCELLED");

            transaction.commit();

        } catch (Exception e) {

            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }

            throw new RuntimeException(
                    "Unable to cancel join request.", e);
        }
    }


    public JoinRequest findById(Long requestId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery(
                            "FROM JoinRequest jr " +
                                    "JOIN FETCH jr.user " +
                                    "JOIN FETCH jr.project " +
                                    "WHERE jr.id = :requestId",
                            JoinRequest.class)
                    .setParameter("requestId", requestId)
                    .uniqueResult();
        }
    }

    public void updateStatus(Long requestId, String status) {
        Transaction transaction = null;

        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();

            JoinRequest request = session.get(JoinRequest.class, requestId);

            if (request == null) {
                throw new IllegalArgumentException("Join request not found.");
            }

            request.setStatus(status);
            transaction.commit();

        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            throw new RuntimeException("Unable to update join request.", e);
        }
    }


    public void processRequest(Long requestId, Long ownerId, String decision) {
        if (!"ACCEPTED".equals(decision) && !"REJECTED".equals(decision)) {
            throw new IllegalArgumentException("Invalid decision.");
        }

        Transaction transaction = null;

        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();

            JoinRequest request = session.createQuery(
                            "FROM JoinRequest jr " +
                                    "JOIN FETCH jr.project p " +
                                    "JOIN FETCH p.owner " +
                                    "JOIN FETCH jr.user " +
                                    "WHERE jr.id = :requestId",
                            JoinRequest.class)
                    .setParameter("requestId", requestId)
                    .uniqueResult();

            if (request == null) {
                throw new IllegalArgumentException("Join request not found.");
            }

            if (!ownerId.equals(request.getProject().getOwner().getId())) {
                throw new IllegalArgumentException(
                        "Only the project owner can process this request.");
            }

            if (!"PENDING".equals(request.getStatus())) {
                throw new IllegalArgumentException(
                        "This request has already been processed.");
            }

            if ("ACCEPTED".equals(decision)) {
                Long memberCount = session.createQuery(
                                "SELECT COUNT(pm) FROM ProjectMember pm " +
                                        "WHERE pm.project.id = :projectId " +
                                        "AND pm.user.id = :userId",
                                Long.class)
                        .setParameter("projectId", request.getProject().getId())
                        .setParameter("userId", request.getUser().getId())
                        .getSingleResult();

                if (memberCount == 0) {
                    ProjectMember member = new ProjectMember();
                    member.setProject(request.getProject());
                    member.setUser(request.getUser());
                    session.persist(member);
                }
            }

            request.setStatus(decision);
            Notification notification = new Notification();
            notification.setUser(request.getUser());

            String message;

            if ("ACCEPTED".equals(decision)) {
                message = "Your request to join project '"
                        + request.getProject().getTitle()
                        + "' has been accepted.";
            } else {
                message = "Your request to join project '"
                        + request.getProject().getTitle()
                        + "' has been rejected.";
            }

            notification.setMessage(message);
            session.persist(notification);
            transaction.commit();

        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            throw new RuntimeException("Unable to process join request.", e);
        }
    }




}

