package com.cocook.entity;

import lombok.Data;

import javax.persistence.*;

@Entity
@Data
public class InstallUrl {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "install_url_idx")
    private Long id;
    private String androidUrl;
    private String iosUrl;

}
