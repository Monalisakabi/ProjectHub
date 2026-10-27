package com.projecthub.controller;

import com.projecthub.util.HibernateUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.hibernate.Session;

import java.io.IOException;

@WebServlet("/health")
public class HealthServlet extends HttpServlet {

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            session.createNativeQuery("SELECT 1").getSingleResult();

            response.getWriter().println(
                    "ProjectHub is running. MySQL connection is OK."
            );

        } catch (Exception e) {

            response.setStatus(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR
            );

            response.getWriter().println(
                    "Database connection failed. Check the IntelliJ console."
            );

            e.printStackTrace();
        }
    }
}