创建一个容器，挂载数据卷

    docker run -it -d --name qhtrade-test-script-maiqh -v /home/maiqh/docker_file:/home/trader/myscript -p 0.0.0.0::22 kunshan/qhtrade-test-centos7.4.1708:latest bash

    docker run -itd --name test_mysql_maiqh -v /home/maiqh/Documents/dataAdmin:/home/maiqh/Documents/dataAdmin -p 0.0.0.0::3306 -e MYSQL_ROOT_PASSWORD=123   mysql:5.7.33 bash

查看端口映射

    docker port containerID

创建具体容器：
    docker run -d --cpus=4 -m 8G --name qhtrade-test-maiqh1 kunshan/qhtrade-test-centos7.4.1708:latest

文件复制映射：
    docker cp ~/docker_file  qhtrade-test-maiqh1:/home/trader/

修改更新程序目录属主为trader:
    docker exec qhtrade-test-maiqh1  chown -R trader:trader /home/trader/docker_file


docker run -it -d --name futScript-maiqh -v /home/maiqh/maint:/home/maint python:3.7-buster