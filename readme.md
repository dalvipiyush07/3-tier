# End-to-End 3-Tier Infrastructure Automation using Terraform, Ansible & Jenkins

## Overview
This project demonstrates a complete end-to-end DevOps automation workflow using **Terraform**, **Ansible**, and **Jenkins** on **AWS EC2**.  
The goal of the project is to automate infrastructure provisioning, server configuration, and application deployment using industry-standard DevOps tools.

The entire process is version-controlled and repeatable, following real-world DevOps best practices.

![](./img/overview.png)
---

## Step 1: Infrastructure Provisioning with Terraform
Terraform was used to provision a **3-tier AWS infrastructure** in a fully automated way.

### Key Details:
- Infrastructure created using Infrastructure as Code (IaC)
- AWS resources provisioned:
  - VPC and networking
  - Web Server EC2 instance
  - App Server EC2 instance
  - Security Groups for controlled access
- Terraform ensures consistency, scalability, and easy re-creation of infrastructure
## Terrform

![](./img/terraform.png)

## Ec2

![](./img/ec2.png)

## VPC 

![](./img/vpc.png)

## RDS 

![](./img/rds.png)

## S3

![](./img/s3.png)


## Step 2: Configuration Management with Ansible
Once infrastructure was ready, Ansible was used to configure the servers from a dedicated Ansible control node.

### Ansible Files:
- `web.yml` – Installs and configures Nginx on the Web Server
- `app.yml` – Installs Nginx, PHP, PHP-FPM, and MariaDB on the App Server
- `inventory.ini` – Defines Web and App server hosts

### Key Benefits:
- Agentless configuration
- Idempotent deployments
- Centralized server management

## web.yml

![](./img/web-vs-yml.png)

## app.yml 

![](./img/app-vs-yml.png)

---

## Step 3: Jenkins Pipeline Creation
A Jenkins pipeline was created to automate Ansible execution.

### Jenkins Responsibilities:
- SSH into the Ansible control node
- Pull the latest code from GitHub
- Copy Ansible playbooks and inventory to `/etc/ansible/playbook`
- Perform syntax validation
- Execute Ansible playbooks on target servers

## jenkins

![](./img/jrnkins-vs.png)
---

## Step 4: Push Code to GitHub
All project files were pushed to GitHub, making it the **single source of truth**.

### Repository Includes:
- Terraform configuration files
- Ansible playbooks and inventory
- Website source files
- Jenkinsfile
- Project documentation

GitHub enables version control, collaboration, and CI/CD integration.

## GitHub

![](./img/github.png)
---

## Step 5: Jenkins Pipeline Execution
The Jenkins pipeline is triggered manually or automatically.

### Pipeline Flow:
- Jenkins connects to Ansible server via SSH
- Ansible server pulls the latest GitHub code
- Playbooks are validated using syntax check
- Configurations are deployed to Web and App servers

## output

![](./img/output.png)

---

## Step 6: Deployment Success
After successful execution:
- Nginx is running on the Web Server
- Application services are running on the App Server
- Website and backend API are deployed successfully
- Jenkins pipeline completes with **SUCCESS** status

## Success

![](./img/success.png)
---

## Repository Structure
```
3-tier/
├── ansible/
│   ├── inventory.ini
│   ├── web.yml
│   └── app.yml
├── website/
│   ├── index.html
│   └── api.php
├── Jenkinsfile
└── README.md
```

---

## Key Learnings
- Terraform simplifies infrastructure provisioning
- Ansible ensures consistent server configuration
- Jenkins enables reliable CI/CD automation
- SSH key management is critical for automation
- Amazon Linux 2023 uses MariaDB instead of MySQL
- GitHub acts as a single source of truth

---

## Conclusion
This project demonstrates a real-world DevOps workflow where infrastructure, configuration, and deployment are fully automated.  
The combination of Terraform, Ansible, and Jenkins results in a scalable, reliable, and production-ready deployment process.

---

## Author
**Piyush Dalvi**  
GitHub: https://github.com/dalvipiyush07  

GitHub: https://www.linkedin.com/in/piyush-dalvi-5b1499382?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app

Medium: https://medium.com/@piyushdalvi65
---

## Acknowledgement
Completed under the guidance of respected mentors.
