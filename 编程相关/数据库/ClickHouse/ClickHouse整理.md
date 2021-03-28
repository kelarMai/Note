# 目录
- [简单入门](#简单入门)
    + [使用场景](#使用场景)
    + [部署方法](#部署方法)
    + [参考文章](#参考文章)
- [深入理解](#深入理解)
    + []()
- [拓展学习](#拓展学习)
    + [数据库原理](#数据库原理)


# 简单入门

## 使用场景

多<font color="#dddd00" size="3">查询</font>的数据分析领域。  

联机分析处理 (Online analytical processing-OLAP)  


## 安装相关

[参考网页](https://clickhouse.tech/docs/zh/getting-started/install/)

日志文件将输出在`/var/log/clickhouse-server/`文件夹

默认配置文件`/etc/clickhouse-server/config.xml`

用户权限配置文件`/etc/clickhouse-server/users.xml`，配置[参考地址](https://clickhouse.tech/docs/zh/operations/configuration-files/)
---

## 部署方法

分布式的多节点集群。  

---

## 参考文章

[参考-入门简介](https://zhuanlan.zhihu.com/p/98135840)  

[参考-]()

[返回目录](#目录)

# 深入理解

## 数据存储算法

ClickHouse采用`类LSM Tree`的结构，[B+树到LSM树的说明-1](https://blog.csdn.net/dbanote/article/details/8897599)，[B+树到LSM树的说明-2](https://www.jianshu.com/p/f911cb9e42de)，[LSM树原理说明-1](https://www.zhihu.com/question/19887265)，[LSM树的提出论文](https://www.cs.umb.edu/~poneil/lsmtree.pdf),


## 索引

稀疏索引和稠密索引：稀疏索引，只有部分的行/列的数据存在索引，没有索引的行/列则通过相邻索引然后顺序查找的方式来获取；稠密索引，所有的行/列都有相应的索引，可以通过索引直接获取数据。

对于 mysql 的索引储存方法的[参考](https://zhuanlan.zhihu.com/p/352181863)

---

## 数据硬盘写入相关

[随机IO与顺序IO](https://blog.csdn.net/ch717828/article/details/100574371)，该内容仍需要补充系统的硬盘写入写出体系知识。

[硬盘IO相关说明](https://tech.meituan.com/2017/05/19/about-desk-io.html)，

[SSD的随机IO和顺序IO相关说明](https://www.zhihu.com/question/47544675)，SSD的高速主要来源于主控芯片的多线程寻址。