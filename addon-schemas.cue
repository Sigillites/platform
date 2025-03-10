package holos

#CiliumParameters: {
	clusterName: string
	os:          string
	meshed:      bool
}

#CertManagerParameters: {
	highlyAvailable: bool | *false
}

#ArgoCDParameters: {}

#MetricsServerParameters: {
	highlyAvailable: bool | *false
}

#KubletServingCertApproverParameters: {}

// === Istio === 
#IstioBaseParameters: {
	version: string
}
#IstioCniParameters: {
	version: string
}
#IstioZtunnelParameters: {
	version: string
}
#IstioIstiodParameters: {
	version: string
}
