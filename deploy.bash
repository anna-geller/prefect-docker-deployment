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

# optional: push to public DockerHub, either as shown below or using https://github.com/anna-geller/dataflow-ops/blob/main/.github/workflows/docker_image.yaml
docker login -u annaprefect
docker image tag dataflowops:latest annaprefect/dataflowops:latest
docker image push annaprefect/dataflowops:latest

prefect deployment build flows/healthcheck.py:healthcheck -n dockerhub -q prod --infra docker-container --override image=annaprefect/dataflowops:latest --apply
prefect deployment run healthcheck/dockerhub

# custom infra block for a public DockerHub image
python blocks/dockerhub_block.py
prefect deployment build flows/healthcheck.py:healthcheck -n dockerqa -q prod -ib docker-container/prod --apply
prefect deployment run healthcheck/dockerqa

