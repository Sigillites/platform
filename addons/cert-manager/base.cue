package holos

// === Define Parameter Schema ===

params: #CertManagerParameters

// === Build Plan ===

holos: Helm.BuildPlan

Helm: #Helm & {
	Namespace: "cert-manager"

	Chart: {
		name:    "cert-manager"
		version: params.version
		repository: {
			name: "jetstack"
			url:  "https://charts.jetstack.io"
		}
	}

	Resources: Namespace: "namespace": {
		metadata: {
			name: Helm.Namespace
		}
	}
}

// === Enable HA Mode ===

if params.highlyAvailable {
	Helm: Values: {
		replicaCount: 2
		webhook: replicaCount:    3
		cainjector: replicaCount: 2
	}
}
