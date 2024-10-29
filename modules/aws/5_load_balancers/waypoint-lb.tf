resource "aws_alb" "waypoint" {
  name               = "${var.namespace}-waypoint"
  load_balancer_type = "network"
  internal           = false
  subnets            = var.subnet_ids
  security_groups = var.vpc_security_group_ids
}

resource "aws_alb_target_group" "waypoint" {
  name     = "${var.namespace}-waypoint"
  port     = 9701
  protocol = "TCP"
  vpc_id      = data.aws_vpc.demostack.id

  stickiness {
    enabled = true
    type    = "source_ip"
  }

}
resource "aws_alb_target_group_attachment" "waypoint" {
  for_each        = toset(data.aws_instances.workers.ids)
  target_group_arn = aws_alb_target_group.waypoint.arn
  target_id        = each.key
  port             = 9701
}

resource "aws_alb_listener" "waypoint" {
  load_balancer_arn = aws_alb.waypoint.arn
  port              = "9701"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.waypoint.arn
  }
}
resource "aws_alb" "waypoint-ui" {
  name               = "${var.namespace}-waypoint-ui"
  load_balancer_type = "network"
  internal           = false
  subnets         = var.subnet_ids
}

resource "aws_alb_target_group" "waypoint-ui" {
  name     = "${var.namespace}-waypoint-ui"
  port     = 9702
  protocol = "TCP"
  vpc_id      = data.aws_vpc.demostack.id

  stickiness {
    enabled = true
    type    = "source_ip"
  }

}
resource "aws_alb_target_group_attachment" "waypoint-ui" {
  for_each        = toset(data.aws_instances.workers.ids)
  target_group_arn = aws_alb_target_group.waypoint-ui.arn
  target_id        = each.key
  port             = 9702
}

resource "aws_alb_listener" "waypoint-ui" {
  load_balancer_arn = aws_alb.waypoint-ui.arn
  port              = "9702"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.waypoint-ui.arn
  }
}
