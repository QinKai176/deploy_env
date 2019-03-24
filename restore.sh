#!/bin/sh
stop_program(){
#    ps -ef|grep tomcat|grep -v 'grep'|awk '{print $2}'|xargs {} kill -9 {}
    sh /usr/local/tomcat/apache-tomcat-9.0.13/bin/shutdown.sh
}

restore_env(){
    rm -rf /usr/local/java/
    rm -rf  /usr/local/maven/
    rm -rf /usr/local/tomcat
    rm -rf  /etc/profile
    cp /etc/profile_bak  /etc/profile
}

main()
{
    echo "start to restore env";
    stop_program;
    restore_env;
    echo "finish restoring the environment"
}

main