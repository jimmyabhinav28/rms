package dev.abhinav.rms.train.dto;

import dev.abhinav.rms.train.dao.entity.TrainCategory;
import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

/**
 * DTO representing a Train resource.
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TrainDTO {
    private Integer trainId;

    @NotBlank
    @Size(max = 255)
    private String trainName;

    @NotBlank
    @Size(max = 255)
    private String trainNumber;

    @NotNull
    private TrainCategory trainCategory; // EXPRESS, LOCAL, FREIGHT, HIGH_SPEED

    private boolean inService = true; // align with TrainEntity primitive boolean

    // Coaches assigned to this train (lightweight view)
    private List<CoachAssignmentDTO> coaches = new ArrayList<>();
}
