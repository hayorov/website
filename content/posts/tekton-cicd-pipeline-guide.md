+++
title = "Step-by-Step: Setting Up a CI/CD Pipeline Using Tekton"
date = "2026-02-05"
+++

Setting up a **CI/CD pipeline** with **Tekton** transforms how you handle continuous integration and delivery in Kubernetes environments. This guide walks you through every step - from installation to running a production-ready pipeline - using the latest Tekton practices as of early 2026, enabling you to automate builds, tests, scans, and deployments efficiently on your cluster.

Tekton stands out as a **cloud-native CI/CD framework** because it runs entirely within Kubernetes as custom resources, eliminating the need for external servers. You'll learn to create reusable **Tasks**, orchestrate them in **Pipelines**, and execute **PipelineRuns** with real-world examples, including security scanning and multi-environment deployments. By the end, you'll have a scalable setup that boosts developer productivity and reliability.

## Why Choose Tekton for Your CI/CD Needs

**Tekton Pipelines** excels in Kubernetes-native environments by defining workflows as declarative YAML manifests. Unlike traditional tools like Jenkins, Tekton leverages Kubernetes pods for execution, making it highly scalable and portable across clusters.

Key advantages include:

- **Reusability**: Share **Tasks** across pipelines via Tekton Hub or using the cluster resolver.
- **Flexibility**: Run tasks sequentially, in parallel, or conditionally using `when` expressions.
- **Data sharing**: Use **Workspaces** and **Results** to pass artifacts and metadata between steps without hardcoded paths.
- **Extensibility**: Integrate with tools like Kaniko for builds, Trivy for scans, and Kubernetes for deployments.
- **Event-driven automation**: Use Tekton Triggers with EventListeners for webhook-based pipeline execution.

The latest Tekton v1.3.1 LTS (released August 2025, supported through August 2026) emphasizes better resource management, improved performance, and stable v1 APIs. For teams managing microservices on Kubernetes, this setup reduces deployment times by up to 50% compared to agent-based systems, based on community benchmarks.

