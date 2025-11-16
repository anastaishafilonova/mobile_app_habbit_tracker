package com.habit_tracker.backend.user.dto;

import jakarta.validation.constraints.Size;

public class UpdateUserRequest {

  @Size(min = 1, max = 255)
  private String username;

  @Size(max = 512)
  private String avatarImage;

  public UpdateUserRequest() {
  }

  public UpdateUserRequest(String username, String avatarImage) {
    this.username = username;
    this.avatarImage = avatarImage;
  }

  public String getUsername() {
    return username;
  }

  public void setUsername(String username) {
    this.username = username;
  }

  public String getAvatarImage() {
    return avatarImage;
  }

  public void setAvatarImage(String avatarImage) {
    this.avatarImage = avatarImage;
  }
}
