let sharedResources = ./resources.dhall

in  merge
      { None = "", Some = \(name : Text) -> name }
      sharedResources.sharedNamespace.metadata.name
