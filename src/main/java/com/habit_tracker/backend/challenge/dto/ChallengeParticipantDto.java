package com.habit_tracker.backend.challenge.dto;

import com.habit_tracker.backend.challenge.entity.ChallengeStatus;

import java.util.UUID;

public class ChallengeParticipantDto {
  private UUID id;
  private String email;
  private String username;
  private int progressDays;
  private ChallengeStatus status;
  private Boolean markedToday;

  public ChallengeParticipantDto(
      UUID id,
      String email,
      String username,
      int progressDays,
      ChallengeStatus status,
      Boolean markedToday) {
    this.id = id;
    this.email = email;
    this.username = username;
    this.progressDays = progressDays;
    this.status = status;
    this.markedToday = markedToday;
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

  public int getProgressDays() {
    return progressDays;
  }

  public void setProgressDays(int progressDays) {
    this.progressDays = progressDays;
  }

  public ChallengeStatus getStatus() {
    return status;
  }

  public void setStatus(ChallengeStatus status) {
    this.status = status;
  }

  public Boolean getMarkedToday() {
    return markedToday;
  }

  public void setMarkedToday(Boolean markedToday) {
    this.markedToday = markedToday;
  }
}
