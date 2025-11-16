package com.habit_tracker.backend.challenge.controller;

import com.habit_tracker.backend.challenge.dto.*;
import com.habit_tracker.backend.challenge.service.ChallengeService;
import jakarta.validation.Valid;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/challenges")
public class ChallengeController {

  private final ChallengeService challengeService;

  public ChallengeController(ChallengeService challengeService) {
    this.challengeService = challengeService;
  }

  @GetMapping("/library")
  public List<ChallengeLibraryDto> getLibrary() {
    return challengeService.getLibrary();
  }

  @PostMapping("/create")
  public ChallengeDto createChallenge(
      @AuthenticationPrincipal UUID userId,
      @Valid @RequestBody CreateChallengeRequest request
  ) {
    return challengeService.createChallenge(userId, request);
  }

  @GetMapping("/my")
  public List<ChallengeDto> getMyChallenges(
      @AuthenticationPrincipal UUID userId
  ) {
    return challengeService.getMyChallenges(userId);
  }

  @PostMapping("/{id}/progress")
  public ChallengeDto markProgress(
      @AuthenticationPrincipal UUID userId,
      @PathVariable("id") UUID challengeId
  ) {
    return challengeService.markProgress(userId, challengeId);
  }

  @PostMapping("/{id}/complete")
  public ChallengeDto completeChallenge(
      @AuthenticationPrincipal UUID userId,
      @PathVariable("id") UUID challengeId
  ) {
    return challengeService.completeChallenge(userId, challengeId);
  }

  @DeleteMapping("/{id}")
  public void deleteChallenge(
      @AuthenticationPrincipal UUID userId,
      @PathVariable("id") UUID challengeId
  ) {
    challengeService.deleteChallenge(userId, challengeId);
  }

  @PostMapping("/{id}/invite")
  public ChallengeDto inviteUsers(
      @AuthenticationPrincipal UUID userId,
      @PathVariable("id") UUID challengeId,
      @Valid @RequestBody InviteUsersRequest request
  ) {
    return challengeService.inviteUsers(userId, challengeId, request);
  }
}
