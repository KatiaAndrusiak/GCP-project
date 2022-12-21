terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
    }
  }
}

provider "google" {
    version = ">= 4.34.0"
    project = "evident-hexagon-371520"
    region  = "us-central1"
    zone    = "us-central1-c"
}

resource "random_id" "bucket_prefix" {
  byte_length = 8
}

resource "google_service_account" "account" {
  account_id   = "satest"
  display_name = "email-sender-service-account-test"
}

resource "google_service_account" "trigger" {
  account_id   = "satriggertest"
  display_name = "email-service_account_trigger-test"
}

resource "google_project_iam_member" "invoking" {
  project = "evident-hexagon-371520"
  role    = "roles/run.invoker"
  member = "serviceAccount:${google_service_account.trigger.email}"
}

resource "google_project_iam_member" "storage" {
  project = "evident-hexagon-371520"
  role    = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.account.email}"
}

resource "google_pubsub_topic" "topic" {
  name = "emails-sender-test-topic"
}

resource "google_storage_bucket" "bucket" {
  name                        = "${random_id.bucket_prefix.hex}-gcf-source" 
  location                    = "US"
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "object" {
  name   = "function-source.zip"
  bucket = google_storage_bucket.bucket.name
  source = "function-source.zip" 
}

resource "google_storage_bucket" "content" {
  name                        = "emails-sender-data" 
  location                    = "US"
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "emails" {
  name   = "emails.txt"
  bucket = google_storage_bucket.content.name
  source = "emails.txt" 
}

resource "google_storage_bucket_object" "content" {
  name   = "content.txt"
  bucket = google_storage_bucket.content.name
  source = "content.txt" 
}

resource "google_cloudfunctions2_function" "function" {
  name        = "emails-sender-test"
  location    = "us-central1"
  description = "Function to send emails"

  build_config {
    runtime     = "python38"
    entry_point = "send_email_notification" # Set the entry point
    source {
      storage_source {
        bucket = google_storage_bucket.bucket.name
        object = google_storage_bucket_object.object.name
      }
    }
  }

  service_config {
    max_instance_count = 1000
    min_instance_count = 0
    available_memory   = "256M"
    timeout_seconds    = 60
    ingress_settings               = "ALLOW_ALL"
    service_account_email          = google_service_account.account.email
  }

  event_trigger {
    trigger_region = "us-central1"
    event_type     = "google.cloud.pubsub.topic.v1.messagePublished"
    pubsub_topic   = google_pubsub_topic.topic.id
    service_account_email = google_service_account.trigger.email
  }
}

resource "google_cloud_scheduler_job" "job" {
  name        = "emails-sender-scheduler-test"
  description = "emails-sender-scheduler job"
  schedule    = "0 9 * * *"
  time_zone   = "Europe/Warsaw"

  pubsub_target {
    # topic.id is the topic's full resource name.
    topic_name = google_pubsub_topic.topic.id
    data       = base64encode("Hello from scheduler!")
  }
}






