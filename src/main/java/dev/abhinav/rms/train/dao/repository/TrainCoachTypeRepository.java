package dev.abhinav.rms.train.dao.repository;

import dev.abhinav.rms.train.dao.entity.TrainCoachTypeEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface TrainCoachTypeRepository extends JpaRepository<TrainCoachTypeEntity, Integer> {
    List<TrainCoachTypeEntity> findByTrain_TrainIdOrderByCoachNumberAsc(Integer trainId);
}
