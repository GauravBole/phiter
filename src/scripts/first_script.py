from datetime import datetime
from ntpath import join
import sys
from typing import Dict, Any
import boto3
from pyspark.context import SparkContext
from pyspark.sql.functions import current_date

from awsglue.utils import getResolvedOptions

from botobeak.glue.etl import GlueETL
from botobeak.glue.catalog import DataCatalog

class JobScript:

    def __init__(self) -> None:
        self.gelu_args = {}
        self.source_path = ""
        self.target_path = ""
        self.spark = None
        self.file_schema = []

    def __glue_arg(self) -> None:
        required_args = ["JOB_NAME", "env", "source_path", "athena_database"]
        args = getResolvedOptions(sys.argv, required_args)
        self.gelu_args = args

    def get_glue_arg(self, key_name:str, default_value=None):
        if not self.gelu_args:
            self.__glue_arg()
        return self.gelu_args.get(key_name, default_value)

    def get_source_destination_path(self):
        source_path_arg = self.get_glue_arg("source_path")

        if not source_path_arg:
            raise ValueError("source path shoud be not empty or None")

        self.source_path = source_path_arg
        job_name = self.get_glue_arg("JOB_NAME", "spark_job")
        self.target_path = f"s3://phiter/destination/{job_name}/"

    def __get_or_craete_spark_session(self):
        if self.spark is None:
            glue_etl = GlueETL()
            self.spark = glue_etl.spark
        
    def __get_dataframe_schema(self, dataframe):
        colume_data = [{"Name": col, "Type": dtype}
                    for col, dtype in dict(dataframe.dtypes).items()]
        return colume_data

    def process_and_write_parquet(self):
        self.__get_or_craete_spark_session()
        df = self.spark.read.options(header=True).\
            csv(self.source_path, inferSchema=True)
        df_with_current_date = df.withColumn("date", current_date())

        self.file_schema = self.__get_dataframe_schema(df_with_current_date)

        df_with_current_date.write.mode("overwrite").\
            partitionBy("date").parquet(self.target_path)

    def create_glue_database_table(self):
        glue_client = boto3.client("glue", "us-east-1")
        job_name = self.get_glue_arg("JOB_NAME", "spark_job").replace("-", "_")
        athena_database = self.get_glue_arg("athena_database", "phiter_databse").replace("-", "_")
        catalog_details = {"Name": job_name,
                        "Description": "script data",
                        "StorageDescriptor": {
                            "Columns": self.file_schema,
                            "Location": self.target_path
                        }
                        }
        data_catalog = DataCatalog(client=glue_client)
        data_catalog.write_catalog(database_name=athena_database, table_name=job_name,
                                catalog_details=catalog_details,
                                data_format="parquet")





if __name__ == "__main__":

    job = JobScript()

    job.get_source_destination_path()
    job.process_and_write_parquet()
    job.create_glue_database_table()
