FROM openjdk:8
ADD jarstaging/com/stalin/myapp/2.0.3/*.jar myapp.jar  
ENTRYPOINT ["java", "-jar", "myapp.jar"]
