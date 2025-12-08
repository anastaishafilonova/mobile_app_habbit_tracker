package com.habit_tracker.backend.challenge_user.entity;

import java.io.Serializable;
import java.util.Objects;
import java.util.UUID;

public class ChallengeUserId implements Serializable {
  private UUID challenge;
  private UUID user;

  public ChallengeUserId() {}

  public ChallengeUserId(UUID challenge, UUID user) {
    this.challenge = challenge;
    this.user = user;
  }

  @Override
  public boolean equals(Object o) {
    if (o == null || getClass() != o.getClass()) return false;
    ChallengeUserId that = (ChallengeUserId) o;
    return Objects.equals(challenge, that.challenge) && Objects.equals(user, that.user);
  }

  @Override
  public int hashCode() {
    return Objects.hash(challenge, user);
  }
}

