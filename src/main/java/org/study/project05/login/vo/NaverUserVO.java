/**
 * 네이버 회원 프로필 API 응답을 담는 DTO(이름·이메일·휴대폰·프로필 이미지 등).
 */
package org.study.project05.login.vo;

import com.google.gson.annotations.SerializedName;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class NaverUserVO {
    private String id;
    private String name;
    private String email;
    private String mobile;

    @SerializedName("profile_image")
    private String profileImage;
}
