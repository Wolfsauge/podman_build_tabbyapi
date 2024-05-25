# podman_build_tabbyapi
This repo contains scripts for building docker images of [theroyallab/tabbyAPI](https://github.com/theroyallab/tabbyAPI) suitable for [RunPod](https://www.runpod.io/) or local use.

## Docker Image CI
[![Docker Image CI](https://github.com/Wolfsauge/podman_build_tabbyapi/actions/workflows/docker-image.yaml/badge.svg)](https://github.com/Wolfsauge/podman_build_tabbyapi/actions/workflows/docker-image.yaml)

## Tags
* `12.4.1-runtime-ubuntu22.04-runpod`
* `12.3.2-runtime-ubuntu22.04-runpod`
* `12.2.2-runtime-ubuntu22.04-runpod`
* `12.1.0-runtime-ubuntu22.04-runpod`

## Example Use

A 2x 48 GB GPU system is required to follow this example.

### Download Model Files

```shell
$ cd /app/models; \
    HF_HUB_ENABLE_HF_TRANSFER=1 huggingface-cli \
    download \
    turboderp/Llama-3-70B-Instruct-exl2 \
    --local-dir turboderp_Llama-3-70B-Instruct-exl2_6.0bpw \
    --revision 6.0bpw \
    --cache-dir /app/models/.cache
```

URL: Huggingface repository [turboderp/Llama-3-70B-Instruct-exl2](https://huggingface.co/turboderp/Llama-3-70B-Instruct-exl2)

### Example Configuration

Adapt `/app/models/config.yml` to use this model.

```yaml
network:
  host: 0.0.0.0
  port: 7000
  disable_auth: False
logging:
  prompt: False
  generation_params: False
sampling:
developer:
model:
  max_seq_len: 32768
  model_dir: models
  model_name: turboderp_Llama-3-70B-Instruct-exl2_6.0bpw
  gpu_split_auto: False
  gpu_split: [25, 47]
  cache_mode: Q4
  fasttensors: true
```

### Restart the Application

```shell
$ restart.sh
```

### Inspect the Logfile

```shell
$ tail -f /app/tabbyAPI.log
```

### Find the API Key

```shell
$ grep API /app/tabbyAPI.log
```

### Use the API

Insert the API key into the authorization header.

```shell
$ curl -s http://localhost:7000/v1/chat/completions \
    -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer d160430598b33ef9acd98235d12dc3ae" \
    -d '{
    "model": "turboderp_Llama-3-70B-Instruct-exl2_6.0bpw",
    "messages": [
      {
        "role": "user",
        "content": "Compose a poem that explains the concept of recursion in programming."
      }
    ]
  }'
```

## RunPod Templates
* [tabbyAPI RunPod template](https://www.runpod.io/console/explore/ypdsxfga99) for CUDA 12.1, derived from _nvidia/cuda:12.1.0-runtime-ubuntu22.04_
* [tabbyAPI RunPod template](https://www.runpod.io/console/explore/hiut3m6hcu) for CUDA 12.2, derived from _nvidia/cuda:12.2.2-runtime-ubuntu22.04_
* [tabbyAPI RunPod template](https://www.runpod.io/console/explore/i6ipm7ovin) for CUDA 12.3, derived from _nvidia/cuda:12.3.2-runtime-ubuntu22.04_
* [tabbyAPI RunPod template](https://www.runpod.io/console/explore/2cta3jznfv) for CUDA 12.4, derived from _nvidia/cuda:12.4.1-runtime-ubuntu22.04_

## Related Repositories
* The Royal Lab's [tabbyAPI](https://github.com/theroyallab/tabbyAPI/) GitHub
* Docker Hub [repo](https://hub.docker.com/r/nschle/tabbyapi) with custom RunPod images

## References
Inspirations and scripts from the following projects were used.
* [TheBloke AI](https://github.com/TheBlokeAI/dockerLLM)
* [The Royal Lab](https://github.com/theroyallab/)

Last changed: 2024-05-25
