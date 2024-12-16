package com.example.workus.security;

import com.example.workus.user.vo.User;
import lombok.Getter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.List;

public class CustomUserDetails extends LoginUser implements UserDetails {

    private String username;
    private String password;
    @Getter
    private Collection<? extends GrantedAuthority> authorities;

    public CustomUserDetails(User user) {
        super(user.getNo(), user.getId(), user.getName());
        this.password = user.getPassword();
        this.username = user.getId();
        this.authorities = List.of(new SimpleGrantedAuthority(user.getRoleName()));
    }

    @Override
    public String getPassword() {
        return password;
    }

    @Override
    public String getUsername() {
        return username;
    }
}
