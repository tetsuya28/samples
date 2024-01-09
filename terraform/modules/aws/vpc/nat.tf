resource "aws_eip" "this" {
  count = var.nat ? 1 : 0
  vpc   = true
  tags = {
    Name      = "${var.app}-nat"
    CreatedBy = var.created_by
  }
}

resource "aws_nat_gateway" "this" {
  count         = var.nat ? 1 : 0
  allocation_id = aws_eip.this[0].id
  subnet_id     = aws_subnet.public[0].id
  tags = {
    Name      = var.app
    CreatedBy = var.created_by
  }
}
