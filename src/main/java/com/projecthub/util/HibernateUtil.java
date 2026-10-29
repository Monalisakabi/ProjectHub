package com.projecthub.util;

import com.projecthub.entity.*;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import com.projecthub.entity.Notification;
import com.projecthub.entity.Skill;

public class HibernateUtil {

    private static final SessionFactory SESSION_FACTORY =
            buildSessionFactory();

    private static SessionFactory buildSessionFactory() {
        try {
            Configuration configuration = new Configuration();

            // Load Hibernate configuration
            configuration.configure("hibernate.cfg.xml");

            // Register the User entity
            configuration.addAnnotatedClass(User.class);
            configuration.addAnnotatedClass(Project.class);
            configuration.addAnnotatedClass(Follow.class);
            configuration.addAnnotatedClass(JoinRequest.class);
            configuration.addAnnotatedClass(ProjectMember.class);
            configuration.addAnnotatedClass(Notification.class);
            configuration.addAnnotatedClass(Skill.class);

            // Read database credentials from environment variables
            String username = System.getenv("PROJECTHUB_DB_USER");
            String password = System.getenv("PROJECTHUB_DB_PASSWORD");

            if (username == null || password == null) {
                throw new IllegalStateException(
                        "Database environment variables are missing."
                );
            }

            // Set database credentials
            configuration.setProperty(
                    "hibernate.connection.username", username
            );

            configuration.setProperty(
                    "hibernate.connection.password", password
            );

            // Create SessionFactory
            return configuration.buildSessionFactory();

        } catch (Exception e) {
            throw new ExceptionInInitializerError(e);
        }
    }

    public static SessionFactory getSessionFactory() {
        return SESSION_FACTORY;
    }

    public static void shutdown() {
        if (SESSION_FACTORY != null && !SESSION_FACTORY.isClosed()) {
            SESSION_FACTORY.close();
        }
    }
}