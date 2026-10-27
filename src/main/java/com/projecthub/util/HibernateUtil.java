package com.projecthub.util;

import com.projecthub.entity.User;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

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