let certManager = (./imports.dhall).certManager

let certManagerResources = ./certManager/resources.dhall

let Resource = ./resourceUnion.dhall

in  certManagerResources : List Resource
