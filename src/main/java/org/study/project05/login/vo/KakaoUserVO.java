/**
 * 카카오 사용자 API 응답을 담는 DTO(닉네임·이메일·전화 등).
 */
package org.study.project05.login.vo;

import com.google.gson.annotations.SerializedName;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class KakaoUserVO {
    private String id;
    private String nickname;
    private String email;
    private String phoneNumber;
    private String baseAddress;
    private String detailAddress;

    @SerializedName("thumbnail_image_url")
    private String thumbnailImageUrl;
}
