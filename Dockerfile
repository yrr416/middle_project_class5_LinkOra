FROM tomcat:10.1-jdk21

# 기본 ROOT 웹앱 제거
RUN rm -rf /usr/local/tomcat/webapps/*

# 빌드된 WAR 복사 (context-path = /linkora)
COPY target/project05-0.0.1-SNAPSHOT.war /usr/local/tomcat/webapps/linkora.war


ENV JAVA_OPTS="-Dfile.encoding=UTF-8 -Dspring.profiles.active=prod"

EXPOSE 8080
CMD ["catalina.sh", "run"]
