# dotnet-todo

## Test the GET endpoints

Test the app by calling the endpoints from a browser or Postman. The following steps are for Postman.

  Create a new HTTP request.
  Set the HTTP method to GET.
  Set the request URI to https://localhost:<port>/todoitems. For example, https://localhost:5001/todoitems.
  Select Send.

The call to GET /todoitems produces a response similar to the following:

```json
[
  {
    "id": 1,
    "name": "walk dog",
    "isComplete": false
  }
]
```

  Set the request URI to https://localhost:<port>/todoitems/1. For example, https://localhost:5001/todoitems/1.

  Select Send.

  The response is similar to the following:

```json
  {
    "id": 1,
    "name": "walk dog",
    "isComplete": false
  }
```

This app uses an in-memory database. If the app is restarted, the GET request doesn't return any data. If no data is returned, POST data to the app and try the GET request again.

## Build and run Docker image

### Prerequisites

- Docker installed on your machine. You can download and install Docker from [here](https://docs.docker.com/get-docker/).

This is how to build the Docker image:

```
docker build -t todoapp:latest .
```

To run the Docker image follow this command:

```
docker run -p 8080:8080 todoapp:latest
```

To check if application is working run:
```
curl http://localhost:8080/healtz
curl http://localhost:8080/todoitems
```

## Deploy Helm chart

### Prerequisites
- Helm should be installed in your Kubernetes cluster.

### Deploying the Helm Chart

1. **Create Namespace**: If you haven't already created a namespace for deploying the chart, you can create one using the following command:
    ```
    kubectl create namespace <namespace-name>
    ```

2. **Install the Chart**: To install the chart, use the `helm install` command. Replace `<release-name>` with a name for your release and `<chart-name>` with the name of the Helm chart:
    ```
    helm install <release-name> <chart-name>
    ```

    Optionally, if chart is already installed, but want to update it, use this command: 
    ```bash
    helm upgrade --install <release-name> <chart-name> 
    ```

3. **Verify Deployment**: After installation, verify that the resources have been deployed correctly by checking the status of the pods, services, etc.
    ```
    kubectl get pods
    kubectl get services
    ```

### Uninstalling the Chart

To uninstall/delete the chart, use the `helm uninstall` command:
```bash
helm uninstall <release-name>

## GitHub Actions Pipeline

This GitHub Actions pipeline is designed to automate the build, deployment, and versioning processes for the project. It consists of several jobs and steps triggered by different events, including pushes to the main branch, pull requests to various branches, and manual workflow dispatches.

### Workflow Triggers

- **Push**: Triggered on pushes to the `main` branch.
- **Pull Request**: Triggered on pull requests to the `main`, `feature/**`, `bugfix/**`, and `release/**` branches.
- **Workflow Dispatch**: Allows manual triggering with an optional input to bump the version.

### Jobs and Steps

`build-and-deploy` Job

This job runs on an Ubuntu latest environment and consists of the following steps:

1. **Checkout code**: Clones the repository.
2. **Login to Docker Hub**: Authenticates with Docker Hub using secrets for Docker username and password.
3. **Configure Git identity**: Sets up Git user email and name.
4. **Install bumpversion**: Installs the `bumpversion` tool.
5. **Version Bump**: Bumps the project version according to the input provided (`major`, `minor`, `patch`, or `release`).
6. **Build and push Docker image**: Builds and pushes the Docker image to Docker Hub.
7. **Update version in Helm chart**: Updates the version in the Helm chart `Chart.yaml` file.
8. **Commit version changes**: Commits all changes to the repository.
9. **Start minikube**: Sets up Minikube.
10. **Setup Helm**: Sets up Helm.
11. **Install Helm Chart**: Installs or upgrades the Helm chart for the application.
12. **Check app health status**: Verifies if deployed application is running.


###NOTE:
1. **Sonarcloud** - in the branch sonarcloud, in the workflow file, there is a step to run code analysis. During testing I was facing issues with sonar_token, and not able to find in time the issue.
2. **Terraform** - for the last part of the assessment only VPC is created, I'm getting familiar with AWS Lambda currently and it would take me a bit more time to find the right solution to implement with Terraform 
