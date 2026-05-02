# Hands-on instructions

Here's a complete lab you can run on your laptop in under five minutes using [Kind](https://kind.sigs.k8s.io/), [kubectl](https://kubernetes.io/docs/tasks/tools/), and [Docker](https://docs.docker.com/get-docker/):

## Create a kind cluster with Calico (a CNI that actually enforces NetworkPolicy)
```bash
./scripts/setup.sh
```

## Deploy the RAG app — Chat UI, RAG API, Vector DB
```bash
kubectl apply -f manifests/
```

## Prove everything is wide open (your embeddings are one curl away)
```bash
./scripts/test-connectivity.sh
```

## Lock it down, then open surgical paths
```bash
kubectl apply -f policies/01-deny-all.yaml
kubectl apply -f policies/02-allow-ui-to-api.yaml
kubectl apply -f policies/03-allow-api-to-db.yaml
./scripts/test-connectivity.sh
```

## Run all 8 edge-case scenarios — see the AND/OR trap live
```bash
kubectl apply -f manifests/edge-cases-setup.yaml
./scripts/test-edge-cases.sh
# Check all policies in policies/edge-cases. Apply each edge-case policy one at a time. Run the test script after each one. Watch the connectivity matrix shift. The "aha" moment when you see a single hyphen change the results is worth more than reading this post ten times.
```


# Clean up
```bash
./scripts/teardown.sh
```