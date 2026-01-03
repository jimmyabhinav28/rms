package dev.abhinav.rms.station.controller;

import dev.abhinav.rms.station.dto.StationDTO;
import dev.abhinav.rms.station.service.IStationService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;


@Validated
@RestController
@RequestMapping("/api/v1/stations")
public class StationControllerV1 {

    private final IStationService stationService;

    public StationControllerV1(IStationService stationService) {
        this.stationService = stationService;
    }

    @PostMapping
    public ResponseEntity<StationDTO> create(@Valid @RequestBody StationDTO stationDTO) {
        StationDTO created = stationService.create(stationDTO);
        return ResponseEntity.created(URI.create("/api/v1/stations/" + created.getStationId())).body(created);
    }

    @GetMapping("/{id}")
    public ResponseEntity<StationDTO> getById(@PathVariable("id") Integer id) {
        return stationService.getById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/code/{code}")
    public ResponseEntity<StationDTO> getByCode(@PathVariable("code") String code) {
        return stationService.getByCode(code)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping
    public ResponseEntity<List<StationDTO>> getAll() {
        return ResponseEntity.ok(stationService.getAll());
    }

    @PutMapping("/{id}")
    public ResponseEntity<StationDTO> update(@PathVariable("id") Integer id, @Valid @RequestBody StationDTO stationDTO) {
        StationDTO updated = stationService.update(id, stationDTO);
        if (updated == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(updated);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable("id") Integer id) {
        stationService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
