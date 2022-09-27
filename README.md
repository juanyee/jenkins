# jenkins

### Build Dockerfile
- `docker image build -t juanyee/jenkins .` or `docker build -t juanyee/jenkins .`, both are the same.

### Deploy as a Kubernetes Container
- `kubectl apply -f jenkins.yaml`

### Save into Docker Hub
- `docker push juanyee/jenkins`