package com.habit_tracker.backend.challenge.repository;

import com.habit_tracker.backend.challenge.entity.ChallengeLibrary;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface ChallengeLibraryRepository extends JpaRepository<ChallengeLibrary, UUID> {
}
