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
