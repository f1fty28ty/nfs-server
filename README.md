# Distributed NFS Storage Simulation with Docker & Kubernetes

This project demonstrates a distributed Network File System (NFS) setup in a cloud-like environment using Docker and Kubernetes. Docker is used to create and manage the NFS server container, while Kubernetes is employed to manage multiple client pods that access the shared NFS storage. This setup simulates a hybrid cloud storage infrastructure, showcasing high availability, redundancy, and self-healing capabilities.

## Project Overview

The setup includes:
- **NFS Server (Docker)**: A Docker container running nfs-kernel-server on an Ubuntu image. This container acts as a cloud storage provider, exposing shared directories that client pods in Kubernetes can access.
- **Client Access (Kubernetes)**: Kubernetes is used to deploy pods that connect to the NFS server, demonstrating client interaction, auto-scaling, and fault tolerance. If a client pod fails, Kubernetes will automatically restart it, ensuring continuous access to the NFS storage.

## Prerequisites

Ensure the following are installed and configured:
- [Docker](https://docs.docker.com/get-docker/) - for building and running the NFS server container
- [Kubernetes](https://kubernetes.io/docs/setup/) - for managing client pods
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) - for controlling the Kubernetes environment

## Setup Instructions

1. **Clone the Repository**

    ```bash
    git clone https://github.com/f1fty28ty/nfs-server.git
    cd nfs-server
    ```

2. **Build and Run the NFS Server in Docker**

    ```bash
    docker build -t nfs-server .
    docker run -d --name nfs-server --privileged -v /path/to/shared/data:/mnt/data -p 2049:2049 nfs-server
    ```

    Replace `/path/to/shared/data` with the directory you want to share with Kubernetes client pods.

3. **Deploy Kubernetes Client Pods**
   
    Apply the Kubernetes deployment configuration to create client pods that will access the shared NFS storage:

    ```bash
    kubectl apply -f Kubernetes/deployment.yaml
    ```

    The deployment automatically provisions client pods that connect to the NFS server and demonstrate resilience and high availability.

## Project Structure

- **Dockerfile**: Configuration file for building the NFS server container image.
- **Kubernetes/**: Contains Kubernetes configurations for deploying and managing client pods.
- **start-nfs.sh**: Script to start the NFS server.
- **stop.sh**: Script to stop the NFS server.
- **exports**: Configuration file specifying the NFS export directory.

## Usage

- **Start the NFS Server:**

    ```bash
    ./start-nfs.sh
    ```

- **Stop the NFS Server:**

    ```bash
    ./stop.sh
    ```

- **Access from Kubernetes Client Pods:**

    After deploying, Kubernetes pods will have access to the NFS share at the specified mount point, simulating client-side access in a distributed storage environment.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request.

## License

This project is licensed under the BSD-3-Clause License. See the LICENSE file for details.

## Acknowledgments

Thanks to the open-source community for the tools and resources that made this project possible.
