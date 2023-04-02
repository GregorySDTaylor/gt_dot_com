let dns = ./dns.dhall

let version = "0.3.0"
let namespace = "gt-homelab"

in  { namespace
    , versionLabel = { mapKey = dns.host ++ "/version", mapValue = version }
    }
