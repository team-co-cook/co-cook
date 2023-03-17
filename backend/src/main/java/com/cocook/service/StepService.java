package com.cocook.service;

import com.cocook.dto.db.StepReqDto;
import com.cocook.entity.Recipe;
import com.cocook.entity.Step;
import com.cocook.repository.StepRepository;
import com.cocook.util.S3Uploader;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@Service
public class StepService {
    @Autowired
    private StepRepository stepRepository;

    @Autowired
    private S3Uploader s3Uploader;

    public void makeSteps(Recipe recipe, List<StepReqDto> steps, List<MultipartFile> stepImgs) {

        for (int i = 0; i < steps.size(); i++) {
            String storedFilePath;
            try {
                storedFilePath = s3Uploader.upload(stepImgs.get(i), "images");
            } catch (IOException e) {
                throw new RuntimeException(e.getMessage());
            }

            StepReqDto newStep = steps.get(i);

            Integer timer;
            if (newStep.getTimer() == 0) {
                timer = null;
            } else {
                timer = newStep.getTimer();
            }

            Step step = Step.builder()
                    .recipe(recipe)
                    .imgPath(storedFilePath)
                    .timer(timer)
                    .content(newStep.getContent())
                    .currentStep(newStep.getCurrentStep()).build();
            stepRepository.save(step);
        }

    }
}
