package holos

#CiliumParameters: {
	version:     string
	clusterName: string
	os:          string
	meshed:      bool
}

#CertManagerParameters: {
	version:         string
	highlyAvailable: bool | *false
}

#MetricsServerParameters: {
	version:         string
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
