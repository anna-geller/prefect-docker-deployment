from prefect.infrastructure.docker import (
    DockerContainer,
    DockerRegistry,
    ImagePullPolicy,
)

dockerhub = DockerRegistry(
    username="annaprefect",
    password="xxx",
    reauth=True,
    registry_url="https://index.docker.io/v1/",
)
dockerhub.save("prod", overwrite=True)

docker_block = DockerContainer(
    image="annaprefect/dataflowops:latest",
    image_registry=dockerhub,
    image_pull_policy=ImagePullPolicy.ALWAYS,
)
uuid = docker_block.save("prod", overwrite=True)
print(uuid)
