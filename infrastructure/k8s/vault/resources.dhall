let certManagerFunctions = ../certManager/functions.dhall

let certManagerResources = ../certManager/resources.dhall

let Resource = ../resourceUnion.dhall

let namespace = (../resources.dhall).sharedNamespace

let letsencryptCertificate =
      certManagerFunctions.defaultLetsencryptCertificate
        { name = "letsencrypt-certificate"
        , issuer = certManagerResources.letsencryptProductionIssuer
        , namespace
        }

in  { letsencryptCertificate
    , resourceList =
        [ Resource.Certificate letsencryptCertificate ] : List Resource
    }
