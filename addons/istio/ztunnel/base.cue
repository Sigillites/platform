package holos

// === Define Parameter Schema ===

params: #IstioZtunnelParameters

// === Build Plans ===

holos: Helm.BuildPlan

Helm: #Helm & {
	Namespace: "istio-system"

	Chart: {
		name:    "ztunnel"
		version: params.version
		repository: {
			name: "istio"
			url:  "https://istio-release.storage.googleapis.com/charts"
		}
	}
}
