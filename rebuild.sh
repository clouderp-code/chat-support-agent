# Stop containers
docker-compose down

# Rebuild
docker-compose build

# Start services
docker-compose up -d

# Wait a few seconds for the service to start
sleep 10

# Run tests
./backend/test-endpoints.sh

#Test verification script
docker-compose exec backend python tests/verify_setup.py