Visit [hayorov.me](https://hayorov.me) for more insights into optimizing your Kubernetes workflows with modern DevOps tools.

## Prerequisites for Tekton Installation

Before diving in, ensure your environment meets these requirements:

- A running **Kubernetes cluster** (v1.27+ recommended for full Tekton v1 support).
- **kubectl** configured and working.
- **tkn CLI** v0.43.0 or later installed.
- Cluster-admin access for installing CRDs.
- Persistent storage class for Workspaces (e.g., for source code sharing).

Install the latest Tekton CLI (v0.43.0+):

```bash
# macOS via Homebrew
brew install tektoncd-cli

# Linux (x86_64)
curl -LO https://github.com/tektoncd/cli/releases/download/v0.43.0/tkn_0.43.0_Linux_x86_64.tar.gz
sudo tar xvzf tkn_0.43.0_Linux_x86_64.tar.gz -C /usr/local/bin/ tkn

# Verify installation
tkn version
```

## Installing Tekton Pipelines on Your Cluster

Tekton installation is straightforward via YAML manifests. Use the latest LTS release for production stability.

1. **Install Tekton Pipelines** (latest v1.3.1 LTS):

```bash
kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
```

2. **Verify installation**:

```bash
tkn version
kubectl get pods -n tekton-pipelines
```

Expect `tekton-pipelines-controller` and `tekton-pipelines-webhook` pods running.

3. **Wait for all components to be ready**:

```bash
kubectl wait --for=condition=ready pod --all -n tekton-pipelines --timeout=300s
```

For visualization, install the **Tekton Dashboard** (latest release):

```bash
kubectl apply --filename https://storage.googleapis.com/tekton-releases/dashboard/latest/release.yaml
```

Access it via port-forward: `kubectl port-forward -n tekton-pipelines service/tekton-dashboard 9097:9097`, then open `http://localhost:9097` in your browser.

**Pro Tip**: For production environments, pin to specific LTS versions for stability. The current LTS v1.3.1 is supported through August 2026.

## Understanding Tekton Core Components

Master these building blocks to build flexible pipelines:

- **Step**: A single container execution (e.g., `npm test`).
- **Task**: Sequence of steps for one job (e.g., git-clone).
- **Pipeline**: Orchestrates Tasks with parameters, workspaces, and conditions.
- **PipelineRun**: Instantiates a Pipeline with concrete values.
- **Workspace**: PersistentVolumeClaim or other storage for sharing files between tasks.
- **Results**: Structured outputs passed between Tasks (e.g., image digest).
- **Resolvers**: Fetch Tasks from external sources (Hub, Git, Bundles, Cluster).

**Important Note**: ClusterTasks are deprecated in favor of the **cluster resolver**. Use `resolver: cluster` in taskRef to reference cluster-scoped tasks.

## Creating Your First Simple Task

Start with a basic **git-clone Task** using the Tekton Hub resolver - the modern way to reference tasks.

Install the git-clone task from Tekton Hub:

```bash
tkn hub install task git-clone
```

Test with a standalone **TaskRun**:

```yaml
apiVersion: tekton.dev/v1
kind: TaskRun
metadata:
  name: test-git-clone
spec:
  taskRef:
    resolver: hub
    params:
    - name: catalog
      value: tekton
    - name: type
      value: task
    - name: name
      value: git-clone
    - name: version
      value: "0.9"
  params:
  - name: url
    value: https://github.com/tektoncd/pipeline
  - name: revision
    value: main
  workspaces:
  - name: output
    persistentVolumeClaim:
      claimName: source-pvc  # Create this PVC first
```

Apply: `kubectl apply -f taskrun.yaml`, then check logs: `tkn taskrun logs test-git-clone -f`.

This clones the repo into a Workspace, foundational for pipelines.

## Building a Basic Pipeline: Clone, Build, and Push

Combine Tasks into a **Pipeline** for a classic flow: clone → build → push.

Install required tasks from Tekton Hub:

```bash
tkn hub install task git-clone
tkn hub install task kaniko
```

Create `basic-pipeline.yaml` using v1 API:

```yaml
apiVersion: tekton.dev/v1
kind: Pipeline
metadata:
  name: build-and-push
spec:
  params:
  - name: git-url
    type: string
  - name: image
    type: string
  - name: revision
    type: string
    default: "main"
  workspaces:
  - name: source
  - name: dockerconfig
  tasks:
  - name: fetch-repo
    taskRef:
      resolver: hub
      params:
      - name: catalog
        value: tekton
      - name: type
        value: task
      - name: name
        value: git-clone
      - name: version
        value: "0.9"
    params:
    - name: url
      value: $(params.git-url)
    - name: revision
      value: $(params.revision)
    workspaces:
    - name: output
      workspace: source
  - name: build-push
    runAfter: [fetch-repo]
    taskRef:
      resolver: hub
      params:
      - name: catalog
        value: tekton
      - name: type
        value: task
      - name: name
        value: kaniko
      - name: version
        value: "0.6"
    workspaces:
    - name: source
      workspace: source
    - name: dockerconfig
      workspace: dockerconfig
    params:
    - name: IMAGE
      value: $(params.image)
```

Apply: `kubectl apply -f basic-pipeline.yaml`.

## Executing Your First PipelineRun

Create a PVC for Workspace:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: source-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
```

Create a Docker config secret for pushing images:

```bash
kubectl create secret docker-registry docker-credentials \
  --docker-server=docker.io \
  --docker-username=YOUR_USERNAME \
  --docker-password=YOUR_PASSWORD \
  --docker-email=YOUR_EMAIL
```

Run the Pipeline:

```yaml
apiVersion: tekton.dev/v1
kind: PipelineRun
metadata:
  generateName: basic-run-
spec:
  pipelineRef:
    name: build-and-push
  params:
  - name: git-url
    value: https://github.com/your-org/sample-app
  - name: image
    value: docker.io/yourusername/sample-app:latest
  - name: revision
    value: main
  workspaces:
  - name: source
    persistentVolumeClaim:
      claimName: source-pvc
  - name: dockerconfig
    secret:
      secretName: docker-credentials
  timeouts:
    pipeline: "30m"
```

Apply with: `kubectl create -f pipelinerun.yaml` (note: use create for generateName), then monitor: `tkn pipelinerun logs -f -L`.

Success! Your code is cloned, built with Kaniko (no Docker daemon needed), and pushed.

## Advanced Pipeline: Full CI/CD with Tests, Scans, and Deployments

Scale to production with testing, security scanning, and multi-stage deploys.

Install additional tasks:

```bash
tkn hub install task git-clone
tkn hub install task kaniko
tkn hub install task trivy-scanner
tkn hub install task kubernetes-actions
```

Create `advanced-pipeline.yaml` with modern v1 API and hub resolver:

```yaml
apiVersion: tekton.dev/v1
kind: Pipeline
metadata:
  name: app-cicd-pipeline
spec:
  params:
  - name: git-url
    type: string
  - name: git-revision
    type: string
    default: "main"
  - name: image-registry
    type: string
    default: "docker.io"
  - name: image-name
    type: string
  - name: deploy-env
    type: string
    default: "staging"
  workspaces:
  - name: source-code
  - name: docker-config
  - name: kubeconfig
  results:
  - name: image-digest
    value: $(tasks.build-image.results.IMAGE_DIGEST)
  tasks:
  # Clone repository
  - name: fetch-source
    taskRef:
      resolver: hub
      params:
      - name: catalog
        value: tekton
      - name: type
        value: task
      - name: name
        value: git-clone
      - name: version
        value: "0.9"
    params:
    - name: url
      value: $(params.git-url)
    - name: revision
      value: $(params.git-revision)
    workspaces:
    - name: output
      workspace: source-code

  # Parallel: Tests and Security Scan
  - name: run-unit-tests
    taskRef:
      name: run-tests  # Custom Task: npm test, pytest, etc.
    runAfter: [fetch-source]
    workspaces:
    - name: source
      workspace: source-code

  - name: security-scan
    taskRef:
      resolver: hub
      params:
      - name: catalog
        value: tekton
      - name: type
        value: task
      - name: name
        value: trivy-scanner
      - name: version
        value: "0.2"
    runAfter: [fetch-source]
    params:
    - name: ARGS
      value: ["fs", "--severity", "CRITICAL,HIGH", "."]
    - name: IMAGE_PATH
      value: "."
    workspaces:
    - name: manifest-dir
      workspace: source-code

  # Build after tests pass
  - name: build-image
    taskRef:
      resolver: hub
      params:
      - name: catalog
        value: tekton
      - name: type
        value: task
      - name: name
        value: kaniko
      - name: version
        value: "0.6"
    runAfter:
    - run-unit-tests
    - security-scan
    params:
    - name: IMAGE
      value: "$(params.image-registry)/$(params.image-name):$(params.git-revision)"
    workspaces:
    - name: source
      workspace: source-code
    - name: dockerconfig
      workspace: docker-config

  # Conditional Deploy to Staging
  - name: deploy-staging
    taskRef:
      resolver: hub
      params:
      - name: catalog
        value: tekton
      - name: type
        value: task
      - name: name
        value: kubernetes-actions
      - name: version
        value: "0.2"
    runAfter: [build-image]
    when:
    - input: $(params.deploy-env)
      operator: in
      values: ["staging"]
    params:
    - name: script
      value: |
        kubectl set image deployment/myapp myapp=$(params.image-registry)/$(params.image-name):$(params.git-revision) -n staging
        kubectl rollout status deployment/myapp -n staging
    workspaces:
    - name: kubeconfig-dir
      workspace: kubeconfig

  finally:
  - name: cleanup
    taskRef:
      name: cleanup-workspace
    workspaces:
    - name: source
      workspace: source-code
```

Key enhancements:

- **Hub resolver**: Modern way to reference tasks from Tekton Hub (no more ClusterTasks).
- **Parallel execution**: Tests and security scans run simultaneously for faster feedback.
- **When conditions**: Environment-specific deploys based on parameters.
- **Finally block**: Ensures cleanup/notifications always run, even on failure.
- **Pipeline-level Results**: Capture deployable artifacts like image digests.
- **Timeouts**: Prevent resource hogs with task and pipeline-level timeouts.

## Service Accounts, Secrets, and Security Best Practices

Secure your pipeline with proper RBAC and secret management:

1. **Create ServiceAccount with proper permissions**:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: pipeline-sa
  namespace: default
secrets:
- name: docker-credentials
- name: kubeconfig-secret
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pipeline-deployer
  namespace: staging
rules:
- apiGroups: ["apps"]
  resources: ["deployments"]
  verbs: ["get", "list", "patch", "update"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: pipeline-sa-deployer
  namespace: staging
subjects:
- kind: ServiceAccount
  name: pipeline-sa
  namespace: default
roleRef:
  kind: Role
  name: pipeline-deployer
  apiGroup: rbac.authorization.k8s.io
```

2. **Registry Secret** (already created in previous section):

```bash
kubectl create secret docker-registry docker-credentials \
  --docker-server=docker.io \
  --docker-username=youruser \
  --docker-password=yourtoken \
  --docker-email=you@example.com
```

3. **Kubeconfig for Deployments**: Create a service account in your target cluster with deploy permissions, extract the token, and create a kubeconfig secret.

4. **Resource Limits and Timeouts**:

```yaml
# Add to individual tasks
timeout: 10m
computeResources:
  requests:
    cpu: 500m
    memory: 512Mi
  limits:
    cpu: 1000m
    memory: 1Gi
```

**2026 Security Best Practices**:

- Use **Workload Identity** or **IRSA** (IAM Roles for Service Accounts) instead of static credentials where possible.
- Parameterize all sensitive inputs; never hardcode secrets in YAML.
- Use **immutable image tags** (git commit SHA) instead of `latest`.
- Implement **Trivy scanning** with severity thresholds (CRITICAL, HIGH).
- Enable **SBOM generation** for supply chain security.
- Use **signed bundles** with Tekton Chains for task provenance.
- Implement **network policies** to restrict pod-to-pod communication.
- Version pipelines in Git alongside application code (GitOps approach).
- Use **OPA Gatekeeper** or Kyverno for policy enforcement.

## Event-Driven Automation with Tekton Triggers

Automate pipeline execution using webhooks with Tekton Triggers and EventListeners.

Install Tekton Triggers:

```bash
kubectl apply --filename https://storage.googleapis.com/tekton-releases/triggers/latest/release.yaml
kubectl apply --filename https://storage.googleapis.com/tekton-releases/triggers/latest/interceptors.yaml
```

Create an EventListener for GitHub webhooks:

```yaml
apiVersion: triggers.tekton.dev/v1beta1
kind: EventListener
metadata:
  name: github-listener
spec:
  serviceAccountName: pipeline-sa
  triggers:
  - name: github-push
    interceptors:
    - ref:
        name: github
      params:
      - name: eventTypes
        value: ["push"]
    bindings:
    - ref: github-binding
    template:
      ref: pipeline-template
---
apiVersion: triggers.tekton.dev/v1beta1
kind: TriggerBinding
metadata:
  name: github-binding
spec:
  params:
  - name: gitrevision
    value: $(body.head_commit.id)
  - name: gitrepositoryurl
    value: $(body.repository.clone_url)
---
apiVersion: triggers.tekton.dev/v1beta1
kind: TriggerTemplate
metadata:
  name: pipeline-template
spec:
  params:
  - name: gitrevision
  - name: gitrepositoryurl
  resourcetemplates:
  - apiVersion: tekton.dev/v1
    kind: PipelineRun
    metadata:
      generateName: github-run-
    spec:
      pipelineRef:
        name: app-cicd-pipeline
      params:
      - name: git-url
        value: $(tt.params.gitrepositoryurl)
      - name: git-revision
        value: $(tt.params.gitrevision)
      - name: image-name
        value: myapp
      workspaces:
      - name: source-code
        volumeClaimTemplate:
          spec:
            accessModes:
            - ReadWriteOnce
            resources:
              requests:
                storage: 1Gi
      - name: docker-config
        secret:
          secretName: docker-credentials
```

Expose the EventListener:

```bash
kubectl port-forward service/el-github-listener 8080:8080
```

Configure your GitHub repository webhook to point to the EventListener URL (use ngrok or Ingress for external access).

## Monitoring, Troubleshooting, and Optimization

- **Logs**:

```bash
tkn pipelinerun logs <name> -f
tkn pipelinerun list
tkn taskrun list
```

- **Dashboard**: Visualize pipeline graphs, execution status, and logs at `http://localhost:9097`.

- **Events**:

```bash
kubectl get events --sort-by='.lastTimestamp' -n default
kubectl describe pipelinerun <name>
```

- **Prometheus Metrics**: Enable monitoring with Prometheus Operator:

```bash
kubectl apply -f https://storage.googleapis.com/tekton-releases/pipeline/latest/release-metrics.yaml
```

- **Common Issues and Fixes**:

| Issue | Fix |
|-------|-----|
| PVC not bound | Check storage class exists and has provisioner |
| Permission denied | Verify ServiceAccount RBAC roles and bindings |
| Task timeout | Increase timeout or optimize task steps |
| Image push fail | Verify registry credentials and network access |
| Resolver error | Check Hub connectivity or use specific versions |
| Workspace error | Ensure PVC/secret exists and is accessible |

## Scaling Tekton for Enterprise Workloads

For large teams and production environments:

- **EventListeners with Triggers**: Auto-run pipelines on Git events (push, PR, tag).
- **Multi-tenancy**: Use namespaces and ResourceQuotas to isolate teams.
- **Multi-cluster deployments**: Deploy to multiple clusters using different kubeconfigs.
- **Metrics and Observability**:
  - Enable Prometheus integration for metrics collection
  - Use Grafana dashboards for visualization
  - Integrate with OpenTelemetry for distributed tracing
- **Cost Optimization**:
  - Use ephemeral workspaces with emptyDir for non-persistent data
  - Implement autoscaling for EventListener pods
  - Set aggressive resource limits on Tasks
  - Use spot instances for build workloads
- **GitOps Integration**: Combine with ArgoCD or Flux for complete CI/CD:
  - Tekton builds and pushes images
  - ArgoCD/Flux handles deployment and sync
  - Maintain separation of concerns
- **Supply Chain Security**:
  - Use Tekton Chains for artifact signing and provenance
  - Generate SBOMs (Software Bill of Materials)
  - Implement policy enforcement with OPA/Kyverno

## What's New in Tekton 2026

Recent advancements in Tekton v1.3.x (2026) include:

- **Stable v1 API**: Migration from v1beta1 complete; use `tekton.dev/v1` for all resources.
- **Improved Resolvers**: Hub, Git, Bundle, and Cluster resolvers are production-ready.
- **Pipeline-level Results**: Aggregate results from multiple tasks.
- **Better Resource Management**: Enhanced scheduling and resource allocation.
- **Enhanced Security**: Non-root container execution by default.
- **Performance Improvements**: Faster webhook processing and controller responsiveness.
- **Tekton Chains Integration**: Built-in support for artifact signing and SLSA provenance.

## Conclusion

Mastering Tekton unlocks Kubernetes-native CI/CD that grows with your applications. This guide covered installation, basic and advanced pipelines, security best practices, event-driven automation, and enterprise scaling patterns using the latest Tekton v1 APIs and tooling available in 2026.

Start with the basic clone-build-push example, iterate to advanced flows with testing and security scanning, then add event-driven automation with Triggers. Integrate with ArgoCD for GitOps-based deployments and implement supply chain security with Tekton Chains.

Explore more DevOps automation patterns and Kubernetes best practices at [hayorov.me](https://hayorov.me) to continue elevating your cloud-native journey.

## Additional Resources

- [Official Tekton Documentation](https://tekton.dev/docs/)
- [Tekton Hub](https://hub.tekton.dev/) - Reusable Tasks and Pipelines
- [Tekton Pipelines GitHub](https://github.com/tektoncd/pipeline)
- [Tekton Triggers GitHub](https://github.com/tektoncd/triggers)
- [Tekton Chains Documentation](https://tekton.dev/docs/chains/)
