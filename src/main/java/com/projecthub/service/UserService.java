package com.projecthub.service;

import com.projecthub.dao.UserDAO;
import com.projecthub.entity.User;
import org.mindrot.jbcrypt.BCrypt;

import java.util.Optional;

public class UserService {


    private final UserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();
    }

    public User register(String name, String email, String password) {

        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Name is required.");
        }

        if (email == null || email.trim().isEmpty()) {
            throw new IllegalArgumentException("Email is required.");
        }

        if (password == null || password.length() < 8) {
            throw new IllegalArgumentException(
                    "Password must contain at least 8 characters."
            );
        }

        String normalizedName = name.trim();
        String normalizedEmail = email.trim().toLowerCase();

        Optional<User> existingUser = userDAO.findByEmail(normalizedEmail);

        if (existingUser.isPresent()) {
            throw new IllegalArgumentException(
                    "An account with this email already exists."
            );
        }

        String passwordHash = BCrypt.hashpw(
                password,
                BCrypt.gensalt(12)
        );

        User user = new User();
        user.setName(normalizedName);
        user.setEmail(normalizedEmail);
        user.setPasswordHash(passwordHash);

        userDAO.save(user);

        return user;
    }

    public Optional<User> authenticate(String email, String password) {

        if (email == null || email.trim().isEmpty()
                || password == null || password.isEmpty()) {
            return Optional.empty();
        }

        Optional<User> result = userDAO.findByEmail(
                email.trim().toLowerCase()
        );

        if (result.isEmpty()) {
            return Optional.empty();
        }

        User user = result.get();

        if (BCrypt.checkpw(password, user.getPasswordHash())) {
            return Optional.of(user);
        }

        return Optional.empty();
    }


}
