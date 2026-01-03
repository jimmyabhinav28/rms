package dev.abhinav.rms.station.dto;

import jakarta.validation.constraints.*;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StationDTO {
    private Integer stationId;

    @NotBlank(message = "Station name is required")
    @Size(max = 100, message = "Station name must be at most 100 characters")
    private String stationName;

    @NotBlank(message = "Station code is required")
    @Size(max = 10, message = "Station code must be at most 10 characters")
    private String stationCode;

    @NotNull
    @DecimalMin(value = "-90.0", message = "Latitude must be >= -90")
    @DecimalMax(value = "90.0", message = "Latitude must be <= 90")
    private double latitude;

    @NotNull
    @DecimalMin(value = "-180.0", message = "Longitude must be >= -180")
    @DecimalMax(value = "180.0", message = "Longitude must be <= 180")
    private double longitude;

    @NotNull
    @Min(value = 0, message = "Platform count must be >= 0")
    private int platformCount;
}
