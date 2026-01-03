package dev.abhinav.rms.train.dao.entity;

import dev.abhinav.rms.train.coach.dao.entity.CoachTypeEntity;
import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "train")
public class TrainEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "train_id")
    private Integer trainId;

    @Column(name = "train_name", nullable = false)
    private String trainName;

    @Column(name = "train_number", nullable = false, unique = true)
    private String trainNumber;

    @Enumerated(EnumType.STRING)
    @Column(name = "train_category", nullable = false)
    private TrainCategory trainCategory;

    @Column(name = "in_service", nullable = false)
    private boolean inService;

    @OneToMany(mappedBy = "train", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<TrainCoachTypeEntity> coachAssignments = new ArrayList<>();
}
