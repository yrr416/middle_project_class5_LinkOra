/**
 * 프로필 이미지를 디스크에 저장하고 /static/upload/profiles/… URL을 반환하는 구현체.
 */
package org.study.project05.common.service.impl;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.study.project05.common.service.ProfileImageStorageService;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Locale;
import java.util.Set;
import java.util.UUID;

@Service
public class ProfileImageStorageImpl implements ProfileImageStorageService {

    private static final Set<String> ALLOWED_EXT = Set.of(".jpg", ".jpeg", ".png", ".gif", ".webp");

    private final Path profilesDirectory;

    public ProfileImageStorageImpl(@Value("${app.upload.profiles-dir:src/main/webapp/static/upload/profiles}") String profilesDir) {
        this.profilesDirectory = Paths.get(profilesDir).toAbsolutePath().normalize();
    }

    /**
     * 이미지를 저장하고 웹 경로 {@code /static/upload/profiles/파일명} 을 반환. 비어 있거나 형식이 맞지 않으면 null.
     */
    public String storeIfValid(MultipartFile file) throws IOException {
        if (file == null || file.isEmpty()) {
            return null;
        }
        String ext = extensionOf(file.getOriginalFilename());
        if (ext == null || !ALLOWED_EXT.contains(ext)) {
            return null;
        }
        // content-type 이 없거나 브라우저가 application/octet-stream 으로 보내는 경우에도
        // 위에서 확장자로 이미 허용 여부를 검증했으므로 통과
        String contentType = file.getContentType();
        if (contentType != null
                && !contentType.isBlank()
                && !contentType.toLowerCase(Locale.ROOT).startsWith("image/")
                && !contentType.equalsIgnoreCase("application/octet-stream")) {
            return null; // 명백히 이미지가 아닌 타입(예: text/html)만 거부
        }
        Files.createDirectories(profilesDirectory);
        String filename = UUID.randomUUID() + ext;
        Path target = profilesDirectory.resolve(filename);
        try (InputStream in = file.getInputStream()) {
            Files.copy(in, target, StandardCopyOption.REPLACE_EXISTING);
        }
        return "/static/upload/profiles/" + filename;
    }

    private static String extensionOf(String original) {
        if (original == null || !original.contains(".")) {
            return null;
        }
        return original.substring(original.lastIndexOf('.')).toLowerCase(Locale.ROOT);
    }
}
