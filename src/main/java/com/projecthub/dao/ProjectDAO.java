package com.projecthub.dao;

import com.projecthub.entity.Project;
import com.projecthub.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;
import java.util.Optional;

public class ProjectDAO {

    public void save(Project project) {
        Transaction transaction = null;

        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(project);
            transaction.commit();

        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }

            throw new RuntimeException("Unable to save project.", e);
        }
    }

    public List<Project> findAll() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery(
                    "FROM Project p JOIN FETCH p.owner ORDER BY p.createdAt DESC",
                    Project.class
            ).getResultList();
        }
    }

    public Optional<Project> findById(Long id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Project project = session.createQuery(
                            "FROM Project p JOIN FETCH p.owner WHERE p.id = :id",
                            Project.class
                    )
                    .setParameter("id", id)
                    .uniqueResult();

            return Optional.ofNullable(project);
        }
    }

    public List<Project> findByOwnerId(Long ownerId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery(
                            "FROM Project p WHERE p.owner.id = :ownerId ORDER BY p.createdAt DESC",
                            Project.class
                    )
                    .setParameter("ownerId", ownerId)
                    .getResultList();
        }
    }

    public void update(Project project) {
        Transaction transaction = null;

        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(project);
            transaction.commit();

        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }

            throw new RuntimeException("Unable to update project.", e);
        }
    }

    public void delete(Long id) {
        Transaction transaction = null;

        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();

            Project project = session.get(Project.class, id);

            if (project != null) {
                session.remove(project);
            }

            transaction.commit();

        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }

            throw new RuntimeException("Unable to delete project.", e);
        }
    }
}