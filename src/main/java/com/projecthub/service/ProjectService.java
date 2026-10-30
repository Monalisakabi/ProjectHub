package com.projecthub.service;

import com.projecthub.dao.ProjectDAO;
import com.projecthub.entity.Project;
import com.projecthub.entity.User;

import java.util.HashSet;
import java.util.Set;

import java.util.List;
import java.util.Optional;

public class ProjectService {


    private final ProjectDAO projectDAO = new ProjectDAO();

    public Project createProject(
            User owner,
            String title,
            String description,
            String techStack,
            String projectType,
            Integer requiredMembers,
            String status,
            String githubUrl,
            String demoUrl,
            Set<Long> requiredSkillIds) {

        if (owner == null || owner.getId() == null) {
            throw new IllegalArgumentException("Please log in to create a project.");
        }

        validateProjectDetails(title, description, projectType, requiredMembers, status);

        Project project = new Project();
        project.setTitle(title.trim());
        project.setDescription(description.trim());
        project.setTechStack(cleanOptionalField(techStack));
        project.setProjectType(projectType.trim());
        project.setRequiredMembers(requiredMembers);
        project.setStatus(status.trim());
        project.setGithubUrl(cleanOptionalField(githubUrl));
        project.setDemoUrl(cleanOptionalField(demoUrl));
        project.setOwner(owner);

        Set<Long> skillIds = requiredSkillIds == null
                ? new HashSet<>()
                : new HashSet<>(requiredSkillIds);

        projectDAO.saveWithSkills(project, skillIds);

        return project;
    }
    public List<Project> getAllProjects() {
        return projectDAO.findAll();
    }
    public List<Project> searchProjects(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllProjects();
        }

        return projectDAO.search(keyword);
    }

    public List<Project> getProjectsByOwner(Long ownerId) {
        if (ownerId == null) {
            throw new IllegalArgumentException("Owner ID is required.");
        }

        return projectDAO.findByOwnerId(ownerId);
    }

    public Optional<Project> getProjectById(Long projectId) {
        if (projectId == null) {
            return Optional.empty();
        }

        return projectDAO.findById(projectId);
    }

    public void updateProject(
            Long projectId,
            Long currentUserId,
            String title,
            String description,
            String techStack,
            String projectType,
            Integer requiredMembers,
            String status,
            String githubUrl,
            String demoUrl,
            Set<Long> requiredSkillIds) {

        Project project = getOwnedProject(projectId, currentUserId);

        validateProjectDetails(title, description, projectType, requiredMembers, status);

        project.setTitle(title.trim());
        project.setDescription(description.trim());
        project.setTechStack(cleanOptionalField(techStack));
        project.setProjectType(projectType.trim());
        project.setRequiredMembers(requiredMembers);
        project.setStatus(status.trim());
        project.setGithubUrl(cleanOptionalField(githubUrl));
        project.setDemoUrl(cleanOptionalField(demoUrl));

        Set<Long> skillIds = requiredSkillIds == null
                ? new HashSet<>()
                : new HashSet<>(requiredSkillIds);

        projectDAO.updateWithSkills(project, skillIds);
    }
    private void validateProjectDetails(
            String title,
            String description,
            String projectType,
            Integer requiredMembers,
            String status) {

        if (title == null || title.trim().isEmpty()) {
            throw new IllegalArgumentException("Project title is required.");
        }

        if (title.trim().length() > 150) {
            throw new IllegalArgumentException("Project title must not exceed 150 characters.");
        }

        if (description == null || description.trim().isEmpty()) {
            throw new IllegalArgumentException("Project description is required.");
        }

        if (description.trim().length() > 2000) {
            throw new IllegalArgumentException("Description must not exceed 2000 characters.");
        }

        if (projectType == null || projectType.trim().isEmpty()) {
            throw new IllegalArgumentException("Project type is required.");
        }

        if (requiredMembers == null || requiredMembers < 1 || requiredMembers > 100) {
            throw new IllegalArgumentException("Required team members must be between 1 and 100.");
        }

        if (status == null || status.trim().isEmpty()) {
            throw new IllegalArgumentException("Project status is required.");
        }
    }

    public void deleteProject(Long projectId, Long currentUserId) {
        getOwnedProject(projectId, currentUserId);
        projectDAO.delete(projectId);
    }

    private Project getOwnedProject(Long projectId, Long currentUserId) {
        if (projectId == null || currentUserId == null) {
            throw new IllegalArgumentException("Project and user IDs are required.");
        }

        Project project = projectDAO.findById(projectId)
                .orElseThrow(() -> new IllegalArgumentException("Project not found."));

        if (project.getOwner() == null
                || !currentUserId.equals(project.getOwner().getId())) {
            throw new IllegalArgumentException("You are not allowed to modify this project.");
        }

        return project;
    }

    private String cleanOptionalField(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        return value.trim();
    }
}