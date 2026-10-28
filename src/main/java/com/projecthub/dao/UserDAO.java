package com.projecthub.dao;

import com.projecthub.entity.User;
import com.projecthub.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

import java.util.Optional;

public class UserDAO {

    public void save(User user) {
        Transaction transaction = null;

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            transaction = session.beginTransaction();

            session.persist(user);

            transaction.commit();

        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }

            throw new RuntimeException("Unable to save user.", e);
        }
    }

    public Optional<User> findByEmail(String email) {
        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            User user = session.createQuery(
                            "FROM User u WHERE u.email = :email",
                            User.class)
                    .setParameter("email", email)
                    .uniqueResult();

            return Optional.ofNullable(user);
        }
    }
    public java.util.List<User> findAllExcept(Long userId) {
        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            return session.createQuery(
                            "FROM User u WHERE u.id <> :userId ORDER BY u.name",
                            User.class)
                    .setParameter("userId", userId)
                    .getResultList();

        } catch (Exception e) {
            throw new RuntimeException(
                    "Unable to fetch other users.", e
            );
        }
    }
    public User findById(Long id) {
        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            return session.get(User.class, id);

        } catch (Exception e) {
            throw new RuntimeException("Unable to find user by ID.", e);
        }
    }

    public void update(User user) {
        Transaction transaction = null;

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            transaction = session.beginTransaction();

            session.merge(user);

            transaction.commit();

        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }

            throw new RuntimeException("Unable to update user.", e);
        }
    }
    public List<User> searchUsersByName(String name, Long currentUserId) {
        if (name == null || name.trim().isEmpty()) {
            return java.util.Collections.emptyList();
        }

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            return session.createQuery(
                            "FROM User u " +
                                    "WHERE u.id <> :userId " +
                                    "AND LOWER(u.name) LIKE :name " +
                                    "ORDER BY u.name",
                            User.class)
                    .setParameter("userId", currentUserId)
                    .setParameter("name", "%" + name.trim().toLowerCase() + "%")
                    .setMaxResults(50)
                    .getResultList();

        } catch (Exception e) {
            throw new RuntimeException(
                    "Unable to search developers.", e
            );
        }
    }

}