package com.pds.microservices.Staff_service.client;
//package com.pds.microservices.Auth_service.dto

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@FeignClient(name = "Auth-service", url = "${Auth-service.url:http://localhost:9003}")
public interface AuthServiceClient {

    // ---------- CREATE USER ----------
    @PostMapping("/users/register")
    ResponseEntity<UserResponseDTO> registerUser(@RequestBody UserRegistrationDTO userDTO);

    // ---------- GET USER ----------
    @GetMapping("/users/{userId}")
    ResponseEntity<UserResponseDTO> getUserById(@PathVariable("userId") String userId);

    // ---------- UPDATE USER ----------
    @PutMapping("/users/{userId}")
    ResponseEntity<UserResponseDTO> updateUser(
            @PathVariable("userId") String userId,
            @RequestBody UserRegistrationDTO userDTO
    );

    // ---------- DELETE USER ----------
    @DeleteMapping("/users/{userId}")
    ResponseEntity<Void> deleteUser(@PathVariable("userId") String userId);

    // ---------- HEALTH CHECK ----------
    @GetMapping("/users/health")
    ResponseEntity<String> health();
}

