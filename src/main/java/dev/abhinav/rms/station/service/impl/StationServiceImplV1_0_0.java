package dev.abhinav.rms.station.service.impl;

import dev.abhinav.rms.station.dao.entity.StationEntity;
import dev.abhinav.rms.station.dao.repository.StationRepository;
import dev.abhinav.rms.station.dto.StationDTO;
import dev.abhinav.rms.station.service.IStationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;
import org.springframework.validation.annotation.Validated;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * Station service implementation (version 1.0.0).
 * <p>
 * This implementation follows a DTO-centric contract defined by {@link IStationService}. Externally it accepts
 * and returns {@link StationDTO}, while internally it uses {@link StationEntity} with the {@link StationRepository}
 * for persistence.
 * </p>
 * <p>
 * The active profile is controlled via the configuration property {@code application.service.version=1.0.0}.
 * </p>
 */
@Component
@Validated
@ConditionalOnProperty(value = "application.service.version", havingValue = "1.0.0")
public class StationServiceImplV1_0_0 implements IStationService {

    private final StationRepository stationRepository;

    /**
     * Constructs the station service implementation.
     *
     * @param stationRepository repository for station persistence operations
     */
    @Autowired
    public StationServiceImplV1_0_0(StationRepository stationRepository) {
        this.stationRepository = stationRepository;
    }

    /**
     * Create a new station.
     * <p>
     * Converts the incoming DTO into an entity, clears the identifier (to ensure an insert), persists,
     * and returns the saved station as DTO.
     * </p>
     *
     * @param stationDTO the station details to create
     * @return the created station, including the generated identifier
     */
    @Override
    public StationDTO create(StationDTO stationDTO) {
        if (stationDTO == null) {
            throw new IllegalArgumentException("stationDTO cannot be null");
        }
        StationEntity entity = toEntity(stationDTO);
        // Ensure ID is null so JPA treats this as a new entity
        entity.setStationId(null);
        StationEntity saved = stationRepository.save(entity);
        return toDTO(saved);
    }

    /**
     * Retrieve a station by its identifier.
     *
     * @param stationId the station identifier
     * @return an {@link Optional} containing the station DTO if found; otherwise empty
     */
    @Override
    public Optional<StationDTO> getById(Integer stationId) {
        return stationRepository.findById(stationId).map(this::toDTO);
    }

    /**
     * Retrieve a station by its unique station code.
     *
     * @param stationCode the station code to look up
     * @return an {@link Optional} containing the station DTO if found; otherwise empty
     */
    @Override
    public Optional<StationDTO> getByCode(String stationCode) {
        return stationRepository.findByStationCode(stationCode).map(this::toDTO);
    }

    /**
     * Retrieve all stations.
     *
     * @return a list of station DTOs; may be empty if none exist
     */
    @Override
    public List<StationDTO> getAll() {
        return stationRepository.findAll().stream().map(this::toDTO).collect(Collectors.toList());
    }

    /**
     * Update an existing station.
     * <p>
     * Loads the existing entity by ID, applies changes from the incoming DTO, persists, and returns
     * the updated station as DTO.
     * </p>
     *
     * @param stationId  the identifier of the station to update
     * @param stationDTO the new station data
     * @return the updated station DTO, or {@code null} if the station does not exist
     */
    @Override
    public StationDTO update(Integer stationId, StationDTO stationDTO) {
        Optional<StationEntity> existingOpt = stationRepository.findById(stationId);
        if (existingOpt.isEmpty()) {
            return null;
        }
        StationEntity existing = existingOpt.get();
        StationEntity incoming = toEntity(stationDTO);
        // Update mutable fields
        existing.setStationName(incoming.getStationName());
        existing.setStationCode(incoming.getStationCode());
        existing.setLatitude(incoming.getLatitude());
        existing.setLongitude(incoming.getLongitude());
        existing.setPlatformCount(incoming.getPlatformCount());
        StationEntity saved = stationRepository.save(existing);
        return toDTO(saved);
    }

    /**
     * Delete a station by its identifier.
     *
     * @param stationId the station identifier to delete
     */
    @Override
    public void delete(Integer stationId) {
        stationRepository.deleteById(stationId);
    }

    /**
     * Convert a DTO to an entity for internal persistence operations.
     *
     * @param dto the DTO to convert; may be {@code null}
     * @return a new entity reflecting the DTO values; may be {@code null} if input is {@code null}
     */
    @Override
    public StationEntity toEntity(StationDTO dto) {
        if (dto == null) return null;
        return StationEntity.builder()
                .stationId(dto.getStationId())
                .stationName(dto.getStationName())
                .stationCode(dto.getStationCode())
                .latitude(dto.getLatitude())
                .longitude(dto.getLongitude())
                .platformCount(dto.getPlatformCount())
                .build();
    }

    /**
     * Convert an entity to a DTO for external representation.
     *
     * @param entity the entity to convert; may be {@code null}
     * @return a new DTO reflecting the entity values; may be {@code null} if input is {@code null}
     */
    @Override
    public StationDTO toDTO(StationEntity entity) {
        if (entity == null) return null;
        return StationDTO.builder()
                .stationId(entity.getStationId())
                .stationName(entity.getStationName())
                .stationCode(entity.getStationCode())
                .latitude(entity.getLatitude())
                .longitude(entity.getLongitude())
                .platformCount(entity.getPlatformCount())
                .build();
    }
}
