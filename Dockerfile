# Usa una imagen base con Maven y Java 21 para construir el proyecto
FROM maven:3-eclipse-temurin-21 AS build

# Establece el directorio de trabajo
WORKDIR /app

# Copia el archivo pom.xml para descargar dependencias
COPY pom.xml .

# Descarga las dependencias
RUN mvn dependency:go-offline

# Copia el resto del código fuente
COPY src ./src

# Construye la aplicación, omitiendo los tests
RUN mvn clean package -DskipTests

# Usa una imagen base de Java para la ejecución
FROM eclipse-temurin:21-jre

# Establece el directorio de trabajo
WORKDIR /app

# Expone el puerto en el que corre Eureka
EXPOSE 8761

# Copia el archivo JAR construido desde la etapa de 'build'
COPY --from=build /app/target/discovery-server-0.0.1-SNAPSHOT.jar discovery-server.jar

# Comando para ejecutar la aplicación
ENTRYPOINT ["java", "-jar", "discovery-server.jar"] 