package com.cocook.service;

import com.cocook.entity.Recipe;
import com.cocook.entity.Tag;
import com.cocook.entity.Theme;
import com.cocook.repository.TagRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class TagService {
    @Autowired
    private TagRepository tagRepository;

    public void makeTag(Recipe recipe, Theme theme) {
        Tag tag = new Tag();
        tag.setRecipe(recipe);
        tag.setTheme(theme);
        tagRepository.save(tag);
    }
}
