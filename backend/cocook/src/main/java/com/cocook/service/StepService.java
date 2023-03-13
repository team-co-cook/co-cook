package com.cocook.service;

import com.cocook.dto.db.StepReqDto;
import com.cocook.entity.Recipe;
import com.cocook.entity.Step;
import com.cocook.repository.StepRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class StepService {
    @Autowired
    private StepRepository stepRepository;

    public void makeSteps(Recipe recipe, StepReqDto stepReqDto) {
        Step step = Step.builder()
                .recipe(recipe)
                .imgPath(stepReqDto.getImgPath())
                .timer(stepReqDto.getTimer())
                .content(stepReqDto.getContent())
                .currentStep(stepReqDto.getCurrentStep()).build();
        stepRepository.save(step);
    }
}
