package dev.abhinav.rms.station.dao.repository;

import dev.abhinav.rms.station.dao.entity.StationEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface StationRepository extends JpaRepository<StationEntity, Integer> {
    Optional<StationEntity> findByStationCode(String stationCode);
}

