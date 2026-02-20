# Lesson 3 – TorchScript + Docker

## Build fat image
docker build -f Dockerfile.fat -t ml-fat .

## Build slim image
docker build -f Dockerfile.slim -t ml-slim .

## Run
docker run --rm -v $(pwd):/app ml-fat example.jpg
docker run --rm -v $(pwd):/app ml-slim example.jpg