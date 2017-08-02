resource "aws_security_group" "worker" {
  vpc_id = "${data.aws_vpc.cluster_vpc.id}"

  tags = "${merge(map(
      "Name", "${var.cluster_name}_worker_sg",
      "kubernetes.io/cluster/${var.cluster_name}", "owned",
      "tectonicClusterID", "${var.cluster_id}"
    ), var.extra_tags)}"
}

resource "aws_security_group_rule" "worker_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.worker.id}"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "worker_ingress_icmp" {
  type              = "ingress"
  security_group_id = "${aws_security_group.worker.id}"

  protocol    = "icmp"
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = 0
  to_port     = 0
}

resource "aws_security_group_rule" "worker_ingress_ssh" {
  type              = "ingress"
  security_group_id = "${aws_security_group.worker.id}"

  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = 22
  to_port     = 22
}

resource "aws_security_group_rule" "worker_ingress_http" {
  type              = "ingress"
  security_group_id = "${aws_security_group.worker.id}"

  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = 80
  to_port     = 80
}

resource "aws_security_group_rule" "worker_ingress_https" {
  type              = "ingress"
  security_group_id = "${aws_security_group.worker.id}"

  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = 443
  to_port     = 443
}

resource "aws_security_group_rule" "worker_ingress_heapster" {
  type              = "ingress"
  security_group_id = "${aws_security_group.worker.id}"

  protocol  = "tcp"
  from_port = 4194
  to_port   = 4194
  self      = true
}

resource "aws_security_group_rule" "worker_ingress_heapster_from_master" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.worker.id}"
  source_security_group_id = "${aws_security_group.master.id}"

  protocol  = "tcp"
  from_port = 4194
  to_port   = 4194
}

resource "aws_security_group_rule" "worker_ingress_flannel" {
  type              = "ingress"
  security_group_id = "${aws_security_group.worker.id}"

  protocol  = "udp"
  from_port = 4789
  to_port   = 4789
  self      = true
}

resource "aws_security_group_rule" "worker_ingress_flannel_from_master" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.worker.id}"
  source_security_group_id = "${aws_security_group.master.id}"

  protocol  = "udp"
  from_port = 4789
  to_port   = 4789
}

resource "aws_security_group_rule" "worker_ingress_node_exporter" {
  type              = "ingress"
  security_group_id = "${aws_security_group.worker.id}"

  protocol  = "tcp"
  from_port = 9100
  to_port   = 9100
  self      = true
}

resource "aws_security_group_rule" "worker_ingress_node_exporter_from_master" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.worker.id}"
  source_security_group_id = "${aws_security_group.master.id}"

  protocol  = "tcp"
  from_port = 9100
  to_port   = 9100
}

resource "aws_security_group_rule" "worker_ingress_kubelet_insecure" {
  type              = "ingress"
  security_group_id = "${aws_security_group.worker.id}"

  protocol  = "tcp"
  from_port = 10250
  to_port   = 10250
  self      = true
}

resource "aws_security_group_rule" "worker_ingress_kubelet_insecure_from_master" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.worker.id}"
  source_security_group_id = "${aws_security_group.master.id}"

  protocol  = "tcp"
  from_port = 10250
  to_port   = 10250
}

resource "aws_security_group_rule" "worker_ingress_kubelet_secure" {
  type              = "ingress"
  security_group_id = "${aws_security_group.worker.id}"

  protocol  = "tcp"
  from_port = 10255
  to_port   = 10255
  self      = true
}

resource "aws_security_group_rule" "worker_ingress_kubelet_secure_from_master" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.worker.id}"
  source_security_group_id = "${aws_security_group.master.id}"

  protocol  = "tcp"
  from_port = 10255
  to_port   = 10255
}

resource "aws_security_group_rule" "worker_ingress_services" {
  type              = "ingress"
  security_group_id = "${aws_security_group.worker.id}"

  protocol  = "tcp"
  from_port = 32000
  to_port   = 32767
  self      = true
}

resource "aws_security_group_rule" "worker_ingress_services_from_console" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.worker.id}"
  source_security_group_id = "${aws_security_group.console.id}"

  protocol  = "tcp"
  from_port = 32000
  to_port   = 32767
}

resource "aws_security_group_rule" "worker_ingress_portworx_mgmt" {
  type              = "ingress"
  security_group_id = "${aws_security_group.worker.id}"

  protocol  = "tcp"
  from_port = 9001
  to_port   = 9001
  self      = true
}

resource "aws_security_group_rule" "worker_ingress_portworx_gossip" {
  type              = "ingress"
  security_group_id = "${aws_security_group.worker.id}"

  protocol  = "tcp"
  from_port = 9002
  to_port   = 9002
  self      = true
}

resource "aws_security_group_rule" "worker_ingress_portworx_data" {
  type              = "ingress"
  security_group_id = "${aws_security_group.worker.id}"

  protocol  = "tcp"
  from_port = 9003
  to_port   = 9003
  self      = true
}

resource "aws_security_group_rule" "worker_ingress_portworx_object" {
  type              = "ingress"
  security_group_id = "${aws_security_group.worker.id}"

  protocol  = "tcp"
  from_port = 9010
  to_port   = 9010
  self      = true
}

resource "aws_security_group_rule" "worker_ingress_portworx_namespace" {
  type              = "ingress"
  security_group_id = "${aws_security_group.worker.id}"

  protocol  = "tcp"
  from_port = 9012
  to_port   = 9012
  self      = true
}

resource "aws_security_group_rule" "worker_ingress_portworx_diags" {
  type              = "ingress"
  security_group_id = "${aws_security_group.worker.id}"

  protocol  = "tcp"
  from_port = 9014
  to_port   = 9014
  self      = true
}
