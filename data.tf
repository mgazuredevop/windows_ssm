data "aws_ami" "windows" {
  most_recent = true

  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-*"]

  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]

  }
}

data "template_file" "windows-userdata" {
  template = <<EOF
<powershell>

#Install ssm agent
$progressPreference = 'silentlyContinue'
Invoke-WebRequest `
    https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/windows_amd64/AmazonSSMAgentSetup.exe `
    -OutFile $env:USERPROFILE\Desktop\SSMAgent_latest.exe

Start-Process `
    -FilePath $env:USERPROFILE\Desktop\SSMAgent_latest.exe `
    -ArgumentList "/S"
</powershell>
EOF
}


# Restart machine
##shutdown -r -t 10;
