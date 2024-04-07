# 1단계: 빌드 환경 준비
FROM openjdk:17-jdk-slim as build

# 작업 디렉토리 설정
WORKDIR /app

# 필요한 파일들 복사
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .
COPY src src

# 프로젝트 빌드
RUN ./gradlew build -x test

# 2단계: 실행 환경 준비
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# 1단계에서 생성된 JAR 파일 복사
COPY --from=build /app/build/libs/*-SNAPSHOT.jar /app/app.jar

EXPOSE 8090

# 애플리케이션 실행
# 애플리케이션의 시간 설정 = "-Duser.timezone=Asia/Seoul" (DB Created_at 시간이 영국시간으로 보여 설정 함)
ENTRYPOINT ["java", "-Duser.timezone=Asia/Seoul", "-Dspring.profiles.active=prod", "-jar", "/app/app.jar"]
