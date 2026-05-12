DATA_DIR	= /home/almeekel/data

# Resolve docker binary for non-interactive shells that may have a limited PATH.
# This will use the first available `docker` in PATH, otherwise fall back to /usr/bin/docker.
DOCKER ?= $(shell command -v docker 2>/dev/null || echo /usr/bin/docker)

all: setup
	cd srcs && $(DOCKER) compose up --build

setup:
	mkdir -p $(DATA_DIR)/wordpress $(DATA_DIR)/db

down:
	cd srcs && $(DOCKER) compose down

clean: down
	$(DOCKER) system prune -f

fclean: clean
	rm -rf $(DATA_DIR)
	$(DOCKER) volume prune -f

re: fclean all

.PHONY: all setup down clean fclean re
