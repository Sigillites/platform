package holos

import (
	"encoding/yaml"
  "encoding/json"
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
      patchesJson6902: [
				{
					target: {
						group: "apps"
						version: "v1"
						kind: "Deployment"
						name: "argocd-repo-server"
						namespace: "argocd"
					}
					patch: json.Marshal(RepoServerPatch)
				},
			]
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

// JSON Patch for the repo server
RepoServerPatch: [
	{
		op:    "add"
		path:  "/spec/template/spec/automountServiceAccountToken"
		value: true
	},
	{
		op:   "add"
		path: "/spec/template/spec/volumes/-"
		value: {
			configMap: {
				name: "cmp-plugin"
			}
			name: "cmp-plugin"
		}
	},
	{
		op:   "add"
		path: "/spec/template/spec/volumes/-"
		value: {
			name: "custom-tools"
			emptyDir: {}
		}
	},
	{
		op:   "add"
		path: "/spec/template/spec/initContainers/-"
		value: {
			name:  "download-tools"
			image: "registry.access.redhat.com/ubi8"
			env: [
				{
					name:  "AVP_VERSION"
					value: "1.16.1"
				},
			]
			command: ["sh", "-c"]
			args: [
				"curl -L https://github.com/argoproj-labs/argocd-vault-plugin/releases/download/v$(AVP_VERSION)/argocd-vault-plugin_$(AVP_VERSION)_linux_amd64 -o argocd-vault-plugin && chmod +x argocd-vault-plugin && mv argocd-vault-plugin /custom-tools/",
			]
			volumeMounts: [
				{
					mountPath: "/custom-tools"
					name:      "custom-tools"
				},
			]
		}
	},
	{
		op:   "add"
		path: "/spec/template/spec/containers/-"
		value: {
			name: "avp"
			command: ["/var/run/argocd/argocd-cmp-server"]
			image: "registry.access.redhat.com/ubi8"
			securityContext: {
				runAsNonRoot: true
				runAsUser:    999
			}
			volumeMounts: [
				{
					mountPath: "/var/run/argocd"
					name:      "var-files"
				},
				{
					mountPath: "/home/argocd/cmp-server/plugins"
					name:      "plugins"
				},
				{
					mountPath: "/tmp"
					name:      "tmp"
				},
				{
					mountPath: "/home/argocd/cmp-server/config/plugin.yaml"
					subPath:   "avp.yaml"
					name:      "cmp-plugin"
				},
				{
					name:      "custom-tools"
					subPath:   "argocd-vault-plugin"
					mountPath: "/usr/local/bin/argocd-vault-plugin"
				},
			]
		}
	},
]

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
