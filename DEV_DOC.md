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

Files used by the project:
- `srcs/.env`
- `secrets/credentials.txt`
- `secrets/db_password.txt`
- `secrets/db_root_password.txt`

The compose file expects `srcs/.env`, as the services load `.env` from inside the Compose directory.

### Host directories for persistence
The Makefile creates the host storage directories under:
- `/home/almeekel/data/wordpress`
- `/home/almeekel/data/db`

These are the bind-mount targets used by the WordPress and MariaDB volumes.

## Build and launch

### Using the Makefile
From the repository root:
```bash
make setup
make all
```

What happens:
- `make setup` creates the persistent host directories.
- `make all` enters `srcs/` and runs `docker compose up --build`.

### Using Docker Compose directly
```bash
cd srcs
docker compose up --build
```

If you want detached mode during development:
```bash
cd srcs
docker compose up --build -d
```

## Container management commands

### Stop the stack
```bash
make down
```
or:
```bash
cd srcs
docker compose down
```

### Inspect running containers
```bash
docker compose -f srcs/docker-compose.yml ps
```

### View logs
```bash
docker compose -f srcs/docker-compose.yml logs -f
```
For a single service:
```bash
docker compose -f srcs/docker-compose.yml logs -f nginx
```

### Rebuild from scratch
```bash
make fclean
make all
```
or:
```bash
make re
```

### Clean Docker state
```bash
make clean
```
This stops the stack and prunes unused Docker system objects.

## Data storage and persistence

### Where the data lives
The project stores persistent data in two bind-mounted directories on the host:
- `/home/almeekel/data/wordpress` for WordPress files and uploaded content.
- `/home/almeekel/data/db` for MariaDB data files.

### How persistence works
- The compose file maps named volumes to those host paths using `driver_opts` with `type: none` and `o: bind`.
- Removing a container does not delete the host data.
- Rebuilding images does not erase the database or website content as long as the host directories remain intact.

### Practical checks
To confirm persistence:
1. Start the stack.
2. Create a sample post or upload a file in WordPress.
3. Stop the stack with `make down`.
4. Start it again with `make all`.
5. Confirm the content is still present.

## Service behavior notes
- Nginx listens on `443` and proxies PHP requests to the WordPress container.
- WordPress waits for MariaDB to become reachable before running its bootstrap logic.
- MariaDB initializes the database, creates the WordPress user, and sets the root password during container startup.
- The stack uses a dedicated bridge network named `inception_net` for internal service communication.

## Useful debug commands

### Inspect container shells
```bash
docker exec -it nginx sh
docker exec -it wordpress bash
docker exec -it db bash
```

### Check WordPress CLI state
```bash
docker exec -it wordpress wp core is-installed --allow-root
docker exec -it wordpress wp option get siteurl --allow-root
```

### Check MariaDB connectivity
```bash
docker exec -it db mysql -u root -p
```

### Test the HTTPS endpoint
```bash
curl -k https://almeekel.42.fr
```

## Notes for maintenance
- If you change any service ports, container names, or the domain name, update both the compose file and these docs.
- If you rotate credentials, update the secret files and rebuild the stack so the bootstrap scripts receive the new values.
- If persistence behaves unexpectedly, verify the host paths under `/home/almeekel/data/` and the compose volume definitions first.
