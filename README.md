# DNS-to-DNS-over-TLS Proxy

This Docker container runs a simple DNS-to-DNS-over-TLS proxy that forwards DNS queries to DNS-over-TLS servers of Google and Cloudflare and prompt the user for DOT server input in case of no response from mentioned DNS-over-TLS server.

## Requirements

- Docker

## Usage

1. Clone this repository: `https://github.com/HimanshuChauhan007/dns-dns-over-tls-proxy.git`

### Building the Docker Image
`docker build -t dns-proxy .`

### Running the Docker Container
`docker run -d -p 53:53 dns-proxy`

###
Configure Your Client to Use the Proxy:

Command to get <container_id>: `docker ps` OR `docker container ls`

Identify the IP address of the running container using `docker inspect <container_id> | grep "IPAddress"` OR `docker inspect <container_id> | findstr "IPAddress"`
Configure your client application (e.g., your computer's network settings) to use the container's IP address as the primary DNS server.

### Testing the Proxy
Once the container is running, you can test the DNS-to-DNS-over-TLS proxy by sending DNS queries to it. Here's an example using `dig` OR `nslookup` command:
`dig www.google.com @<container_ip_address>`
