package com.habit_tracker.backend.auth.service.impl;

import com.habit_tracker.backend.auth.dto.AuthResponse;
import com.habit_tracker.backend.auth.dto.LoginRequest;
import com.habit_tracker.backend.auth.dto.RegisterRequest;
import com.habit_tracker.backend.auth.service.AuthService;
import com.habit_tracker.backend.security.JwtService;
import com.habit_tracker.backend.user.entity.Login;
import com.habit_tracker.backend.user.entity.User;
import com.habit_tracker.backend.user.repository.LoginRepository;
import com.habit_tracker.backend.user.repository.UserRepository;
import jakarta.persistence.EntityExistsException;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;

@Service
@Transactional
public class AuthServiceImpl implements AuthService {

  private final UserRepository userRepository;
  private final LoginRepository loginRepository;
  private final PasswordEncoder passwordEncoder;
  private final JwtService jwtService;

  public AuthServiceImpl(
      UserRepository userRepository,
      LoginRepository loginRepository,
      PasswordEncoder passwordEncoder,
      JwtService jwtService) {
    this.userRepository = userRepository;
    this.loginRepository = loginRepository;
    this.passwordEncoder = passwordEncoder;
    this.jwtService = jwtService;
  }

  @Override
  public AuthResponse register(RegisterRequest request) {
    if (loginRepository.findByLogin(request.getEmail()).isPresent()) {
      throw new EntityExistsException("Пользователь с таким логином уже существует");
    }

    User user = new User(request.getEmail(), request.getUsername());
    user = userRepository.save(user);

    String hashed = passwordEncoder.encode(request.getPassword());
    Login login = new Login(user, request.getEmail(), hashed);
    loginRepository.save(login);

    String token = jwtService.generateToken(user.getId(), user.getEmail());
    Date expiresAt = new Date(System.currentTimeMillis() + 30L * 24 * 60 * 60 * 1000);

    return new AuthResponse(token, expiresAt, user.getId(), user.getEmail(), user.getUsername());
  }

  @Override
  public AuthResponse login(LoginRequest request) {
    Login login =
        loginRepository
            .findByLogin(request.getLogin())
            .orElseThrow(() -> new EntityNotFoundException("Неверный логин или пароль"));

    if (!passwordEncoder.matches(request.getPassword(), login.getHashedPassword())) {
      throw new EntityNotFoundException("Неверный логин или пароль");
    }

    User user = login.getUser();

    String token = jwtService.generateToken(user.getId(), user.getEmail());
    Date expiresAt = new Date(System.currentTimeMillis() + 30L * 24 * 60 * 60 * 1000);

    return new AuthResponse(token, expiresAt, user.getId(), user.getEmail(), user.getUsername());
  }
}
