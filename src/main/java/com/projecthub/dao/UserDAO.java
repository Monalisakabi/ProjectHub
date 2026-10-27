package com.projecthub.dao;

import com.projecthub.entity.User;
import com.projecthub.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

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
}