resource "aws_ecr_repository" "this" {
    for_each = toset(var.repositories)
    name = "${var.name}-ecr-${each.key}"
    image_tag_mutability = var.mutability

    tags = merge(var.common_tags, {
        Name = "${var.name}-ecr-repository"
    })
}

resource "aws_ecr_lifecycle_policy" "this" {
  for_each = toset(var.repositories)
  repository = aws_ecr_repository.this[each.key].name

  policy = jsondecode({
    rules = concat(
        [
            for i, p in var.keep_tag_prefixes : {
                rulePriority = i + 1
                description  = "Keep at least 1 image for tag prefix ${p}"
                selection = {
                    tagStatus     = "tagged"
                    tagPrefixList = [p]
                    countType     = "imageCountMoreThan"
                    countNumber   = 1
            }
            action = { type = "expire" }
        }
        ],
        [
            {
                rulePriority = length(var.keep_tag_prefixes) + 1
                description  = "Keep last ${var.keep_any_last} any images"
                selection = {
                    tagStatus   = "any"
                    countType   = "imageCountMoreThan"
                    countNumber = var.keep_any_last
                }
                action = { type = "expire" }
            }
        ]
    )
  })
}