A demo of kubernetes rollouts, similar to the progressive delivery talk by Carlos Sanchez: https://www.youtube.com/watch?v=8fcC8KVRo4o

- Kubernetes static response endpoint (a colour) horizontally scaled 
- Dashboard with grid of requests (renders colour cells)
- Argo CD deployment of colour
- Demo of progressive rollout
- Fully hostable local; Or Terraform deploy (e.g. to AWS)


Prerequisites
===

For local:
---

1. docker (app containers)
1. kubectl (commands local Kubernetes)
1. minikube (hosts local Kubernetes in docker and with docker pods)

Build
===

1. Build dashboard image: `docker build -t kevreece/rolloutdashboard:v1.0.0 Dashboard`
1. Push to docker: `docker push kevreece/rolloutdashboard:v1.0.0`
1. Build colour image: `docker build -t kevreece/colour:blue Colour`
1. Push to docker: `docker push kevreece/colour:blue`
1. Edit the colour/index.html content to "green"
1. Rebuild the colour image: `docker build -t kevreece/colour:green Colour`
1. Push to docker: `docker push kevreece/colour:green`

Deploy
===

For local:
---

1. Deploy =
    1. start docker
    1. `minikube start`
    1. Deploy: `kubectl apply -k k8s-manifests/overlays/local` (Warning, due to self dependency on argo rollout, this might need a rerun)
    1. Pass a Minikube colour tunnelled URL to Dashboard client =
        1. Open a colour service tunnel: `minikube service colour --url` (keep open)
        1. Update [./k8s-manifests/base/dashboard/deployment.yaml] `COLOUR_URL` with the prior url
        1. Redeploy Dashboard to force an image refresh: `kubectl rollout restart deployment dashboard`
1. Open a Dashboard service tunnel: `minikube service dashboard --url` (keep open)
1. Observe Dashboard renders as all blue
1. Test green colour deploy =
    1. Update the [./k8s-manifests/base/colour/rollout.yaml] `image` tag `green`
    1. Deploy new version: `kubectl apply -k k8s-manifests/overlays/local`
    1. Observe Dashboard progresses to green in less than a minute


Todo
===

1. deploy using algo cd
1. complete AWS prerequisites/run readme
