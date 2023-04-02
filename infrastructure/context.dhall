let dns = ./dns.dhall

let version = "0.2.0"

in  { namespace = "gt-homelab"
    , versionLabel = { mapKey = dns.host ++ "/version", mapValue = version }
    }
