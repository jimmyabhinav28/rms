package dev.abhinav.rms.train.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CoachAssignmentDTO {
    private Integer assignmentId;
    private Integer coachTypeId;
    private String coachTypeName;
    private Integer position;
    private Integer quantity;
}

