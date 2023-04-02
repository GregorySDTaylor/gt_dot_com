let certManager = (../imports.dhall).certManager

let k8s = (../imports.dhall).k8s

in  < Issuer : certManager.Issuer.Type
    | Certificate : certManager.Certificate.Type
    | Secret : k8s.Secret.Type
    | Namespace : k8s.Namespace.Type
    >
