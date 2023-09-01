# clickhouse 

## 目录

- [简单入门](#简单入门)
- [使用场景](#使用场景)
- [安装方法](#安装方法)
- [部署方法](#部署方法)
- [参考文章](#参考文章)
- [深入理解](#深入理解)
- [拓展学习](#拓展学习)
  - [数据库原理](#数据库原理)

## 颜色说明

<font color="#dd0000">问题</font>  
<font color="#FF1493">可能的尝试</font>  
[链接]()

---

## 简单入门

## 使用场景

多<font color="#dddd00" size="3">查询</font>的数据分析领域。  

联机分析处理 (Online analytical processing-OLAP)  

---

## 安装方法

[参考网页](https://clickhouse.tech/docs/zh/getting-started/install/)

日志文件将输出在`/var/log/clickhouse-server/`文件夹

[配置参考](https://clickhouse.tech/docs/en/operations/configuration-files/)  

<span id="config_setting"> 默认配置文件`/etc/clickhouse-server/config.xml` </span>

重写的配置文件`.xml`一般可以放置在`/etc/clickhouse-server/config.d` 文件夹中，有修改或者需要重写的内容，最好都是在新文件中进行重写；xml 文件的根节点名称为 `<yandex>`；

默认的配置文件路径是 `./config.xml`

当指定配置文件路径运行

    $ clickhouse-server --config-file=/etc/clickhouse-server/config.xml

会读取`/etc/clickhouse-server/config.d/config.xml`文件(如果存在)；然后把两个文件进行合并。

用户权限配置文件`/etc/clickhouse-server/users.xml`，配置[参考地址](https://clickhouse.tech/docs/zh/operations/configuration-files/)


文件分布\
运行文件：/usr/bin/clickhouse-server  链接： /usr/bin/clickhouse\

<span id="new_user"><span>

clickhouse user 的限制配置 `/etc/security/limits.d/clickhouse.conf`; 创建了 clickhouse 的用户组和用户，使用 `cat /etc/passwd` 可以看到，但是该用户的登录 shell 为 /bin/false 即不能切换为该用户（虽然可以更改，但没必要。）

<span id="modify_file_privilege"><span>

安装时，创建并修改用户权限的目录/文件

    chown --recursive clickhouse:clickhouse '/etc/clickhouse-server'
    chown --recursive clickhouse:clickhouse '/var/log/clickhouse-server/'
    chown --recursive clickhouse:clickhouse '/var/run/clickhouse-server'
    chown clickhouse:clickhouse '/var/lib/clickhouse/'

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


### 尝试

[详细步骤](https://segmentfault.com/a/1190000038318776)

1. 修改 /etc/hosts 中的 hostname，添加 ip 地址到 hostname 的映射
2. （暂不设置 ip mac 地址，不关闭防火墙，）
3. 永久关闭防火墙
4. 设置公钥认证
5. 时钟同步
6. 安装 jdk
7. 安装 zookeeper
    启动 zookeeper 时报错找不到 JAVA_HOME ，[解决方法](https://blog.csdn.net/HACKERRONGGE/article/details/102485260)
8. 安装必要的依赖
9. 在添加 `<include_from>file_path(如/etc/clickhouse-server/metrica.xml)</include_from>` 时，这个新的 file 的内容一定要准确，特别是 host 的地址。
   1. 添加了 metrica.xml 后，可以添加 `<clickhouse_remote_servers></clickhouse_remote_servers>` 节点，然后在主 config.xml 文件的中修改 `<remote_servers incl="clickhouse_remote_servers"></remote_servers>` ；
   2. 可以不添加 `<include_from>file_path</include_from>` 而直接在 config.d 文件夹中新加一个 config.xml ，然后在该文件中添加 `<remote_servers></remote_servers>` 内容。
   3. 区分：如果是使用额外的文件，即在 config.xml 中添加 `<include_from>file_path(如/etc/clickhouse-server/metrica.xml)</include_from>` 然后在 metrica.xml 中添加 `<remote_servers></remote_servers>` ；那么在 config.xml 文件中也必须要修改为 `<remote_servers incl="remote_servers"></remote_servers>`。而如果只是在 config.d 中添加新的 config.xml 文件，原来的 config.xml 文件就不需要做修改。
   4. 最好的方法还是添加 config.d/config.xml 文件
10. 建表，使用 clickhouse 的远程功能即可。（注意防火墙是否关闭/如果不关闭防火墙，端口是否打开）


---

### 常见错误

- 无法启动
    + 重现方法： 
        * 使用 `sudo service clickhouse-server start` 命令启动时，产生 `Effective user of the process (root) does not match the owner of the data (clickhouse)` 这样的错误。
        * 使用其他普通用户运行 `clickhouse-server start` 可以运行，但是无法读取默认的配置文件 `/etc/clickhouse-server/config.xml`；如果运行 `clickhouse-server --config = /etc/clickhouse-server/config.xml` 则会因为没有权限而无法访问 `config.xml` 文件
    + 原因：因为安装 clickhouse 时，创建了一个 clickhouse 的[用户和用户组](#new_user)，clickhouse 的很多相关文件都是属于该用户的；
    + 解决方法： 
        * 或者[修改文件权限](#modify_file_privilege)，修改文件的所属用户为该用户或者 root. 然后使用 `sudo clickhouse-server start` 命令来启动（不推荐）
        * 直接使用 root 用户安装；然后使用 `sudo clickhouse start` 启动服务端，该命令会运行一个脚本文件，脚本命令应该为 `su -s /bin/sh 'clickhouse' -c '/usr/bin/clickhouse-server --config-file /etc/clickhouse-server/config.xml --pid-file /var/run/clickhouse-server/clickhouse-server.pid --daemon'`；即启动一个 clickhouse 的 shell 然后后台启动该服务。停止运行使用命令 `sudo clickhouse stop`

- 服务运行时，重启电脑，服务仍旧为启动状态，无需再启动，可以先尝试使用 `clickhouse-client` 连接。

- 远程连接
方法：先[修改配置](https://blog.csdn.net/zhangpeterx/article/details/95059059)；如果无法连接 ssl ，可以先[生成证书](https://blog.csdn.net/liuchunming033/article/details/48470575)，再根据 config.xml 的 <openSSL> 标签，把证书放置到指定位置。即可连接。

---

### 参考文章

[参考-入门简介](https://zhuanlan.zhihu.com/p/98135840)  

[返回目录](#目录)

---

## 深入理解

### 数据存储算法

ClickHouse采用`类LSM Tree`的结构，[B+树到LSM树的说明-1](https://blog.csdn.net/dbanote/article/details/8897599)，[B+树到LSM树的说明-2](https://www.jianshu.com/p/f911cb9e42de)，[LSM树原理说明-1](https://www.zhihu.com/question/19887265)，[LSM树的提出论文](https://www.cs.umb.edu/~poneil/lsmtree.pdf),

---

### 相关命令

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

SELECT
- WITH
> 别称，表达式的命名；
- SAMPLE
> 近似查询过程；随机选择部分数据进行查询或者计算；  
该命令只能在 MergeTree 族类型的表中使用，且抽样表达需要在建表时即确定。即建表时，使用 `SAMPLE BY` 命令确定用来抽样的行。
- PREWHERE
> 把部分 where 命令提前，用于优化查询；第一个 where 过滤可以使用 prewhere 替代。
- GROUP BY
> 把数据分组合并；SELECT 的元素只能是被 GROUP BY 的元素或者是对某列进行 aggregate 操作(SUM,COUNT 等函数)；  
WITH ROLLUP/CUBE 是对 GROUP 的字段做部分的不 GROUP 处理，生成多张相应的表。具体查看[网址](https://clickhouse.tech/docs/en/sql-reference/statements/select/group-by/)
- LIMIT [offset_value, ]n BY k
> 和 LIMIT 不同，这个是获取 n 种值的 k 的行；
- HAVING Clause
> 在 group by 之后，再进行筛选。和 where 功能类似
- FORMAT Clause
> 用于对数据序列化
- DISTINCT 
> 获取某一列数据的所有类型，结果和 GROUP BY 类似；如果有 ORDER BY ，则先获取单一类型，再进行排序。

| a | b |
| --- | --- |
| 2 | 1 |
| 1 | 2 |
| 3 | 3 |
| 2 | 4 |

    SELECT DISTINCT a FROM test ORDER BY b DESC 

会先获取 a 的单一值，从前往后就是 2 1 3，最后一个 2 是相同的，则不纳入。然后再根据 b 来排序。结果为\
3 1 2

--- 

## 有趣功能

### 分片分区

`partition` ：query中的分片命令\
`replicated` : 配置文件中的副本配置\
`shard` : ；配置文件中的分片配置；\
`ON CLUSTER cluster_name` ：query 命令直接运行在 cluster_name 的所有节点中。

    CREATE TABLE [IF NOT EXISTS] [db.]table_name [ON CLUSTER cluster]
    (
        name1 [type1] [NULL|NOT NULL] [DEFAULT|MATERIALIZED|ALIAS expr1] [compression_codec] [TTL expr1],
        name2 [type2] [NULL|NOT NULL] [DEFAULT|MATERIALIZED|ALIAS expr2] [compression_codec] [TTL expr2],
        ...
    ) ENGINE = engine
    
    CREATE TABLE tutorial.hits_all AS tutorial.hits_local 
    ENGINE = Distributed(perftest_3shards_1replicas, tutorial, hits_local, rand());

理解两个命令的区别，首先得明白，即使是集群模式，集群中的每一个节点都是独立的；而不是单纯的备份。\
前者可以把 query 操作直接执行在所有节点的实际数据库(如在所有节点中创建表 table_name )或者表中。\
后者则需要先在所有节点分别中创建一个 hits_local 表，然后创建 hits_local 的映射表 hits_all，之后对 hits_all 的 query 操作都会在所有节点中执行。 hits_all 就像一个代理，分发并且保证所有的节点上相同的表执行相同的操作。\
另外，不同节点上的相同表，都可以对自己做单独的操作而不同步到所有其他节点中。
    
    INSERT INTO tutorial.hits_local [(c1, c2, c3)] VALUES (v11, v12, v13), (v21, v22, v23), ...

这样就只在 hits_local 中插入数据。

### replicated 和 distributed 的异同

1. [distirbuted table](https://clickhouse.com/docs/en/engines/table-engines/special/distributed#distributed-writing-data) 是按 shard 对数据进行拆分的；每个 shard 有自己的 weight ，决定该 shard 分配数据的权重，新建 distributed table 的时候(可以)设置 sharding_key ，clickhouse 会计算 sharding_key 和 weight ，决定该数据最终分配到哪一个 shard 中。
2. sharding_key 可以是任意返回正整数的表达式；比如返回日期的数字格式、字符串的哈希(`intHash64(Contract)`)、rand()；
3. 设置 cluster 配置时，可以给每个 shard 定义 replica ，用来定义该 shard 是否多个备份表；
   1. 备份表可以是普通的 `MergeTree` 表，也可以是 `Replicated*MergeTree` 表；
      1. 如果使用 `MergeTree` 引擎，需要在 shard 的配置中设置 `<internal_replication>False</internal_replication>`；插入数据时需要插入到 distributed 表，而不能是底表；如果有数据分配到该 shard ，分布式引擎会把数据同时分发到该 shard 的所有 replica 表中；
      2. 如果使用 `Replicated*MergeTree` 引擎，需要在 shard 的配置中设置 `<internal_replication>True</internal_replication>`；如果插入数据到 distributed 表，有数据分配到该 shard 时，就会从 replica 中选一个进行插入，然后底层的 `Replicated*MergeTree` 引擎会自动把数据同步到不同的 replica 中；也可以直接插入数据到某一个 replica 的底表中，也会进行不同 replica 的数据同步；
   2. 官方建议底层使用 `Replicated*MergeTree` 引擎配合 `<internal_replication>True</internal_replication>`
4. replicated 和 distirbuted 是独立的两个内容，只不过 distributed 的底层表**可以是** replicated ，使用其功能来增添分布式表的备份属性；
5. 在查询 distributed 表时，如果某个 shard 有多个 replicated ，需要给 session 设置 `prefer_localhost_replica=0` ，否则 `= 1` 会把所有 query 都发送到当前的 server ；这是把单条 query 发送到某个 replicated 上**完整执行**；即使是使用同一个 session 连续发送多条 query (比如使用 python 的进程池时) 也有效。还可以添加 [`load_balancing='random'`](https://clickhouse.com/docs/en/operations/settings/settings#settings-load_balancing) 来设置不同的效果。

        SELECT something(*) FROM distributed_table
        SETTINGS prefer_localhost_replica=0,load_balancing='random'

6. 如果是 **单条复杂sql** 查询某个 **distributed 表**，其 shard 有多个 replicated 表的，可以使用 `max_parallel_replicas`,`prefer_localhost_replica=0` 搭配，直接从多个 replicated 表**异步**查询；需要注意的是，如果只是做简单查询，比如 `SELECT COUNT(*) FROM distributed_table` 需要添加 `optimize_trivial_count_query=0`
<!-- 1. 需要表是 [`sample by`](https://github.com/ClickHouse/ClickHouse/pull/29279),[Parallel processing using SAMPLE key](https://clickhouse.com/docs/en/operations/settings/settings#parallel-processing-using-sample-key)；而如果有 [subquery](https://clickhouse.com/docs/en/sql-reference/operators/in#distributed-subqueries-and-max_parallel_replicas)，subquery 查的表的 `sample by` 需要和原表相同；
2. 或者和参数 [`allow_experimental_parallel_reading_from_replicas=1`](https://clickhouse.com/blog/whats-new-in-clickhouse-22-1)搭配；[参考1](https://clickhouse.com/blog/clickhouse-release-23-03)，[参考2](https://clickhouse.com/docs/en/whats-new/changelog#experimental-feature-2) ； -->

        SELECT complicated_sql(*) FROM distributed_table
        SETTINGS max_parallel_replicas=2,prefer_localhost_replica=0

        SELECT simple_sql(*) FROM distributed_table
        SETTINGS max_parallel_replicas=2,prefer_localhost_replica=0
        optimize_trivial_count_query=0

7. 在升级了 ck 版本到 >[23.3.8](https://clickhouse.com/docs/en/whats-new/changelog#new-feature-4) 后 可以使用 `parallel_replicas_custom_key=xxHash32(Contract)` 和 `parallel_replicas_custom_key_filter_type='default'` 关键字；用来给**单个 shard 配置多个 replicated 的表**分割 replicated 表为多个虚拟的 shard ；注意这两个配置和 `prefer_localhost_replica` 的[配合使用](https://clickhouse.com/docs/en/operations/settings/settings#settings-prefer-localhost-replica)


---

## Table Engine

### MergeTree

1. 分批量数据写入，然后其后台把数据合并到规定的 block 中。
2. ？

#### Primary Key; Partition Key, Order By

1. Partition Key 是表的分区
2. Primary Key 和其他数据库的不同，不需要唯一性。最好是创建 small sparse index ；Primary Key 是用来做 Index 的，具有良好的稀疏性能更好提升查询速度。
3. Primary key 和 Order By 是类似的。两者一般是相同的，如果不相同时， Primary key 必须是 Order By 的前缀
    
       不可行
       PRIMARY KEY(toYYYYMMDD(TickTime),Contract)
       ORDER BY (toYYYYMMDD(TickTime),TickTime,Contract)

       可行
       PRIMARY KEY(toYYYYMMDD(TickTime),Contract)
       ORDER BY (toYYYYMMDD(TickTime),Contract,TickTime)

4. 多列的 Primary Key 对于查询性能影响不大，但会对插入/合并和内存消耗（存放 index ) 的影响比较大
5. 对于 SummingMergeTree 和 AggregatingMergeTree ，因为需要某些列进行 GROUP BY / Aggregate，则常用来 GROUP BY 的列最好都放到  ORDER BY () 中。那么这时候，Primary Key 比 Order By 少是很有必要的。Primary Key 用来大范围地过滤数据，Order By 用来作为  dimension 提升 GROUP BY /Aggregate 的性能。
6. 


#### 数据存储方法

- Data parts 的拆分方法是：Partition
- Data parts 中的数据保存方法：使用 Wide 模式，每列分别存储在不同的文件中；使用 Compact 模式，所有列数据存储在同一个文件中。对于少量高频存储的数据，使用后者更好。
- Data parts 根据 `index_granularity/index_granularity_bytes` 对数据拆分成小单元；`index_granularity` 标记每个单元的行数量，`index_granularity_bytes` 标记每个单元的字节大小；每个单元存储 整数行 数据；然后每个单元贴上相应 Primary Key 的 mark。
- 假如使用的是 Wide 模式，每个文件存储一列数据，则 index file 会记录每个 Data parts 的 mark，并且记录每个文件/每列数据中的 **单元** 的 mark。假如使用的是 Compact 模式，则一个文件中有 列数*单列拆分单元数 个单元。
- 查询的时候，根据不同的 Primary Key 的 mark 定位相关数据的两侧位置，然后顺序/二分法查找到所需数据的位置。

---

## 常用函数
[参考]()

---

## 数据类型
- ClickHouse 的空数据表示为 NULL 和 NaN ?
- 

---

## 索引相关

稀疏索引和稠密索引：稀疏索引，只有部分的行/列的数据存在索引，没有索引的行/列则通过相邻索引然后顺序查找的方式来获取；稠密索引，所有的行/列都有相应的索引，可以通过索引直接获取数据。

对于 mysql 的索引储存方法的[参考](https://zhuanlan.zhihu.com/p/352181863)

---

## 数据硬盘写入相关

[随机IO与顺序IO](https://blog.csdn.net/ch717828/article/details/100574371)，该内容仍需要补充系统的硬盘写入写出体系知识。

[硬盘IO相关说明](https://tech.meituan.com/2017/05/19/about-desk-io.html)，

[SSD的随机IO和顺序IO相关说明](https://www.zhihu.com/question/47544675)，SSD的高速主要来源于主控芯片的多线程寻址。


## 额外

1. ORDER BY 和 Primary Key 具有同等的地位，一般两者相同，可以没有 Priamry Key ，但不能没有 ORDER BY .
2. SAMPLE BY: 用来抽样的字段；其字段必须是正整性并且是 Primary key 


## 坑

1. insert with 和 remote 同时使用的时候，因为 with 的执行机制，导致出错。

       INSERT INTO test.fut_level1_tick_data
       WITH
           intDiv(TickTime,1000) AS SECOND_NUM,
           intDiv(SECOND_NUM,3600) AS HOUR_,
           intDiv(modulo(SECOND_NUM,3600),60) AS MINUTE_,
           modulo(modulo(SECOND_NUM,3600),60) AS SECOND_,
           modulo(TickTime,1000) AS MILLISECOND_,
           HOUR*10000000+MINUTE_*100000+SECOND_*1000+MILLISECOND_ AS TIME_,
           if(HOUR_ < 20 ,TIME_+240000000,TIME_) AS SORTTIME_
        SELECT 
            Symbol,TradingDate,SORTTIME_,TIME_,
            Volume , 0 AS OI,LastPrice,Amount,HighPrice,LowPrice,
            0 AS BP1,0 AS BV1,0 AS SP1,0 AS SV1,
            0 AS ULP,0 AS LLP ,0 AS POI
        FROM 
        remote('114:9000',etl_mid_temp,gtja_sip_index_l1_snapshot,'user','password')
        WHERE TradingDate = 20221216

这样的就会导致只插入了部分的一两个合约的数据；而如果

        INSERT INTO test.fut_level1_tick_data
        SELECT * FROM
        (
        WITH
           intDiv(TickTime,1000) AS SECOND_NUM,
           intDiv(SECOND_NUM,3600) AS HOUR_,
           intDiv(modulo(SECOND_NUM,3600),60) AS MINUTE_,
           modulo(modulo(SECOND_NUM,3600),60) AS SECOND_,
           modulo(TickTime,1000) AS MILLISECOND_,
           HOUR*10000000+MINUTE_*100000+SECOND_*1000+MILLISECOND_ AS TIME_,
           if(HOUR_ < 20 ,TIME_+240000000,TIME_) AS SORTTIME_
        SELECT 
            Symbol,TradingDate,SORTTIME_,TIME_,
            Volume , 0 AS OI,LastPrice,Amount,HighPrice,LowPrice,
            0 AS BP1,0 AS BV1,0 AS SP1,0 AS SV1,
            0 AS ULP,0 AS LLP ,0 AS POI
        FROM 
        remote('114:9000',etl_mid_temp,gtja_sip_index_l1_snapshot,'user','password')
        WHERE TradingDate = 20221216
        )

这样就没事，能正常插入所有数据。