package com.gov.schemematcher.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "schemes")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Scheme {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private String name;
    private String ministry;

    @Column(name = "min_age")
    private Integer minAge;

    @Column(name = "max_age")
    private Integer maxAge;

    @Column(name = "max_income")
    private Integer maxIncome;

    private String gender;
    private String category;
    private String profession;
    private String state;

    @Column(columnDefinition = "TEXT")
    private String benefit;

    @Column(name = "official_website")
    private String officialWebsite;

    @Column(name = "apply_steps", columnDefinition = "TEXT")
    private String applySteps;
}