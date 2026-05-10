# Install and enable Docker
sudo dnf install docker -y
sudo systemctl enable --now docker

# Set-up the gitlab-runner permission
sudo usermod -aG docker gitlab-runner

# Refresh the service so it picks up the new group membership
sudo systemctl restart gitlab-runner
