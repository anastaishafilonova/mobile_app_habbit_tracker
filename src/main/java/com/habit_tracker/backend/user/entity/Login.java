package com.habit_tracker.backend.user.entity;

import jakarta.persistence.*;

import java.util.UUID;

@Entity
@Table(name = "logins")
public class Login {

  @Id
  @Column(name = "user_id")
  private UUID userId;

  @OneToOne
  @MapsId
  @JoinColumn(name = "user_id")
  private User user;

  @Column(name = "login", nullable = false, unique = true, length = 255)
  private String login;

  @Column(name = "hashed_password", nullable = false, length = 255)
  private String hashedPassword;

  protected Login() {
  }

  public Login(User user, String login, String hashedPassword) {
    this.user = user;
    this.login = login;
    this.hashedPassword = hashedPassword;
  }

  public UUID getUserId() {
    return userId;
  }

  public User getUser() {
    return user;
  }

  public void setUser(User user) {
    this.user = user;
  }

  public String getLogin() {
    return login;
  }

  public void setLogin(String login) {
    this.login = login;
  }

  public String getHashedPassword() {
    return hashedPassword;
  }

  public void setHashedPassword(String hashedPassword) {
    this.hashedPassword = hashedPassword;
  }
}
