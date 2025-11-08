module "ecs_cluster" {
    source = "../modules/compute/ecs-cluster"
    name = var.name
    common_tags = var.common_tags

    vpc_id = module.vpc.vpc_id
    private_subnet_ids = module.subnets.private_subnet_ids

    namespace = var.namespace
    enable_fargate = var.enable_fargate
    enable_ec2 = var.enable_ec2

    ecs_instance_sg_ids = module.sg.sg_ec2_instance_id
    instance_type = var.instance_type
    instance_profile_arn = module.iam.instance_profile_arn
    max_size = var.max_size
    min_size = var.min_size
    desired_capacity = var.desired_capacity
    services = var.services
}

module "ecs_task_definition" {
    source = "../modules/compute/ecs-task-definition"

    name = var.name
    common_tags = var.common_tags

    region = var.region
    service_definitions = {
        for svc, def in var.service_definitions :
        svc => merge(def, {
            image = "${lookup(module.ecr.repository_urls, svc, module.ecr.repository_names["test"])}:latest" #레파지토리 이름 수정 필요
            env_map = lookup(def, "env", var.environment)
        })
    }
    ecs_task_execution_role_arn = module.iam.ecs_task_execution_role
    ecs_task_role_arns = module.iam.ecs_task_role
    ecs_log_group_names = module.cloudwatch.cloudwatch_ecs_log_group_names
}

module "ecs_service" {
    source = "../modules/compute/ecs-services"
    name = var.name
    common_tags = var.common_tags
    region = var.region

    service_definitions = var.service_definitions
    cluster_arn = module.ecs_cluster.ecs_cluster_arn
    task_definition_arns = module.ecs_task_definition.task_definition_arns
    
    private_subnet_ids = module.subnets.private_subnet_ids
    sg_ecs_service_ids = module.sg.sg_ecs_service_ids
}