package com.habit_tracker.backend.user.entity;

import jakarta.persistence.*;

import java.util.UUID;

@Entity
@Table(name = "users")
public class User {

  @Id
  @GeneratedValue
  @Column(name = "id", nullable = false, updatable = false)
  private UUID id;

  @Column(name = "email", nullable = false, unique = true, length = 255)
  private String email;

  @Column(name = "username", nullable = false, length = 255)
  private String username;

  @Column(name = "score", nullable = false)
  private int score;

  @Column(name = "avatar_image", length = 512)
  private String avatarImage;

  protected User() {}

  public User(String email, String username) {
    this.email = email;
    this.username = username;
    this.score = 0;
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
