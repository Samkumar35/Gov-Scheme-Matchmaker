package com.gov.schemematcher.repository;

import com.gov.schemematcher.entity.Scheme;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SchemeRepository extends JpaRepository<Scheme, Integer> {

    // Custom query to match user criteria with database columns
    @Query("SELECT s FROM Scheme s WHERE " +
            ":age BETWEEN s.minAge AND s.maxAge AND " +
            "(:income <= s.maxIncome OR s.maxIncome = -1) AND " +
            "(s.gender = 'Any' OR s.gender = :gender) AND " +
            "(s.category = 'Any' OR s.category = :category) AND " +
            "(s.profession = 'Any' OR s.profession = :profession)")
    List<Scheme> findEligibleSchemes(
            @Param("age") Integer age,
            @Param("income") Integer income,
            @Param("gender") String gender,
            @Param("category") String category,
            @Param("profession") String profession
    );
}