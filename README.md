# podman_build_tabbyapi
This repo contains scripts for building [theroyallab/tabbyAPI](https://github.com/theroyallab/tabbyAPI).

## Docker Image CI
[![Docker Image CI](https://github.com/Wolfsauge/podman_build_tabbyapi/actions/workflows/docker-image.yaml/badge.svg)](https://github.com/Wolfsauge/podman_build_tabbyapi/actions/workflows/docker-image.yaml)

## RunPod Templates
* [tabbyAPI RunPod template](https://www.runpod.io/console/explore/ypdsxfga99) for CUDA 12.1, derived from _nvidia/cuda:12.1.0-runtime-ubuntu22.04_
* [tabbyAPI RunPod template](https://www.runpod.io/console/explore/hiut3m6hcu) for CUDA 12.2, derived from _nvidia/cuda:12.2.2-runtime-ubuntu22.04_
* [tabbyAPI RunPod template](https://www.runpod.io/console/explore/i6ipm7ovin) for CUDA 12.3, derived from _nvidia/cuda:12.3.2-runtime-ubuntu22.04_
* [tabbyAPI RunPod template](https://www.runpod.io/console/explore/2cta3jznfv) for CUDA 12.4, derived from _nvidia/cuda:12.4.1-runtime-ubuntu22.04_

## Related Repositories
* The Royal Lab's [tabbyAPI](https://github.com/theroyallab/tabbyAPI/) GitHub
* Docker Hub [repo](https://hub.docker.com/r/nschle/tabbyAPI) with custom RunPod images

## References
Inspirations and scripts from the following projects were used.
* [TheBloke AI](https://github.com/TheBlokeAI/dockerLLM)
* [The Royal Lab](https://github.com/theroyallab/)

Last changed: 2024-05-25
