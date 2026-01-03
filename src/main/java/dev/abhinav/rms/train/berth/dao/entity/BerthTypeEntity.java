package dev.abhinav.rms.train.berth.dao.entity;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "berth_type")
public class BerthTypeEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "berth_type_id")
    private Integer berthTypeId;

    @Column(name = "berth_type_name", nullable = false, unique = true)
    private String berthTypeName;

    @Column(name = "description")
    private String description;
}

