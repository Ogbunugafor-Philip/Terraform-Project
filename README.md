# Scalable-AWS-Infrastructure-with-Terraform-for-High-Availability-Web-Application


## Introduction
This project, Scalable AWS Infrastructure with Terraform for High-Availability Web Application, demonstrates how to build a secure, resilient, and production-ready cloud environment using Terraform. It provisions a custom VPC with both public and private subnets across multiple Availability Zones, ensuring high availability. Key components include an Application Load Balancer, Auto Scaling Groups for EC2 instances, a multi-AZ RDS database, and proper network routing with Internet and NAT Gateways.
Security is enforced using IAM roles and security groups across all layers—web, app, and database. A bastion host in the public subnet enables controlled SSH access to private resources. All infrastructure is managed through Terraform, making deployments consistent, repeatable, and scalable. This setup reflects real-world cloud architecture for hosting modern, fault-tolerant web applications.

## Project Objectives
- To deploy a highly available and fault-tolerant AWS infrastructure across multiple Availability Zones.
- To automate the provisioning of cloud resources using Terraform as Infrastructure as Code.
- To implement secure network segmentation and access control using IAM roles and security groups.
- To ensure scalability and efficient traffic distribution using Auto Scaling and Load Balancing.

## Project Steps
#### Step 1: Set Up Terraform Environment
#### Step 2: Create the VPC and Networking Resources
#### Step 3: Configure Security
#### Step 4: Provision Compute Resources
#### Step 5: Load Balancer
#### Step 6: Deploy the Database Layer
#### Step 7: Configure Bastion Host
#### Step 8: Output and Validation




## Overview of Project Implementation
The implementation of this project begins by setting up the Terraform environment to prepare the workspace for writing and executing Infrastructure as Code. Next, Terraform is configured to connect with AWS, allowing secure authentication and control over cloud resource provisioning. With access established, the foundational network infrastructure is built by creating a custom VPC that includes public and private subnets distributed across multiple Availability Zones for high availability. Alongside this, Internet and NAT Gateways are provisioned to manage inbound and outbound traffic, while route tables are created and associated with each subnet to ensure correct routing between resources and external services.
Security is then configured by defining IAM roles and creating security groups tailored for different layers of the application stack—Application Load Balancer (Web SG), EC2 (App SG), RDS (DB SG), and the Bastion Host (SSH SG)—enforcing least-privilege access and network protection. Compute resources are provisioned next using EC2 Launch Templates and Auto Scaling Groups to enable scalable deployments in private subnets, along with health checks and automated instance replacement. An Application Load Balancer is deployed in public subnets, configured with HTTP/HTTPS listeners and target groups to efficiently route client traffic to healthy EC2 instances.
The database layer is set up using Amazon RDS in a Multi-AZ configuration within private subnets, providing high availability and failover support for persistent data storage. A Bastion Host is then deployed in a public subnet with an SSH key pair, serving as a secure access point to EC2 instances in private subnets without exposing them to the internet. Finally, key outputs such as the ALB DNS and Bastion IP are displayed for operational use, and the setup is validated to ensure full functionality. Maintenance operations and safe teardown are handled using Terraform commands, supporting future updates and lifecycle management of the infrastructure.

## Project Implementation
### Step 1: Set Up Terraform Environment
Terraform is an open-source Infrastructure as Code (IaC) tool that allows you to provision and manage cloud infrastructure using declarative configuration files.
First, we would install terraform on our local machine. Open your PowerShell as Administrator
Create a Directory for Terraform
```bash
mkdir "$HOME\terraform"
cd "$HOME\terraform"
```

Download Terraform v1.11.4
```bash
Invoke-WebRequest -Uri "https://releases.hashicorp.com/terraform/1.11.4/terraform_1.11.4_windows_amd64.zip" -OutFile "terraform_1.11.4_windows_amd64.zip"
```

Extract the ZIP File
```bash
Expand-Archive -Path "terraform_1.11.4_windows_amd64.zip" -DestinationPath "$HOME\terraform"
```
Add Terraform to PATH (User-level)
```bash
$oldPath = [Environment]::GetEnvironmentVariable("Path", "User")
$newPath = "$oldPath;$HOME\terraform"
[Environment]::SetEnvironmentVariable("Path", $newPath, "User")
```

