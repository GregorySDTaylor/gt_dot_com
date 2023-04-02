let version = "0.3.0"
let namespace = "gt-homelab"

in  { namespace
    , versionLabel = { mapKey = namespace ++ "/version", mapValue = version }
    }
