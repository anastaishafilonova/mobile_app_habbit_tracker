package com.habit_tracker.backend.auth.controller;

import com.habit_tracker.backend.auth.dto.AuthResponse;
import com.habit_tracker.backend.auth.dto.LoginRequest;
import com.habit_tracker.backend.auth.dto.RegisterRequest;
import com.habit_tracker.backend.auth.service.AuthService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

  private final AuthService authService;

  public AuthController(AuthService authService) {
    this.authService = authService;
  }

  @PostMapping("/register")
  public AuthResponse register(@Valid @RequestBody RegisterRequest request) {
    return authService.register(request);
  }

  @PostMapping("/login")
  public AuthResponse login(@Valid @RequestBody LoginRequest request) {
    return authService.login(request);
  }
}
