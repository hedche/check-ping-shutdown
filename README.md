

export DOCKER_BUILDKIT=1

docker buildx create --name mybuilder --use


docker buildx build --platform linux/amd64,linux/arm/v7 \
  -t hedche/power-monitor:latest \
  --push \
  .
