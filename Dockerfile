FROM openjdk:17
WORKDIR /appContainer
COPY ./target/jenkinsCiCd.jar jenkinsCiCd.jar
EXPOSE 8282
CMD ["java","-jar","jenkinsCiCd.jar"]