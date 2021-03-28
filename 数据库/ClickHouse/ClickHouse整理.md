# 目录
- [简单入门](#简单入门)
    + [使用场景](#使用场景)
    + [部署方法](#部署方法)
    + [参考文章](#参考文章)
- [深入理解](#深入理解)
    + []()
- [拓展学习](#拓展学习)
    + [数据库原理](#数据库原理)

# 颜色说明
<font color="#dd0000">问题</font>  
<font color="#FF1493">可能的尝试</font>  
[链接]()

---

# 简单入门

## 使用场景

多<font color="#dddd00" size="3">查询</font>的数据分析领域。  

联机分析处理 (Online analytical processing-OLAP)  

---

## 安装相关

[参考网页](https://clickhouse.tech/docs/zh/getting-started/install/)

日志文件将输出在`/var/log/clickhouse-server/`文件夹

[配置参考](https://clickhouse.tech/docs/en/operations/configuration-files/)  

<span id="config_setting">默认配置文件`/etc/clickhouse-server/config.xml`  </span>

重写的配置文件`.xml`一般可以放置在`/etc/clickhouse-server/config.d` 文件夹中，有修改或者需要重写的内容，最好都是在新文件中进行重写；xml 文件的根节点名称为 `<yandex>`；

默认的配置文件路径是 `./config.xml`

当指定配置文件路径运行

    $ clickhouse-server --config-file=/etc/clickhouse-server/config.xml

会读取`/etc/clickhouse-server/config.d/config.xml`文件(如果存在)；然后把两个文件进行合并。

用户权限配置文件`/etc/clickhouse-server/users.xml`，配置[参考地址](https://clickhouse.tech/docs/zh/operations/configuration-files/)

---

## 部署方法

---
### 核心
分布式的多节点集群。  

---

### 集群布置方法
[参考](https://clickhouse.tech/docs/en/getting-started/tutorial/)  
1. 每个节点安装 clickhouse
2. 修改配置文件 `config.xml` 中的集群属性(`<remote_servers>`)<font color="#FF1493">(理应可以在`/etc/clickhouse-server/config.d` 的配置文件中进行修改)；[相关问题](#config_setting)</font>
3. 在每个节点中建立相应的表
4. 创建需要分布式的表

例子：  

通过在 `/etc/clickhouse-server/config.xml` 中修改 `<remote_servers>` 属性，添加新的值( 如<test_1shard_1replica> )，然后再
    
    CREATE TABLE view_table_name as local_table_name ENGINE = Distributed (test_1shard_1replica,database_name, )



---

## 常见错误

- 无法启动
    + 重现方法： 使用 `sudo service clickhouse-server start` 命令或者 `service clickhouse-server start` 命令启动时，都无法启动，产生 `Effective user of the process (root) does not match the owner of the data (clickhouse)` 这样的错误。  
    + 可能原因：因为安装 clickhouse 时，创建了一个 clickhouse 的用户和用户组（可以使用`ls -l /var/log/clickhouse-server/`命令查看相关文件的用户属性），日志文件的所属用户是 clickhouse 用户和用户组的，而 `/usr/bin/clickhouse` 则是 root 用户和用户组的；这里应该是和 clickhouse 的用户管理，linux 的用户管理相关。  
    + 相关分析： <font color="#dd0000">这里需要先重新了解 linux 的用户管理机制，sudo 的安装机制，还有 clickhouse 的用户机制，然后再能完全的解决。</font>  
    + 暂行办法： 直接使用 `clickhouse-server start` 命令来启动，可是日志会直接输出到控制台。或者根据提示，使用 `sudo -u clickhouse clickhoouse-server start` 来启动

---

## 参考文章

[参考-入门简介](https://zhuanlan.zhihu.com/p/98135840)  

[返回目录](#目录)

---

# 深入理解

## 数据存储算法

ClickHouse采用`类LSM Tree`的结构，[B+树到LSM树的说明-1](https://blog.csdn.net/dbanote/article/details/8897599)，[B+树到LSM树的说明-2](https://www.jianshu.com/p/f911cb9e42de)，[LSM树原理说明-1](https://www.zhihu.com/question/19887265)，[LSM树的提出论文](https://www.cs.umb.edu/~poneil/lsmtree.pdf),

---

## 相关命令
- `PARTITION BY`  
> 解析：定义用来分区列；在配置中编辑文件中的`<remote_servers> <shard>` 即与之相关。

> 问：如果是单服务器类型，是否有分区的必要？分区的话，是否能方便之后的集群和分布式；  
答：

- `SAMPLE BY`  
> 解析： 

- `ENGINE =`  
> 解析：该数据库可以使用多种引擎，不同的引擎有不过的特殊功能，默认的引擎为 `MergeTree`

- `Nested`
> 该类型为复合类型；支持一层，<font color="#dd0000">是否支持多层？</font>

---

## 常用函数
[参考]()

---

## 数据类型
- 
- 

---

## 索引

稀疏索引和稠密索引：稀疏索引，只有部分的行/列的数据存在索引，没有索引的行/列则通过相邻索引然后顺序查找的方式来获取；稠密索引，所有的行/列都有相应的索引，可以通过索引直接获取数据。

对于 mysql 的索引储存方法的[参考](https://zhuanlan.zhihu.com/p/352181863)

---

## 数据硬盘写入相关

[随机IO与顺序IO](https://blog.csdn.net/ch717828/article/details/100574371)，该内容仍需要补充系统的硬盘写入写出体系知识。

[硬盘IO相关说明](https://tech.meituan.com/2017/05/19/about-desk-io.html)，

[SSD的随机IO和顺序IO相关说明](https://www.zhihu.com/question/47544675)，SSD的高速主要来源于主控芯片的多线程寻址。