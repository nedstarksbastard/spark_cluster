from pyspark.sql import SparkSession
import random

spark = SparkSession.builder \
    .master("spark://localhost:7077") \
    .appName("Spark Test App") \
    .getOrCreate()

NUM_SAMPLES = 6

def inside(p):
    x, y = random.random(), random.random()
    return x*x + y*y < 1


count = spark.sparkContext.parallelize(range(0, NUM_SAMPLES)).filter(inside).count()

print(f'Pi is roughly {4.0 * count / NUM_SAMPLES}')