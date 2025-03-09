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
		Resources: "github.com/argoproj/argo-cd//manifests/cluster-install?ref=v2.14.4": _
		Kustomization: {
			namespace: "argocd"
			patches: [for x in KustomizePatches {x}]
		}
	}

	Resources: {
		Namespace: "namespace": {
			metadata: {
				name: "argocd"
			}
		}

		Application: "bootstrap": {
			metadata: {
				name:      "bootstrap"
				namespace: "argocd"
				//finalizers: "resources-finalizer.argocd.argoproj.io"
			}
			spec: {
				destination: server: "https://kubernetes.default.svc"
				project: "default"
				source: {
					path:           "deploy/gitops"
					repoURL:        "https://github.com/Sigillites/platform.git"
					targetRevision: "main"
					directory: recurse: true
				}
				syncPolicy: {
					automated: {
						prune:    true
						selfHeal: true
					}
					syncOptions: [
						"ApplyOutOfSyncOnly=true",
					]
				}
			}
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
			"resource.exclusions": """
				- apiGroups:
				  - cilium.io
				  kinds:
				  - CiliumIdentity
				  clusters:
				  - '*'
				"""
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
