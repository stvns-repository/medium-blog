resource "aws_ecr_repository" "frontend" {
  name                 = "gitops-repo/frontend"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  
  image_scanning_configuration {
    scan_on_push = true
  }
}

output "frontend_repo_url" {
  value = aws_ecr_repository.frontend.repository_url
}

