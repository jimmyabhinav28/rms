package dev.abhinav.rms.train.coach.dao.repository;

import dev.abhinav.rms.train.coach.dao.entity.CoachTypeEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface CoachTypeRepository extends JpaRepository<CoachTypeEntity, Integer> {
    Optional<CoachTypeEntity> findByCoachTypeName(String coachTypeName);
}

