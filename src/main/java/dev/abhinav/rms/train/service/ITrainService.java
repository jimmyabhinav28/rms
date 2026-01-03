package dev.abhinav.rms.train.service;

import dev.abhinav.rms.train.dao.entity.TrainCoachTypeEntity;
import dev.abhinav.rms.train.dao.entity.TrainEntity;
import dev.abhinav.rms.train.dto.TrainCoachAssignmentDTO;
import dev.abhinav.rms.train.dto.TrainDTO;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import org.springframework.validation.annotation.Validated;

import java.util.List;
import java.util.Optional;

@Validated
public interface ITrainService {
    TrainDTO create(@NotNull @Valid TrainDTO trainDTO);
    Optional<TrainDTO> getById(@NotNull Integer trainId);
    Optional<TrainDTO> getByNumber(@NotBlank String trainNumber);
    List<TrainDTO> getAll();
    TrainDTO update(@NotNull Integer trainId, @NotNull @Valid TrainDTO trainDTO);
    void delete(@NotNull Integer trainId);

    TrainEntity toEntity(TrainDTO dto);
    TrainDTO toDTO(TrainEntity entity);

    // Train rake composition management (DTO-based)
    List<TrainCoachAssignmentDTO> listCoachAssignments(@NotNull Integer trainId);
    TrainCoachAssignmentDTO addCoachAssignment(@NotNull Integer trainId, @NotNull Integer coachTypeId, @NotNull String coachNumber, @NotNull Integer position);
    void removeCoachAssignment(@NotNull Integer assignmentId);
}
