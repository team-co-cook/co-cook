package com.cocook.util;

import com.cocook.auth.PrincipalDetails;
import com.cocook.auth.PrincipalDetailsService;
import com.cocook.entity.User;
import com.cocook.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.AuditorAware;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
public class UserAuditorAware implements AuditorAware<Long> {

    private UserRepository userRepository;

    @Autowired
    public UserAuditorAware(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public Optional<Long> getCurrentAuditor() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !authentication.isAuthenticated()) {
            return Optional.empty();
        }

//        String nickname = ((PrincipalDetails) authentication.getPrincipal()).getUsername();
        User user = ((PrincipalDetails) authentication.getPrincipal()).getUser();

        return Optional.of(user.getId());
    }
}
