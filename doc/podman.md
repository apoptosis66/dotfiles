# Podman Setup Where Needed

yay -S podman netavark catatonit nvidia-container-toolkit
podman run -d \
	--name ferrofin \
	--network host \
	--restart unless-stopped \
	--device nvidia.com/gpu=all \
  -v ~/.config/ferrofin:/data:Z \
  -v /media:/media:ro \
  ghcr.io/mangoleaf/ferrofin:latest
podman stop ferrofin
podman rm ferrofin
podman logs -f ferrofin
podman pull ghcr.io/mangoleaf/ferrofin:latest
systemctl --user restart ferrofin.service
systemctl --user stop ferrofin.service
systemctl --user status ferrofin.service
