resource "aws_alb" "fabio" {
  name = "${var.namespace}-fabio"

  security_groups = var.vpc_security_group_ids
  subnets         = var.subnet_ids

}

resource "aws_alb_target_group" "fabio" {
  name     = "${var.namespace}-fabio"
  port     = "9999"
  vpc_id      = data.aws_vpc.demostack.id
  protocol = "HTTP"

  health_check {
    interval          = "5"
    timeout           = "2"
    path              = "/health"
    port              = "9998"
    protocol          = "HTTP"
    healthy_threshold = 2
    matcher           = 200
  }
}

resource "aws_alb_target_group" "fabio-ui" {
  name     = "${var.namespace}-fabio-ui"
  port     = "9998"
 vpc_id      = data.aws_vpc.demostack.id
  protocol = "HTTP"

  health_check {
    interval          = "5"
    timeout           = "2"
    path              = "/health"
    port              = "9998"
    protocol          = "HTTP"
    healthy_threshold = 2
    matcher           = 200
  }
}

resource "aws_alb_listener" "fabio" {
  load_balancer_arn = aws_alb.fabio.arn

  port     = "9999"
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.fabio.arn
    type             = "forward"
  }
}

resource "aws_alb_listener" "fabio-ui" {
  load_balancer_arn = aws_alb.fabio.arn
  port              = "9998"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.fabio-ui.arn
    type             = "forward"
  }
}

resource "aws_alb_target_group_attachment" "fabio" {
  count            = var.workers
  target_group_arn = aws_alb_target_group.fabio.arn
  target_id        = element(var.aws_instance_workers_ids[*], count.index)
  port             = "9999"

}

resource "aws_alb_target_group_attachment" "fabio-ui" {
  count            = var.workers
  target_group_arn = aws_alb_target_group.fabio-ui.arn
  target_id        = element(var.aws_instance_workers_ids[*], count.index)
  port             = "9998"

}
