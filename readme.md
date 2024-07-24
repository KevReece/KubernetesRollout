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

- kubectl
- Argo CD CLI
- docker


Todo
===

1. local dashboard dummy grid
1. docker compose dashboard
1. local single colour node, and dashboard usage
1. colour node into kubernetes, and dashboard usage
1. multiple load balanced colour nodes, and dashboard usage
1. docker compose kubernetes setup
1. argo CD deployment
1. docker compose argo CD
1. demo of progressive rollout (led by readme)
1. dashboard prior versions list display
1. complete local prerequisites/run readme
1. terraform nodes
1. terraform rest
1. complete AWS prerequisites/run readme
