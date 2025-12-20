locals {
    formatted_project_name = lower(replace(var.project_name, " ", "_"))
    new_tags = merge(var.default_tags, var.environment_tags)
    formatted_bucket_name = replace(replace(
        substr(lower(var.bucket_name), 0, 63),
        " ",""
    ), "!",""
    )

    port_list = split(",", var.allowed_ports)

    sg_rules = [for port in local.port_list :
    {
        name = "port-${port}"
        port = port
        descripition = "Allow traffic on port ${port}"
    }
    ]

    instance_size = lookup(var.instance_sizes, var.environment, "t2.micro")
}

resource "aws_s3_bucket" "firsts3" {
    bucket = local.formatted_bucket_name
    tags = local.new_tags
}