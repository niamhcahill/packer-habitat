/*
This is a test server definition for GCE+Terraform for GH-9564
*/

provider "google" {
  project = "${var.gcp_project}" // Your project ID here.
  region  = "${var.gcp_region}"
}

resource "google_compute_firewall" "gh-9564-firewall-externalssh" {
  name    = "gh-9564-firewall-externalssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22", "8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["externalssh"]
}

resource "google_compute_instance" "dev1" {
  name         = "gcp-rhel7-${var.dev_channel}"
  machine_type = "${var.gcp_machine_type}"
  zone         = "${var.gcp_zone}"
  tags         = ["externalssh"]

  boot_disk {
    initialize_params {
      image = "${var.gcp_image}"
    }
  }

  network_interface {
    network = "default"

    access_config {
      # Ephemeral
    }
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "${var.gcp_image_user}"
      timeout     = "500s"
      private_key = "${file("~/.ssh/google_compute_engine")}"
    }

    inline = [
      "sudo hostnamectl set-hostname gcp-rhel-${var.dev_channel}",
    ]
  }

  provisioner "habitat" {
    use_sudo     = true
    service_type = "systemd"

    service {
      name     = "${var.hab_origin}/chef-base"
      channel  = "${var.dev_channel}"
      strategy = "at-once"
    }

    service {
      name     = "${var.hab_origin}/np-mongodb"
      channel  = "${var.dev_channel}"
      strategy = "at-once"
    }

    service {
      name     = "${var.hab_origin}/national-parks"
      binds    = ["database:np-mongodb.default"]
      channel  = "${var.dev_channel}"
      strategy = "at-once"
    }

    connection {
      type        = "ssh"
      user        = "${var.gcp_image_user}"
      timeout     = "500s"
      private_key = "${file("~/.ssh/google_compute_engine")}"
    }
  }

  # Ensure firewall rule is provisioned before server, so that SSH doesn't fail.
  depends_on = ["google_compute_firewall.gh-9564-firewall-externalssh"]

  service_account {
    scopes = ["compute-ro"]
  }

  metadata {
    ssh-keys = "USERNAME:${file("~/.ssh/google_compute_engine.pub")}"
  }
}

resource "google_compute_instance" "prod1" {
  name         = "gcp-rhel7-prod1"
  machine_type = "${var.gcp_machine_type}"
  zone         = "${var.gcp_zone}"
  tags         = ["externalssh"]

  boot_disk {
    initialize_params {
      image = "${var.gcp_image}"
    }
  }

  network_interface {
    network = "default"

    access_config {
      # Ephemeral
    }
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "${var.gcp_image_user}"
      timeout     = "500s"
      private_key = "${file("~/.ssh/google_compute_engine")}"
    }

    inline = [
      "sudo hostnamectl set-hostname gcp-rhel-production",
    ]
  }

  provisioner "habitat" {
    use_sudo     = true
    service_type = "systemd"

    service {
      name     = "${var.hab_origin}/chef-base"
      channel  = "production"
      strategy = "at-once"
    }

    service {
      name     = "${var.hab_origin}/np-mongodb"
      channel  = "production"
      strategy = "at-once"
    }

    service {
      name     = "${var.hab_origin}/national-parks"
      binds    = ["database:np-mongodb.default"]
      channel  = "production"
      strategy = "at-once"
    }

    connection {
      type        = "ssh"
      user        = "${var.gcp_image_user}"
      timeout     = "500s"
      private_key = "${file("~/.ssh/google_compute_engine")}"
    }
  }

  # Ensure firewall rule is provisioned before server, so that SSH doesn't fail.
  depends_on = ["google_compute_firewall.gh-9564-firewall-externalssh"]

  service_account {
    scopes = ["compute-ro"]
  }

  metadata {
    ssh-keys = "USERNAME:${file("~/.ssh/google_compute_engine.pub")}"
  }
}
