# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: aareslan <aareslan@student.42beirut.com>    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/09/24 21:24:00 by aareslan          #+#    #+#              #
#    Updated: 2026/09/24 21:24:00 by aareslan         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME			:= ft_onion
CONTAINER_NAME	:= ft_onion_container
IMAGE_NAME		:= ft_onion
WEB_PORT		?= 8080
SSH_PORT		?= 2222
SSH_USER		:= aareslan

# Default target: build and launch container
all: run

build:
	@echo "==> Building Docker image $(IMAGE_NAME)..."
	docker build -t $(IMAGE_NAME) .

run: build
	@echo "==> Starting container $(CONTAINER_NAME)..."
	@docker stop $(CONTAINER_NAME) 2>/dev/null || true
	@docker rm $(CONTAINER_NAME) 2>/dev/null || true
	docker run -d --name $(CONTAINER_NAME) -p $(WEB_PORT):80 -p $(SSH_PORT):4242 $(IMAGE_NAME)
	@echo "==> Waiting 3s for services to start..."
	@sleep 3
	@$(MAKE) status

status:
	@echo "============================================="
	@echo "               ft_onion Status               "
	@echo "============================================="
	@if docker ps -q -f name=$(CONTAINER_NAME) | grep -q .; then \
		echo "Container Status : Running"; \
		echo "Local Web        : http://localhost:$(WEB_PORT)"; \
		echo "Local SSH        : ssh -p $(SSH_PORT) $(SSH_USER)@localhost"; \
		echo "---------------------------------------------"; \
		echo -n "Web .onion URL   : "; \
		docker exec $(CONTAINER_NAME) cat /var/lib/tor/hidden_service/hostname 2>/dev/null || echo "Waiting for Tor..."; \
		echo -n "SSH .onion URL   : "; \
		docker exec $(CONTAINER_NAME) cat /var/lib/tor/hidden_ssh/hostname 2>/dev/null || echo "Waiting for Tor..."; \
	else \
		echo "Container Status : Not running"; \
	fi
	@echo "============================================="

logs:
	docker logs -f $(CONTAINER_NAME)

ssh:
	ssh -o StrictHostKeyChecking=no -p $(SSH_PORT) $(SSH_USER)@localhost

stop:
	@echo "==> Stopping container $(CONTAINER_NAME)..."
	-docker stop $(CONTAINER_NAME)

clean: stop
	@echo "==> Removing container $(CONTAINER_NAME)..."
	-docker rm $(CONTAINER_NAME)

fclean: clean
	@echo "==> Removing image $(IMAGE_NAME)..."
	-docker rmi $(IMAGE_NAME)

re: fclean all

help:
	@echo "Available Makefile targets for $(NAME):"
	@echo "  make              - Build image, run container, and show status"
	@echo "  make build        - Build Docker image only"
	@echo "  make run          - Build and run container"
	@echo "  make status       - Display status and Onion addresses"
	@echo "  make logs         - Stream container logs"
	@echo "  make ssh          - Connect to container via local SSH"
	@echo "  make stop         - Stop the running container"
	@echo "  make clean        - Stop and remove the container"
	@echo "  make fclean       - Remove container and Docker image"
	@echo "  make re           - Full rebuild and restart (fclean + all)"

.PHONY: all build run status logs ssh stop clean fclean re help
