import sys
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.utils import getResolvedOptions

args = getResolvedOptions(sys.argv, ['JOB_NAME'])

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

print("Starting Glue Aggregation Job")
# 1. Read CSV from Staging bucket
# 2. Perform aggregation
# 3. Write CSV to Analytics bucket
# Note: PII columns are written to Analytics because Lake Formation controls the fine-grained access.

job.commit()
