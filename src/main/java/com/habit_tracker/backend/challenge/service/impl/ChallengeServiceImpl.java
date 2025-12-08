package com.habit_tracker.backend.challenge.service.impl;

import com.habit_tracker.backend.challenge.dto.*;
import com.habit_tracker.backend.challenge.entity.Challenge;
import com.habit_tracker.backend.challenge.entity.ChallengeLibrary;
import com.habit_tracker.backend.challenge.entity.ChallengeStatus;
import com.habit_tracker.backend.challenge.repository.ChallengeLibraryRepository;
import com.habit_tracker.backend.challenge.repository.ChallengeRepository;
import com.habit_tracker.backend.challenge.service.ChallengeService;
import com.habit_tracker.backend.challenge_user.entity.ChallengeUser;
import com.habit_tracker.backend.challenge_user.repository.ChallengeUserRepository;
import com.habit_tracker.backend.user.entity.User;
import com.habit_tracker.backend.user.repository.UserRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.aop.scope.ScopedProxyUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

@Service
@Transactional
public class ChallengeServiceImpl implements ChallengeService {

  private final ChallengeRepository challengeRepository;
  private final ChallengeLibraryRepository challengeLibraryRepository;
  private final UserRepository userRepository;
  private final ChallengeUserRepository challengeUserRepository;

  public ChallengeServiceImpl(ChallengeRepository challengeRepository,
                              ChallengeLibraryRepository challengeLibraryRepository,
                              UserRepository userRepository, ChallengeUserRepository challengeUserRepository) {
    this.challengeRepository = challengeRepository;
    this.challengeLibraryRepository = challengeLibraryRepository;
    this.userRepository = userRepository;
    this.challengeUserRepository = challengeUserRepository;
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
    challenge.setIcon(request.getIcon());

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
//    for (User participant : participants) {
//      ChallengeUser cu = new ChallengeUser();
//      cu.setChallenge(saved);
//      cu.setUser(participant);
//      challengeUserRepository.save(cu);
//    }
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

    ChallengeUser cu = challengeUserRepository
        .findByChallengeIdAndUserId(challengeId, currentUserId)
        .orElseThrow(() -> new EntityNotFoundException(
            "ChallengeUser not found for challenge " + challengeId + " and user " + currentUserId
        ));

    if (cu.getStatus() == ChallengeStatus.COMPLETED) {
      return toDto(challenge);
    }

    if (cu.getProgressDays() < challenge.getAim()) {
      cu.setProgressDays(cu.getProgressDays() + 1);
      cu.setLastCheckDate(LocalDate.now());
      User u = cu.getUser();
      u.setScore(u.getScore() + 10);

      if (cu.getProgressDays() >= challenge.getAim()) {
        cu.setStatus(ChallengeStatus.COMPLETED);
      }
      challengeUserRepository.save(cu);
    }

    int maxProgress = challengeUserRepository.findByChallengeId(challengeId).stream()
        .mapToInt(ChallengeUser::getProgressDays)
        .max()
        .orElse(0);
    challenge.setCurrentProgress(maxProgress);

    boolean allCompleted = challengeUserRepository.findByChallengeId(challengeId).stream()
        .allMatch(cuItem -> cuItem.getStatus() == ChallengeStatus.COMPLETED);

    if (allCompleted) {
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
//      ChallengeUser cu = new ChallengeUser();
//      cu.setChallenge(challenge);
//      cu.setUser(u);
//      challengeUserRepository.save(cu);
    }

    Challenge saved = challengeRepository.save(challenge);
    return toDto(saved);
  }

  public ChallengeDto getChallenge(UUID challengeId, UUID currentUserId) {
    Challenge challenge = challengeRepository.findById(challengeId)
        .orElseThrow(() -> new EntityNotFoundException("Challenge not found: " + challengeId));

    boolean isParticipant = challenge.getParticipants().stream()
        .anyMatch(u -> u.getId().equals(currentUserId));

    if (!isParticipant) {
      throw new IllegalStateException("User is not a participant of this challenge");
    }

    return toDto(challenge);
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
    List<ChallengeUser> challengeUsers = challengeUserRepository.findByChallengeId(challenge.getId());

    List<ChallengeParticipantDto> participants = challengeUsers.stream()
        .map(cu -> new ChallengeParticipantDto(
            cu.getUser().getId(),
            cu.getUser().getEmail(),
            cu.getUser().getUsername(),
            cu.getProgressDays(),
            cu.getStatus(),
            cu.getLastCheckDate() != null && cu.getLastCheckDate().isEqual(LocalDate.now())
        ))
        .toList();

    for (ChallengeParticipantDto p: participants) {
      System.out.println(p.getUsername());
      System.out.println(p.getProgressDays());
    }

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
        participants,
        challenge.getIcon()
    );
  }
}
