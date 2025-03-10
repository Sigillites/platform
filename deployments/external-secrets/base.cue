package holos

// === Define Parameter Schema ===

params: #ExternalSecretsParameters

// === Build Plan ===

holos: Component.BuildPlan

Component: #Helm & {
	Name:      "external-secrets"
	Namespace: "external-secrets"

	Chart: {
		version: params.version
		repository: {
			name: "external-secrets"
			url:  "https://charts.external-secrets.io"
		}
	}

	Resources: Namespace: "namespace": {
		metadata: {
			name: "external-secrets"
		}
	}

	Values: installCRDs: false
}
