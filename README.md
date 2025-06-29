# RoboShop Ansible Configuration Management

## 📋 Table of Contents
- [Overview](#overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Quick Start](#quick-start)
- [Ansible Playbooks](#ansible-playbooks)
- [Inventory Management](#inventory-management)
- [Variables and Configuration](#variables-and-configuration)
- [Deployment Strategies](#deployment-strategies)
- [Monitoring and Troubleshooting](#monitoring-and-troubleshooting)
- [Best Practices](#best-practices)
- [Contributing](#contributing)

## 🎯 Overview

This repository contains Ansible playbooks and configuration management scripts for deploying and managing the **RoboShop** e-commerce application. RoboShop is a microservices-based application consisting of multiple services that work together to provide a complete e-commerce solution.

### 🚀 Key Features
- **Infrastructure as Code**: Complete infrastructure provisioning using Ansible
- **Multi-Environment Support**: Development, staging, and production configurations
- **Service Orchestration**: Automated deployment of all microservices
- **Database Management**: Automated setup of MongoDB, MySQL, Redis, and RabbitMQ
- **Load Balancing**: Nginx reverse proxy configuration
- **Monitoring Ready**: Built-in health checks and logging

## 🏗️ Architecture

### 📊 System Architecture
```
┌─────────────────────────────────────────────────────────────────┐
│                        RoboShop E-Commerce                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐         │
│  │    User     │    │    Cart     │    │  Shipping   │         │
│  │  Service    │◄──►│  Service    │◄──►│  Service    │         │
│  │ (Node.js)   │    │ (Node.js)   │    │  (Java)     │         │
│  └─────────────┘    └─────────────┘    └─────────────┘         │
│         │                    │                    │             │
│         ▼                    ▼                    ▼             │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐         │
│  │ Catalogue   │    │   Redis     │    │   MySQL     │         │
│  │  Service    │    │  (Cache)    │    │  (Orders)   │         │
│  │ (Node.js)   │    │             │    │             │         │
│  └─────────────┘    └─────────────┘    └─────────────┘         │
│         │                    │                    │             │
│         ▼                    ▼                    ▼             │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐         │
│  │  MongoDB    │    │  RabbitMQ   │    │  Dispatch   │         │
│  │ (Products & │    │ (Message    │    │  Service    │         │
│  │   Users)    │    │  Queue)     │    │  (Go)       │         │
│  └─────────────┘    └─────────────┘    └─────────────┘         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 🔧 Services Overview

| Service | Technology | Purpose | Port | Database |
|---------|------------|---------|------|----------|
| **Frontend** | Nginx + Static Files | User interface | 80 | - |
| **User Service** | Node.js | User management & authentication | 8080 | MongoDB |
| **Catalogue Service** | Node.js | Product catalog management | 8080 | MongoDB |
| **Cart Service** | Node.js | Shopping cart operations | 8080 | Redis |
| **Shipping Service** | Java (Spring Boot) | Order processing & shipping | 8080 | MySQL |
| **Payment Service** | Python (Flask) | Payment processing | 8080 | - |
| **Dispatch Service** | Go | Order dispatch notifications | 8080 | - |

### 🗄️ Infrastructure Services

| Service | Purpose | Port | Configuration |
|---------|---------|------|---------------|
| **Nginx** | Reverse proxy & load balancer | 80 | `nginx.conf` |
| **Redis** | Caching & session storage | 6379 | `redis.conf` |
| **MongoDB** | Document database | 27017 | `mongod.conf` |
| **MySQL** | Relational database | 3306 | `my.cnf` |
| **RabbitMQ** | Message queue | 5672 | `rabbitmq.conf` |

## 📋 Prerequisites

### 🖥️ System Requirements
- **Operating System**: CentOS/RHEL 9 or compatible
- **CPU**: 2+ cores
- **RAM**: 4GB minimum, 8GB recommended
- **Storage**: 20GB minimum
- **Network**: Stable internet connection

### 🛠️ Software Requirements
- **Ansible**: 2.12 or higher
- **Python**: 3.8 or higher
- **SSH**: Enabled on target servers
- **Sudo**: Root or sudo access on target servers

### 🔑 Access Requirements
- SSH key-based authentication
- Sudo privileges on target servers
- Internet access for package downloads

## 📁 Project Structure

```
roboshop-ansible/
├── README.md                 # This file
├── ansible.cfg              # Ansible configuration
├── inventory/               # Inventory files
│   ├── hosts               # Main inventory file
│   ├── group_vars/         # Group variables
│   │   ├── all.yml         # Global variables
│   │   ├── webservers.yml  # Web server variables
│   │   └── databases.yml   # Database variables
│   └── host_vars/          # Host-specific variables
├── playbooks/              # Ansible playbooks
│   ├── site.yml           # Main playbook
│   ├── infrastructure.yml # Infrastructure setup
│   ├── applications.yml   # Application deployment
│   └── monitoring.yml     # Monitoring setup
├── roles/                  # Ansible roles
│   ├── common/            # Common tasks
│   ├── nginx/             # Nginx configuration
│   ├── mongodb/           # MongoDB setup
│   ├── mysql/             # MySQL setup
│   ├── redis/             # Redis setup
│   ├── rabbitmq/          # RabbitMQ setup
│   ├── nodejs/            # Node.js applications
│   ├── java/              # Java applications
│   ├── python/            # Python applications
│   └── go/                # Go applications
├── templates/              # Configuration templates
├── files/                  # Static files
└── vars/                   # Variable files
```

## 🚀 Quick Start

### 1. Clone and Setup
```bash
# Clone the repository
git clone <repository-url>
cd roboshop-ansible

# Install Ansible (if not already installed)
sudo dnf install ansible -y  # CentOS/RHEL
# or
sudo apt install ansible -y  # Ubuntu/Debian

# Verify Ansible installation
ansible --version
```

### 2. Configure Inventory
```bash
# Edit the inventory file
vim inventory/hosts

# Add your target servers
[webservers]
web1 ansible_host=192.168.1.10 ansible_user=root
web2 ansible_host=192.168.1.11 ansible_user=root

[databases]
db1 ansible_host=192.168.1.20 ansible_user=root

[all:vars]
ansible_python_interpreter=/usr/bin/python3
```

### 3. Test Connection
```bash
# Test SSH connectivity
ansible all -m ping

# Check system facts
ansible all -m setup
```

### 4. Deploy RoboShop
```bash
# Deploy complete infrastructure and applications
ansible-playbook -i inventory/hosts playbooks/site.yml

# Or deploy step by step
ansible-playbook -i inventory/hosts playbooks/infrastructure.yml
ansible-playbook -i inventory/hosts playbooks/applications.yml
```

## 📜 Ansible Playbooks

### 🏗️ Main Playbook (`site.yml`)
The main playbook that orchestrates the entire deployment:

```yaml
---
- name: Deploy RoboShop Complete Stack
  hosts: all
  become: yes
  
  pre_tasks:
    - name: Update package cache
      dnf:
        update_cache: yes
      when: ansible_os_family == "RedHat"
  
  roles:
    - common
    - nginx
    - mongodb
    - mysql
    - redis
    - rabbitmq
    - nodejs
    - java
    - python
    - go
```

### 🗄️ Infrastructure Playbook (`infrastructure.yml`)
Sets up all infrastructure components:

```yaml
---
- name: Setup Infrastructure Services
  hosts: all
  become: yes
  
  roles:
    - common
    - nginx
    - mongodb
    - mysql
    - redis
    - rabbitmq
```

### 🎯 Applications Playbook (`applications.yml`)
Deploys all application services:

```yaml
---
- name: Deploy RoboShop Applications
  hosts: webservers
  become: yes
  
  roles:
    - nodejs
    - java
    - python
    - go
```

## 📊 Inventory Management

### 🔧 Static Inventory (`inventory/hosts`)
```ini
[webservers]
web1 ansible_host=192.168.1.10 ansible_user=root
web2 ansible_host=192.168.1.11 ansible_user=root

[databases]
db1 ansible_host=192.168.1.20 ansible_user=root

[loadbalancers]
lb1 ansible_host=192.168.1.30 ansible_user=root

[all:vars]
ansible_python_interpreter=/usr/bin/python3
ansible_ssh_private_key_file=~/.ssh/id_rsa
```

### 🌍 Environment-Specific Inventories
```bash
# Development environment
ansible-playbook -i inventory/dev/hosts playbooks/site.yml

# Staging environment
ansible-playbook -i inventory/staging/hosts playbooks/site.yml

# Production environment
ansible-playbook -i inventory/prod/hosts playbooks/site.yml
```

## 🔧 Variables and Configuration

### 🌐 Global Variables (`inventory/group_vars/all.yml`)
```yaml
---
# Application settings
app_name: roboshop
app_version: v3
app_user: roboshop
app_home: /app

# Database settings
mongodb_host: mongodb-dev.shr-eng.com
mysql_host: mysql-dev.shr-eng.com
redis_host: redis-dev.shr-eng.com
rabbitmq_host: rabbitmq-dev.shr-eng.com

# Service ports
nginx_port: 80
app_port: 8080
mongodb_port: 27017
mysql_port: 3306
redis_port: 6379
rabbitmq_port: 5672

# Credentials (use vault in production)
mysql_root_password: "RoboShop@1"
rabbitmq_user: roboshop
rabbitmq_password: roboshop123
```

### 🎯 Service-Specific Variables
```yaml
# inventory/group_vars/webservers.yml
---
# Node.js settings
nodejs_version: "20"
nodejs_packages:
  - nodejs
  - npm

# Java settings
java_version: "11"
maven_version: "3.8"

# Python settings
python_version: "3.9"
python_packages:
  - python3
  - python3-pip
  - python3-devel
  - gcc
```

## 🚀 Deployment Strategies

### 🔄 Rolling Deployment
```bash
# Deploy with rolling updates
ansible-playbook -i inventory/hosts playbooks/applications.yml \
  --limit=webservers[0] \
  --extra-vars="deployment_strategy=rolling"
```

### 🔒 Blue-Green Deployment
```bash
# Deploy to blue environment
ansible-playbook -i inventory/hosts playbooks/applications.yml \
  --limit=blue_servers

# Switch traffic to blue
ansible-playbook -i inventory/hosts playbooks/switch_traffic.yml \
  --extra-vars="active_environment=blue"
```

### 🔍 Canary Deployment
```bash
# Deploy to canary server
ansible-playbook -i inventory/hosts playbooks/applications.yml \
  --limit=canary_server

# Monitor and gradually roll out
ansible-playbook -i inventory/hosts playbooks/rollout.yml \
  --extra-vars="rollout_percentage=25"
```

## 📊 Monitoring and Troubleshooting

### 🔍 Health Checks
```bash
# Check service status
ansible webservers -m shell -a "systemctl status nginx"
ansible webservers -m shell -a "systemctl status user"
ansible webservers -m shell -a "systemctl status catalogue"

# Check application health
ansible webservers -m uri -a "url=http://localhost:8080/health"
```

### 📝 Log Monitoring
```bash
# Check application logs
ansible webservers -m shell -a "journalctl -u user -f"
ansible webservers -m shell -a "journalctl -u catalogue -f"

# Check nginx logs
ansible webservers -m shell -a "tail -f /var/log/nginx/access.log"
```

### 🛠️ Common Troubleshooting

#### Service Not Starting
```bash
# Check service configuration
ansible webservers -m shell -a "systemctl daemon-reload"
ansible webservers -m shell -a "systemctl status user"

# Check logs for errors
ansible webservers -m shell -a "journalctl -u user --no-pager -l"
```

#### Database Connection Issues
```bash
# Test MongoDB connection
ansible webservers -m shell -a "mongosh --host {{ mongodb_host }}"

# Test MySQL connection
ansible webservers -m shell -a "mysql -h {{ mysql_host }} -uroot -p{{ mysql_root_password }}"
```

#### Port Conflicts
```bash
# Check port usage
ansible webservers -m shell -a "netstat -tulpn | grep :8080"

# Kill conflicting processes
ansible webservers -m shell -a "fuser -k 8080/tcp"
```

## 🎯 Best Practices

### 🔐 Security
- Use Ansible Vault for sensitive data
- Implement least privilege access
- Regular security updates
- Network segmentation

### 📈 Performance
- Use connection pooling
- Implement caching strategies
- Monitor resource usage
- Optimize database queries

### 🔄 Maintenance
- Regular backups
- Automated testing
- Version control
- Documentation updates

### 🚀 Scalability
- Horizontal scaling
- Load balancing
- Database sharding
- Microservices architecture

## 🤝 Contributing

### 📝 Development Workflow
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

### 🧪 Testing
```bash
# Syntax check
ansible-playbook --syntax-check playbooks/site.yml

# Dry run
ansible-playbook --check playbooks/site.yml

# Run tests
ansible-playbook playbooks/test.yml
```

### 📚 Documentation
- Update README.md for new features
- Document configuration changes
- Maintain changelog
- Add inline comments

## 📞 Support

### 🆘 Getting Help
- Check the troubleshooting section
- Review logs and error messages
- Search existing issues
- Create a new issue with details

### 📧 Contact
- **Issues**: GitHub Issues
- **Documentation**: README.md
- **Community**: GitHub Discussions

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- RoboShop application architecture
- Ansible community
- Open source contributors
