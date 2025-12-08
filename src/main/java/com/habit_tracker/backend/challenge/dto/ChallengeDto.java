package com.habit_tracker.backend.challenge.dto;

import com.habit_tracker.backend.challenge.entity.ChallengeStatus;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.UUID;

public class ChallengeDto {

  private UUID id;
  private String title;
  private String description;
  private ChallengeStatus status;
  private OffsetDateTime startTime;
  private OffsetDateTime endTime;
  private String frequency;
  private int aim;
  private int currentProgress;
  private boolean pushOn;
  private UUID templateId;
  private UUID createdBy;
  private List<ChallengeParticipantDto> participants;
  private String icon;

  public ChallengeDto() {}

  public ChallengeDto(
      UUID id,
      String title,
      String description,
      ChallengeStatus status,
      OffsetDateTime startTime,
      OffsetDateTime endTime,
      String frequency,
      int aim,
      int currentProgress,
      boolean pushOn,
      UUID templateId,
      UUID createdBy,
      List<ChallengeParticipantDto> participants,
      String icon) {
    this.id = id;
    this.title = title;
    this.description = description;
    this.status = status;
    this.startTime = startTime;
    this.endTime = endTime;
    this.frequency = frequency;
    this.aim = aim;
    this.currentProgress = currentProgress;
    this.pushOn = pushOn;
    this.templateId = templateId;
    this.createdBy = createdBy;
    this.participants = participants;
    this.icon = icon;
  }

  public UUID getId() {
    return id;
  }

  public void setId(UUID id) {
    this.id = id;
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

  public ChallengeStatus getStatus() {
    return status;
  }

  public void setStatus(ChallengeStatus status) {
    this.status = status;
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

  public int getCurrentProgress() {
    return currentProgress;
  }

  public void setCurrentProgress(int currentProgress) {
    this.currentProgress = currentProgress;
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

  public UUID getCreatedBy() {
    return createdBy;
  }

  public void setCreatedBy(UUID createdBy) {
    this.createdBy = createdBy;
  }

  public List<ChallengeParticipantDto> getParticipants() {
    return participants;
  }

  public void setParticipants(List<ChallengeParticipantDto> participants) {
    this.participants = participants;
  }

  public String getIcon() {
    return icon;
  }

  public void setIcon(String icon) {
    this.icon = icon;
  }
}
