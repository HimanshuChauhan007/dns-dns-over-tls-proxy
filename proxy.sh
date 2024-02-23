#!/bin/bash

# Set DNS-over-TLS servers
DNS_TLS_SERVERS=("8.8.8.8" "1.1.1.1")
DNS_TLS_PORT=853

# Function to handle DNS queries
handle_dns_query() {
    local query="$1"
    # Iterate over DNS-over-TLS servers
    for server in "${DNS_TLS_SERVERS[@]}"; do
        # Forward the DNS query to DNS-over-TLS server and capture the response
        response=$(echo "$query" | openssl s_client -connect "${server}:${DNS_TLS_PORT}" -quiet 2>/dev/null)
        # Print the response
        echo "$response"
    done
}

# Listen for DNS queries over UDP and TCP
while true; do
    # Receive DNS query from client
    read -r query
    # Handle the DNS query and forward to DNS-over-TLS servers
    handle_dns_query "$query"
done
