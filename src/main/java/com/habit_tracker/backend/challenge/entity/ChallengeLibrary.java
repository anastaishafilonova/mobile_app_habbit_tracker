package com.habit_tracker.backend.challenge.entity;

import jakarta.persistence.*;

import java.util.UUID;

@Entity
@Table(name = "challenge_library")
public class ChallengeLibrary {

  @Id
  @GeneratedValue
  @Column(name = "id", nullable = false, updatable = false)
  private UUID id;

  @Column(name = "title", nullable = false, length = 255)
  private String title;

  @Column(name = "description")
  private String description;

  @Column(name = "photo", length = 512)
  private String photo;

  @Column(name = "frequency", nullable = false, length = 50)
  private String frequency;

  protected ChallengeLibrary() {
  }

  public ChallengeLibrary(String title, String description, String photo, String frequency) {
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
