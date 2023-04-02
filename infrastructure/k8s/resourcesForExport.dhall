let certManagerResources = (./certManager/resources.dhall).resourceList

let sharedCertificateResources = (./sharedCertificate.dhall).resourceList

in  certManagerResources # sharedCertificateResources
