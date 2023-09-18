import pyspark
from pyspark.sql import SparkSession
from pyspark.sql.types import StructType, StructField, StringType, IntegerType, TimestampType, FloatType
from pyspark.sql.window import Window
from pyspark.sql.functions import col, row_number
from pyspark.sql.functions import *
from delta import *

builder = pyspark.sql.SparkSession.builder.appName("DaaS") \
    .config("spark.sql.extensions", "io.delta.sql.DeltaSparkSessionExtension") \
    .config("spark.sql.catalog.spark_catalog", "org.apache.spark.sql.delta.catalog.DeltaCatalog")

spark = configure_spark_with_delta_pip(builder).getOrCreate()
spark.sparkContext.setLogLevel("ERROr")

# Configuracao
people_path = "s3a://data-platform-dl-extracao-prod-default/people_table"
emp_path    = "s3a://data-platform-dl-extracao-prod-default/emp"
dep_path    = "s3a://data-platform-dl-extracao-prod-default/dep"
dim_path    = "s3a://data-platform-dl-extracao-prod-default/dimension"

# retornando tabelas
def show_table(table_path):
    print("\n Show the table")
    df = spark.read.format("delta").load(table_path)
    df.show()


def generate_Data(table_path, table_path2, table_path3):

    print("\n Criando Tabela:")
    employees = [(1, "James", "","Smith","36636", "M", 5000, 1,222),
                 (2, "Michael", "Rose", "","40288", "M", 400, 2, 333),
                 (3, "Robert", "","Williams", "42114", "M", 3500, 3,444),
                 (4, "Maria", "Anne", "Jones", "39192","F",3800, 3,555),
                 (5, "Jen", "Mary", "Brown", "","F",-1,3,666)]
    
    schema_emp = StructType([
        StructField("Id", IntegerType(), True),
        StructField("primeiroNome", StringType(), True),
        StructField("nomeMeio", StringType(), True),
        StructField("ultimoNome", StringType(), True),
        StructField("matricula", StringType(), True),
        StructField("genero", StringType(), True),
        StructField("salario", StringType(), True),
        StructField("DepID", IntegerType(), True),
        StructField("CentCusto", StringType(), True),
    ])

    df_emp = [(1, "TI"),
              (2, "Marketing"),
              (3, "RH"),
              (4, "Vendas")]
    
    schema_dep = StructType([
        StructField("id", IntegerType(), True),
        StructField("Departamento", StringType(), True)
    ])

    df_emp = spark.createDataFrame(data=employees, schema=schema_emp)
    df_dep = spark.createDataFrame(data=df_dep, schema=schema_dep)

    print("Salvando tabela Delta...\n")
    df_emp.write.format("delta")\
        .option("overwriteSchema", "true")\
        .mode("overwrite")\
        .save(table_path)
    
    df_dep.write.format("delta")\
        .option("overwriteSchema", "true")\
        .mode("overwrit")\
        .save(table_path2)
    
    print("Carregando tabelas Delta...\n")
    df_emp = spark.read.format("delta").load(table_path)
    df_dep = spark.read.format("delta").load(table_path2)

    df_emp.show()
    df_dep.show()

    print("Criando visualização do Delta...\n")
    df_emp.createOrReplaceTempView("Funcionarios")
    df_dep.createOrReplaceTempView("Departamentos")

    print("Dimensao da tabela...\n")
    query = spark.sql('''
                        SELECT e.id,
                        e.primeiroNome,
                        e.nomeMeio,
                        e.salario,
                        d.Departamento,
                        FROM Funcionarios e INNER JOIN Departamentos d
                        ON e.id = d.id
                        ''')
    query.show()

    print("Salvando tabela Delta para Tabela Dimensao")
    query.write.format("delta")\
        .mode("overwrite")\
        .save(table_path3)
    
generate_Data(emp_path, dep_path, dim_path)