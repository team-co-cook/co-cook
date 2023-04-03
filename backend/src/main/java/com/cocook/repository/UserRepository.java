package com.cocook.repository;

import com.cocook.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {
    User findByEmail(String email);

    User findByNickname(String nickname);

    User findByIdAndIsActiveTrue(Long id);

    User findByEmailAndIsActiveTrue(String email);

    User findByNicknameAndIsActiveTrue(String nickname);

}
