package com.habit_tracker.backend.user.repository;

import com.habit_tracker.backend.user.entity.Login;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface LoginRepository extends JpaRepository<Login, UUID> {

  Optional<Login> findByLogin(String login);
}
