# User Documentation

## What the stack provides
This project deploys a three-service web stack:
- **Nginx**: HTTPS entry point for the website.
- **WordPress**: the CMS application and PHP runtime.
- **MariaDB**: the database that stores the WordPress content.

The website is accessed through Nginx on port `443`, and the application data is stored persistently so the site remains available after container restarts.

## Starting the project
From the repository root:
```bash
make setup
make all
```

What these commands do:
- `make setup` creates the host directories used by the persistent storage.
- `make all` builds the images and starts the full stack with Docker Compose.

If the stack is already prepared, `make all` is enough to rebuild and launch it.

## Stopping the project
Use one of the following commands from the repository root:

- Stop the containers while keeping data:
  ```bash
  make down
  ```
- Stop the containers and remove common Docker leftovers:
  ```bash
  make clean
  ```
- Stop the containers, delete the host data directory, and remove volumes:
  ```bash
  make fclean
  ```

## Accessing the website and admin panel
- Open the public website:
  ```
  https://almeekel.42.fr
  ```
- WordPress administration is available from the same site.
- The usual WordPress admin page is reached through the `/wp-admin` path after logging in.
- The Nginx container serves TLS traffic on port `443`.

If the domain does not resolve on your machine, point `almeekel.42.fr` to the IP address of the Docker host in your local hosts file.

## Locating and managing credentials
The repository stores the sensitive values in the `secrets/` directory.

Expected files:
- `srcs/.env`
- `secrets/credentials.txt`
- `secrets/db_password.txt`
- `secrets/db_root_password.txt`

The compose file reads `srcs/.env`, so keep it aligned with the values used by the stack.

Notes:
- These files contain the values used for WordPress and MariaDB authentication.
- Do not commit real secrets from a personal environment to version control.
- If you rotate a password, update the corresponding secret file and rebuild the stack.

## Checking that services are running correctly
Use these checks after startup:

### Container status
```bash
docker compose -f srcs/docker-compose.yml ps
```
You should see the `nginx`, `wordpress`, and `db` containers running.

### Logs
```bash
docker compose -f srcs/docker-compose.yml logs -f nginx wordpress db
```
Look for successful startup messages and no repeated restart loops.

### Website response
```bash
curl -k https://almeekel.42.fr
```
A valid HTML response confirms that the HTTPS entry point is working.

### WordPress installation
```bash
docker exec -it wordpress wp core is-installed --allow-root
```
A successful exit means the WordPress installation completed.

### Database availability
```bash
docker exec -it db mysql -u root -p
```
Use the root password from `secrets/db_root_password.txt` to confirm MariaDB is reachable.
