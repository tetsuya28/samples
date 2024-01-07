resource "google_iam_workload_identity_pool" "github_actions" {
  provider                  = google-beta
  project                   = var.project
  workload_identity_pool_id = "github-actions"
  display_name              = "github-actions"
  description               = "Workload Identity Pool for GitHub Actions"
}

resource "google_iam_workload_identity_pool_provider" "github_actions" {
  provider                           = google-beta
  project                            = var.project
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_actions.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-actions"
  display_name                       = "github-actions"
  description                        = "Workload Identity Provider for GitHub Actions"
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
    "attribute.org"        = "assertion.repository_owner"
  }
  attribute_condition = var.attribute_condition
}

resource "google_service_account" "github_actions" {
  account_id   = "github-actions"
  display_name = "github-actions"
}

resource "google_service_account_iam_member" "github_actions" {
  for_each = toset([
    # GitHub Actions
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_actions.name}/*",
  ])
  service_account_id = google_service_account.github_actions.id
  role               = "roles/iam.workloadIdentityUser"
  member             = each.value
}

resource "google_project_iam_member" "github_actions" {
  project = var.project
  member  = "serviceAccount:${google_service_account.github_actions.email}"
  for_each = toset(var.github_actions_roles)
  role = each.value
}
