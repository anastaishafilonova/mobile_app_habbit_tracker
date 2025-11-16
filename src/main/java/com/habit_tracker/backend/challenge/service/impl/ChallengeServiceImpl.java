package com.habit_tracker.backend.challenge.service.impl;

import com.habit_tracker.backend.challenge.dto.ChallengeDto;
import com.habit_tracker.backend.challenge.dto.ChallengeLibraryDto;
import com.habit_tracker.backend.challenge.dto.CreateChallengeRequest;
import com.habit_tracker.backend.challenge.dto.InviteUsersRequest;
import com.habit_tracker.backend.challenge.entity.Challenge;
import com.habit_tracker.backend.challenge.entity.ChallengeLibrary;
import com.habit_tracker.backend.challenge.entity.ChallengeStatus;
import com.habit_tracker.backend.challenge.repository.ChallengeLibraryRepository;
import com.habit_tracker.backend.challenge.repository.ChallengeRepository;
import com.habit_tracker.backend.challenge.service.ChallengeService;
import com.habit_tracker.backend.user.entity.User;
import com.habit_tracker.backend.user.repository.UserRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Service
@Transactional
public class ChallengeServiceImpl implements ChallengeService {

  private final ChallengeRepository challengeRepository;
  private final ChallengeLibraryRepository challengeLibraryRepository;
  private final UserRepository userRepository;

  public ChallengeServiceImpl(ChallengeRepository challengeRepository,
                              ChallengeLibraryRepository challengeLibraryRepository,
                              UserRepository userRepository) {
    this.challengeRepository = challengeRepository;
    this.challengeLibraryRepository = challengeLibraryRepository;
    this.userRepository = userRepository;
  }

  @Override
  @Transactional(readOnly = true)
  public List<ChallengeLibraryDto> getLibrary() {
    return challengeLibraryRepository.findAll()
        .stream()
        .map(this::toLibraryDto)
        .collect(Collectors.toList());
  }

  @Override
  public ChallengeDto createChallenge(UUID currentUserId, CreateChallengeRequest request) {
    User creator = userRepository.findById(currentUserId)
        .orElseThrow(() -> new EntityNotFoundException("User not found: " + currentUserId));

    Challenge challenge = new Challenge();
    challenge.setTitle(request.getTitle());
    challenge.setDescription(request.getDescription());
    challenge.setStartTime(request.getStartTime());
    challenge.setEndTime(request.getEndTime());
    challenge.setFrequency(request.getFrequency());
    challenge.setAim(request.getAim());
    challenge.setCurrentProgress(0);
    challenge.setPushOn(request.isPushOn());
    challenge.setStatus(ChallengeStatus.ACTIVE);
    challenge.setCreatedBy(creator);

    if (request.getTemplateId() != null) {
      ChallengeLibrary template = challengeLibraryRepository.findById(request.getTemplateId())
          .orElseThrow(() -> new EntityNotFoundException("Template not found: " + request.getTemplateId()));
      challenge.setTemplate(template);
    }

    Set<User> participants = new HashSet<>();
    participants.add(creator);

    if (request.getOpponentIds() != null && !request.getOpponentIds().isEmpty()) {
      List<User> opponents = userRepository.findAllById(request.getOpponentIds());
      if (opponents.size() != request.getOpponentIds().size()) {
        throw new EntityNotFoundException("Some opponents not found");
      }
      participants.addAll(opponents);
    }

    challenge.setParticipants(participants);

    Challenge saved = challengeRepository.save(challenge);
    return toDto(saved);
  }

  @Override
  @Transactional(readOnly = true)
  public List<ChallengeDto> getMyChallenges(UUID currentUserId) {
    List<Challenge> challenges = challengeRepository.findByParticipants_Id(currentUserId);
    return challenges.stream()
        .map(this::toDto)
        .collect(Collectors.toList());
  }

  @Override
  public ChallengeDto markProgress(UUID currentUserId, UUID challengeId) {
    Challenge challenge = getChallengeForUser(challengeId, currentUserId);

    if (challenge.getStatus() != ChallengeStatus.ACTIVE) {
      throw new IllegalStateException("Challenge is not active");
    }

    if (challenge.getCurrentProgress() < challenge.getAim()) {
      challenge.setCurrentProgress(challenge.getCurrentProgress() + 1);
    }

    if (challenge.getCurrentProgress() >= challenge.getAim()) {
      challenge.setStatus(ChallengeStatus.COMPLETED);
    }

    Challenge saved = challengeRepository.save(challenge);
    return toDto(saved);
  }

  @Override
  public ChallengeDto completeChallenge(UUID currentUserId, UUID challengeId) {
    Challenge challenge = getChallengeForUser(challengeId, currentUserId);
    challenge.setStatus(ChallengeStatus.COMPLETED);
    Challenge saved = challengeRepository.save(challenge);
    return toDto(saved);
  }

  @Override
  public void deleteChallenge(UUID currentUserId, UUID challengeId) {
    Challenge challenge = challengeRepository.findById(challengeId)
        .orElseThrow(() -> new EntityNotFoundException("Challenge not found: " + challengeId));

    if (challenge.getCreatedBy() == null ||
        !challenge.getCreatedBy().getId().equals(currentUserId)) {
      throw new IllegalStateException("Only creator can delete challenge");
    }

    challengeRepository.delete(challenge);
  }

  @Override
  public ChallengeDto inviteUsers(UUID currentUserId, UUID challengeId, InviteUsersRequest request) {
    Challenge challenge = getChallengeForUser(challengeId, currentUserId);

    if (request.getOpponentIds() == null || request.getOpponentIds().isEmpty()) {
      return toDto(challenge);
    }

    List<User> opponents = userRepository.findAllById(request.getOpponentIds());
    if (opponents.isEmpty()) {
      throw new EntityNotFoundException("Opponents not found");
    }

    for (User u : opponents) {
      challenge.addParticipant(u);
    }

    Challenge saved = challengeRepository.save(challenge);
    return toDto(saved);
  }

  private Challenge getChallengeForUser(UUID challengeId, UUID currentUserId) {
    Challenge challenge = challengeRepository.findById(challengeId)
        .orElseThrow(() -> new EntityNotFoundException("Challenge not found: " + challengeId));

    boolean isParticipant = challenge.getParticipants().stream()
        .anyMatch(u -> u.getId().equals(currentUserId));

    if (!isParticipant) {
      throw new IllegalStateException("User is not a participant of this challenge");
    }

    return challenge;
  }

  private ChallengeLibraryDto toLibraryDto(ChallengeLibrary cl) {
    return new ChallengeLibraryDto(
        cl.getId(),
        cl.getTitle(),
        cl.getDescription(),
        cl.getPhoto(),
        cl.getFrequency()
    );
  }

  private ChallengeDto toDto(Challenge challenge) {
    UUID templateId = challenge.getTemplate() != null ? challenge.getTemplate().getId() : null;
    UUID creatorId = challenge.getCreatedBy() != null ? challenge.getCreatedBy().getId() : null;
    List<UUID> participantIds = challenge.getParticipants().stream()
        .map(User::getId)
        .collect(Collectors.toList());

    return new ChallengeDto(
        challenge.getId(),
        challenge.getTitle(),
        challenge.getDescription(),
        challenge.getStatus(),
        challenge.getStartTime(),
        challenge.getEndTime(),
        challenge.getFrequency(),
        challenge.getAim(),
        challenge.getCurrentProgress(),
        challenge.isPushOn(),
        templateId,
        creatorId,
        participantIds
    );
  }
}
