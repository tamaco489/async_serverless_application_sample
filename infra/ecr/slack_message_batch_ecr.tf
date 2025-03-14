resource "aws_ecr_repository" "slack_message_batch" {
  name                 = local.slack_message_batch
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.slack_message_batch}"
  }
}

resource "aws_ecr_lifecycle_policy" "slack_message_batch" {
  repository = aws_ecr_repository.slack_message_batch.name
  policy = jsonencode(
    {
      "rules" : [
        {
          "rulePriority" : 1,
          "description" : "バージョン付きのイメージを5個保持する、6個目がアップロードされた際には古いものから順に削除されていく",
          "selection" : {
            "tagStatus" : "tagged",
            "tagPrefixList" : ["slack_message_batch_v"],
            "countType" : "imageCountMoreThan",
            "countNumber" : 5
          },
          "action" : {
            "type" : "expire"
          }
        },
        {
          "rulePriority" : 2,
          "description" : "タグが設定されていないイメージをアップロードされてから3日後に削除する",
          "selection" : {
            "tagStatus" : "untagged",
            "countType" : "sinceImagePushed",
            "countUnit" : "days",
            "countNumber" : 3
          },
          "action" : {
            "type" : "expire"
          }
        },
        {
          "rulePriority" : 3,
          "description" : "タグが設定されたイメージをアップロードされてから7日後に削除する",
          "selection" : {
            "tagStatus" : "any",
            "countType" : "sinceImagePushed",
            "countUnit" : "days",
            "countNumber" : 7
          },
          "action" : {
            "type" : "expire"
          }
        }
      ]
    }
  )
}
