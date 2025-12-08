package com.habit_tracker.backend.user.controller;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import com.habit_tracker.backend.user.dto.UpdateUserRequest;
import com.habit_tracker.backend.user.dto.UserDto;
import com.habit_tracker.backend.user.service.UserService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
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

  @GetMapping("/all")
  public List<UserDto> getAllUsers(@AuthenticationPrincipal UUID userId) {
    return userService.getAllUsers();
  }

  @GetMapping("/{id}")
  public UserDto getUser(@PathVariable("id") UUID id) {
    return userService.getUserById(id);
  }

  @PutMapping("/me")
  public UserDto updateMe(
      @AuthenticationPrincipal UUID userId,
      @Valid @RequestBody UpdateUserRequest request
  ) {
    return userService.updateCurrentUser(userId, request);
  }

  @PostMapping("/me/avatar")
  public UserDto uploadAvatar(
      @AuthenticationPrincipal UUID userId,
      @RequestParam("file") MultipartFile file
  ) throws IOException {
    return userService.updateAvatar(userId, file);
  }
}
