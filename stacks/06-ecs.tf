module "ecs_cluster" {
    source = "terrafor-aws-modules/ecs/aws//modules/cluster"

    name = ""

    configuration {
        execute_command_configuration {
            log_configuration {
                cloud_watch_log_group_name = ""
            }
        }
    }

    

}