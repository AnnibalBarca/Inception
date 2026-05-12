*This project has been created as part of the 42 curriculum by almeekel.*

# Inception

## Description
Inception is a Docker-based infrastructure project that deploys a small but complete web stack made of:
- Nginx as the HTTPS reverse proxy.
- WordPress with PHP-FPM as the application layer.
- MariaDB as the database layer.

The goal is to understand container orchestration, persistent storage, networking, secrets handling, and service isolation by building the stack from scratch with Docker and Docker Compose.

### Project overview
The stack is composed of three containers:
- **Nginx** listens on port `443` and terminates TLS.
- **WordPress** runs PHP-FPM on port `9000` inside the internal Docker network.
- **MariaDB** stores the WordPress database and persists its data on the host.

The configuration is driven by `srcs/docker-compose.yml`, while the service-specific setup lives under `srcs/requirements/`.

## Instructions

### Prerequisites
Before running the project, make sure the following are available on your system:
- Docker Engine
- Docker Compose plugin (`docker compose`)
- GNU Make
- A local user with permission to run Docker commands
- A `srcs/.env` file, because `srcs/docker-compose.yml` loads `.env` from the Compose directory
- The project secrets placed in the `secrets/` directory

### Project layout
The most important files are:
- `Makefile`: convenience targets for setup, start, stop, cleanup, and rebuild.
- `srcs/docker-compose.yml`: container orchestration, service wiring, volumes, and networks.
- `srcs/.env`: environment values loaded by Docker Compose.
- `srcs/requirements/nginx/`: Nginx image build context and configuration.
- `srcs/requirements/wordpress/`: WordPress image build context, PHP-FPM configuration, and bootstrap script.
- `srcs/requirements/mariadb/`: MariaDB image build context and database bootstrap script.
- `secrets/`: credential files used by the stack.

### Build and run
From the repository root:
1. Create the host directories used by the bind-mounted volumes:
   ```bash
   make setup
   ```
2. Build and start the full stack:
   ```bash
   make all
   ```
   This runs `docker compose up --build` from `srcs/`.

If you prefer running Compose manually, use:
```bash
cd srcs
docker compose up --build
```

### Stop and clean
- Stop the stack without removing data:
  ```bash
  make down
  ```
- Stop the stack and remove Docker system leftovers:
  ```bash
  make clean
  ```
- Stop the stack, remove the host data directory, and prune volumes:
  ```bash
  make fclean
  ```
- Rebuild everything from scratch:
  ```bash
  make re
  ```

### Access the website
After the stack is up:
- Open the website at:
  ```
  https://almeekel.42.fr
  ```
- The Nginx configuration serves the site over HTTPS on port `443`.
- The domain name is configured in the service environment and Nginx virtual host.

If your machine does not resolve `almeekel.42.fr`, add a local hosts entry that points it to the Docker host IP used for testing.

### Test and verification commands
Use these commands to confirm the stack is working:

#### 1. Confirm the containers are running
```bash
docker compose -f srcs/docker-compose.yml ps
```
Expected outcome:
- `nginx` is healthy and listening on port `443`.
- `wordpress` is running PHP-FPM.
- `db` is running MariaDB.

#### 2. Check logs for startup errors
```bash
docker compose -f srcs/docker-compose.yml logs -f nginx wordpress db
```
What to look for:
- WordPress completes installation only once.
- MariaDB finishes initialization and accepts connections.
- Nginx starts without TLS or upstream errors.

#### 3. Test the HTTPS endpoint
```bash
curl -k https://almeekel.42.fr
```
Expected outcome:
- HTML is returned instead of a connection error.
- The site responds over TLS.

#### 4. Verify WordPress installation state
```bash
docker exec -it wordpress wp core is-installed --allow-root
```
Expected outcome:
- The command exits successfully after the first bootstrapping run.

#### 5. Inspect the database container
```bash
docker exec -it db mysql -u root -p
```
Then check the WordPress database and users created by the bootstrap script.

#### 6. Validate persistent storage
```bash
docker volume ls
sudo ls -la /home/almeekel/data
```
Expected outcome:
- The data directories exist on the host.
- WordPress and MariaDB data remain after container restarts.

### Troubleshooting notes
- If the site is unavailable, confirm that `make setup` was executed before `make all`.
- If Nginx cannot reach WordPress, check the `inception_net` Docker network and the upstream container name.
- If MariaDB fails to start, verify the passwords stored in `secrets/db_password.txt` and `secrets/db_root_password.txt`.
- If WordPress setup repeats on every start, check whether the persistent volume for `/var/www/wordpress` is being mounted correctly.

## Resources
### Classic references
- Docker documentation: https://docs.docker.com/
- Docker Compose documentation: https://docs.docker.com/compose/
- Nginx documentation: https://nginx.org/en/docs/
- WordPress documentation: https://wordpress.org/documentation/
- WP-CLI documentation: https://wp-cli.org/
- MariaDB documentation: https://mariadb.com/kb/en/documentation/

### AI usage
AI was used to:
- Structure this documentation so it matches the project requirements.
- Cross-check the Makefile, Docker Compose file, and startup scripts to keep the run commands accurate.
- Improve clarity in the comparison sections and troubleshooting notes.

All technical choices, service names, paths, and commands were derived from the repository contents and adjusted to match the actual stack configuration.

## Project Description
This project uses Docker to package the web server, application runtime, and database into isolated services that can be started together with a single command.

### Sources included in the project
The repository includes:
- Dockerfiles for Nginx, WordPress, and MariaDB.
- Nginx configuration for TLS termination and reverse proxying.
- PHP-FPM pool configuration for WordPress.
- Bootstrap scripts for WordPress installation and MariaDB initialization.
- Persistent volume definitions backed by host directories.
- Secret files used to provide credentials to the services.

### Main design choices
- One container per service to keep responsibilities separated.
- Nginx exposed on the host, while WordPress and MariaDB remain internal to the Docker network.
- WordPress and database data persisted through bind-mounted volumes so the stack survives container recreation.
- Credentials isolated from image builds and kept in dedicated secret files.
- Service startup ordered so WordPress waits for MariaDB before bootstrapping.

### Docker vs Virtual Machines
- **Virtual Machines** virtualize an entire operating system, including its own kernel, which gives strong isolation but higher overhead.
- **Docker** shares the host kernel and isolates only the application layer, making it lighter, faster to start, and easier to rebuild.
- For this project, Docker is the better fit because the goal is to compose a small service stack quickly and reproducibly without managing full guest operating systems.

### Secrets vs Environment Variables
- **Secrets** are stored as separate files and are easier to keep out of image layers and versioned application code.
- **Environment variables** are convenient for simple runtime configuration but are easier to expose through process listings, logs, or shell history if handled carelessly.
- This project uses secret files for credential values while still passing them into containers as environment variables at runtime, which keeps the sensitive source material separate from the image build context.

### Docker Network vs Host Network
- **Docker networks** provide service-to-service isolation and predictable container DNS names such as `db` and `wordpress`.
- **Host networking** would expose the container directly on the host interfaces and remove most of that isolation.
- This project uses a dedicated bridge network because Nginx only needs to reach WordPress privately, and the database should never be exposed on the host network.

### Docker Volumes vs Bind Mounts
- **Docker volumes** are Docker-managed storage abstractions that are convenient and portable.
- **Bind mounts** map container paths to explicit host paths and make the stored data easy to inspect and manage during development.
- This project uses bind-mounted host directories for WordPress and MariaDB persistence so the data is visible under `/home/almeekel/data/` and survives rebuilds and container removal.
