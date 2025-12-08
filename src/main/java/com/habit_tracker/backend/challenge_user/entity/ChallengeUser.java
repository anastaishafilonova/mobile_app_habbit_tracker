package com.habit_tracker.backend.challenge_user.entity;

import com.habit_tracker.backend.challenge.entity.Challenge;
import com.habit_tracker.backend.challenge.entity.ChallengeStatus;
import com.habit_tracker.backend.user.entity.User;
import jakarta.persistence.*;

import java.time.LocalDate;
import java.util.*;

@Entity
@IdClass(ChallengeUserId.class)
@Table(name = "challenge_user")
public class ChallengeUser {

  @Id
  @ManyToOne
  @JoinColumn(name = "challenge_id")
  private Challenge challenge;

  @Id
  @ManyToOne
  @JoinColumn(name = "user_id")
  private User user;

  private int progressDays = 0;

  private LocalDate lastCheckDate;

  @Enumerated(EnumType.STRING)
  private ChallengeStatus status = ChallengeStatus.ACTIVE;

  public Challenge getChallenge() {
    return challenge;
  }

  public void setChallenge(Challenge challenge) {
    this.challenge = challenge;
  }

  public User getUser() {
    return user;
  }

  public void setUser(User user) {
    this.user = user;
  }

  public int getProgressDays() {
    return progressDays;
  }

  public void setProgressDays(int progressDays) {
    this.progressDays = progressDays;
  }

  public LocalDate getLastCheckDate() {
    return lastCheckDate;
  }

  public void setLastCheckDate(LocalDate lastCheckDate) {
    this.lastCheckDate = lastCheckDate;
  }

  public ChallengeStatus getStatus() {
    return status;
  }

  public void setStatus(ChallengeStatus status) {
    this.status = status;
  }
}

