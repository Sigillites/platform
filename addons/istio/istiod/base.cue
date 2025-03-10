package holos

import (
	"encoding/yaml"
	ks "sigs.k8s.io/kustomize/api/types"
)

// === Define Parameter Schema ===

params: #IstioIstiodParameters

// === Build Plans ===

holos: Helm.BuildPlan

Helm: #Helm & {
	Namespace: "istio-system"

	Chart: {
		name:    "istiod"
		version: params.version
		repository: {
			name: "istio"
			url:  "https://istio-release.storage.googleapis.com/charts"
		}
	}

	Values: {
		profile: "ambient"
	}

	KustomizeConfig: Kustomization: patches: [for x in KustomizePatches {x}]
}

#KustomizePatches: [ArbitraryLabel=string]: ks.#Patch
let KustomizePatches = #KustomizePatches & {
	validator: {
		target: {
			group:   "admissionregistration.k8s.io"
			version: "v1"
			kind:    "ValidatingWebhookConfiguration"
			name:    "istio-validator-istio-system"
		}
		let Patch = [{
			op:    "replace"
			path:  "/webhooks/0/failurePolicy"
			value: "Fail"
		}]
		patch: yaml.Marshal(Patch)
	}
}
