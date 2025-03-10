package holos

// === Define Parameter Schema ===

params: #IstioGatewayParameters

// === Build Plans ===

holos: Helm.BuildPlan

Helm: #Helm & {
	Namespace: "istio-ingress"

	Chart: {
		name:    "gateway"
		version: "1.25.0"
		repository: {
			name: "istio"
			url:  "https://istio-release.storage.googleapis.com/charts"
		}
	}
}
