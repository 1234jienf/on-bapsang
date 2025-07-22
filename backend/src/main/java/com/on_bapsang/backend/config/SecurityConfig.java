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
                        // 인증 없이 허용
                        .requestMatchers(HttpMethod.GET,
                                "/api/auth/**",
                                "/api/users/check-username",
                                "/api/seasonal/**",
                                "/api/market/**",
                                "/api/recipe/popular",
                                "/api/recipe/ingredient",
                                "/api/recipe/search",
                                "/api/recipe",
                                "/api/recipe/review/**",
                                "/api/community/posts",               // 게시글 목록
                                "/api/community/posts/{id}",         // 게시글 상세
                                "/api/community/posts/autocomplete", // 자동완성
                                "/api/community/comments/{postId}"   // 댓글 목록
                        ).permitAll()

                        // 인증 없이 허용되는 POST
                        .requestMatchers(HttpMethod.POST,
                                "/api/users/signup"
                        ).permitAll()

                        // 인증이 필요한 요청
                        .requestMatchers(HttpMethod.POST, "/api/community/posts").authenticated()
                        .requestMatchers(HttpMethod.PATCH, "/api/community/posts/{id}").authenticated()
                        .requestMatchers(HttpMethod.DELETE, "/api/community/posts/{id}").authenticated()
                        .requestMatchers(HttpMethod.POST, "/api/community/comments/**").authenticated()
                        .requestMatchers(HttpMethod.DELETE, "/api/community/comments/**").authenticated()
                        .requestMatchers("/api/recipe/recommend").authenticated()
                        .requestMatchers("/api/recipe/foreign/**").authenticated()
                        .requestMatchers("/api/recipe/scrap/**").authenticated()

                        // 그 외 모든 요청은 인증 필요
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
