FROM ubuntu:22.04
RUN apt update -y
RUN apt install openjdk-21-jdk -y
RUN apt install maven -y
WORKDIR /app
ADD https://github.com/Siva825/spring-petclinic.git .
RUN mvn clean package -Dskiptests -Dcheckstyle.skip=true
EXPOSE 8080
CMD ["java", "-jar", "/app/target/spring-petclinic-3.5.0-SNAPSHOT.jar"]
