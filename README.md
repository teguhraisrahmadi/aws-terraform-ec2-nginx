# Amazon Web Sevices

## Building NGINX Web Server With Terraform on AWS

•	Create IAM User

1. For security and audit reason, please avoid using root account. Just create Administrator user for daily task of sysadmin. I have already created Administrator user. Please note, allow programmatic access. Terraform can utilize this permmison to access AWS programmatically.
<br> ![Capture](Material/1.png) <br>
<br> ![Capture](Material/2.png) <br>

2. Attach this policy for your Administrator user.
<br> ![Capture](Material/3.png) <br>

3. After you create the user. You can get the access key id and secret id from Administrator user. You can add this one for login and access AWS programmatic from local PC. Don’t forget to create key pair for secure access to your ec2 instance. You can create this key pair at ec2 menu, then go to key pair.
<br> ![Capture](Material/4.png) <br>

4. And then click create key pair. As you can see, I already have created the key pair.
<br> ![Capture](Material/5.png) <br>

5. You can follow this option to create the key pair.
<br> ![Capture](Material/6.png) <br>

•	Using Terraform for Provision

6. Terraform is an infrastructure as code tool that lets you build, change, and version cloud and on-prem resources safely and efficiently (developer hashicorp). So we use this tools to provision amazon ec2 Centos 7 instances. Make sure you already install this tools in your local pc. For installation you can use this guide,
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
* Step 1,
Configure AWS CLI and provide the following information when prompted. This file used for authentication to access AWS programmatic with your credential IAM user. You can create this file with name “terraform.tfvars” in your local pc. Fill the aws_access_key and aws_secret_key with your credential. You can see this key from file after you created IAM user. 
Fill the key_name with your key pair name and call the file at private_key_patch.
<br> ![Capture](Material/7.png) <br>
* Step 2,
Create module.tf file for several configurations. We will configure variable, provider, data, security group resource and public dns output. Just follow this option to fill the file at modul.tf.
- Variable,
We declare what we create at terraform.tfvars and call the region what we want to use.
<br> ![Capture](Material/8.png) <br>
- Provider,
In this case, we user AWS to provison our ec2 instance.
<br> ![Capture](Material/9.png) <br>
- Data,
For specific request, I use centos 7 for guest OS to provision the ec2 instance.
<br> ![Capture](Material/10.png) <br>
- Security group,
We allow for specific protocol to access the ec2 like ssh, http and https port.
<br> ![Capture](Material/11.png) <br>
- Resource,
This function running to create the ec2 instance and security group what we created before based on configuration file.
<br> ![Capture](Material/12.png) <br>
- Output,
Last, we will display the public dns from ec2 instance. It can use for web server access. for this case, later we will use the nginx webserver after this configuration was launched.
<br> ![Capture](Material/13.png) <br>
* Step 3,
In this step, we will run the terraform file. Go to your terminal.
<br> ![Capture](Material/14.png) <br>
You can see, we already have the file in local pc. Now run this command to provison,
“terraform init”
<br> ![Capture](Material/15.png) <br>
“terraform validate”
<br> ![Capture](Material/16.png) <br>
“terraform plan”
<br> ![Capture](Material/17.png) <br>
“terraform apply”
<br> ![Capture](Material/18.png) <br>
Then write “yes” and click
<br> ![Capture](Material/19.png) <br>
Complete, and save the public dns.
“ec2-54-236-20-199.compute-1.amazonaws.com” -> we use this later for nginx access.
<br> ![Capture](Material/20.png) <br>

•	Check the Instance.

7. Go to the ec2 instance menu. You can see the instance was running.
<br> ![Capture](Material/21.png) <br>

•	Install the NGINX webserver.

8. Now we will install the nginx in the ec2 instance was we created. I use ssh connection login to the instance.
<br> ![Capture](Material/22.png) <br>
9. After login, we create bash script on centos to automate the installation.
<br> ![Capture](Material/23.png) <br>
10. Create “webserver.sh” file in the centos.
<br> ![Capture](Material/24.png) <br>
11. Then open it with vi (you can use nano/vim, etc) to fill the command.
<br> ![Capture](Material/25.png) <br>
12. Then fill this command, then save.
<br> ![Capture](Material/26.png) <br>
13. Re-checked the file.
<br> ![Capture](Material/27.png) <br>
14. Now edit the file gonna be execute.
<br> ![Capture](Material/28.png) <br>
15. Now run the script. Wait until finished.
<br> ![Capture](Material/29.png) <br>
16. The script was done. 
<br> ![Capture](Material/30.png) <br>
17. Now, we checked the nginx. As you can see, it was running.
<br> ![Capture](Material/31.png) <br>
18. Then, we test to access nginx webserver with public dns.
“ec2-54-236-20-199.compute-1.amazonaws.com” 
<br> ![Capture](Material/32.png) <br>
19. Great, it was successfully. But look at that, this url have not secure access, because we not yet set the ssl certificate to this url. 
Next, let’s go set the certificate for this access. go to the aws certificate manager. Then click request certificate.
<br> ![Capture](Material/33.png) <br>
20. Click next,
<br> ![Capture](Material/34.png) <br>
21. Follow this option, 
<br> ![Capture](Material/35.png) <br>
22. then click request.
<br> ![Capture](Material/36.png) <br>
23. You must have wait for several minute, because it need approval from AWS.
<br> ![Capture](Material/37.png) <br>
24. “I don’t completely show you when the certificate was done. Because it might take a long time, so you must wait for this, then I just show to you how to configure the ssl/tls certification for your webserver”.
Now we go to Route 53 to set the record. 
<br> ![Capture](Material/38.png) <br>
25. Then click create hosted zone.
<br> ![Capture](Material/39.png) <br>
26. Zone was created.
<br> ![Capture](Material/40.png) <br>
<br> ![Capture](Material/41.png) <br>
27. Now we must create the distribution on cloudfront service. Go to cloudfront and create.
<br> ![Capture](Material/42.png) <br>
28. Follow this option to create the setting. Just fill below the picture.
<br> ![Capture](Material/43.png) <br>
29. Fill the certificate.
<br> ![Capture](Material/44.png) <br>
30. Then click create distribution.
<br> ![Capture](Material/45.png) <br>
31. Edit the distribution.
<br> ![Capture](Material/46.png) <br>
<br> ![Capture](Material/47.png) <br>
32. Then add your alternative domain. Click save changes.
<br> ![Capture](Material/48.png) <br>
33. Go back to route 53, then create a record.
Choose the route traffic with cloudfront. Then click create record.
<br> ![Capture](Material/49.png) <br>
34. After a minute, just refresh the browser with “cert-manager-centos7-88.com” domain name.
Done. Thanks
