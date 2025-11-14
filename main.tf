provider "google" {
  project     = "winter-monolith-477705-m8"
  region      = "us-central1"
  zone        = "us-central1-b"

  credentials = file(var.credentials_file)
}

variable "credentials_file" {}

resource "google_compute_instance" "java_vm" {
  name         = "java-vm"
  machine_type = "e2-small"
  zone         = "us-central1-b"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"

    access_config {} # for public IP
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y docker.io
    systemctl start docker
    systemctl enable docker
    docker --version
  EOF
}
