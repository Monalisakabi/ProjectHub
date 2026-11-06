package com.projecthub.dao;

import com.projecthub.entity.ProjectMember;
import com.projecthub.util.HibernateUtil;
import org.hibernate.Session;

import java.util.List;

public class ProjectMemberDAO {

    public List<ProjectMember> findByProjectId(Long projectId) {

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            return session.createQuery(
                            "SELECT pm FROM ProjectMember pm " +
                                    "JOIN FETCH pm.user " +
                                    "WHERE pm.project.id = :projectId " +
                                    "ORDER BY pm.joinedAt ASC",
                            ProjectMember.class
                    )
                    .setParameter("projectId", projectId)
                    .getResultList();
        }
    }
    public Long countByProjectId(Long projectId) {

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            return session.createQuery(
                            "SELECT COUNT(pm) FROM ProjectMember pm " +
                                    "WHERE pm.project.id = :projectId",
                            Long.class)
                    .setParameter("projectId", projectId)
                    .getSingleResult();
        }
    }
    public boolean isMember(Long projectId, Long userId) {
        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            Long count = session.createQuery(
                            "SELECT COUNT(pm) FROM ProjectMember pm " +
                                    "WHERE pm.project.id = :projectId " +
                                    "AND pm.user.id = :userId",
                            Long.class)
                    .setParameter("projectId", projectId)
                    .setParameter("userId", userId)
                    .getSingleResult();

            return count > 0;
        }
    }

    public List<ProjectMember> findByUserId(Long userId) {

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            return session.createQuery(
                            "SELECT pm FROM ProjectMember pm " +
                                    "JOIN FETCH pm.project " +
                                    "WHERE pm.user.id = :userId " +
                                    "ORDER BY pm.joinedAt DESC",
                            ProjectMember.class
                    )
                    .setParameter("userId", userId)
                    .getResultList();
        }
    }
}