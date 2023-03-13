package com.cocook.repository;

import com.cocook.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {

    User getUserByEmail(String email);

    User getUserByNickname(String nickname);

}
