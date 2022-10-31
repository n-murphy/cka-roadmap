# WEEK 6

## Scaling, updating and working with running applications in Kubernetes

### This is week's content is within the workloads & scheduling section of the exam curriculum
- [Exam Curriculum](https://github.com/cncf/curriculum/blob/master/CKA_Curriculum_v1.24.pdf)


We'll focus on running applications and how to manage them. This includes upgrading applications with zero downtime, and scaling applications to create high availability.

### RESOURCES

- [VIDEO: Rolling Updates](https://youtu.be/xRifmrap7S8)
- [VIDEO: Rollout and Rollbacks](https://kodekloud.com/topic/rolling-updates-and-rollbacks/)
- [LAB: Rolling Updates](https://kodekloud.com/topic/solution-rolling-update/)
- [LAB: Lightning Lab](https://kodekloud.com/topic/lightning-lab-introduction/)
- [TUTORIAL: Scaling an App](https://kubernetes.io/docs/tutorials/kubernetes-basics/scale/scale-interactive/)
- [VIDEO: Using Set Image](https://youtu.be/RV8Avr7KEi8)

### CHALLENGES

> Put all files in WEEK6 Directory

1. Create a deployment named “apache” that uses the image httpd:2.4.54 and contains three pod replicas. 
2. After the deployment has been created, scale the deployment to five replicas
3. Change the image for the "apache" deployment to httpd:alpine
4. Look at the rollout history, then go back to the previous rollout (roll back) 
