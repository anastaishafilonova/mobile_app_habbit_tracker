package com.habit_tracker.backend.user.service.impl;

import com.habit_tracker.backend.user.dto.UpdateUserRequest;
import com.habit_tracker.backend.user.dto.UserDto;
import com.habit_tracker.backend.user.entity.User;
import com.habit_tracker.backend.user.repository.UserRepository;
import com.habit_tracker.backend.user.service.UserService;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
@Transactional
public class UserServiceImpl implements UserService {

  private final UserRepository userRepository;
  @Value("${app.upload-dir}")
  private String uploadDir;

  public UserServiceImpl(UserRepository userRepository) {
    this.userRepository = userRepository;
  }

  @Override
  @Transactional(readOnly = true)
  public UserDto getUserById(UUID userId) {
    User user = userRepository.findById(userId)
        .orElseThrow(() -> new EntityNotFoundException("User not found: " + userId));
    return toDto(user);
  }

  @Override
  @Transactional(readOnly = true)
  public UserDto getCurrentUser(UUID userId) {
    return getUserById(userId);
  }

  @Override
  @Transactional(readOnly = true)
  public List<UserDto> getAllUsers() {
    return userRepository.findAll()
        .stream()
        .map(user -> new UserDto(
            user.getId(),
            user.getUsername(),
            user.getEmail(),
            user.getScore(),
            user.getAvatarImage()
        ))
        .toList();
  }

  @Override
  public UserDto updateCurrentUser(UUID userId, UpdateUserRequest request) {
    User user = userRepository.findById(userId)
        .orElseThrow(() -> new EntityNotFoundException("User not found: " + userId));

    if (request.getUsername() != null && !request.getUsername().isBlank()) {
      user.setUsername(request.getUsername());
    }

    if (request.getAvatarImage() != null) {
      user.setAvatarImage(request.getAvatarImage());
    }

    User saved = userRepository.save(user);
    return toDto(saved);
  }

  @Override
  public UserDto updateAvatar(UUID userId, MultipartFile file) throws IOException {
    User user = userRepository.findById(userId)
        .orElseThrow(() -> new EntityNotFoundException("User not found: " + userId));

    if (file.isEmpty()) {
      throw new IllegalArgumentException("Empty file");
    }

    Path baseUploadPath = Paths.get(uploadDir).toAbsolutePath().normalize();

    Path avatarsDir = baseUploadPath.resolve("avatars");
    Files.createDirectories(avatarsDir);

    String originalName = file.getOriginalFilename();
    String ext = StringUtils.getFilenameExtension(originalName);
    if (ext == null || ext.isBlank()) {
      ext = "jpg";
    }

    String filename = "avatar-" + userId + "-" + System.currentTimeMillis() + "." + ext;
    Path targetPath = avatarsDir.resolve(filename);

    Files.copy(file.getInputStream(), targetPath, StandardCopyOption.REPLACE_EXISTING);

    String publicUrl = "/uploads/avatars/" + filename;
    user.setAvatarImage(publicUrl);

    User saved = userRepository.save(user);
    return toDto(saved);
  }

  private UserDto toDto(User user) {
    return new UserDto(
        user.getId(),
        user.getEmail(),
        user.getUsername(),
        user.getScore(),
        user.getAvatarImage()
    );
  }
}
