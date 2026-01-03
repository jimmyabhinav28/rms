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
public class TrainCoachAssignmentDTO {
    private Integer id;
    private Integer trainId;
    private Integer coachTypeId;
    private String coachTypeName;
    private String coachNumber;
    private Integer position;
}

