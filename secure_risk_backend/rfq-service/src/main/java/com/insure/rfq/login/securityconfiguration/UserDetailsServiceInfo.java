package com.insure.rfq.login.securityconfiguration;

import java.util.Optional;

import com.insure.rfq.login.entity.UserRegisteration;
import com.insure.rfq.login.repository.UserRepositiry;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Component;
@Component
public class UserDetailsServiceInfo implements UserDetailsService {
	@Autowired
private UserRepositiry newRepositiry;
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		Optional<UserRegisteration> userNew = newRepositiry.findByEmail(username);
        return  userNew.map(UserDetailsInfo :: new ).orElseThrow(()->new UsernameNotFoundException(" user not found with email "+ username));
	}

}
