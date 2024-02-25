resource "azurerm_resource_group" "aks" {
  name     = "my-resource-group"
  location = "eastus"
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = "my-log-analytics-workspace"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  sku                 = "PerGB2018"

}

resource "azurerm_container_registry" "reg" {
  name                = "acrdevcontainerseus01"
  resource_group_name = azurerm_resource_group.aks.name
  location            = azurerm_resource_group.aks.location
  sku                 = "Basic"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "my-aks-cluster"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  dns_prefix          = "my-aks-cluster"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
  }

}

resource "azurerm_role_assignment" "example" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.reg.id
  skip_service_principal_aad_check = true
}

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"
  version    = "8.10.2"

  set {
    name  = "controller.service.loadBalancerIP"
    value = azurerm_public_ip.ingress_ip.ip_address
  }
}

resource "azurerm_public_ip" "ingress_ip" {
  name                = "ingress-ip"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  allocation_method   = "Static"
}
resource "kubernetes_namespace" "dev_containers" {
  metadata {
    name = "dev-containers"
  }
}

resource "kubernetes_deployment" "dev_container_deployment" {
  metadata {
    name      = "dev-container-deployment"
    namespace = kubernetes_namespace.dev_containers.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "dev-container"
      }
    }

    template {
      metadata {
        labels = {
          app = "dev-container"
        }
      }

      spec {
        container {
          name  = "dev-container"
          image = "your-dev-container-image"
          # Add other container configuration as needed
        }
      }
    }
  }
}
