package com.projecthub.service;

import com.projecthub.dao.JoinRequestDAO;
import com.projecthub.entity.JoinRequest;

import java.util.List;

public class JoinRequestService {

    private final JoinRequestDAO joinRequestDAO = new JoinRequestDAO();

    public void createRequest(JoinRequest joinRequest) {
        if (joinRequest == null ||
                joinRequest.getProject() == null ||
                joinRequest.getProject().getId() == null ||
                joinRequest.getUser() == null ||
                joinRequest.getUser().getId() == null) {
            throw new IllegalArgumentException(
                    "A valid project and user are required.");
        }

        Long projectId = joinRequest.getProject().getId();
        Long userId = joinRequest.getUser().getId();

        if (joinRequest.getProject().getOwner() != null &&
                userId.equals(joinRequest.getProject().getOwner().getId())) {
            throw new IllegalArgumentException(
                    "You cannot request to join your own project.");
        }

        if (joinRequestDAO.hasPendingRequest(projectId, userId)) {
            throw new IllegalArgumentException(
                    "You already have a pending request for this project.");
        }

        joinRequest.setStatus("PENDING");
        joinRequestDAO.save(joinRequest);
    }

    public List<JoinRequest> getRequestsForProject(Long projectId) {
        if (projectId == null) {
            throw new IllegalArgumentException("Project ID is required.");
        }

        return joinRequestDAO.findByProjectId(projectId);
    }

    public JoinRequest getRequestById(Long requestId) {
        if (requestId == null) {
            throw new IllegalArgumentException("Request ID is required.");
        }

        return joinRequestDAO.findById(requestId);
    }


    public void processRequest(Long requestId, Long ownerId, String decision) {
        if (requestId == null || ownerId == null) {
            throw new IllegalArgumentException(
                    "Request ID and owner ID are required.");
        }

        if (!"ACCEPTED".equals(decision) && !"REJECTED".equals(decision)) {
            throw new IllegalArgumentException("Invalid decision.");
        }

        joinRequestDAO.processRequest(requestId, ownerId, decision);
    }


}

