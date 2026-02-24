package com.gov.schemematcher.dto;

import lombok.Data;

@Data
public class UserEligibilityRequest {
    private Integer age;
    private String gender;
    private String category;
    private String profession;
    private Integer monthlyIncome;
}