let dns = ../dns.dhall

let IngressTLS = (../imports.dhall).k8s.IngressTLS.Type

let sharedCertificate = (../k8s/sharedCertificate.dhall).letsencryptCertificate

in  { server =
      { ingress =
        { enabled = True
        , hosts = [ { host = "vault." ++ dns.host } ]
        , tls =
              [ { hosts = Some [ "*." ++ dns.host, dns.host ]
                , secretName = Some
                    sharedCertificate.spec.secretName
                }
              ]
            : List IngressTLS
        }
      , dataStorage.storageClass = "microk8s-hostpath"
      }
    }
