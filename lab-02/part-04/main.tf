resource "aws_ecr_repository" "frontend" {
  name                 = "gitops-repo/frontend"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "cart-service" {
  name                 = "gitops-repo/cart-service"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "frontend_repo_url" {
  value = aws_ecr_repository.frontend.repository_url
}

output "cart-service_repo_url" {
  value = aws_ecr_repository.cart-service.repository_url
}