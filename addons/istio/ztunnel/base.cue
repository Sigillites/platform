package holos

// === Define Parameter Schema ===

params: #IstioZtunnelParameters

// === Build Plans ===

holos: Helm.BuildPlan

Helm: #Helm & {
	Namespace: "istio-system"

	Chart: {
		name:    "ztunnel"
		version: "1.25.0"
		repository: {
			name: "istio"
			url:  "https://istio-release.storage.googleapis.com/charts"
		}
	}
}
