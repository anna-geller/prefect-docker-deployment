docker build -t dataflowops .
IMAGE=$(docker images --no-trunc --quiet dataflowops)

# custom infra block
python blocks/docker_block.py
prefect deployment build flows/healthcheck.py:healthcheck -n prod -q prod -ib docker-container/prod --override image=$IMAGE --apply
prefect deployment run healthcheck/prod

# reusing the same for other flows
prefect deployment build flows/df.py:df -n prod -q prod -ib docker-container/prod --override image=$IMAGE --apply
prefect deployment run df/prod

# default infra block
prefect deployment build flows/healthcheck.py:healthcheck -n default -q prod --infra docker-container --override image=$IMAGE --apply
prefect deployment run healthcheck/default