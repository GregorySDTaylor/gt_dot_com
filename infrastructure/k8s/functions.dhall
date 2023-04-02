let k8s = (../imports.dhall).k8s

in  { nameSpace =
        \(args : { name : Text }) ->
          k8s.Namespace::{
          , metadata = k8s.ObjectMeta::{ name = Some args.name }
          }
    }
