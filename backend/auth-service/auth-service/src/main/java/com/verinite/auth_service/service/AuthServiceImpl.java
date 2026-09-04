package com.verinite.auth_service.service;

import com.verinite.auth_service.adapter.AuthService;
import com.verinite.auth_service.request.LoginRequest;
import com.verinite.auth_service.response.LoginResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final AuthenticationManager authenticationManager;
    private final CustomUserDetailsService userDetailsService;
    private final JwtService jwtService;
    @Autowired
    private PasswordEncoder passwordEncoder;




    @Override
    public LoginResponse login(LoginRequest request) {

        String encoded = passwordEncoder.encode("admin123");
        System.out.println(encoded);

        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.username(),
                        request.password()
                )
        );

        UserDetails user =
                userDetailsService.loadUserByUsername(
                        request.username());

        String accessToken =
                jwtService.generateToken(user);

        String refreshToken =
                UUID.randomUUID().toString();

        return new LoginResponse(
                accessToken,
                refreshToken,
                "Bearer",
                3600
        );
    }
}

