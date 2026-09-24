# ft_onion - Docker Hidden Service

Simple Docker container with Nginx, SSH, and Tor hidden services.

## Usage

### Using Makefile (Standard 42 Method)
```bash
make          # Build and start container
make status   # Show running status and Tor .onion URLs
make logs     # Follow container logs
make ssh      # Connect via SSH
make stop     # Stop container
make clean    # Stop and delete container
make fclean   # Stop, delete container, and delete Docker image
make re       # Rebuild and restart from scratch
```

### Using Management Script
```bash
./ft_onion.sh start
./ft_onion.sh status
./ft_onion.sh stop
./ft_onion.sh restart
./ft_onion.sh ssh
./ft_onion.sh logs
```

## Access

- **Web (HTTP)**: http://localhost:80 (or http://localhost:8080)
- **SSH**: `ssh -p 4242 aareslan@localhost` (or `-p 2222`, password: `cyberpiscine`)
- **Onion addresses**: Run `make status` or `./ft_onion.sh status`

## Simple Structure

```
├── Dockerfile          # Container definition
├── ft_onion.sh         # Management script
├── nginx.conf          # Web server
├── sshd_config         # SSH (minimal)
├── torrc               # Tor configuration
├── index.html          # Your website
├── start.sh            # Simple startup (3 lines)
└── README.md           # This file
```

## Credentials

- **User**: aareslan
- **Password**: cyberpiscine