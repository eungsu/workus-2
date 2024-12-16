package com.example.workus.security;

import com.example.workus.user.mapper.UserMapper;
import com.example.workus.user.vo.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    private final UserMapper userMapper;

    @Autowired
    public CustomUserDetailsService(UserMapper userMapper) {
        this.userMapper = userMapper;
    }

    @Override
    public UserDetails loadUserByUsername(String id) throws UsernameNotFoundException {

        // ID로 사용자 정보를 조회한다.
        User user = userMapper.getUserById(id);

        if(user == null) { // 조회된 사용자 정보가 없으면 UsernameNotFoundException 예외 발생
            throw new UsernameNotFoundException("["+id+"]사용자가 없습니다.");
       }

        CustomUserDetails customUserDetails = new CustomUserDetails(user);

        return customUserDetails;
    }

}

