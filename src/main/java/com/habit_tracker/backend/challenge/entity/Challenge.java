package com.habit_tracker.backend.challenge.entity;

import com.habit_tracker.backend.user.entity.User;
import jakarta.persistence.*;

import java.time.OffsetDateTime;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

@Entity
@Table(name = "challenges")
public class Challenge {

  @Id
  @GeneratedValue
  @Column(name = "id", nullable = false, updatable = false)
  private UUID id;

  @Column(name = "title", nullable = false, length = 255)
  private String title;

  @Column(name = "description")
  private String description;

  @Enumerated(EnumType.STRING)
  @Column(name = "status", nullable = false, length = 50)
  private ChallengeStatus status;

  @Column(name = "start_time", nullable = false)
  private OffsetDateTime startTime;

  @Column(name = "end_time", nullable = false)
  private OffsetDateTime endTime;

  @Column(name = "frequency", nullable = false, length = 50)
  private String frequency;

  @Column(name = "aim", nullable = false)
  private int aim;

  @Column(name = "current_progress", nullable = false)
  private int currentProgress;

  @Column(name = "push_on", nullable = false)
  private boolean pushOn;

  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "template_id")
  private ChallengeLibrary template;

  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "created_by")
  private User createdBy;

  @ManyToMany
  @JoinTable(
      name = "challenge_user",
      joinColumns = @JoinColumn(name = "challenge_id"),
      inverseJoinColumns = @JoinColumn(name = "user_id")
  )
  private Set<User> participants = new HashSet<>();

  @Column(name = "created_at", nullable = false)
  private OffsetDateTime createdAt;

  @Column(name = "updated_at", nullable = false)
  private OffsetDateTime updatedAt;

  public Challenge() {
  }

  @PrePersist
  public void prePersist() {
    OffsetDateTime now = OffsetDateTime.now();
    this.createdAt = now;
    this.updatedAt = now;
    if (this.status == null) {
      this.status = ChallengeStatus.ACTIVE;
    }
  }

  @PreUpdate
  public void preUpdate() {
    this.updatedAt = OffsetDateTime.now();
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

  public ChallengeLibrary getTemplate() {
    return template;
  }

  public void setTemplate(ChallengeLibrary template) {
    this.template = template;
  }

  public User getCreatedBy() {
    return createdBy;
  }

  public void setCreatedBy(User createdBy) {
    this.createdBy = createdBy;
  }

  public Set<User> getParticipants() {
    return participants;
  }

  public void setParticipants(Set<User> participants) {
    this.participants = participants;
  }

  public OffsetDateTime getCreatedAt() {
    return createdAt;
  }

  public void setCreatedAt(OffsetDateTime createdAt) {
    this.createdAt = createdAt;
  }

  public OffsetDateTime getUpdatedAt() {
    return updatedAt;
  }

  public void setUpdatedAt(OffsetDateTime updatedAt) {
    this.updatedAt = updatedAt;
  }

  public void addParticipant(User user) {
    this.participants.add(user);
  }
}
