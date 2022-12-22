# GCP-project

### Email sender to multiple recipients
- Cloud Function: 
  - gets recipient's emails and content to send from Cloud Storage
  - subscribes to a Pub/Sub topic
- Pub/Sub topic to trigger the function
- Cloud Scheduler job that invokes the Pub/Sub trigger

![Untitled-2022-12-08-2136](https://user-images.githubusercontent.com/61588903/206571072-6cf91786-a57c-494e-8733-1d5b05cb036c.png)


### How to run in Google Cloud Console

Clone the project:
```
git clone https://github.com/KatiaAndrusiak/GCP-project.git
```
  
Change to the directory
```
  cd GCP-project
```

In the directory containing your main.tf file, run this command 
to add the necessary plugins and build the .terraform directory:
```
  terraform init
```
  
Apply the Terraform configuration:
```
  terraform apply
```

To remove all the resources defined in the configuration file
```
  terraform destroy
```
