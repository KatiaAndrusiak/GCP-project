# GCP-project

### Email sender to multiple recipients
- Cloud Function: 
  - gets recipient's emails and content to send from Cloud Storage
  - subscribes to a Pub/Sub topic
- Pub/Sub topic to trigger the function
- Cloud Scheduler job that invokes the Pub/Sub trigger

![Untitled-2022-12-08-2136](https://user-images.githubusercontent.com/61588903/206571072-6cf91786-a57c-494e-8733-1d5b05cb036c.png)
