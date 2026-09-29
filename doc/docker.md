# Docker Setup Where Needed

- yay -S docker docker-buildx docker-compose
- sudo systemctl enable --now docker.service
- sudo usermod -aG docker apoptosis
- newgrp docker
