FROM tomcat:latest
COPY target/*.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 3001
CMD ["catalina.sh", "run"]
