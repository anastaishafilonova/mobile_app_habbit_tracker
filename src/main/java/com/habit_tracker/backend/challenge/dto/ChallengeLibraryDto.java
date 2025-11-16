package com.habit_tracker.backend.challenge.dto;

import java.util.UUID;

public class ChallengeLibraryDto {

  private UUID id;
  private String title;
  private String description;
  private String photo;
  private String frequency;

  public ChallengeLibraryDto() {
  }

  public ChallengeLibraryDto(UUID id, String title, String description, String photo, String frequency) {
    this.id = id;
    this.title = title;
    this.description = description;
    this.photo = photo;
    this.frequency = frequency;
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

  public String getPhoto() {
    return photo;
  }

  public void setPhoto(String photo) {
    this.photo = photo;
  }

  public String getFrequency() {
    return frequency;
  }

  public void setFrequency(String frequency) {
    this.frequency = frequency;
  }
}
