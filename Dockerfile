# 1단계: Gradle을 사용하여 Spring Boot 애플리케이션 빌드
# OpenJDK를 포함한 Gradle 공식 이미지 사용
FROM gradle:8.5-jdk17 AS build

# 작업 디렉토리 설정
WORKDIR /app

# Gradle 래퍼와 빌드 스크립트 복사
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .

# 소스 코드 복사
COPY src src

# 애플리케이션 빌드
# 빌드된 JAR 파일은 `build/libs` 아래에 위치합니다.
RUN ./gradlew bootJar --no-daemon

# 2단계: 빌드된 JAR 파일을 실행하기 위한 새로운 Docker 이미지
FROM openjdk:17

# 작업 디렉토리 설정
WORKDIR /app

# 1단계에서 빌드한 JAR 파일을 현재 이미지로 복사
COPY --from=build /app/build/libs/*.jar app.jar

# 컨테이너가 시작될 때 애플리케이션 실행
ENTRYPOINT ["java","-jar","app.jar"]
