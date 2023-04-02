let context = ../context.dhall

let k8sFunctions = ./functions.dhall

let sharedNamespace = k8sFunctions.nameSpace { name = context.namespace }

in  { sharedNamespace }
