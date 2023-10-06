
# note

1. catchup : 如果想修改 start_date ，可以使用 backfill 命令；[参考](https://airflow.apache.org/docs/apache-airflow/stable/core-concepts/dag-run.html#catchup)；例如：
   1. airflow dags backfill --start-date 2020.04.01 --end-date 2023.01.31  kdb_to_ddb_general_ctp
   2. 使用了 --continue-on-failures 后，遇到 max_active_runs limit for dag has been reached - waiting for other dag runs to finish; -> 解决方法：

## 架构说明

[架构说明](https://towardsdatascience.com/a-gentle-introduction-to-understand-airflow-executor-b4f2fee211b1)

## 优化

1. "As mentioned in the previous chapter, Top level Python Code. you should avoid using Airflow Variables at top level Python code of DAGs. You can use the Airflow Variables freely inside the execute() methods of the operators, but you can also pass the Airflow Variables to the existing operators via Jinja template, which will delay reading the value until the task execution." ; 不要在 python 代码的顶层获取 airflow 的相关变量数据；可以在执行函数 or operator 中使用 jinja 模板获取。
2. [任务调度延时问题分析和优化](https://blog.csdn.net/csdnnews/article/details/110914052)
   1. 物理机部署比容器部署处理的速度会更快；
   2. 
3. [不同层级的参考](https://docs.astronomer.io/learn/airflow-scaling-workers)





