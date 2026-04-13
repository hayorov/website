+++
title = "Part 1 | IDPs: What Comes to Your Mind?"
date = "2024-06-13"
description = "Internal Developer Platforms vs Infrastructure Developer Platforms: differences, similarities, and roles in modern platform engineering."
tags = ["platform-engineering", "devops", "idp"]
+++

> 🏗️ Topic: Internal Developer Platforms vs Infrastructure Developer Platforms  
> 🎯 Goal: Clarify what "IDP" actually means in platform engineering  
> 📍 Part 1 of the IDP series

"IDP" — most people think Identity Provider. In platform engineering, it means something else entirely. There are two flavors: **Internal Developer Platforms** and **Infrastructure Developer Platforms**. They solve different problems, serve different users, and get confused constantly.

This post breaks down both.

---

## 🔀 Two Platforms, One Acronym

Two distinct platforms exist in modern engineering orgs. They complement each other, but they are not the same thing. Understanding the difference matters if you're building or buying either one.

## 🔑 Self-Service Is the Common Thread

Both platform types share one core principle: **self-service**. Developers and ops teams should access resources without filing tickets or waiting on another team. Self-service removes bottlenecks, speeds up delivery, and is the foundational capability that makes either platform worth building.

### Internal Developer Platform (IDP)

The Internal Developer Platform sits at the center of the development workflow. It gives developers what they need to build, test, and deploy — without depending on ops for every request.

- **Self-Service Capabilities**: Developers provision resources independently. No ticket queues.
- **Unified Interfaces**: One portal for project management, docs, and collaboration.
- **Automation**: CI/CD pipelines, automated testing, deployment — all integrated.
- **Observability and Monitoring**: Logging, alerting, and performance tracking built in.

### Infrastructure Developer Platform

The Infrastructure Developer Platform is the foundation layer. It manages the compute, storage, and networking that applications run on.

- **Infrastructure Provisioning**: Create, manage, and scale VMs, containers, and storage.
- **Configuration Management**: Define infrastructure state with Terraform, Ansible, or Kubernetes.
- **Resource Allocation and Optimization**: Scale up or down based on demand. No waste.
- **Security and Compliance**: Enforce security standards and regulatory requirements at the infra level.

---

## 📊 A Face-to-Face Comparison

| Feature                       | Internal Developer Platform                                | Infrastructure Developer Platform                         |
|-------------------------------|------------------------------------------------------------|-----------------------------------------------------------|
| **Primary Focus**             | Enhances the development process, providing developers with tools and environments to streamline workflows. | Manages and optimizes the underlying infrastructure, ensuring resources are available and efficiently used. |
| **User Interface**            | User-friendly portals and dashboards designed for developers to easily manage their projects and resources. | More technical interfaces tailored to cloud engineers and operations teams responsible for managing infrastructure. |
| **Automation and Self-Service**| Emphasizes self-service capabilities and the automation of development workflows, enabling developers to operate independently. | Focuses on automating infrastructure provisioning and management. |
| **End Users**                 | Designed for software developers, aiming to make their development process more efficient and enjoyable. | Serves both developers and operations teams, providing tools to manage and optimize infrastructure. |

## 🧭 Platforms to Explore

Here are some notable platforms in the space:

- **[Backstage](https://backstage.io/)**: Originated from Spotify, it's an open-source platform for building developer portals, focusing on improving the developer experience.
- **[Port](https://getport.io/)**: A platform designed to streamline infrastructure and operations, offering tools for managing applications and resources.
- **[Spacelift](https://spacelift.io/)**: A CI/CD platform for infrastructure as code, designed to enhance collaboration and automation in infrastructure management.
- **[Platform.sh](https://platform.sh/)**: A platform-as-a-service that offers tools for developing, deploying, and scaling applications, with a focus on ease of use and integration.
- **[HashiCorp Waypoint](https://www.waypointproject.io/)**: A platform for building, deploying, and releasing applications across any platform, with a focus on simplifying the deployment process.

## 🏁 Conclusion

Both platforms play crucial but different roles. The Internal Developer Platform makes it easier and faster to build and ship applications. The Infrastructure Developer Platform ensures the underlying infra is robust, scalable, and secure. They're complementary — not interchangeable.

Next time, I'll dive deeper into IDP autonomy in the enterprise and explain why I've been building IDPs — and why it's a hard business.
