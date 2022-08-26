from prefect.infrastructure import DockerContainer

docker_block = DockerContainer(image="prefecthq/prefect:dev-python3.9")
uuid = docker_block.save("prod", overwrite=True)
print(uuid)
