package com.on_bapsang.backend.config;

import com.on_bapsang.backend.jwt.JwtAuthenticationFilter;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
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
                        // 로그인 관련은 모든 메서드 허용
                        .requestMatchers("/api/auth/**","api/users/check-username").permitAll()

                        // 회원가입은 POST만 허용
                        .requestMatchers(HttpMethod.POST, "/api/users/signup").permitAll()

                        // 제철/마켓/레시피 공개 API
                        .requestMatchers(HttpMethod.GET,
                                "/api/seasonal/**",
                                "/api/market/**",
                                "/api/recipe/keywords/popular",
                                "/api/recipe/keywords/recent",
                                "/api/recipe/popular",
                                "/api/recipe/ingredient",
                                "/api/recipe/search",
                                "/api/recipe/recommend",
                                "/api/recipe",
                                "/api/recipe/review/**",
                                "/api/community/posts",
                                "/api/community/posts/{id}",
                                "/api/community/posts/autocomplete",
                                "/api/community/comments/{postId}"
                        ).permitAll()

                        // 이외는 인증 필요
                        .anyRequest().authenticated()
                )
                .formLogin(form -> form.disable())
                .httpBasic(httpBasic -> httpBasic.disable())
                .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class)
                .build();
    }

    @Bean
    public BCryptPasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
