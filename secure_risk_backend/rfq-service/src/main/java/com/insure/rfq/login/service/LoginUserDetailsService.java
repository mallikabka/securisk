package com.insure.rfq.login.service;

import jakarta.servlet.http.HttpServletRequest;

public interface LoginUserDetailsService {

    boolean saveClientDetails( String email);
}
