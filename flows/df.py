from prefect import task, flow
from prefect import get_run_logger
import pandas  # to demonstrate that imports work correctly


@task
def process_df(user_name: str):
    logger = get_run_logger()
    logger.info("Hello from Prefect, %s!", user_name)
    logger.info("Pandas Version = %s 🐼", pandas.__version__)


@flow
def df(user: str = "Marvin"):
    process_df(user)
