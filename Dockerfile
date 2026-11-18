# Fase 1: compilar o projeto com Maven (Java 17)
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml
COPY src ./src
RUN mvn -B -DskipTests package

# Fase 2: imagem leve, só com o Java para rodar o .jar
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
# Plano gratuito tem 512MB de RAM: limitamos a memório do Java
ENV JAVA_TOOL_OPTIONS="-XX:MaxRAMPercentage=70 -XX:+UseSerialGC -Xss512k --XX:TieredStopAtLevel=1"
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]