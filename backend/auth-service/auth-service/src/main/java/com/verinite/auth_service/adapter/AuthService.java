package com.verinite.auth_service.adapter;

import com.verinite.auth_service.request.LoginRequest;
import com.verinite.auth_service.response.LoginResponse;

public interface AuthService {

    LoginResponse login(LoginRequest request);

}
