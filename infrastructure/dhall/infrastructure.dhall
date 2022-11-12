let certManager = ./certManager.dhall

in  [ certManager.letsencryptStagingIssuer
    , certManager.letsencryptProductionIssuer
    ]
