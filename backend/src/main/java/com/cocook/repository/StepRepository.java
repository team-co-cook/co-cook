package com.cocook.repository;

import com.cocook.entity.Step;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface StepRepository extends JpaRepository<Step, Long> {
//    @Query(value = "SELECT * FROM step s " +
//            "WHERE s.recipe_idx = :recipeIdx ", nativeQuery = true)
    List<Step> findStepsByRecipeId(@Param("recipeIdx") Long recipeIdx);
}
