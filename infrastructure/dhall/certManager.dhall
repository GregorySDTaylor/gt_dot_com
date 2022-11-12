let certManager = (./imports.dhall).certManager

let k8s = (./imports.dhall).k8s

let newACMEIssuerArgs =
      { name : Text
      , server : Text
      , email : Text
      , solver : certManager.ACMEChallengeSolver.Type
      }

let newACMEIssuer =
      \(args : newACMEIssuerArgs) ->
          { apiVersion = "cert-manager.io/v1"
          , kind = "Issuer"
          , metadata = k8s.ObjectMeta::{ name = Some args.name }
          , spec =
              certManager.IssuerSpecUnion.Type.ACME
                { acme = certManager.ACMEIssuer::{
                  , server = args.server
                  , email = Some args.email
                  , privateKeySecretRef = certManager.SecretKeySelector::{
                    , name = args.name
                    }
                  , solvers = Some [ args.solver ]
                  }
                }
          }
        : certManager.Issuer.Type

let newCloudFlareDns01Solver =
      \(apiTokenSecretKeyRef : certManager.SecretKeySelector.Type) ->
        certManager.ACMEChallengeSolver.Type.Dns01
          certManager.ACMEChallengeSolverDNS01::{
          , dns01 =
              certManager.ACMEChallengeSolverDNS01Union.Type.Cloudflare
                certManager.ACMEChallengeSolverDNS01Cloudflare::{
                , cloudflare = Some
                    ( certManager.ACMEIssuerDNS01ProviderCloudflare.Type.ApiToken
                        { apiTokenSecretRef = apiTokenSecretKeyRef }
                    )
                }
          }

let cloudflareApiTokenSecret =
      { name = "cloudflare-dns01-token", key = Some "api-token" }

let cloudFlareDns01Solver = newCloudFlareDns01Solver cloudflareApiTokenSecret

let gregsEmail = "GregorySDTaylor@gmail.com"

in  { letsencryptStagingIssuer =
        newACMEIssuer
          { name = "letsencrypt-staging"
          , server = "https://acme-v02.api.letsencrypt.org/directory"
          , email = gregsEmail
          , solver = cloudFlareDns01Solver
          }
    , letsencryptProductionIssuer =
        newACMEIssuer
          { name = "letsencrypt-production"
          , server = "https://acme-v02.api.letsencrypt.org/directory"
          , email = gregsEmail
          , solver = cloudFlareDns01Solver
          }
    }
