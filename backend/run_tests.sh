#!/bin/bash

# Run tests in Docker with PYTHONPATH set
docker build -t backend-tests -f Dockerfile .
docker run --rm -e PYTHONPATH=/app backend-tests pytest
