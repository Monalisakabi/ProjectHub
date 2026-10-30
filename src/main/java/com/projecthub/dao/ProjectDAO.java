package com.projecthub.dao;

import com.projecthub.entity.Project;
import com.projecthub.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import com.projecthub.entity.Skill;
import java.util.Set;

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
    public void saveWithSkills(Project project, Set<Long> skillIds) {
        Transaction transaction = null;

        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();

            if (skillIds != null) {
                for (Long skillId : skillIds) {
                    Skill skill = session.get(Skill.class, skillId);

                    if (skill == null) {
                        throw new IllegalArgumentException("Invalid skill selected.");
                    }

                    project.getRequiredSkills().add(skill);
                }
            }

            session.persist(project);
            transaction.commit();

        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }

            if (e instanceof IllegalArgumentException) {
                throw (IllegalArgumentException) e;
            }

            throw new RuntimeException("Unable to save project with skills.", e);
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
                            "FROM Project p " +
                                    "JOIN FETCH p.owner " +
                                    "LEFT JOIN FETCH p.requiredSkills " +
                                    "WHERE p.id = :id",
                            Project.class
                    )
                    .setParameter("id", id)
                    .uniqueResult();

            return Optional.ofNullable(project);
        }
    }
    public List<Project> search(String keyword) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {

            String searchKeyword = "%" + keyword.toLowerCase().trim() + "%";

            return session.createQuery(
                            "FROM Project p JOIN FETCH p.owner " +
                                    "WHERE LOWER(p.title) LIKE :keyword " +
                                    "OR LOWER(p.description) LIKE :keyword " +
                                    "OR LOWER(p.techStack) LIKE :keyword " +
                                    "ORDER BY p.createdAt DESC",
                            Project.class)
                    .setParameter("keyword", searchKeyword)
                    .getResultList();
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
    public void updateWithSkills(Project project, Set<Long> skillIds) {
        Transaction transaction = null;

        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();

            Project existingProject = session.get(Project.class, project.getId());

            if (existingProject == null) {
                throw new IllegalArgumentException("Project not found.");
            }

            existingProject.setTitle(project.getTitle());
            existingProject.setDescription(project.getDescription());
            existingProject.setTechStack(project.getTechStack());
            existingProject.setProjectType(project.getProjectType());
            existingProject.setRequiredMembers(project.getRequiredMembers());
            existingProject.setGithubUrl(project.getGithubUrl());
            existingProject.setDemoUrl(project.getDemoUrl());
            existingProject.setStatus(project.getStatus());

            existingProject.getRequiredSkills().clear();

            if (skillIds != null) {
                for (Long skillId : skillIds) {
                    Skill skill = session.get(Skill.class, skillId);

                    if (skill == null) {
                        throw new IllegalArgumentException("Invalid skill selected.");
                    }

                    existingProject.getRequiredSkills().add(skill);
                }
            }

            transaction.commit();

        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }

            if (e instanceof IllegalArgumentException) {
                throw (IllegalArgumentException) e;
            }

            throw new RuntimeException("Unable to update project with skills.", e);
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