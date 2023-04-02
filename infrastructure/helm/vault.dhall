let dns = ../dns.dhall

let IngressTLS = (../imports.dhall).k8s.IngressTLS.Type

let vaultResources = ../k8s/vault/resources.dhall

in  { server =
      { ingress =
        { enabled = True
        , hosts = [ { host = "vault." ++ dns.host } ]
        , tls =
              [ { hosts = Some [ "*." ++ dns.host, dns.host ]
                , secretName = Some
                    vaultResources.letsencryptCertificate.spec.secretName
                }
              ]
            : List IngressTLS
        }
      , dataStorage.storageClass = "microk8s-hostpath"
      }
    }
