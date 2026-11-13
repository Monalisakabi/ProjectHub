package com.projecthub.dao;

import com.projecthub.entity.Follow;
import com.projecthub.entity.User;
import com.projecthub.util.HibernateUtil;
import java.util.List;
import java.util.Set;
import java.util.HashSet;
import org.hibernate.Session;
import org.hibernate.Transaction;
import com.projecthub.entity.Notification;

import java.util.Optional;

public class FollowDAO {

    public boolean followUser(Long followerId, Long followedId) {

        if (followerId == null || followedId == null) {
            throw new IllegalArgumentException("User IDs cannot be null.");
        }

        if (followerId.equals(followedId)) {
            throw new IllegalArgumentException("You cannot follow yourself.");
        }

        Transaction transaction = null;

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            transaction = session.beginTransaction();

            User follower = session.get(User.class, followerId);
            User followed = session.get(User.class, followedId);

            if (follower == null || followed == null) {
                transaction.rollback();
                return false;
            }

            Optional<Follow> existingFollow = session.createQuery(
                            "FROM Follow f WHERE f.follower.id = :followerId " +
                                    "AND f.followed.id = :followedId",
                            Follow.class
                    )
                    .setParameter("followerId", followerId)
                    .setParameter("followedId", followedId)
                    .uniqueResultOptional();

            if (existingFollow.isPresent()) {
                transaction.rollback();
                return false;
            }

            Follow follow = new Follow(follower, followed);
            session.persist(follow);

// Create notification for the followed user.
            Notification notification = new Notification(
                    followed,
                    follower.getName() + " started following you."
            );

            session.persist(notification);

            transaction.commit();
            return true;

        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            throw new RuntimeException("Could not follow user.", e);
        }
    }

    public boolean unfollowUser(Long followerId, Long followedId) {

        if (followerId == null || followedId == null) {
            throw new IllegalArgumentException("User IDs cannot be null.");
        }

        Transaction transaction = null;

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            transaction = session.beginTransaction();

            int deleted = session.createMutationQuery(
                            "DELETE FROM Follow f " +
                                    "WHERE f.follower.id = :followerId " +
                                    "AND f.followed.id = :followedId"
                    )
                    .setParameter("followerId", followerId)
                    .setParameter("followedId", followedId)
                    .executeUpdate();

            transaction.commit();
            return deleted > 0;

        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            throw new RuntimeException("Could not unfollow user.", e);
        }
    }

    public boolean isFollowing(Long followerId, Long followedId) {

        if (followerId == null || followedId == null) {
            return false;
        }

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            Long count = session.createQuery(
                            "SELECT COUNT(f) FROM Follow f " +
                                    "WHERE f.follower.id = :followerId " +
                                    "AND f.followed.id = :followedId",
                            Long.class
                    )
                    .setParameter("followerId", followerId)
                    .setParameter("followedId", followedId)
                    .uniqueResult();

            return count != null && count > 0;
        }
    }
    public List<User> getAllOtherUsers(Long currentUserId) {
        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            return session.createQuery(
                            "FROM User u WHERE u.id <> :currentUserId ORDER BY u.name ASC",
                            User.class)
                    .setParameter("currentUserId", currentUserId)
                    .getResultList();
        }
    }

    public Set<Long> getFollowingUserIds(Long currentUserId) {
        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            List<Long> followedIds = session.createQuery(
                            "SELECT f.followed.id FROM Follow f " +
                                    "WHERE f.follower.id = :currentUserId",
                            Long.class)
                    .setParameter("currentUserId", currentUserId)
                    .getResultList();

            return new HashSet<>(followedIds);
        }
    }

    // Get users who follow the specified user
    public List<User> getFollowers(Long userId) {
        if (userId == null) {
            throw new IllegalArgumentException("User ID cannot be null.");
        }

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            return session.createQuery(
                            "SELECT f.follower FROM Follow f " +
                                    "WHERE f.followed.id = :userId " +
                                    "ORDER BY f.follower.name ASC",
                            User.class)
                    .setParameter("userId", userId)
                    .getResultList();
        }
    }

    // Get users followed by the specified user
    public List<User> getFollowing(Long userId) {
        if (userId == null) {
            throw new IllegalArgumentException("User ID cannot be null.");
        }

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            return session.createQuery(
                            "SELECT f.followed FROM Follow f " +
                                    "WHERE f.follower.id = :userId " +
                                    "ORDER BY f.followed.name ASC",
                            User.class)
                    .setParameter("userId", userId)
                    .getResultList();
        }
    }
    public Long countFollowers(Long userId) {
        if (userId == null) {
            return 0L;
        }

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            return session.createQuery(
                            "SELECT COUNT(f) FROM Follow f " +
                                    "WHERE f.followed.id = :userId",
                            Long.class)
                    .setParameter("userId", userId)
                    .getSingleResult();
        }
    }

    public Long countFollowing(Long userId) {
        if (userId == null) {
            return 0L;
        }

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            return session.createQuery(
                            "SELECT COUNT(f) FROM Follow f " +
                                    "WHERE f.follower.id = :userId",
                            Long.class)
                    .setParameter("userId", userId)
                    .getSingleResult();
        }
    }
}

