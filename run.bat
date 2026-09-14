@echo off 
set "JAVA_HOME=C:\Program Files\Java\jdk-11.0.32.1" 
cd /d "C:\Users\Asus\Downloads\tomcat\apache-tomcat-10.1.59-windows-x64\apache-tomcat-10.1.59\bin" 
start catalina.bat run 
timeout /t 2 >nul 
start http://localhost:8080/SWP391/login.jsp
