# Developer Documentation

## Environment setup from scratch

### Prerequisites
Install the following tools on the development machine:
- Docker Engine
- Docker Compose plugin
- GNU Make
- A shell capable of running the project commands

### Required configuration files
The stack expects credential values to be available through the secret files in `secrets/`.
# Developer Documentation

## Prerequisites
- Docker Engine
- Docker Compose plugin
- GNU Make
- `sudo` access for full cleanup with `make fclean`
- `almeekel.42.fr` mapped to `127.0.0.1` in `/etc/hosts`

## Environment Setup
Create `srcs/.env` before starting the stack. The file must stay untracked and contain these variables:
- `DOMAIN_NAME`: public domain used by Nginx and WordPress
- `DB_NAME`: MariaDB database name
- `DB_USER`: MariaDB user for WordPress
- `DB_PASSWORD`: password for `DB_USER`
- `DB_ROOT_PASSWORD`: MariaDB root password
- `WP_TITLE`: WordPress site title
- `WP_ADMIN_USER`: WordPress administrator username
- `WP_ADMIN_EMAIL`: WordPress administrator email address
- `WP_ADMIN_PASSWORD`: WordPress administrator password
- `WP_USER`: regular WordPress user username
- `WP_USER_EMAIL`: regular WordPress user email address
- `WP_USER_PASSWORD`: regular WordPress user password

Example format:
```dotenv
DOMAIN_NAME=almeekel.42.fr
DB_NAME=wordpress
DB_USER=wpuser
DB_PASSWORD=<your_password>
DB_ROOT_PASSWORD=<your_root_password>
WP_TITLE=Inception
WP_ADMIN_USER=almeekel
WP_ADMIN_EMAIL=almeekel@student.42.fr
WP_ADMIN_PASSWORD=<your_admin_password>
WP_USER=sacha
WP_USER_EMAIL=meekelsacha@gmail.com
WP_USER_PASSWORD=<your_user_password>
```

## Run
From the repository root:
```bash
make all
```

This creates the host data directories if needed and starts the stack with `docker compose up --build` from `srcs/`.

## Stop
```bash
make down
```

## Full Reset
```bash
make fclean
```
This removes the host data directory tree and requires `sudo`.

## Access
- Website: `https://almeekel.42.fr`
- Only port `443` is exposed.
- A self-signed certificate warning in the browser is normal.

## Container Management
- `docker compose ps`
- `docker compose logs <service>`
- `docker exec -it <container> bash`

## Data Storage
- MariaDB data: `/home/almeekel/data/db/`
- WordPress data: `/home/almeekel/data/wordpress/`
or:
