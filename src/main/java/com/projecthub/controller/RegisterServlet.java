package com.projecthub.controller;

import com.projecthub.entity.User;
import com.projecthub.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.getRequestDispatcher("/register.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            User user = userService.register(name, email, password);

            request.setAttribute(
                    "successMessage",
                    "Registration successful! You can now log in."
            );

            request.setAttribute("registeredName", user.getName());

            request.getRequestDispatcher("/register.jsp")
                    .forward(request, response);

        } catch (IllegalArgumentException e) {

            request.setAttribute("errorMessage", e.getMessage());

            request.getRequestDispatcher("/register.jsp")
                    .forward(request, response);

        } catch (RuntimeException e) {

            getServletContext().log(
                    "Registration failed.",
                    e
            );

            request.setAttribute(
                    "errorMessage",
                    "Registration could not be completed. Please try again."
            );

            request.getRequestDispatcher("/register.jsp")
                    .forward(request, response);
        }
    }


}
