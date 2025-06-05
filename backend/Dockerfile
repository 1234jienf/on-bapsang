# 1) Builder 스테이지: OpenJDK 21 + Gradle Wrapper
FROM openjdk:21-slim AS builder
WORKDIR /home/app

# gradlew, 소스, 설정 복사
COPY --chown=root:root gradlew gradlew
COPY --chown=root:root gradle gradle
COPY --chown=root:root build.gradle settings.gradle ./
COPY --chown=root:root src src

# 실행권한 주고 JAR 빌드 (테스트 제외)
RUN chmod +x gradlew \
  && ./gradlew clean bootJar -x test --no-daemon

# 2) Runtime 스테이지: OpenJDK 21 Slim
FROM openjdk:21-slim
WORKDIR /app

# netcat 설치 (healthcheck 등에서 필요하다면)
RUN apt-get update \
  && apt-get install -y netcat-openbsd \
  && rm -rf /var/lib/apt/lists/*

# Redis 환경변수 명시
ENV REDIS_HOST=redis
ENV REDIS_PORT=6379

# 빌더에서 만든 JAR만 복사
COPY --from=builder /home/app/build/libs/*.jar app.jar

EXPOSE 8081
ENTRYPOINT ["java", "-jar", "app.jar"]
