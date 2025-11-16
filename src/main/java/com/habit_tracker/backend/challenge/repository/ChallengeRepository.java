package com.habit_tracker.backend.challenge.repository;

import com.habit_tracker.backend.challenge.entity.Challenge;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface ChallengeRepository extends JpaRepository<Challenge, UUID> {
  List<Challenge> findByParticipants_Id(UUID userId);
}
