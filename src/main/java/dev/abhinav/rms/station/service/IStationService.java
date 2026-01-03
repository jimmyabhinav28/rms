package dev.abhinav.rms.station.service;

import dev.abhinav.rms.station.dao.entity.StationEntity;
import dev.abhinav.rms.station.dto.StationDTO;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import org.springframework.validation.annotation.Validated;

import java.util.List;
import java.util.Optional;

/**
 * Service contract for managing Station resources.
 * <p>
 * This interface is DTO-centric: callers interact using {@link StationDTO}, while implementations
 * may convert to/from {@link StationEntity} internally for persistence.
 * </p>
 * <p>
 * Typical responsibilities include creating, reading, updating, and deleting stations, along with
 * convenience lookups by identifier and station code.
 * </p>
 */
@Validated
public interface IStationService {
    /**
     * Create a new station.
     * <p>
     * Implementations should convert the incoming DTO to an entity and persist it. If an ID is provided
     * in the DTO, it is typically ignored or treated as a request to update depending on business rules.
     * </p>
     *
     * @param stationDTO the station details to create; must be non-null and valid
     * @return the created station as DTO, including any generated identifier
     */
    StationDTO create(@NotNull @Valid StationDTO stationDTO);

    /**
     * Retrieve a station by its identifier.
     *
     * @param stationId the station identifier; must be non-null
     * @return an {@link Optional} containing the station DTO if found; otherwise empty
     */
    Optional<StationDTO> getById(@NotNull Integer stationId);

    /**
     * Retrieve a station by its unique station code.
     *
     * @param stationCode the station code (e.g., short code used for timetables); must be non-blank
     * @return an {@link Optional} containing the station DTO if found; otherwise empty
     */
    Optional<StationDTO> getByCode(@NotBlank String stationCode);

    /**
     * Retrieve all stations.
     *
     * @return a list of station DTOs; may be empty if none exist
     */
    List<StationDTO> getAll();

    /**
     * Update an existing station.
     * <p>
     * Implementations should load the existing entity by ID, apply changes from the DTO (typically for
     * mutable fields), persist, and return the updated DTO.
     * </p>
     *
     * @param stationId  the identifier of the station to update; must be non-null
     * @param stationDTO the new station data; must be non-null and valid
     * @return the updated station DTO, or {@code null} if the station does not exist (implementations may alternatively throw)
     */
    StationDTO update(@NotNull Integer stationId, @NotNull @Valid StationDTO stationDTO);

    /**
     * Delete a station by its identifier.
     *
     * @param stationId the station identifier to delete; must be non-null
     */
    void delete(@NotNull Integer stationId);

    /**
     * Convert a {@link StationDTO} to a {@link StationEntity} for internal persistence operations.
     *
     * @param dto the DTO to convert; may be {@code null}
     * @return a new entity reflecting the DTO values; may be {@code null} if input is {@code null}
     */
    StationEntity toEntity(StationDTO dto);

    /**
     * Convert a {@link StationEntity} to a {@link StationDTO} for external representation.
     *
     * @param entity the entity to convert; may be {@code null}
     * @return a new DTO reflecting the entity values; may be {@code null} if input is {@code null}
     */
    StationDTO toDTO(StationEntity entity);
}
