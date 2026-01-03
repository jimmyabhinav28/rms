package dev.abhinav.rms.train.coach.dao.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.LinkedHashSet;
import java.util.Set;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "coach_type")
public class CoachTypeEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "coach_type_id")
    private Integer coachTypeId;

    @Column(name = "coach_type_name", nullable = false, unique = true)
    private String coachTypeName;

    @Column(name = "description")
    private String description;

    @Column(name = "capacity", nullable = false)
    private Integer capacity;

    @Column(name = "has_ac", nullable = false)
    private Boolean hasAc = Boolean.TRUE;

    // Association to join table entries (navigation only from coach type)
    @OneToMany(mappedBy = "coachType", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<CoachTypeBerthEntity> coachTypeBerths = new LinkedHashSet<>();
}
