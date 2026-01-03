package dev.abhinav.rms.train.berth.dto;

import jakarta.validation.constraints.*;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class BerthTypeDTO {
    private Integer berthTypeId;

    @NotBlank
    @Size(max = 100)
    private String berthTypeName;

    @Size(max = 500)
    private String description;
}

