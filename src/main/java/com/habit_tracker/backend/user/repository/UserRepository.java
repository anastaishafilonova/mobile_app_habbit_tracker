package com.habit_tracker.backend.user.repository;

import com.habit_tracker.backend.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.ArrayList;
import java.util.Optional;
import java.util.UUID;

public interface UserRepository extends JpaRepository<User, UUID> {

  Optional<User> findByEmail(String email);
}
