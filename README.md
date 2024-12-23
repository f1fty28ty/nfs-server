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
    chmod +x start.sh stop.sh start-nfs.sh
    ```

## Project Structure

- **Dockerfile**: Configuration file for building the NFS server container image.
- **Kubernetes/**: Contains Kubernetes configurations for deploying and managing client pods.
- **start.sh**: Script to start the NFS server.
- **stop.sh**: Script to stop the NFS server.
- **exports**: Configuration file specifying the NFS export directory.

## Usage

- **Start the NFS Server:**

    ```bash
    ./start.sh
    ```

- **Stop the NFS Server:**

    ```bash
    ./stop.sh
    ```

- **Access from Kubernetes Client Pods:**

    ```bash
    kubectl get pods
    ```

    You can ```kubectl exec -it <podname> -- sh``` into any of these pods and test the capabilities
  
## Contributing

Contributions are welcome! Please fork the repository and submit a pull request.

## License

This project is licensed under the BSD-3-Clause License. See the LICENSE file for details.

## Acknowledgments

Thanks to the open-source community for the tools and resources that made this project possible.
