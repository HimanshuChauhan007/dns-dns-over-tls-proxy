#!/bin/bash

# DoT server list with failover (customize with your preferred servers)
DOT_SERVERS=(
  "1.1.1.1" # Cloudflare
  "8.8.8.8" # Google Public DNS
)

# Function to attempt DoT server connection and return response
function connect_dot_server {
  server_address="$1"
  dot_request="GET /dns-query=.$dot_query HTTP/1.1
Host: $server_address
User-Agent: $(hostname)"

  response=$(echo -e "$dot_request\n\n" | nc -w 5 $server_address 853)
  echo "$response"
}

# Main logic
function main {
  dot_query=$(echo "$1" | base64)

  # Loop through DoT servers
  for dot_server in "${DOT_SERVERS[@]}"; do
    response=$(connect_dot_server "$dot_server")

    # Check for successful response and extract answer
    if [[ -n "$response" ]]; then
      answer=$(echo "$response" | grep -i "^A ")
      if [[ -n "$answer" ]]; then
        echo "$answer" | cut -d' ' -f 5-
        return 0 # Got response, exit loop
      fi
    else
      echo "ERROR: Connection to $dot_server failed."
    fi
  done

  # No answer from DoT servers, prompt for manual input
  echo "No answer found from DoT servers. Try a different server manually?"
  read -p "Enter server address (or 'N' to quit): " answer

  if [[ "$answer" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    # User entered valid IP address, try connecting
    response=$(connect_dot_server "$answer")
    if [[ -n "$response" ]]; then
      answer=$(echo "$response" | grep -i "^A ")
      if [[ -n "$answer" ]]; then
        echo "$answer" | cut -d' ' -f 5-
        return 0 # Got response, exit
      else
        echo "ERROR: Invalid response from provided server."
      fi
    else
      echo "ERROR: Connection to provided server failed."
    fi
  else
    echo "Exiting."
  fi

  # No valid response, indicate complete failure
  echo "ERROR: Could not resolve DNS query."
}
