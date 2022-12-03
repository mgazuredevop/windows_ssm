resource "aws_instance" "example" {
  ami                  = data.aws_ami.windows.id
  instance_type        = "t2.micro"
  availability_zone    = "us-east-1a"
  key_name             = "mgdev"
  user_data            = data.template_file.windows-userdata.rendered
  iam_instance_profile = aws_iam_instance_profile.ec2-ssm-iam-profile.name
  lifecycle {
    ignore_changes = [ami]
  }

}

resource "aws_iam_role" "ec2_role" {
  name = "ec2-role"
  path = "/"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "ec2.amazonaws.com"
          },
          "Effect" : "Allow"
        }
      ]
    }
  )
}
resource "aws_iam_role_policy_attachment" "ec2-ssm-policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_iam_instance_profile" "ec2-ssm-iam-profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_role.name
}
