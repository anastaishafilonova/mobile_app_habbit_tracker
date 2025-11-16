package com.habit_tracker.backend.auth.dto;

import java.util.Date;
import java.util.UUID;

public class AuthResponse {

  private String token;
  private Date expiresAt;
  private UUID userId;
  private String email;
  private String username;

  public AuthResponse() {}

  public AuthResponse(String token, Date expiresAt, UUID userId, String email, String username) {
    this.token = token;
    this.expiresAt = expiresAt;
    this.userId = userId;
    this.email = email;
    this.username = username;
  }

  public String getToken() {
    return token;
  }

  public Date getExpiresAt() {
    return expiresAt;
  }

  public UUID getUserId() {
    return userId;
  }

  public String getEmail() {
    return email;
  }

  public String getUsername() {
    return username;
  }
}
