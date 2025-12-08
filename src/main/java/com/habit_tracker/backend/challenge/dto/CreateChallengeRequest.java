package com.habit_tracker.backend.challenge.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.UUID;

public class CreateChallengeRequest {

  @NotBlank
  private String title;

  private String description;

  @NotNull
  private OffsetDateTime startTime;

  @NotNull
  private OffsetDateTime endTime;

  @NotBlank
  private String frequency;

  @Min(1)
  private int aim;

  private boolean pushOn = true;

  private UUID templateId;

  private List<UUID> opponentIds;
  @NotNull
  private String icon;

  public CreateChallengeRequest() {
  }

  public String getTitle() {
    return title;
  }

  public void setTitle(String title) {
    this.title = title;
  }

  public String getDescription() {
    return description;
  }

  public void setDescription(String description) {
    this.description = description;
  }

  public OffsetDateTime getStartTime() {
    return startTime;
  }

  public void setStartTime(OffsetDateTime startTime) {
    this.startTime = startTime;
  }

  public OffsetDateTime getEndTime() {
    return endTime;
  }

  public void setEndTime(OffsetDateTime endTime) {
    this.endTime = endTime;
  }

  public String getFrequency() {
    return frequency;
  }

  public void setFrequency(String frequency) {
    this.frequency = frequency;
  }

  public int getAim() {
    return aim;
  }

  public void setAim(int aim) {
    this.aim = aim;
  }

  public boolean isPushOn() {
    return pushOn;
  }

  public void setPushOn(boolean pushOn) {
    this.pushOn = pushOn;
  }

  public UUID getTemplateId() {
    return templateId;
  }

  public void setTemplateId(UUID templateId) {
    this.templateId = templateId;
  }

  public List<UUID> getOpponentIds() {
    return opponentIds;
  }

  public void setOpponentIds(List<UUID> opponentIds) {
    this.opponentIds = opponentIds;
  }

  public String getIcon() {
    return icon;
  }

  public void setIcon(String icon) {
    this.icon = icon;
  }
}
