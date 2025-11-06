resource "aws_ecr_repository" "this" {
    for_each = toset(var.repositories)
    name = "${var.name}-ecr-${each.key}"
    image_tag_mutability = ""

    tags = merge(var.common_tags, {
        Name = "${var.name}-ecr-repository"
    })
}