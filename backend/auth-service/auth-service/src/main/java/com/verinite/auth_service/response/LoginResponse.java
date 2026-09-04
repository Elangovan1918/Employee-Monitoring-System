package com.verinite.auth_service.response;

public record LoginResponse( String accessToken,
                             String refreshToken,
                             String tokenType,
                             long expiresIn) {
}
