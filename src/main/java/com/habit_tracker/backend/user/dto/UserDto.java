package com.habit_tracker.backend.user.dto;

import java.util.UUID;

public class UserDto {

  private UUID id;
  private String email;
  private String username;
  private int score;
  private String avatarImage;
  public UserDto() {
  }

  public UserDto(UUID id, String email, String username, int score, String avatarImage) {
    this.id = id;
    this.email = email;
    this.username = username;
    this.score = score;
    this.avatarImage = avatarImage;
  }

  public UUID getId() {
    return id;
  }

  public void setId(UUID id) {
    this.id = id;
  }

  public String getEmail() {
    return email;
  }

  public void setEmail(String email) {
    this.email = email;
  }

  public String getUsername() {
    return username;
  }

  public void setUsername(String username) {
    this.username = username;
  }

  public int getScore() {
    return score;
  }

  public void setScore(int score) {
    this.score = score;
  }

  public String getAvatarImage() {
    return avatarImage;
  }

  public void setAvatarImage(String avatarImage) {
    this.avatarImage = avatarImage;
  }
}
