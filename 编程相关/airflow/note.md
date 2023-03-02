
# note

1. catchup : 如果想修改 start_date ，可以使用 backfill 命令；[参考](https://airflow.apache.org/docs/apache-airflow/stable/core-concepts/dag-run.html#catchup)；例如：
   1. airflow dags backfill --start-date 2020.04.01 --end-date 2023.01.31  kdb_to_ddb_general_ctp









