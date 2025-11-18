# Étape 1 : utiliser une image JDK pour compiler et exécuter le service
FROM eclipse-temurin:17-jdk-jammy

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Copier le JAR dans le conteneur
COPY target/Staff-service-0.0.1-SNAPSHOT.jar staff-service.jar

# Exposer le port sur lequel l'application écoute
EXPOSE 9002

# Commande pour lancer l'application
ENTRYPOINT ["java","-jar","staff-service.jar"]
