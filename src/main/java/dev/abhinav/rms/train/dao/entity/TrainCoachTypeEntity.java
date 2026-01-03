package dev.abhinav.rms.train.dao.entity;

import dev.abhinav.rms.train.coach.dao.entity.CoachTypeEntity;
import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "train_coach")
public class TrainCoachTypeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "train_coach_id")
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "train_id", nullable = false)
    private TrainEntity train;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "coach_type_id", nullable = false)
    private CoachTypeEntity coachType;

    @Column(name = "coach_number", nullable = false, length = 50)
    private String coachNumber;

    @Column(name="position_in_train", nullable = false)
    private Integer position;
}

