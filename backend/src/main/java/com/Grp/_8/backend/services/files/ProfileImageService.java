package com.Grp._8.backend.services.files;


import com.Grp._8.backend.entities.users.Users;
import com.Grp._8.backend.repositories.users.UserRepository;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class ProfileImageService {

    @Value("${file.upload-dir.profileImage}")
    private String imageDirectoryLocation;
    @Value("${server.servlet.context-path}")
    private String serverPath;

    private final UserRepository userRepository;

    @PostConstruct
    public void init()throws IOException {
        Files.createDirectories(Paths.get(imageDirectoryLocation));
    }

    public String uploadImage(MultipartFile image) throws IOException {

        String contentType = image.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            throw new IllegalArgumentException("Only image files are allowed");
        }

        log.info("Naming the image file");
        String extension = StringUtils.getFilenameExtension(image.getOriginalFilename());
        String storedImageName = UUID.randomUUID() + "." + extension;

        log.info("Copying the image content to directory");
        Path targetPath = Paths.get(imageDirectoryLocation).resolve(storedImageName);
        Files.copy(image.getInputStream(),targetPath, StandardCopyOption.REPLACE_EXISTING);

        log.info("Updating Users ImageUrl Field");
        String imageUrl = serverPath+"/profile/image/"+storedImageName;
        Users users = (Users) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        users.setProfileImageUrl(imageUrl);
        userRepository.save(users);

        return imageUrl;
    }

}
