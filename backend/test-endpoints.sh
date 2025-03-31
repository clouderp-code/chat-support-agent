#!/bin/bash

echo "Testing endpoints from outside container..."

# Test external access (using localhost)
for endpoint in "" "health" "api/chat/test" "api/chat/test-openai"; do
    echo -n "Testing /${endpoint}: "
    curl -s "http://localhost:8000/${endpoint}"
    echo
done

echo -e "\nTesting endpoints from inside container..."
# Test internal access (using service name)
docker-compose exec -e DOCKER_ENV=1 backend python /app/tests/test_endpoints.py 