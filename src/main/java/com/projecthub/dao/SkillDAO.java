package com.projecthub.dao;

import com.projecthub.entity.Skill;
import com.projecthub.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;
import java.util.Optional;

public class SkillDAO {

    public Skill save(Skill skill) {
        Transaction transaction = null;

        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();

            session.persist(skill);

            transaction.commit();
            return skill;

        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            throw new RuntimeException("Failed to save skill.", e);
        }
    }

    public Optional<Skill> findByName(String name) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery(
                            "FROM Skill s WHERE lower(s.name) = :name",
                            Skill.class
                    )
                    .setParameter("name", name.trim().toLowerCase())
                    .uniqueResultOptional();
        }
    }

    public List<Skill> findAll() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery(
                    "FROM Skill s ORDER BY s.name",
                    Skill.class
            ).getResultList();
        }
    }

    public Optional<Skill> findById(Long id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return Optional.ofNullable(session.find(Skill.class, id));
        }
    }
}