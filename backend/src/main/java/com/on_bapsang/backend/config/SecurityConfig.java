package com.on_bapsang.backend.config;

import com.on_bapsang.backend.jwt.JwtAuthenticationFilter;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableMethodSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final JwtAuthenticationFilter jwtFilter;

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        return http
                .csrf(csrf -> csrf.disable())
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers(
                                "/api/auth/**", // 로그인, 토큰 재발급
                                "/api/users/signup", // 회원가입
                                "/api/users/check-username",
                                "/api/seasonal/**", // 제철농산물 조회는 비회원 허용
                                "/api/market/**")
                        .permitAll()
                        .anyRequest().authenticated() // 그 외는 인증 필요
                )
                .formLogin(form -> form.disable()) // 로그인 UI 제거
                .httpBasic(httpBasic -> httpBasic.disable()) // 브라우저 팝업 로그인 제거
                .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class)
                .build();
    }

    @Bean
    public BCryptPasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
