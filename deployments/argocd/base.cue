package holos

import (
	"encoding/yaml"
	ks "sigs.k8s.io/kustomize/api/types"
)

// === Define Parameter Schema ===

params: #ArgoCDParameters

// === Build Plan ===

holos: Kustomize.BuildPlan

Kustomize: #Kustomize & {
	KustomizeConfig: {
		Resources: "github.com/argoproj/argo-cd//manifests/cluster-install?ref=v2.13.1": _
		Kustomization: patches: [for x in KustomizePatches {x}]
	}

	Resources: Namespace: "namespace": {
		metadata: {
			name: "argocd"
		}
	}
}

// == Patches ==

#KustomizePatches: [ArbitraryLabel=string]: ks.#Patch

let KustomizePatches = #KustomizePatches & {
	"argocd-cm-patch": patch: yaml.Marshal({
		apiVersion: "v1"
		kind:       "ConfigMap"
		metadata: {
			name: "argocd-cm"
		}
		data: {
			"resource.exclusions": [{
				apiGroups: ["cilium.io"]
				kinds: ["CiliumIdentity"]
				clusters: ["*"]
			}]
		}
	})

	"argocd-cmd-params-patch": patch: yaml.Marshal({
		apiVersion: "v1"
		kind:       "ConfigMap"
		metadata: {
			name: "argocd-cmd-params-cm"
		}
		data: {
			"controller.diff.server.side": "true"
		}
	})
}
