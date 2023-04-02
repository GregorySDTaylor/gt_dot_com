let dns = ../dns.dhall

let IngressTLS = (../imports.dhall).k8s.IngressTLS.Type

let sharedCertificate = (../k8s/sharedCertificate.dhall).letsencryptCertificate

in  { ingress =
      { enabled = True
      , hosts =
        [ { host = "pgadmin4." ++ dns.host
          , paths = [ { path = "/", pathType = "Prefix" } ]
          }
        ]
      , tls =
            [ { hosts = Some [ "*." ++ dns.host, dns.host ]
              , secretName = Some sharedCertificate.spec.secretName
              }
            ]
          : List IngressTLS
      }
    }
