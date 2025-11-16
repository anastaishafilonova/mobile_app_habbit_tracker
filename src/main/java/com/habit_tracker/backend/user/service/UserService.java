package com.habit_tracker.backend.user.service;

import com.habit_tracker.backend.user.dto.UpdateUserRequest;
import com.habit_tracker.backend.user.dto.UserDto;

import java.util.UUID;

public interface UserService {

  UserDto getUserById(UUID userId);

  UserDto getCurrentUser(UUID userId);

  UserDto updateCurrentUser(UUID userId, UpdateUserRequest request);
}
