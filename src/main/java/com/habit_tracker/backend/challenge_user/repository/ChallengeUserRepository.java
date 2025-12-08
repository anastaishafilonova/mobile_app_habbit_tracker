package com.habit_tracker.backend.challenge_user.repository;

import com.habit_tracker.backend.challenge_user.entity.ChallengeUser;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.*;

public interface ChallengeUserRepository extends JpaRepository<ChallengeUser, UUID> {
  List<ChallengeUser> findByChallengeId(UUID challengeId);
  Optional<ChallengeUser> findByChallengeIdAndUserId(UUID challengeId, UUID userId);
}

