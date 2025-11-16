package com.habit_tracker.backend.user.controller;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import com.habit_tracker.backend.user.dto.UpdateUserRequest;
import com.habit_tracker.backend.user.dto.UserDto;
import com.habit_tracker.backend.user.service.UserService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/users")
public class UserController {

  private final UserService userService;

  public UserController(UserService userService) {
    this.userService = userService;
  }

  @GetMapping("/me")
  public UserDto getMe(@AuthenticationPrincipal UUID userId) {
    return userService.getCurrentUser(userId);
  }

  @PutMapping("/me")
  public UserDto updateMe(
      @AuthenticationPrincipal UUID userId,
      @Valid @RequestBody UpdateUserRequest request
  ) {
    return userService.updateCurrentUser(userId, request);
  }
}
