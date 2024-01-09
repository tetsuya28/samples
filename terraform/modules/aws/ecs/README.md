## ECS Service module

## Spec
|variable|role|
|:-|:-|
|name|task definition name, service name|
|container_def|rendered container definition|
|ecs_cluster_name|ecs_cluster_name|
|ecs_service_desired_count|task desired count|
|cloudwatch_log_group_name|cloudwatch_log_group_name|
|task_role_policy|Use [data.aws_iam_policy_document](https://www.terraform.io/docs/providers/aws/d/iam_policy_document.html)|
|task_exec_role_policy|Use [data.aws_iam_policy_document](https://www.terraform.io/docs/providers/aws/d/iam_policy_document.html)|
