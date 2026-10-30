package com.projecthub.service;

import com.projecthub.dao.ProjectMemberDAO;
import com.projecthub.entity.ProjectMember;

import java.util.List;

public class ProjectMemberService {

    private final ProjectMemberDAO projectMemberDAO = new ProjectMemberDAO();

    public List<ProjectMember> getProjectMembers(Long projectId) {
        return projectMemberDAO.findByProjectId(projectId);
    }
}