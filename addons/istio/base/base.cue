package holos

import (
	"encoding/yaml"
	ks "sigs.k8s.io/kustomize/api/types"
)

// === Define Parameter Schema ===

params: #IstioBaseParameters

// === Build Plans ===

holos: Helm.BuildPlan

Helm: #Helm & {
	Namespace: "istio-system"

	Chart: {
		name:    "base"
		version: params.version
		repository: {
			name: "istio"
			url:  "https://istio-release.storage.googleapis.com/charts"
		}
	}

	Resources: Namespace: "namespace": {
		metadata: {
			name: "istio-system"
			labels: {
				"pod-security.kubernetes.io/enforce": "privileged"
			}
		}
	}

	KustomizeConfig: Kustomization: patches: [for x in KustomizePatches {x}]
}

// === Patches === 

#KustomizePatches: [ArbitraryLabel=string]: ks.#Patch
let KustomizePatches = #KustomizePatches & {
	validator: {
		target: {
			group:   "admissionregistration.k8s.io"
			version: "v1"
			kind:    "ValidatingWebhookConfiguration"
			name:    "istiod-default-validator"
		}
		let Patch = [{
			op:    "replace"
			path:  "/webhooks/0/failurePolicy"
			value: "Fail"
		}]
		patch: yaml.Marshal(Patch)
	}
}
