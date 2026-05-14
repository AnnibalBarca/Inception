DATA_DIR	= /home/almeekel/data

all: setup
	cd srcs && docker compose up --build

setup:
	mkdir -p $(DATA_DIR)/wordpress $(DATA_DIR)/db

down:
	cd srcs && docker compose down

clean: down
	docker system prune -f

fclean: clean
	sudo rm -rf $(DATA_DIR)
	docker volume prune -f

re: fclean all

.PHONY: all setup down clean fclean re
