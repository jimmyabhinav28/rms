package dev.abhinav.rms.train.service;

import dev.abhinav.rms.train.dao.entity.TrainCoachTypeEntity;
import dev.abhinav.rms.train.dao.repository.TrainCoachTypeRepository;
import dev.abhinav.rms.train.coach.dao.repository.CoachTypeRepository;
import dev.abhinav.rms.train.coach.dao.entity.CoachTypeEntity;
import dev.abhinav.rms.train.dao.entity.TrainEntity;
import dev.abhinav.rms.train.dao.repository.TrainRepository;
import dev.abhinav.rms.train.dto.TrainDTO;
import dev.abhinav.rms.train.dto.CoachAssignmentDTO;
import dev.abhinav.rms.train.dto.TrainCoachAssignmentDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;
import org.springframework.validation.annotation.Validated;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Component
@Validated
@ConditionalOnProperty(value="application.service.version", havingValue = "1.0.0")
public class TrainServiceV1_0_0 implements ITrainService {

    private final TrainRepository trainRepository;
    private final TrainCoachTypeRepository trainCoachTypeRepository;
    private final CoachTypeRepository coachTypeRepository;

    @Autowired
    public TrainServiceV1_0_0(TrainRepository trainRepository,
                               TrainCoachTypeRepository trainCoachTypeRepository,
                               CoachTypeRepository coachTypeRepository) {
        this.trainRepository = trainRepository;
        this.trainCoachTypeRepository = trainCoachTypeRepository;
        this.coachTypeRepository = coachTypeRepository;
    }

    @Override
    public TrainDTO create(TrainDTO trainDTO) {
        if (trainDTO == null) {
            throw new IllegalArgumentException("trainDTO cannot be null");
        }
        TrainEntity entity = toEntity(trainDTO);
        entity.setTrainId(null);
        TrainEntity saved = trainRepository.save(entity);
        return toDTO(saved);
    }

    @Override
    public Optional<TrainDTO> getById(Integer trainId) {
        return trainRepository.findById(trainId).map(this::toDTO);
    }

    @Override
    public Optional<TrainDTO> getByNumber(String trainNumber) {
        return trainRepository.findByTrainNumber(trainNumber).map(this::toDTO);
    }

    @Override
    public List<TrainDTO> getAll() {
        return trainRepository.findAll().stream().map(this::toDTO).collect(Collectors.toList());
    }

    @Override
    public TrainDTO update(Integer trainId, TrainDTO trainDTO) {
        Optional<TrainEntity> existingOpt = trainRepository.findById(trainId);
        if (existingOpt.isEmpty()) {
            return null;
        }
        TrainEntity existing = existingOpt.get();
        TrainEntity incoming = toEntity(trainDTO);
        existing.setTrainName(incoming.getTrainName());
        existing.setTrainNumber(incoming.getTrainNumber());
        existing.setTrainCategory(incoming.getTrainCategory());
        existing.setInService(incoming.isInService());
        TrainEntity saved = trainRepository.save(existing);
        return toDTO(saved);
    }

    @Override
    public void delete(Integer trainId) {
        trainRepository.deleteById(trainId);
    }

    @Override
    public TrainEntity toEntity(TrainDTO dto) {
        if (dto == null) return null;
        TrainEntity entity = new TrainEntity();
        entity.setTrainId(dto.getTrainId());
        entity.setTrainName(dto.getTrainName());
        entity.setTrainNumber(dto.getTrainNumber());
        entity.setTrainCategory(dto.getTrainCategory());
        entity.setInService(dto.isInService());
        return entity;
    }

    @Override
    public TrainDTO toDTO(TrainEntity entity) {
        if (entity == null) return null;
        TrainDTO dto = new TrainDTO();
        dto.setTrainId(entity.getTrainId());
        dto.setTrainName(entity.getTrainName());
        dto.setTrainNumber(entity.getTrainNumber());
        dto.setTrainCategory(entity.getTrainCategory());
        dto.setInService(entity.isInService());
        // Map coach assignments
        if (entity.getCoachAssignments() != null) {
            dto.setCoaches(entity.getCoachAssignments().stream()
                    .map(a -> CoachAssignmentDTO.builder()
                            .assignmentId(a.getId())
                            .coachTypeId(a.getCoachType() != null ? a.getCoachType().getCoachTypeId() : null)
                            .coachTypeName(a.getCoachType() != null ? a.getCoachType().getCoachTypeName() : null)
                            .position(a.getPosition())
                            .quantity(null)
                            .build())
                    .toList());
        }
        return dto;
    }

    @Override
    public java.util.List<TrainCoachAssignmentDTO> listCoachAssignments(Integer trainId) {
        return trainCoachTypeRepository.findByTrain_TrainIdOrderByCoachNumberAsc(trainId).stream()
                .map(this::toAssignmentDTO)
                .toList();
    }

    @Override
    public TrainCoachAssignmentDTO addCoachAssignment(Integer trainId, Integer coachTypeId, String coachNumber, Integer position) {
        TrainEntity train = trainRepository.findById(trainId).orElseThrow(() -> new IllegalArgumentException("Train not found: " + trainId));
        CoachTypeEntity coachType = coachTypeRepository.findById(coachTypeId).orElseThrow(() -> new IllegalArgumentException("CoachType not found: " + coachTypeId));
        TrainCoachTypeEntity assignment = new TrainCoachTypeEntity();
        assignment.setTrain(train);
        assignment.setCoachType(coachType);
        assignment.setCoachNumber(coachNumber);
        assignment.setPosition(position);
        TrainCoachTypeEntity saved = trainCoachTypeRepository.save(assignment);
        return toAssignmentDTO(saved);
    }

    @Override
    public void removeCoachAssignment(Integer assignmentId) {
        trainCoachTypeRepository.deleteById(assignmentId);
    }

    private TrainCoachAssignmentDTO toAssignmentDTO(TrainCoachTypeEntity a) {
        TrainCoachAssignmentDTO dto = new TrainCoachAssignmentDTO();
        dto.setId(a.getId());
        dto.setTrainId(a.getTrain() != null ? a.getTrain().getTrainId() : null);
        dto.setCoachTypeId(a.getCoachType() != null ? a.getCoachType().getCoachTypeId() : null);
        dto.setCoachTypeName(a.getCoachType() != null ? a.getCoachType().getCoachTypeName() : null);
        dto.setCoachNumber(a.getCoachNumber());
        dto.setPosition(a.getPosition());
        return dto;
    }
}
