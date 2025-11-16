package com.habit_tracker.backend.auth.service;

import com.habit_tracker.backend.auth.dto.AuthResponse;
import com.habit_tracker.backend.auth.dto.LoginRequest;
import com.habit_tracker.backend.auth.dto.RegisterRequest;

public interface AuthService {

  AuthResponse register(RegisterRequest request);

  AuthResponse login(LoginRequest request);
}
