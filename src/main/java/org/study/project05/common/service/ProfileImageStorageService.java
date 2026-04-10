/**
 * 회원·사업자 프로필 이미지 업로드 저장 계약(유효한 이미지일 때 웹 경로 반환).
 */
package org.study.project05.common.service;

import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

public interface ProfileImageStorageService {
    String storeIfValid(MultipartFile file) throws IOException;
}
