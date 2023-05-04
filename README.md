# ConnectID with Ping - Quick Start Guide


## Prerequisites

- Root access to a Linux or MacOS machine with:
    - Git
    - Docker
    - Docker Compose v1 (v2 is NOT currently supported)
    - At least 12GB of RAM available to Docker
- A GitHub Account
- An active Ping Identity support account [(Link)](https://www.pingidentity.com/en/account/register.html)
- A working Ping Identity DevOps installation [(Link)](https://devops.pingidentity.com)

## Step by Step Guide

### Clone the ConnectID Repository

While installing Ping Identity devops, you should have created a project folder in your home directory. We’re going to host the ConnectID sandbox here too:<br>

```sh
git clone \
    https://github.com/ttranatping/pingidentity-connectid-sandbox.git \
    /path/to/pingidentity-connectid-sandbox
```

!!! Note
    Using /path/to/pingidentity-connectid-sandbox will make it easier to follow this guide. It will also make it easier for us to help you if you encounter issues.

### Configure and Start the Stack

1. Add the following entries to the /etc/hosts file

    ```sh
    127.0.0.1 bank-01.pingapac.com
    127.0.0.1 mtls-bank-01.pingapac.com
    ```
!!! Note
    You should use your own hostnames and have that reflected in config.env (next step).

1. Configure /path/to/pingidentity-connectid-sandbox/docker-compose/config.env, in particular, the following fields to reflect your desired hostnames:

- BASE_HOSTNAME
- IDP_HOSTNAME
- MTLS_IDP_HOSTNAME

1. Instantiate /path/to/pingidentity-connectid-sandbox/docker-compose/sensitive-config-template.env to /path/to/pingidentity-connectid-sandbox/docker-compose/sensitive-config.env, and configure:

- PING_IDENTITY_ACCEPT_EULA: YES/NO
- PING_IDENTITY_DEVOPS_USER: Your devops user account
- PING_IDENTITY_DEVOPS_KEY: Your devops user password
- SSL_SERVER_CERT_P12_B64: Base64 encoded PKCS12 file containing the SSL certificate matching your hostnames.
- SSL_SERVER_CERT_P12_PASSWORD: Password of PKCS12 keystore.

1. Obtain transport key and certificate from the ConnectID Sandbox register, and store them under:

- server_profiles/pingdatasync/certificates/transport.key
- server_profiles/pingdatasync/certificates/transport.pem

!!! Note
    The issuer-ca.pem and root-ca.pem files are for the ConnectID sandbox environment. These may need to be changed when connecting to different ConnectID instances.

1. Navigate to the docker-compose folder:

    ```sh
    cd /path/to/pingidentity-connectid-sandbox/docker-compose
    ```

1. Start docker containers with docker-compose:

    ```sh
    docker-compose up -d
    ```

1. To display the server logs as the stack starts up, run the following command (ctrl-c to exit):

    ```sh
    docker-compose \
        -f \
        /path/to/pingidentity-connectid-sandbox/ocker-compose/docker-compose.yaml \
        logs -f
    ```

### Testing guide

Follow the ConnectID Relying Party User Guide - Getting Started guide to stand up a sample application.

Considerations:

- Port conflict issue with sample RP application:
  - If running the application on the same server as the IdP, you may run into port conflict issues.
  - You can change the port to something available (like :4443):
    - src/config.js (server_port)
  - The RP client that comes with the ConnectID Sandbox does not allow for other ports, so you'll need to register an RP in the Sandbox with:
    - redirect_uri: https://tpp.localhost:4443/cb
    - You'll also need to update the sample RP config:
      - src/config.js (details under client, such as client_id, organisation_id, redirect_uris, jwks_uri)
      - certs/* files will need to be updated to suit your RP

Testing Steps:

1. Launch https://tpp.localhost:4443/

1. Customise the request:

- The Sandbox supports the standard claims, as well as Extended Claim over18
- Deselect "Show only certified IDPs" if your IDP isn't certified.

1. Click Verify with ConnectID. This will redirect you to the Ping Identity ConnectID Sandbox instance.

1. Log in with crn0/password and complete the request

!!! Note
    The Ping Identity ConnectID Sandbox does not implement the required CX flows of ConnectID.
