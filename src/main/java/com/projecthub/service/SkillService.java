package com.projecthub.service;

import com.projecthub.dao.SkillDAO;
import com.projecthub.entity.Skill;

import java.util.List;
import java.util.Optional;

public class SkillService {

    private final SkillDAO skillDAO = new SkillDAO();

    public Skill addSkill(String name) {
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Skill name is required.");
        }

        String normalizedName = name.trim();

        if (normalizedName.length() > 100) {
            throw new IllegalArgumentException(
                    "Skill name must not exceed 100 characters."
            );
        }

        Optional<Skill> existingSkill =
                skillDAO.findByName(normalizedName);

        if (existingSkill.isPresent()) {
            return existingSkill.get();
        }

        return skillDAO.save(new Skill(normalizedName));
    }

    public List<Skill> getAllSkills() {
        return skillDAO.findAll();
    }

    public Optional<Skill> getSkillById(Long id) {
        if (id == null || id <= 0) {
            return Optional.empty();
        }

        return skillDAO.findById(id);
    }
}