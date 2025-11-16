package com.habit_tracker.backend.security;

import io.jsonwebtoken.*;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.security.Key;
import java.util.Date;
import java.util.UUID;

@Service
public class JwtService {

  private final Key signKey;
  private final long expirationMs;

  public JwtService(
      @Value("${jwt.secret}") String secret,
      @Value("${jwt.expiration-ms}") long expirationMs
  ) {
    this.signKey = buildSignKey(secret);
    this.expirationMs = expirationMs;
  }

  public String generateToken(UUID userId, String email) {
    Date now = new Date();
    Date expiry = new Date(now.getTime() + expirationMs);

    return Jwts.builder()
        .setSubject(userId.toString())
        .setIssuedAt(now)
        .setExpiration(expiry)
        .claim("email", email)
        .signWith(signKey, SignatureAlgorithm.HS256)
        .compact();
  }

  public UUID extractUserId(String token) {
    String subject = extractAllClaims(token).getSubject();
    return UUID.fromString(subject);
  }

  public boolean isTokenValid(String token) {
    try {
      extractAllClaims(token);
      return true;
    } catch (JwtException | IllegalArgumentException e) {
      return false;
    }
  }

  private Claims extractAllClaims(String token) {
    return Jwts.parserBuilder()
        .setSigningKey(signKey)
        .build()
        .parseClaimsJws(token)
        .getBody();
  }

  private Key buildSignKey(String secret) {
    byte[] keyBytes = Decoders.BASE64.decode(secret);
    return Keys.hmacShaKeyFor(keyBytes);
  }
}
