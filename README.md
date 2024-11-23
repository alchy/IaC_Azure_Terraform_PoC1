musí být nastaveny:

- uživatel musí mít přiřazenou roli, která umožní registrovat service principal 
  app registrations: https://learn.microsoft.com/cs-cz/entra/identity-platform/howto-create-service-principal-portal

- základní proměnné pro práci s danou subsrcipcí/tenantem
  az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<subskripce>"

- dále je nutné nastavit proměnné shellu pro připojení terraformu 

###
### variable for terraform
### 
$Env:ARM_CLIENT_ID = "*****"        # appId - vystup az ad sp create-for-rbac
$Env:ARM_CLIENT_SECRET = "*****"    # password - vstup az ad sp create-for-rbac
$Env:ARM_SUBSCRIPTION_ID = "*****"  # ID subskripce - z portálu 
$Env:ARM_TENANT_ID = "*****"        # tenantId - z portálu

###
### specifické neveřejné proměnné pro použití v konfiguracích teraformu
###
$env:TF_VAR_admin_username = "*****"
$env:TF_VAR_admin_password = "*****"

###
### naming module (context of "terraform-azurerm-naming")
###
https://github.com/Azure/terraform-azurerm-naming/tree/master
