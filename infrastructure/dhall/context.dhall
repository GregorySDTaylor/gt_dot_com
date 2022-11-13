let dns = ./dns.dhall

let version = "0.1.0-1"

in  { namespace = "gt-dot-com"
    , versionLabel = { mapKey = dns.host ++ "/version", mapValue = version }
    }
