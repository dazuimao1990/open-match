#!/bin/bash
if [ $(arch) == "arm64" ];then
  docker_pull_cmd="docker pull --platform=amd64"
else
  docker_pull_cmd="docker pull"
fi

# 官方提供的镜像名称
images=(
    openmatch-mmf-go-soloduel
    openmatch-synchronizer
    openmatch-swaggerui
    openmatch-scale-frontend
    openmatch-query
    openmatch-default-evaluator
    openmatch-backend
    openmatch-frontend
    openmatch-scale-backend
)

# 官方镜像 tag，根据要用的版本确定
tag="1.8.1"

# 源镜像地址
origin_hub_url="gcr.io/open-match-public-images"

# 依赖所使用的 redis 镜像，也要转移到国内的镜像仓库
redis_image=(
    redis:7.2.0-debian-11-r0
    redis-sentinel:7.2.0-debian-11-r0
    redis-exporter:1.52.0-debian-11-r17
    os-shell:11-debian-11-r37
)
redis_origin_hub_url="docker.io/bitnami"

# 火山镜像地址，使用参数传递
volc_hub_url=$1

for image in ${images[@]};
  do 
    ${docker_pull_cmd} ${origin_hub_url}/${image}:${tag}
    docker tag ${origin_hub_url}/${image}:${tag} ${volc_hub_url}/${image}:${tag}
    docker push ${volc_hub_url}/${image}:${tag}
  done

for image in ${redis_image[@]};
  do
    ${docker_pull_cmd} ${redis_origin_hub_url}/${image}
    docker tag ${redis_origin_hub_url}/${image} ${volc_hub_url}/${image}
    docker push ${volc_hub_url}/${image}
  done