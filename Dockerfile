FROM java:8
# VOLUME /tmp
ADD ./target/ms-main-0.0.1-SNAPSHOT.jar app.jar
RUN bash -c 'touch /app.jar'
# EXPOSE 80
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]

