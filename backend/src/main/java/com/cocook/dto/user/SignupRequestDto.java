package com.cocook.dto.user;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class SignupRequestDto {

    @NotBlank(message = "닉네임이 비어있습니다.")
    @Size(max = 17, message = "닉네임의 최대 길이는 17자입니다.")
    @Pattern(regexp = "^[a-zA-Z0-9가-힣]*$", message = "닉네임은 한글, 알파벳 대소문자, 숫자만 사용할 수 있습니다.")
    private String nickname;

    @NotBlank(message = "이메일이 비어있습니다.")
    private String email;

    @NotBlank(message = "토큰이 비어있습니다.")
    private String access_token;

}