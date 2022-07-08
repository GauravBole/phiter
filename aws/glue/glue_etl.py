from dataclasses import dataclass
from distutils.command.config import config
from multiprocessing import connection
import sys
from typing import Dict, List, Optional

from pyspark.context import SparkContext
from pyspark.sql import dataframe, DataFrame
from awsglue.dynamicframe import DynamicFrame
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.utils import getResolvedOptions

@dataclass
class GetGlueDyfArgs:
    database: str
    table: str
    select_field: Optional[List[str]]

@dataclass
class GlueETL:
    glue_context: GlueContext = GlueContext(SparkContext.getOrCreate())
    job: Job = Job(glue_context)
    job_name: Optional[str] = getResolvedOptions(sys.argv, ['JOB_NAME'])

    def __post_init__(self):
        self.job.init(self.job_name, {})

    def _union(self, dyf1:DynamicFrame, dyf2:DynamicFrame, result_dyf_name:str):
        
        df1 = dyf1.toDF()
        df2 = dyf2.toDF()

        if df1.head(1).isEmpty():
            return dyf2

        if df2.head(1).isEmpty():
            return dyf1
        
        mereg_df = df1.union(df2)

        merged_dyf = DynamicFrame.fromDF(dataframe=mereg_df, glue_ctx=self.glue_context, name=result_dyf_name)

        return merged_dyf


    def get_glue_dyf(self,
                     database: str,
                     table: str,
                     select_fields: List[str],
                     push_down_predicate: Optional["str"] = "") -> DynamicFrame:

        try:
            dyf = self.glue_context.create_dynamic_frame.from_catalog(**locals())

        except Exception as e:
            # handle push_down_predicate error for empty dyf
            pass

        if select_fields:
            dyf = dyf.select_fields(select_fields)

        return dyf

    def write_s3(self, dyf: DynamicFrame, s3_path: Optional[str] = {}, format: str = "parquet"):

        if dyf.head(1).isEmpty():
            return

        return self.glue_context.write_dynamic_frame.from_options(
            frame=dyf, connection_type="s3", connection_option=s3_path, format=format)


    def _validate_csv_config(self, properties:Dict[str, str]):
        config = {}

        config["file_path"] = properties.get("file_path")
        config["header_ind"] = properties.get("header_ind", True)
        config["quote_char"] = properties.get("quote_char", "\"")
        config["escape_char"] = properties.get("escape_char", "\"")
        config["date_format"] = properties.get("date_format", "dd/MM/yyyy")







        

        



        

