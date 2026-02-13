terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
}

provider "oci" {
  region = "sa-saopaulo-1"
}

variable "compartment_id" {
  type    = string
  default = "ocid1.tenancy.oc1..aaaaaaaavc7ra2cqnq423m473usz7cbfqmp2yalofjl2xsuur7rnl3tu7yfq"
}

resource "oci_core_vcn" "foundry_vcn" {
  cidr_blocks    = ["10.0.0.0/24"]
  compartment_id = var.compartment_id
}

resource "oci_core_subnet" "public-subnet-foundry" {
  compartment_id    = var.compartment_id
  vcn_id            = oci_core_vcn.foundry_vcn.id
  security_list_ids = ["foundry_security_list"]
}

resource "oci_core_security_list" "foundry_security_list" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.foundry_vcn.id

  ingress_security_rules {
    protocol  = "all"
    source    = "0.0.0.0/0"
    stateless = true
    tcp_options {
      max = 80
      min = 80
    }
    udp_options {
      max = 443
      min = 443
    }
  }
  ingress_security_rules {
    protocol  = "all"
    source    = "0.0.0.0/0"
    stateless = true
    tcp_options {
      max = 443
      min = 443
    }
  }
  ingress_security_rules {
    protocol  = "all"
    source    = "0.0.0.0/0"
    stateless = true
    tcp_options {
      max = 30000
      min = 30000
    }
  }
}

resource "oci_core_instance" "foundry_vm" {
  compartment_id                      = var.compartment_id
  availability_domain                 = "wwvl:SA-SAOPAULO-1-AD-1"
  shape                               = "VM.Standard.A1.Flex"
  display_name                        = "foundry_vm"
  is_pv_encryption_in_transit_enabled = "true"

  shape_config {
    ocpus         = 4
    memory_in_gbs = 24
  }
  create_vnic_details {
    subnet_id                 = "public-subnet-foundry"
    assign_public_ip          = true
    assign_ipv6ip             = "false"
    assign_private_dns_record = "true"
    display_name              = "foundry_vnic"
  }
  source_details {
    source_type = "image"
    source_id   = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaamy6x3drp3qt5vplsp6zznlhlqkeffdylaeviintymmzugip4jf7q"
  }
  instance_options {
    are_legacy_imds_endpoints_disabled = "false"
  }
  metadata = {
    "ssh_authorized_keys" = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3jcmhjTFBSvPXqTjLldp87+DyKnUkNTvwD+zWoshhKUzP9e6oIGQMNbJ8MTslv5OcIUekzbLa9NhacimY03v9XdrSr1HpR8sCql5I6pC4jJ+LIHW6ThCitlLg8vy6SyF3pt0Qg9VyNekVZSglr/7bKcMxPhRBC2k931i+60qhKno+i2CmWPqwHGqu0ZfTq/vYwJkTZTsnBF6uS9duS+nk5yyIdlWoRNoSRV7v3RtR6m6s50sGz8+nq5rCqazNRUyvejgTYtyg2w0MHw1k4p9SFSZKxeIBZQnfWum8NwpPiL/9wRF2witTD8jk/3vKYhFSgzr7uvn66ZN609J2o5UJ ssh-key-2026-02-13"
  }
  agent_config {
    is_management_disabled = "false"
    is_monitoring_disabled = "false"
    plugins_config {
      desired_state = "DISABLED"
      name          = "Vulnerability Scanning"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Management Agent"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Custom Logs Monitoring"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Compute RDMA GPU Monitoring"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Compute Instance Monitoring"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Compute HPC RDMA Auto-Configuration"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Compute HPC RDMA Authentication"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Cloud Guard Workload Protection"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Block Volume Management"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Bastion"
    }
  }
  availability_config {
    recovery_action = "RESTORE_INSTANCE"
  }
}
