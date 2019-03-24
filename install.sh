#!/bin/sh
bak_env(){
    rm -rf /etc/profile
    echo "start to bak environment"
    cp /etc/profile_bak  /etc/profile
}

java_deploy(){
    mkdir -p /usr/local/java
    tar -zxvf package/jdk-8u191-linux-x64.tar.gz -C /usr/local/java
    echo 'export JAVA_HOME=/usr/local/java/jdk1.8.0_191' >> /etc/profile
    echo 'export PATH=$JAVA_HOME/jre/bin:$PATH' >> /etc/profile
    source /etc/profile
}

maven_deploy(){
    mkdir -p /usr/local/maven
    tar -zxvf package/apache-maven-3.6.0-bin.tar.gz -C /usr/local/maven
    echo 'export MAVEN_HOME=/usr/local/maven/apache-maven-3.6.0' >> /etc/profile
    sed -i  's#PATH=#PATH=$MAVEN_HOME/bin:#g' /etc/profile
    source /etc/profile
}

tomcat_deploy(){
    mkdir -p /usr/local/tomcat
    tar -zxvf package/apache-tomcat-9.0.13.tar.gz -C /usr/local/tomcat
    sh /usr/local/tomcat/apache-tomcat-9.0.13/bin/startup.sh
}

jenkins_deploy(){
    cp package/jenkins.war /usr/local/tomcat/apache-tomcat-9.0.13/bin/webapps
}

java_check(){
    java -version
    if [ $? = 0 ];then
        echo "java is installed"
    else
        echo "java is not installed"
        exit 1;
    fi
}

maven_check(){
    mvn -version
    if [ $? = 0 ];then
        echo "mvn is installed"
    else
        echo "mvn is not installed"
        exit 1;
    fi
}

tomcat_startup_check(){
    ps -ef|grep tomcat|grep -v 'grep'
    if [ $? = 0 ];then
        echo "tomcat start up successfully"
    else
        echo "tomcat start up failed"
        exit 1;
    fi
}

main()
{
    bak_env;
    echo "start to deploy env";
    java_deploy;
    java_check || exit 1;
    maven_deploy;
    maven_check || exit 1;
    tomcat_deploy;
    tomcat_startup_check || exit 1;
}

main