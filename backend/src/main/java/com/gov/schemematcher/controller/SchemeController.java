package com.gov.schemematcher.controller;

import com.gov.schemematcher.entity.Scheme;
import com.gov.schemematcher.repository.SchemeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/schemes")
@CrossOrigin(origins = "*") // Allows your Flutter app to connect without CORS errors
public class SchemeController {

    @Autowired
    private SchemeRepository schemeRepository;

    // 1. Get all schemes (Useful for an 'Explore' page)
    @GetMapping
    public List<Scheme> getAllSchemes() {
        return schemeRepository.findAll();
    }

    // 2. The 'Matching' logic (Used by the Flutter form)
    @PostMapping("/check")
    public List<Scheme> checkEligibility(@RequestBody Map<String, Object> payload) {
        // Use Number class to safely handle incoming JSON numbers
        Integer age = Integer.parseInt(payload.get("age").toString());
        Integer income = Integer.parseInt(payload.get("monthlyIncome").toString());

        String gender = (String) payload.get("gender");
        String category = (String) payload.get("category");
        String profession = (String) payload.get("profession");

        // Return filtered list from database
        return schemeRepository.findEligibleSchemes(age, income, gender, category, profession);
    }
}