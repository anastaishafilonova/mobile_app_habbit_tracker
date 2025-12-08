package com.habit_tracker.backend.challenge.service;

import com.habit_tracker.backend.challenge.dto.ChallengeDto;
import com.habit_tracker.backend.challenge.dto.ChallengeLibraryDto;
import com.habit_tracker.backend.challenge.dto.CreateChallengeRequest;
import com.habit_tracker.backend.challenge.dto.InviteUsersRequest;
import com.habit_tracker.backend.challenge.entity.Challenge;

import java.util.List;
import java.util.UUID;

public interface ChallengeService {

  List<ChallengeLibraryDto> getLibrary();

  ChallengeDto createChallenge(UUID currentUserId, CreateChallengeRequest request);

  List<ChallengeDto> getMyChallenges(UUID currentUserId);

  ChallengeDto markProgress(UUID currentUserId, UUID challengeId);

  ChallengeDto completeChallenge(UUID currentUserId, UUID challengeId);

  ChallengeDto getChallenge(UUID challengeId, UUID currentUserId);

  void deleteChallenge(UUID currentUserId, UUID challengeId);

  ChallengeDto inviteUsers(UUID currentUserId, UUID challengeId, InviteUsersRequest request);
}
