# DNS-to-DNS-over-TLS Proxy

This Docker container runs a simple DNS-to-DNS-over-TLS proxy that forwards DNS queries to DNS-over-TLS servers of Google and Cloudflare.

## Requirements

- Docker

## Usage

1. Clone this repository: https://github.com/HimanshuChauhan007/dns-dns-over-tls-proxy.git

### Building the Docker Image
docker build -t dns-proxy .

### Running the Docker Container
docker run -d -p 53:53/udp -p 53:53/tcp dns-proxy


### Testing the Proxy
Once the container is running, you can test the DNS-to-DNS-over-TLS proxy by sending DNS queries to it. Here's an example using `dig` OR nslookup command:

dig @localhost example.com
