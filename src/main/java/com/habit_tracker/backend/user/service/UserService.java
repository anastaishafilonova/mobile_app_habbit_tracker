package com.habit_tracker.backend.user.service;

import com.habit_tracker.backend.user.dto.UpdateUserRequest;
import com.habit_tracker.backend.user.dto.UserDto;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public interface UserService {

  UserDto getUserById(UUID userId);

  UserDto getCurrentUser(UUID userId);

  UserDto updateCurrentUser(UUID userId, UpdateUserRequest request);

  List<UserDto> getAllUsers();

  UserDto updateAvatar(UUID userId, MultipartFile file) throws IOException;
}
