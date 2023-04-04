package com.cocook.repository;

import com.cocook.entity.InstallUrl;
import org.springframework.data.jpa.repository.JpaRepository;

public interface InstallUrlRepository extends JpaRepository<InstallUrl, Long> {

    InstallUrl findInstallUrlById(Long installUrlId);

}
