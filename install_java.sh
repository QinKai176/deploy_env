#!/bin/sh

java_deploy(){
    wget -P package/ --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u141-b15/336fa29ff2bb4ef291e347e091f7f4a7/jdk-8u141-linux-x64.tar.gz"
    mkdir -p /usr/local/java
    tar -zxvf package/jdk-8u141-linux-x64.tar.gz -C /usr/local/java
    echo 'export JAVA_HOME=/usr/local/java/jdk1.8.0_141' >> /etc/profile
    echo 'export PATH=$JAVA_HOME/jre/bin:$PATH' >> /etc/profile
    source /etc/profile
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


main()
{
    echo "start to deploy java";
    java_deploy;
    java_check || exit 1;
    echo "install java successfully";
}

main