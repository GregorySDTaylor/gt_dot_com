let functions = ./functions.dhall

let Resource = ../resourceUnion.dhall

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
        }

let letsencryptProductionIssuer =
      functions.defaultACMEIssuer
        { name = "letsencrypt-production"
        , server = "https://acme-v02.api.letsencrypt.org/directory"
        , email = cloudFlareAdministratorEmail
        , solver = cloudFlareDns01Solver
        }

let letsencryptCertificate =
      functions.defaultLetsencryptCertificate
        { name = "letsencrypt-certificate", issuer = letsencryptStagingIssuer }

in    [ Resource.Issuer letsencryptStagingIssuer
      , Resource.Issuer letsencryptProductionIssuer
      , Resource.Certificate letsencryptCertificate
      ]
    : List Resource