Restart your PowerShell or VS Code terminal for the PATH update to apply, then verify Installation
```bash
terraform -version
```
![image](https://github.com/user-attachments/assets/7b356565-875b-4e08-b430-a18f47abc034)


Second, we need to configure AWS CLI and set up IAM credentials securely
To install aws CLI, run the below command on your terminal and follow the prompt
```bash
msiexec.exe /i
```

Restart your terminal and run the command to ensure aws CLI is properly installed
```bash
aws – version
```
![image](https://github.com/user-attachments/assets/54277e0b-cb89-47b2-b8a6-26443919d084)


Create an IAM User for Terraform in AWS Console
- Go to IAM → Users → Add user
- Name it something like: terraform-user
- Enable Programmatic access only
- Attach policy: AdministratorAccess (for project/testing purpose only; limit access in production)
- Create access key. Download the .csv file with Access Key ID and Secret Access Key

Configure AWS CLI on Your System. Run this command in your terminal
```bash
aws configure
```
Fill the following
- Access Key ID: downloaded in your csv file
- Secret Access Key: downloaded in your csv file
- Default region name (e.g., us-east-1)
- Default output format: json or table

To confirm that your AWS CLI is properly configured, run the command
```bash
aws configure list
```
![image](https://github.com/user-attachments/assets/a671ac4b-a9e8-43d8-8036-2f0ad1218f28)


Finally, we need to create a project directory with logical Terraform modules or folders.
- Create the main project folder and name it terraform_modules
- Create these four files inside the terraform_modules folder
  - main.tf
  - provider.tf
  - variables.tf
  - outputs.tf
- Inside the terraform_modules folder, create another folder named modules.
- Create a folder named vpc inside the modules folder.
- In the vpc folder, create 3 files: main.tf, variables.tf and outputs.tf
- Create a folder named security inside the modules folder.
- In the security folder, create 3 files: main.tf, variables.tf and outputs.tf
- Create a folder named compute inside the modules folder.
- In the compute folder, create 3 files: main.tf, variables.tf and outputs.tf
- Create a folder named loadbalancer inside the modules folder.
- In the loadbalancer folder, create 3 files: main.tf, variables.tf and outputs.tf
- Create a folder named database inside the modules folder.
- In the database folder, create 3 files: main.tf, variables.tf and outputs.tf
- Create a folder named bastion inside the modules folder.
- In the bastion folder, create 3 files: main.tf, variables.tf and outputs.tf
  
Run 
```bash 
tree /f
```
command to see your file structure
![image](https://github.com/user-attachments/assets/43e0d8cf-dc58-457b-8be6-341b634cefcc)


Next, we would update our provider.tf file so Terraform knows which cloud (AWS) to use, how to log in (profile and region), and which provider version to work with.

Paste this script on your provide.tf file
```bash
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}
```
![image](https://github.com/user-attachments/assets/0ceed93a-b463-4d64-8b43-01d2e73df440)


Let us set up our variable.tf. We use variables.tf to define values (like region and profile) that make our Terraform setup reusable and easy to configure. 

Paste the below script
```bash
variable "aws_region" {
description = "The AWS region to deploy resources in"
type        = string
default     = "us-east-1"
}

variable "aws_profile" {
description = "The AWS CLI profile to use"
type        = string
default     = "default"
}
```
![image](https://github.com/user-attachments/assets/d4422c8c-a36c-4122-b46a-f85db54719cb)

We would need to prepares our project by downloading necessary provider plugins (like AWS) and setting up Terraforms working directory. Run
```bash
terraform init
```
![image](https://github.com/user-attachments/assets/4c0faaa7-1fab-4827-9894-b027618a1a8c)

Now, let us check our Terraform files for syntax errors and ensures the configuration is valid. Run 
```bash
terraform validate
```
![image](https://github.com/user-attachments/assets/c5dda97d-551e-4a94-b344-ca59d2b63c54)

So far, our terraform configuration is ok and Valid.

### Step 2: Create the VPC and Networking Resources
A VPC (Virtual Private Cloud) is like your own private space on the internet, provided by AWS, where you can build and run your websites, apps, or servers safely and securely.
Think of it like renting a private plot of land in a large city (the internet), and then building your own house (servers, databases) with your own gates, roads, and rules (security and networking settings). No one can enter unless you allow them.
In this step, we would do the following;
- Define a custom VPC block.
- Create 2 Public Subnets, 2 Private Web Subnets, and 2 Private DB Subnets Across Two Availability Zones
- Configure Internet Gateway and attach it to the VPC.
- Create a NAT Gateway in a public subnet for private subnet internet access.
- Define route tables for public and private subnets and associate them.

## Brief explanations of why the above are needed and their significance
- Define a Custom VPC Block
  - What: Create a Virtual Private Cloud (VPC) with a CIDR block of 10.0.0.0/16 ([65,536 IPs]). This gives    you enough IP space to define multiple subnets of varying sizes.

  - Why: The custom VPC allows you to define your network structure from scratch. Having a large IP range ensures flexibility for growth and separation of application layers (public, app, and DB tiers).

- Create 2 Public Subnets, 2 Private Web Subnets, and 2 Private DB Subnets Across Two Availability Zones
  What:
  Create six subnets across two Availability Zones with the following CIDR blocks:
  - Public Subnet 1: 10.0.1.0/24 ([256 IPs]) in us-east-1a
  - Public Subnet 2: 10.0.2.0/24 ([256 IPs]) in us-east-1b
  - Private Web Subnet 1: 10.0.3.0/24 ([256 IPs]) in us-east-1a
  - Private Web Subnet 2: 10.0.4.0/24 ([256 IPs]) in us-east-1b
  - Private DB Subnet 1: 10.0.5.0/24 ([256 IPs]) in us-east-1a
  - Private DB Subnet 2: 10.0.6.0/24 ([256 IPs]) in us-east-1b
Note: AWS reserves 5 IPs per subnet, so usable IPs per /24 subnet = 251.
  Why:
  This setup separates your infrastructure into functional layers while distributing them across AZs for fault tolerance. Public subnets host internet-facing components. Private web
  subnets host internal app servers, and private DB subnets securely store your application
  data. Each /24 subnet provides enough IPs for scaling while maintaining clear separation of
  roles.

- Configure an Internet Gateway and Attach It to the VPC
  What:
  Create and attach an Internet Gateway to the VPC to allow internet access for resources in
  public subnets.
  Why:
  Resources like load balancers or bastion hosts need to be reachable from the internet. The I
  GW enables these resources to send and receive traffic externally.

-  Create a NAT Gateway in One Public Subnet for Private Subnet Internet Access
    What:
  Deploy a NAT Gateway in one of the public subnets (e.g., 10.0.1.0/24) and assign it an
  Elastic IP. This enables internet access for private subnets (web and DB) without exposing
  them to inbound traffic.
  Why:
  Application servers and DBs in private subnets need outbound internet access for updates or
  API calls but should remain isolated from direct inbound internet traffic. The NAT Gateway
  provides secure, outbound-only access.

- Define and Associate Route Tables for Public and Private Subnets
  What:
  - Create a public route table that routes 0.0.0.0/0 to the Internet Gateway, and associate it
    with public subnets.
  - Create a private route table that routes 0.0.0.0/0 to the NAT Gateway, and associate it       with the private web and DB subnets.
Why:
Route tables manage traffic flow. Public route tables allow your web servers to be reachable from the internet. Private route tables allow internal servers to reach out without accepting incoming connections, keeping your environment secure and organized.

### Why this VPC is Solid and Production ready for a wide variety of architectures
- Scalability: Usage of /16 CIDR block — providing 65,536 IP addresses. This gives you plenty of room to create multiple subnets and expand your infrastructure over time.

- High Availability: By spreading your subnets across two Availability Zones (us-east-1a and us-east-1b), your application is protected against single-AZ failures, improving fault tolerance and uptime.

- Security Best Practices: Only the public subnets are connected to the Internet Gateway (IGW). The private subnets (web and DB) route through a NAT Gateway for outbound access, and your databases are kept in isolated subnets for maximum protection.

- Clear Network Segmentation: Your application architecture is logically separated into three layers: public (for internet-facing components), private web (for internal app servers), and private DB (for sensitive data). This matches a secure, industry-standard 3-tier design.

- Internet Access Design: The NAT Gateway enables resources in private subnets to access the internet securely without being exposed to inbound traffic. Public subnets alone can receive incoming internet traffic.

- Routing Logic
You've created separate route tables: one for public subnets (routing 0.0.0.0/0 to the IGW), and one for private subnets (routing 0.0.0.0/0 to the NAT Gateway). This ensures proper and secure traffic flow throughout your network.

Now we need to use terraform to automate the building of this VPC

Implement main.tf for the VPC module. Go to: terraform_modules/modules/vpc/main.tf
Copy and Paste the below

Reference: [VPC Terraform Module](https://github.com/Ogbunugafor-Philip/Terraform-Project/blob/main/terraform_modules/modules/vpc/main.tf)


### What the Script does
VPC & Internet Setup
- aws_vpc: Creates your private network (CIDR 10.0.0.0/16 from variable).
- aws_internet_gateway: Allows internet access for resources in public subnets.
- aws_eip: Allocates a static public IP (used by the NAT Gateway).

Subnets (6 subnets total):
- public_az_1, public_az_2: For internet-facing resources (with public IPs).
- private_web_az_1, private_web_az_2: For internal app servers.
- private_db_az_1, private_db_az_2: For databases — isolated.
- Each subnet is placed in AZ_1 (us-east-1a) and AZ_2 (us-east-1b).

NAT Gateway
- aws_nat_gateway: Lets private subnets access the internet outbound only

Route Tables
- public_rt: Routes traffic from public subnets to internet via Internet Gateway.
- private_rt: Routes traffic from private subnets to internet via NAT Gateway.

Associations
- Each subnet is explicitly linked to its correct route table, ensuring proper internet access behavior:
  - Public subnets → public route table (internet access)
  - Private subnets → private route table (outbound only via NAT)
![image](https://github.com/user-attachments/assets/78f6960f-f8d3-4076-b27c-f374446c67e8)

Implement variables.tf for the VPC module. Go to: terraform_modules/modules/vpc/variables.tf
Copy and Paste the below
Reference: [VPC Module Variables](https://github.com/Ogbunugafor-Philip/Terraform-Project/blob/main/terraform_modules/modules/vpc/variables.tf)


What the Script does
This file defines all the input parameters your main.tf module uses. Instead of hardcoding values (like CIDR blocks or subnet AZs), you define variables here so you can:
- Pass values dynamically when calling the module from root main.tf
- Reuse the module across environments (dev, prod, etc.)
- Improve maintainability by separating logic from data
![image](https://github.com/user-attachments/assets/6807c782-d9d9-4bdf-8cfc-b22635bf7291)


Implement outputs.tf for the VPC module. Go to: terraform_modules/modules/vpc/outputs.tf
Copy and Paste the below

Reference: [VPC Module Outputs](https://github.com/Ogbunugafor-Philip/Terraform-Project/blob/main/terraform_modules/modules/vpc/outputs.tf)

### What the Script does

The outputs.tf file exposes key resource IDs from the module to the root module or other modules, so you can reference them later — for example, when creating EC2 instances, load balancers, RDS databases, or security groups.
Think of it like a return statement for your module.
![image](https://github.com/user-attachments/assets/515040ab-14bf-465d-b65f-86fee0fbcbe8)


We have updated the main.tf, variables.tf and outputs.tf of the VPC module.
Now, lets update the main.tf of our root. The main.tf in your root folder is where you call your modules. It acts like the controller or main entry point for your entire Terraform project.

Go to the folder and paste the below:

Reference: [Root Main Terraform Configuration](https://github.com/Ogbunugafor-Philip/Terraform-Project/blob/main/terraform_modules/main.tf)
line 1 -22



Let us test to be sure our configuration is OK
```bash
terraform init
```
![image](https://github.com/user-attachments/assets/1e1e42ab-bee2-4d97-bb6f-e1e85c5c7370)

Run 
```bash
terraform validate
```
 so terraform can validate your configuration
 ![image](https://github.com/user-attachments/assets/d6d273cf-1a09-4db1-8f48-18f03abcfa53)



Our configuration so far is Ok

### Step 3: Configure Security
Security groups are virtual firewalls that control inbound and outbound traffic to your AWS resources like EC2, RDS, and Load Balancers.
They work at the instance level and allow you to define which traffic is allowed, based on:
- Port number (e.g., 22, 80, 443)
- Protocol (e.g., TCP)
- Source or destination (e.g., IP address or another security group)
By default:
- All inbound traffic is denied
- All outbound traffic is allowed
You must explicitly allow the traffic you want.
Below are infrastructures we would need to automate with terraform
### Security Groups

| SG Name         | Purpose                          | Attached To                    | Rules                                  |
|----------------|----------------------------------|--------------------------------|----------------------------------------|
| Web SG (ALB SG) | Allow public HTTP/HTTPS traffic | Application Load Balancer      | Inbound: 80, 443 from anywhere (0.0.0.0/0) |
| App SG (EC2 SG) | Allow traffic from ALB only     | EC2 in private subnets         | Inbound: 80, 443 from Web SG           |
| DB SG (RDS SG)  | Allow traffic from EC2 only     | MySQL database                 | Inbound: 3306 from App SG              |
| Bastion SG      | Allow SSH from your IP          | Bastion Host in public subnet  | Inbound: 22 from your_ip/32            |



### IAM Roles

| Role              | Used For                                      | Policies                                              |
|-------------------|-----------------------------------------------|-------------------------------------------------------|
| EC2 IAM Role      | Allow EC2 to access AWS services              | AmazonS3ReadOnlyAccess, CloudWatchAgentServerPolicy   |
| Optional RDS Role | (If RDS needs to access S3, e.g., for import) | AmazonS3ReadOnlyAccess                                |



Update main.tf inside terraform_modules/modules/security
Copy and paste this into your main.tf

Reference:

### What the Script Does
Creates Four Security Groups:
- Web SG: Allows internet traffic on ports 80 (HTTP) and 443 (HTTPS) for the Application Load Balancer.
- App SG: Allows traffic only from the Web SG (ALB) to your EC2 instances on ports 80 and 443.
- DB SG: Allows MySQL access only from the App SG (EC2) on port 3306.
- Bastion SG: Allows SSH access on port 22 from your specific IP (197.210.53.31/32).

Creates IAM Role for EC2:
Grants EC2 instances permission to:
- Read from S3 (AmazonS3ReadOnlyAccess)
- Send logs to CloudWatch (CloudWatchAgentServerPolicy)

Optionally Creates IAM Role for RDS (if enabled):
- Allows RDS to read from S3, useful for importing data into the database.
![image](https://github.com/user-attachments/assets/768d0585-23a0-435d-b66d-11fb9b84774a)


Update variables.tf inside terraform_modules/modules/security
Copy and paste this into your variables.tf
Reference:

### What this Script Does
vpc_id Variable:
- Accepts the ID of the VPC where all security groups will be created.
- No default value — it must be passed from the root module.

my_ip Variable:
- Stores your public IP address in CIDR format (197.210.53.31/32).
- Used to allow secure SSH access to the Bastion Host.

enable_rds_role Variable:
- A toggle (true/false) to control whether the RDS IAM role should be created.
- Set to true, which means the RDS role will be created and given access to S3.
![image](https://github.com/user-attachments/assets/8e6c4327-7d20-4cd4-b7d1-18a4cbb61e99)


Update outputs.tf inside terraform_modules/modules/security
Copy and paste this into your outputs.tf
Reference:
![image](https://github.com/user-attachments/assets/38a3ea9e-800d-4207-b23e-ec0dce9d2ec1)

###What the Script Does
It exposes key information from your security groups and IAM roles so other modules or your root configuration can use them.

Update Root main.tf (in your project root folder)
Go to your root main.tf and add this block after your VPC module
Reference:


To test our configuration, these two commands
```bash
terraform init
```

```bash
terraform validate
```


### Step 4: Provision Compute Resources
In this step, we would do two things,

Create a Launch Template for EC2:
- AMI ID
- Instance type
- Key pair (optional for SSH)
- Security Group (App SG)
- User data script
  - Update and upgrade packages
  - Install Apache2
  - Install MySQL Server
  - Install PHP and PHP-MySQL module
  - Enable and start services
  - Create a basic index.php for testing
  - Install unzip, wget, and curl for additional app setup or debugging

Set Up Auto Scaling Group (ASG):
- Reference Launch Template
- Place instances in private subnets
- Link to Target Group (will configure in Load Balancer module)
- Set min, max, desired capacity
- Configure health checks

Update main.tf inside terraform_modules/modules/compute
Copy and paste this into your main.tf
Reference:


What the Script Does
- Fetches latest Ubuntu 20.04 AMI.
- Creates a Launch Template for EC2.
- Sets instance type (from variable).
- Attaches App Security Group.
- Skips SSH key (uses Bastion Host).
- Embeds user data script to:
  - Update and upgrade packages
  - Install Apache2
  - Install MySQL Server
  - Install PHP and PHP-MySQL module
  - Install unzip, wget, and curl
  - Start and enable Apache2 and MySQL services
  - Create index.php for testing
- Creates Auto Scaling Group (ASG).
- References Launch Template in ASG.
- Deploys instances into private subnets.
- Links ASG to Target Group (for Load Balancer).
- Sets min, max, and desired capacity.
- Enables EC2 health checks.
- Tags instances with name “App-Instance”.
![image](https://github.com/user-attachments/assets/a0e6d85f-2fb3-44ab-ad76-ee5a20ca85da)


Update variables.tf inside terraform_modules/modules/compute
Copy and paste this into your variables.tf
Reference:

### What the Script Does
- Defines the EC2 instance type (t2.micro by default).
- Accepts the Security Group ID for the app EC2.
- Accepts a list of private subnet IDs for the Auto Scaling Group.
- Accepts the Target Group ARN for Load Balancer integration.
- Sets the minimum number of instances in the ASG (1).
- Sets the maximum number of instances in the ASG (4).
- Sets the desired (initial/target) number of instances in the ASG (1).
![image](https://github.com/user-attachments/assets/f8c4708c-ccc5-4f3b-8c7c-7c5987640890)


Update outputs.tf inside terraform_modules/modules/compute
Copy and paste this into your outputs.tf
Reference:

### What the Script Does
- Exposes the Launch Template ID for use in other modules or root outputs.
- Exposes the Auto Scaling Group name for reference or monitoring.
![image](https://github.com/user-attachments/assets/84c02e61-c161-41e3-8048-fbf2c281d76c)


Update Root main.tf (in your project root folder)
Go to your root main.tf and add this block after your security module
Reference:

To test our configuration, these two commands
```bash
terraform init
```
```bash
terraform validate
```


Step 5: Load Balancer
In this step, we would do the following;
Create Application Load Balancer (ALB)

- Set type to application, scheme to internet-facing.
- Use public subnets and Web SG (allowing ports 80/443).

Create Target Group
- Target type: instance, port: 80, protocol: HTTP.
- Use your VPC.
- Enable health check on /.

Create HTTP Listener (Port 80)
- Forward HTTP traffic to the Target Group.

Output
- Output the ALB DNS name.
- Output the Target Group ARN (used in ASG).

Update main.tf inside terraform_modules/modules/loadbalancer
Copy and paste this into your main.tf
Reference:

### What this Script Does
Creates an Application Load Balancer (aws_lb.app_alb)
- Type: Application
- Scheme: Internet-facing
- Placed in public subnets
- Uses the Web Security Group

Creates a Target Group (aws_lb_target_group.app_tg)
- Type: Instance
- Port: 80
- Protocol: HTTP
- Health check enabled on / path

Creates an HTTP Listener on Port 80 (aws_lb_listener.http)
- Listens for HTTP traffic
- Forwards traffic to the target group
- Forwards traffic to the same target group
![image](https://github.com/user-attachments/assets/ffd12719-826e-4e74-ac75-6b6d93fb611b)


Update variables.tf inside terraform_modules/modules/loadbalancer
Copy and paste this into your variables.tf
Reference:

### What the Script Does
web_sg_id
- Accepts the Security Group ID for the ALB
- Ensures only allowed traffic (ports 80/443) reaches the load balancer

public_subnet_ids: Accepts a list of public subnet IDs where the ALB will be deployed
- vpc_id: Provides the VPC ID for placing the target group

Update variables.tf inside terraform_modules/modules/loadbalancer
Copy and paste this into your variables.tf
Reference:

### What the Script Does
alb_dns_name
- Outputs the public DNS name of the ALB
- Used to access your application via browser or reverse proxy

target_group_arn
- Outputs the ARN of the target group
- Required for linking Auto Scaling Group (ASG) to the load balancer
![image](https://github.com/user-attachments/assets/8ee19ba8-a3cf-4e88-a22f-74f65afffa22)


Update Root main.tf (in your project root folder)
Go to your root main.tf and add this block after your security module
Reference:

### What the Script Does
- Calls the loadbalancer module from your module’s directory
- Passes in:
  - Web Security Group ID from security module
  - Public subnets from vpc module
  - VPC ID from vpc module

To test our configuration, these two commands
```bash
terraform init
```

```bash
terraform validate
```


### Step 6: Deploy the Database Layer
In this step, we would do the following:
- Create a new database module folder: Holds our database infrastructure code.
- Provision a Multi-AZ RDS MySQL instance: Using aws_db_instance with multi_az = true.
- Create an RDS subnet group: To place the DB in private subnets across two AZs.
- Attach the DB security group: Allows only App EC2 instances to connect on port 3306.
- Accept DB credentials as variables: db_username and db_password.
- Output the RDS endpoint: So the app can connect to it.
- Call the module from root main.tf: Passing in private subnet IDs, DB SG ID, and credentials.


Update main.tf inside terraform_modules/modules/database
Copy and paste this into your main.tf
Reference:

### What This Script Does:
- Creates an RDS Subnet Group using the private DB subnets
- Provisions a MySQL RDS instance with:
  - Multi-AZ for high availability
  - DB name terraform_db
  - Admin login admin / terraform_password
  - Backups enabled for 7 days
  - Deletion protection turned off
  - Secured within private subnets, no public access
  - Only accessible by the DB security group you attach


Update variables.tf inside terraform_modules/modules/database
Copy and paste this into your variables.tf
Reference:

### What This Script Does:
- Defines required inputs for subnet placement, DB access control, and login credentials
- Marks the DB password as sensitive to avoid showing it in CLI output

Update outputs.tf inside terraform_modules/modules/database
Copy and paste this into your outputs.tf
Reference:

### What This Script Does:
- Outputs the DNS endpoint of the RDS instance
- Outputs the logical DB name (e.g., terraform_db) — useful for apps or documentation

Update Root main.tf (in your project root folder)
Go to your root main.tf and add this block after your security module
Reference:
To test our configuration, these two commands
```bash
terraform init
```

```bash
terraform validate
```


### Step 7: Configure Bastion Host
We would the following:
Define Bastion Variables
- AMI ID (e.g., Ubuntu 20.04)
- Instance type (e.g., t2.micro)
- Public subnet ID (from VPC module)
- SSH key pair name
- Security group ID for SSH (from security module)

Create Bastion EC2 Resource
- Launch in public subnet
- Attach SSH SG
- Use key pair for access


Update main.tf inside terraform_modules/modules/bastion
Copy and paste this into your main.tf
Reference:

### What the Script Does
This script provisions a Bastion EC2 instance using the specified:
- AMI (Ubuntu 20.04)
- Instance type (t2.micro)
- Public subnet (for internet access)
- SSH key pair (terraform)
- Security Group that allows SSH from your IP

It tags the instance as "Bastion Host", and is used as a secure jump box to SSH into private instances in the VPC.

Update variables.tf inside terraform_modules/modules/bastion
Copy and paste this into your variables.tf
Reference:

### What the Script Does
This variables.tf file defines all the input variables required to provision the Bastion Host, including:
- The AMI ID for the instance
- The instance type (e.g., t2.micro)
- The SSH key pair name
- The public subnet ID where the instance will be deployed
- The security group ID to allow SSH access


Update outputs.tf inside terraform_modules/modules/bastion
Copy and paste this into your outputs.tf
Reference:

### What the Script Does
This outputs.tf file exposes useful information after the Bastion instance is created:
- bastion_instance_id helps identify and manage the instance.
- bastion_public_ip allows you to SSH into the Bastion Host.

Update Root main.tf (in your project root folder)
Go to your root main.tf and add this block after your security module
Reference:

### What the Script Does
This block calls the Bastion Host module and passes required values:
- AMI ID (Ubuntu 20.04)
- Instance type (t2.micro)
- Key pair (terraform)
- Public subnet from the VPC module
- SSH security group from the security module

This integrates Bastion Host into your overall infrastructure.

### Step 8: Output and Validation
Below are what we would be doing in this step
- Define outputs in the root outputs.tf file to display useful info after deployment — like ALB DNS, Bastion IP, VPC ID, etc.
- Run terraform apply to deploy and show those outputs.
- Validate your infrastructure by:
    - Verifying resources exist and are configured correctly in AWS Console.

Update Root outputs.tf (in your project root folder)
Go to your root outputs.tf and add this block after your security module
Reference:


### What the outputs.tf Script Does
This script collects and displays important values from your deployed infrastructure after Terraform finishes applying.
Specifically, it does the following:
- Extracts resource values from modules (like VPC, ALB, Bastion, DB, Compute).
- Makes them visible in your terminal after terraform apply so you can:
  - Copy your ALB DNS to test in a browser.
  - Use the Bastion IP to SSH into private instances.
  - Confirm VPC and subnet IDs were created as expected.
- Helps you validate the infrastructure without checking manually in the AWS Console.
- Acts as a reference if you need to pass values to other tools (e.g., Ansible, CI/CD).

Next, we would need to run these two commands
```bash
terraform plan
terraform apply
```
Explanation of these 2 Commands
```bash
terraform plan
```
This command:
- Previews what changes Terraform will make to your infrastructure.
- Does NOT make any real changes.
- Shows:
  - Resources to add, change, or destroy.
  - Any errors or missing variables in your code.
- Helps you review before applying.

Think of it as a "dry run".

```bash
terraform apply
```
This command:
- Executes the actual changes to match your code with real infrastructure.
- It:
  - Creates new resources.
  - Updates changed resources.
  - Deletes old ones.
- Prompts for confirmation unless you use -auto-approve.

Think of it as "make it real".
Run terraform plan
![image](https://github.com/user-attachments/assets/76a5197c-1c28-4ad9-994c-77b3a149b407)

Now, let’s run terraform apply
![image](https://github.com/user-attachments/assets/bef02f17-7662-4413-804f-09e0cbd74590)


Next, we need to validate our created infrastructure by verifying resources exist and are configured correctly in AWS Console.

VPC and Networking Resources
![image](https://github.com/user-attachments/assets/4d33604f-9bda-46be-a7aa-faad1c52227d)


Configure Security
![image](https://github.com/user-attachments/assets/10f04588-1b09-46ca-81a5-db0194d0871b)

Compute Resource and Bastion host
![image](https://github.com/user-attachments/assets/05d07f41-cd00-499c-b221-099fc7965255)

Load Balancer
![image](https://github.com/user-attachments/assets/58789914-a615-4958-a97e-90885af852ec)

Database Layer
![image](https://github.com/user-attachments/assets/0706cdbd-71fe-4d05-a351-7a405e1e1bea)


Everything created in only 6 minutes
To destroy everything built, just run the command 
```bash
terraform destroy
```

### Conclusion
This project successfully demonstrated how to build a scalable, secure, and highly available cloud infrastructure on AWS using Terraform as Infrastructure as Code (IaC). By modularizing the Terraform configuration, we created a reusable and well-organized setup that reflects real-world cloud architecture best practices.
From networking to compute, security, database, and load balancing, every component was provisioned automatically with a focus on availability, fault tolerance, and separation of concerns. The use of a custom VPC with public and private subnets across multiple Availability Zones ensured network resilience. Security was enforced using IAM roles and properly scoped security groups. The implementation of an Auto Scaling Group and an Application Load Balancer guarantees scalability and load distribution, while a Bastion Host ensures secure administrative access to private instances.
Additionally, the use of Multi-AZ RDS for the database layer provides robust, persistent storage with failover capabilities. With everything managed via Terraform, deployments are now consistent, repeatable, and easy to update or destroy.
This project serves as a solid foundation for hosting modern, production-grade applications in AWS and provides a real-world example of how DevOps and Infrastructure as Code can simplify cloud operations at scale.



