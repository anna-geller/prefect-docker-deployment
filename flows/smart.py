from faker import Faker
import platform
import prefect
from prefect import task, flow, get_run_logger
import sys


@task
def log_platform_info():
    logger = get_run_logger()
    logger.info("Host's network name = %s", platform.node())
    logger.info("Python version = %s", platform.python_version())
    logger.info("Platform information (instance type) = %s ", platform.platform())
    logger.info("OS/Arch = %s/%s", sys.platform, platform.machine())
    logger.info("Prefect Version = %s", prefect.__version__)


@flow
def smart():
    fake = Faker()
    logger = get_run_logger()
    logger.info("We should %s 🚀", fake.bs())
    log_platform_info()


if __name__ == "__main__":
    smart()
