# terraform-infra-automation-with-jenkins

This repository contains Terraform scripts and Jenkins pipeline configuration to **automate the infrastructure provisioning** of a Flask web application backed by a MySQL database on AWS.

## 🚀 Project Overview

This project sets up the complete cloud infrastructure required to run a Flask-MySQL web application, using:
- **Terraform** for Infrastructure as Code (IaC)
- **Jenkins** for CI/CD automation

The setup is divided into **Two repositories**:

### 📁 Repositories Used

1. **[jenkins-setup-terraform](https://github.com/Sowmyadevi2005/jenkins-setup-terraform.git)**  
   Provisions infrastructure for Jenkins using Terraform. It creates:
   - VPC with 1 Public Subnet
   - EC2 instance with Jenkins and Terraform pre-installed
   - Application Load Balancer (ALB)

2. **[flask-mysql-webapp](https://github.com/Sowmyadevi2005/flask-mysql-webapp.git)**  
   Contains the source code for the Flask + MySQL web application. This repo will be **cloned** during the EC2 user data script .

---

## 🧰 Tech Stack

- **Infrastructure Provisioning:** Terraform
- **Automation:** Jenkins (Pipeline as Code)
- **Cloud Platform:** AWS (EC2, RDS, ALB, VPC, etc.)
- **Application:** Flask + MySQL

---

## 📁 Repo Structure

```
flask-mysql-terraform-infra/
├── infra/                      # Terraform modules
│   ├── certificate-manager/
│   ├── ec2/
│   ├── hosted_zone/
│   ├── load-balancer/
│   ├── networking/
│   ├── rds/
│   ├── security-groups/
│   ├── backend.tf
│   ├── main.tf
│   ├── provider.tf
│   ├── terraform.tfvars
│   ├── variable.tf
└── Jenkinsfile.txt             # Jenkins pipeline to automate infra provisioning
```

---

## ⚙️ Jenkins CI/CD Workflow

1. **Trigger:** Jenkins pipeline is triggered manually or via Git webhook.
2. **Terraform Init & Plan:** Initializes the configuration and creates the plan.
3. **Terraform Apply:** Applies infrastructure changes to AWS.
4. **App Deployment:** Clones the Flask app repo and deploys it to the EC2 instance.

---

## 📝 How to Use

1. Clone this repo and `jenkins-setup-terraform` repo.
2. Use the Jenkins repo to launch your Jenkins EC2 instance.
3. Configure Jenkins credentials and install Terraform plugin.
4. Run the Jenkins pipeline using this repo.

---

## 🛡️ Security Best Practices

- Use AWS Secrets Manager or Jenkins credentials store for secrets.
- Avoid hardcoding sensitive data.
- Use remote backend for Terraform state (e.g., S3 + DynamoDB).

---

## 📄 License

This project is licensed under the MIT License.

---

## 🙌 Acknowledgements

- [Terraform](https://www.terraform.io/)
- [Jenkins](https://www.jenkins.io/)
- [AWS](https://aws.amazon.com/)
- [Flask](https://flask.palletsprojects.com/)

