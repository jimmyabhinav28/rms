package dev.abhinav.rms.train.controller;

import dev.abhinav.rms.train.dao.entity.TrainCoachTypeEntity;
import dev.abhinav.rms.train.dto.TrainDTO;
import dev.abhinav.rms.train.dto.TrainCoachAssignmentDTO;
import dev.abhinav.rms.train.service.ITrainService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;

@Validated
@RestController
@RequestMapping("/api/v1/trains")
public class TrainControllerV1 {

    private final ITrainService trainService;

    public TrainControllerV1(ITrainService trainService) {
        this.trainService = trainService;
    }

    @PostMapping
    public ResponseEntity<TrainDTO> create(@Valid @RequestBody TrainDTO trainDTO) {
        TrainDTO created = trainService.create(trainDTO);
        return ResponseEntity.created(URI.create("/api/v1/trains/" + created.getTrainId())).body(created);
    }

    @GetMapping("/{id}")
    public ResponseEntity<TrainDTO> getById(@PathVariable("id") Integer id) {
        return trainService.getById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/number/{trainNumber}")
    public ResponseEntity<TrainDTO> getByNumber(@PathVariable("trainNumber") String trainNumber) {
        return trainService.getByNumber(trainNumber)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping
    public ResponseEntity<List<TrainDTO>> getAll() {
        return ResponseEntity.ok(trainService.getAll());
    }

    @PutMapping("/{id}")
    public ResponseEntity<TrainDTO> update(@PathVariable("id") Integer id, @Valid @RequestBody TrainDTO trainDTO) {
        TrainDTO updated = trainService.update(id, trainDTO);
        if (updated == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(updated);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable("id") Integer id) {
        trainService.delete(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{id}/coaches")
    public ResponseEntity<List<TrainCoachAssignmentDTO>> listCoachAssignments(@PathVariable("id") Integer id) {
        return ResponseEntity.ok(trainService.listCoachAssignments(id));
    }

    @PostMapping("/{id}/coaches/{coachTypeId}")
    public ResponseEntity<TrainCoachAssignmentDTO> addCoachAssignment(@PathVariable("id") Integer id,
                                                                   @PathVariable("coachTypeId") Integer coachTypeId,
                                                                   @RequestParam(value="coachNumber", required = true) String coachNumber,
                                                                   @RequestParam(value="position", required = true) Integer position) {
        TrainCoachAssignmentDTO created = trainService.addCoachAssignment(id, coachTypeId, coachNumber, position);
        return ResponseEntity.ok(created);
    }

    @DeleteMapping("/coaches/{assignmentId}")
    public ResponseEntity<Void> removeCoachAssignment(@PathVariable("assignmentId") Integer assignmentId) {
        trainService.removeCoachAssignment(assignmentId);
        return ResponseEntity.noContent().build();
    }
}
