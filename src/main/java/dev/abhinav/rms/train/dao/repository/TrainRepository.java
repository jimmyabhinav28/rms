package dev.abhinav.rms.train.dao.repository;

import dev.abhinav.rms.train.dao.entity.TrainEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface TrainRepository extends JpaRepository<TrainEntity, Integer> {
    Optional<TrainEntity> findByTrainNumber(String trainNumber);
}

