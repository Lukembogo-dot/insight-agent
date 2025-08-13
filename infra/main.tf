resource "google_project_service" "enabled_apis" {
  for_each = toset([
    "run.googleapis.com",
    "artifactregistry.googleapis.com",
    "cloudbuild.googleapis.com"
  ])
  service = each.key
}

resource "google_artifact_registry_repository" "repo" {
  location       = var.region
  repository_id  = "insight-agent-repo"
  format         = "DOCKER"
}

resource "google_service_account" "cloud_run_sa" {
  account_id   = "cloud-run-sa"
  display_name = "Cloud Run Service Account"
}

resource "google_cloud_run_service" "service" {
  name     = "insight-agent"
  location = var.region

  template {
    spec {
      service_account_name = google_service_account.cloud_run_sa.email
      containers {
        image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.repo.repository_id}/insight-agent:${var.image_tag}"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  ingress = "internal"
}

resource "google_project_iam_member" "cloud_run_invoker" {
  project = var.project_id
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}