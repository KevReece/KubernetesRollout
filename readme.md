A demo of kubernetes rollouts, similar to the progressive delivery talk by Carlos Sanchez: https://www.youtube.com/watch?v=8fcC8KVRo4o

- Kubernetes nodes of static response endpoints (a colour)
- Dashboard with grid of requests (renders coloured cells)
- Argo CD deployment of Colour nodes
- Demo of progressive rollout
- Fully hostable local; Or Terraform deploy (e.g. to AWS)


Prerequisites
===

For local:
---

1. docker (app containers)
1. kubectl (commands local Kubernetes)
1. minikube (hosts local Kubernetes in docker and with docker pods)



Deploy
===

For local:
---

1. Build and deploy =
    1. `minikube start`
    1. Expose Minikube docker registry: `eval $(minikube -p minikube docker-env)`
    1. Build to Minikube docker registry: `docker build -t kubernetesrollout_dashboard:v1 Dashboard`
    1. Build to Minikube docker registry: `docker build -t kubernetesrollout_node:blue Node`
    1. Deploy: `kubectl apply -k k8s-manifests/overlays/local` (Warning, due to self dependency on argo rollout, this might need a rerun)
    1. Pass a Minikube external Node URL to Dashboard client =
        1. Open a Node tunnel: `minikube service node --url` (keep open)
        1. Update the [./Dashboard/wwwroot/js/site.js] `ColourNodesUrl` to the prior url
        1. Rebuild to Minikube docker registry: `docker build -t kubernetesrollout_dashboard:v1 Dashboard`
        1. Redeploy Dashboard to force an image refresh: `kubectl rollout restart deployment dashboard`
1. Open a Dashboard tunnel: `minikube service dashboard --url` (keep open)
1. Observe Dashboard renders as all blue
1. Test green node deploy =
    1. Edit the Node/index.html content to "green"
    1. Rebuild the node image: `docker build -t kubernetesrollout_node:green Node`
    1. Update the [./k8s-manifests/base/node/rollout.yaml] `image` tag `green`
    1. Deploy new version: `kubectl apply -k k8s-manifests/overlays/local`
    1. Observe Dashboard progresses to green in less than a minute


Todo
===

1. rename overloaded 'node' term to 'colour' (?)
1. use docker hub
1. inject dashboard node url from deployment variables
1. deploy using algo cd
1. complete AWS prerequisites/run readme
