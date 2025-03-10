package holos

// === Define Parameter Schema ===

params: #IstioCniParameters

// === Build Plans ===

holos: Helm.BuildPlan

Helm: #Helm & {
	Namespace: "istio-system"

	Chart: {
		name:    "cni"
		version: "1.25.0"
		repository: {
			name: "istio"
			url:  "https://istio-release.storage.googleapis.com/charts"
		}
	}

	Values: {
		profile: "ambient"
	}
}
