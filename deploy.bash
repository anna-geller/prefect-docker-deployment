prefect dev build-image
docker build -t dataflowops .
IMAGE=$(docker images --no-trunc --quiet dataflowops)

# custom infra block
python blocks/docker_block.py
prefect deployment build flows/healthcheck.py:healthcheck -n dockerinfra -ib docker-container/prod -q prod --skip-upload -o deploy/dockerinfra.yaml --override image=$IMAGE --apply --path /opt/prefect/flows
prefect deployment run healthcheck/dockerinfra

# reusing the same for other flows
prefect deployment build flows/df.py:df -n prod -ib docker-container/prod -q prod --skip-upload -o deploy/df.yaml --override image=$IMAGE --apply --path /opt/prefect/flows
prefect deployment build flows/healthcheck.py:healthcheck -n prod -ib docker-container/prod -q prod --skip-upload -o deploy/healthcheck.yaml --override image=$IMAGE --apply --path /opt/prefect/flows
prefect deployment run df/prod
prefect deployment run healthcheck/prod

# default infra block
prefect deployment build flows/healthcheck.py:healthcheck -n default --infra docker-container -q prod --skip-upload -o deploy/docker.yaml --path /opt/prefect/flows --override image=$IMAGE --apply
prefect deployment run healthcheck/default