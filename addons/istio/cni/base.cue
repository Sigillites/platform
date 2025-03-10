package holos

// === Define Parameter Schema ===

params: #IstioCniParameters

// === Build Plans ===

holos: Helm.BuildPlan

Helm: #Helm & {
	Namespace: "istio-system"

	Chart: {
		name:    "cni"
		version: params.version
		repository: {
			name: "istio"
			url:  "https://istio-release.storage.googleapis.com/charts"
		}
	}

	Values: {
		profile: "ambient"
	}
}
