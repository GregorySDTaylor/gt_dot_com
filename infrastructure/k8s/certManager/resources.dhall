let functions = ./functions.dhall

let k8sFunctions = ../functions.dhall

let Resource = ../resourceUnion.dhall

let namespace = (../resources.dhall).sharedNamespace

let cloudFlareAdministratorEmail = "GregorySDTaylor@gmail.com"

let cloudflareApiTokenSecret =
      { name = "cloudflare-dns01-token", key = Some "api-token" }

let cloudFlareDns01Solver =
      functions.defaultCloudFlareDns01Solver cloudflareApiTokenSecret

let letsencryptStagingIssuer =
      functions.defaultACMEIssuer
        { name = "letsencrypt-staging"
        , server = "https://acme-v02.api.letsencrypt.org/directory"
        , email = cloudFlareAdministratorEmail
        , solver = cloudFlareDns01Solver
        , namespace
        }

let letsencryptStagingSecret =
      functions.secretForAcmeIssuer
        { issuer = letsencryptStagingIssuer, namespace }

let letsencryptProductionIssuer =
      functions.defaultACMEIssuer
        { name = "letsencrypt-production"
        , server = "https://acme-v02.api.letsencrypt.org/directory"
        , email = cloudFlareAdministratorEmail
        , solver = cloudFlareDns01Solver
        , namespace
        }

let letsencryptProductionSecret =
      functions.secretForAcmeIssuer
        { issuer = letsencryptProductionIssuer, namespace }

in  { letsencryptProductionIssuer
    , resourceList =
          [ Resource.Issuer letsencryptStagingIssuer
          , Resource.Issuer letsencryptProductionIssuer
          ]
        : List Resource
    }
