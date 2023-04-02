let certManagerResources = (./certManager/resources.dhall).resourceList

let vaultResources = (./vault/resources.dhall).resourceList

in  certManagerResources # vaultResources
