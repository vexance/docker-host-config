read -p "ACME Email: " ACME_EMAIL
read -p "DNS Token: " DNS_TOKEN
read -p "Host FQDN: " -d '.' HOSTNAME && read HOST_FQDN
#read -p "Hostname: " HOSTNAME
read -p "Traefik Hash: " AUTH_HASH

HOST_FQDN="$HOSTNAME.$HOST_FQDN"
SETUP_PATH="$(pwd)/docker-setup"

echo ""
echo "Please confirm the following configuration:"
echo " * ACME Email Address: $ACME_EMAIL"pwd
echo " * DNS Auth Token: $DNS_TOKEN"
echo " * Hostname: $HOSTNAME"
echo " * Host FQDN: $HOST_FQDN"
echo " * Traefik Dashboard Hash: $AUTH_HASH"
echo " * Setup Path: $SETUP_PATH"
read -p "Confirm Settings? [y/n]: " CONFIRMATION

SETUP_PATH="$(echo $SETUP_PATH | sed 's/\//\\\//g')"

if [[ "$CONFIRMATION" == "y" ]] || [[ "$CONFIRMATION" == "Y" ]]; then
    sed -e "s/\[ACME_EMAIL\]/$ACME_EMAIL/g" \
        -e "s/\[DNS_TOKEN\]/$DNS_TOKEN/g" \
        -e "s/\[HOST_FQDN\]/$HOST_FQDN/g" \
        -e "s/\[HOSTNAME\]/$HOSTNAME/g" \
        -e "s/\[DASHBOARD_AUTH_HASH\]/$AUTH_HASH/g" \
        -e "s/\[SETUP_PATH\]/$SETUP_PATH/g" \
        "./docker-compose-template.yml" > "./docker-setup/docker-compose.yml";

    sed -e "s/\[ACME_EMAIL\]/$ACME_EMAIL/g" \
        -e "s/\[DNS_TOKEN\]/$DNS_TOKEN/g" \
        -e "s/\[HOST_FQDN\]/$HOST_FQDN/g" \
        -e "s/\[HOSTNAME\]/$HOSTNAME/g" \
        -e "s/\[DASHBOARD_AUTH_HASH\]/$AUTH_HASH/g" \
        -e "s/\[SETUP_PATH\]/$SETUP_PATH/g" \
        "./traefik-template.yml" > "./docker-setup/traefik/config/traefik.yml";

    echo "Created config YAML; Composing..."

    chmod 0600 ./docker-setup/traefik/config/acme.json
    docker network create traefik-proxy
    docker-compose up -d -f ./docker-setup/docker-compose.yml

    exit;
fi

echo "Settings not confirmed, exiting";



