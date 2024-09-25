FROM gradle:8.8-jdk21 AS builder

WORKDIR /app

COPY gradle/ gradle/
COPY build.gradle settings.gradle gradlew ./

RUN chmod +x gradlew

COPY src/ src/

# Gradle 캐시 디렉토리를 명시적으로 설정
ENV GRADLE_USER_HOME /app/.gradle

RUN ./gradlew build .





