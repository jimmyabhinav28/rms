package dev.abhinav.rms.train.coach.dao.entity;

import dev.abhinav.rms.train.berth.dao.entity.BerthTypeEntity;
import jakarta.persistence.*;
import lombok.*;

import java.io.Serializable;
import java.util.Objects;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "coach_type_berth")
@IdClass(CoachTypeBerthEntity.CoachTypeBerthId.class)
public class CoachTypeBerthEntity {

    @Id
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "coach_type_id", nullable = false)
    private CoachTypeEntity coachType;

    @Id
    @Column(name = "berth_number", nullable = false)
    private Integer berthNumber;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "berth_type_id", nullable = false)
    private BerthTypeEntity berthType;

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @EqualsAndHashCode
    public static class CoachTypeBerthId implements Serializable {
        private Integer coachType; // refers to coachType.coachTypeId via IdClass semantics
        private Integer berthNumber;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof CoachTypeBerthEntity that)) return false;
        return Objects.equals(coachType, that.coachType) && Objects.equals(berthNumber, that.berthNumber);
    }

    @Override
    public int hashCode() {
        return Objects.hash(coachType, berthNumber);
    }
}
