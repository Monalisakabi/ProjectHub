package com.projecthub.service;

import com.projecthub.dao.FollowDAO;
import com.projecthub.entity.User;
import java.util.List;
import java.util.Set;
import com.projecthub.dao.UserDAO;


public class FollowService {
    private final UserDAO userDAO = new UserDAO();
    private final FollowDAO followDAO;

    public FollowService() {
        this.followDAO = new FollowDAO();
    }

    public boolean followUser(Long followerId, Long followedId) {
        validateUserIds(followerId, followedId);

        if (followerId.equals(followedId)) {
            throw new IllegalArgumentException(
                    "You cannot follow yourself."
            );
        }

        return followDAO.followUser(followerId, followedId);
    }

    public boolean unfollowUser(Long followerId, Long followedId) {
        validateUserIds(followerId, followedId);

        return followDAO.unfollowUser(followerId, followedId);
    }

    public boolean isFollowing(Long followerId, Long followedId) {
        if (followerId == null || followedId == null) {
            return false;
        }

        return followDAO.isFollowing(followerId, followedId);
    }

    private void validateUserIds(Long followerId, Long followedId) {
        if (followerId == null || followedId == null) {
            throw new IllegalArgumentException(
                    "User IDs cannot be null."
            );
        }
    }
    public List<User> getAllOtherUsers(Long currentUserId) {
        validateUserIds(currentUserId, 1L);
        return followDAO.getAllOtherUsers(currentUserId);
    }

    public Set<Long> getFollowingUserIds(Long currentUserId) {
        if (currentUserId == null) {
            throw new IllegalArgumentException("Current user ID cannot be null.");
        }

        return followDAO.getFollowingUserIds(currentUserId);
    }
    public List<User> getOtherUsers(Long currentUserId) {
        if (currentUserId == null) {
            throw new IllegalArgumentException("Current user ID cannot be null.");
        }

        return userDAO.findAllExcept(currentUserId);
    }
    public List<User> searchDevelopers(String name, Long currentUserId) {
        if (currentUserId == null) {
            throw new IllegalArgumentException(
                    "Current user ID cannot be null."
            );
        }

        return userDAO.searchUsersByName(name, currentUserId);
    }
    // Get the list of users who follow this user
    public List<User> getFollowers(Long userId) {
        if (userId == null) {
            throw new IllegalArgumentException("User ID cannot be null.");
        }

        return followDAO.getFollowers(userId);
    }

    // Get the list of users this user follows
    public List<User> getFollowing(Long userId) {
        if (userId == null) {
            throw new IllegalArgumentException("User ID cannot be null.");
        }

        return followDAO.getFollowing(userId);
    }
    public Long getFollowerCount(Long userId) {
        return followDAO.countFollowers(userId);
    }

    public Long getFollowingCount(Long userId) {
        return followDAO.countFollowing(userId);
    }
}
