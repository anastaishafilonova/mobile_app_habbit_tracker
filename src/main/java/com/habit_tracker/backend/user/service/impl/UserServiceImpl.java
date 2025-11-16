package com.habit_tracker.backend.user.service.impl;

import com.habit_tracker.backend.user.dto.UpdateUserRequest;
import com.habit_tracker.backend.user.dto.UserDto;
import com.habit_tracker.backend.user.entity.User;
import com.habit_tracker.backend.user.repository.UserRepository;
import com.habit_tracker.backend.user.service.UserService;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
@Transactional
public class UserServiceImpl implements UserService {

  private final UserRepository userRepository;

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
