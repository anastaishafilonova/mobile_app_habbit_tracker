package com.habit_tracker.backend.challenge.dto;

import jakarta.validation.constraints.NotEmpty;

import java.util.List;
import java.util.UUID;

public class InviteUsersRequest {

  @NotEmpty
  private List<UUID> opponentIds;

  public InviteUsersRequest() {
  }

  public InviteUsersRequest(List<UUID> opponentIds) {
    this.opponentIds = opponentIds;
  }

  public List<UUID> getOpponentIds() {
    return opponentIds;
  }

  public void setOpponentIds(List<UUID> opponentIds) {
    this.opponentIds = opponentIds;
  }
}
