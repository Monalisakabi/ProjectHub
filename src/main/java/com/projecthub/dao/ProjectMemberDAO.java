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