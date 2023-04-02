let certManager = (../../imports.dhall).certManager

let k8s = (../../imports.dhall).k8s

let context = ../../context.dhall

let dns = ../../dns.dhall

in  { secretForAcmeIssuer =
        \ ( args
          : { issuer : certManager.Issuer.Type, namespace : k8s.Namespace.Type }
          ) ->
          k8s.Secret::{
          , metadata = k8s.ObjectMeta::{
            , name = Some
                ( merge
                    { None = "issuer", Some = \(name : Text) -> name }
                    args.issuer.metadata.name
                )
            , namespace = args.namespace.metadata.name
            , labels = Some [ context.versionLabel ]
            }
          }
    , defaultACMEIssuer =
        \ ( args
          : { name : Text
            , server : Text
            , email : Text
            , solver : certManager.ACMEChallengeSolver.Type
            , namespace : k8s.Namespace.Type
            }
          ) ->
            certManager.Issuer::{
            , metadata = k8s.ObjectMeta::{
              , name = Some args.name
              , namespace = args.namespace.metadata.name
              , labels = Some [ context.versionLabel ]
              }
            , kind = "ClusterIssuer"
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
    , defaultCloudFlareDns01Solver =
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
    , defaultLetsencryptCertificate =
        \ ( args
          : { name : Text
            , issuer : certManager.Issuer.Type
            , namespace : k8s.Namespace.Type
            }
          ) ->
          certManager.Certificate::{
          , metadata = k8s.ObjectMeta::{
            , name = Some args.name
            , namespace = args.namespace.metadata.name
            , labels = Some [ context.versionLabel ]
            }
          , spec = certManager.CertificateSpec::{
            , secretName = args.name
            , issuerRef = certManager.ObjectReference::{
              , name =
                  merge
                    { None = "certificate", Some = \(name : Text) -> name }
                    args.issuer.metadata.name
              , kind = Some args.issuer.kind
              }
            , dnsNames = Some [ "*." ++ dns.host, dns.host ]
            }
          }
    }
