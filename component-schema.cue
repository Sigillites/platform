package holos

import ("github.com/holos-run/holos/api/author/v1alpha5:author")

import (
	"path"
	app "argoproj.io/application/v1alpha1"
)

params: #Parameters & _Tags.params

#ComponentConfig: author.#ComponentConfig & {
	Name:          _Tags.component.name
	Path:          _Tags.component.path
	OutputBaseDir: _Tags.outputBaseDir
	Server:        _Tags.server
	Resources:     #Resources

	// labels is an optional field, guard references to it.
	if _Tags.component.labels != _|_ {
		Labels: _Tags.component.labels
	}

	// annotations is an optional field, guard references to it.
	if _Tags.component.annotations != _|_ {
		Annotations: _Tags.component.annotations
	}

	// ArgoCD Mixin
	let ArtifactPath = path.Join(["gitops", OutputBaseDir, "\(Name).application.gen.yaml"], path.Unix)
	let ResourcesPath = path.Join(["deploy", OutputBaseDir, "components", Name], path.Unix)

	Artifacts: "\(Name)-application": {
		artifact: ArtifactPath
		generators: [{
			kind:   "Resources"
			output: artifact
			resources: Application: (Name): app.#Application & {
				metadata: {
					name:      Name
					namespace: "argocd"
					//finalizers: "resources-finalizer.argocd.argoproj.io"
				}
				spec: {
					destination: server: Server
					project: "default"
					source: {
						path:           ResourcesPath
						repoURL:        "https://github.com/Sigillites/platform.git"
						targetRevision: "main"
					}
					syncPolicy: {
						automated: {
							prune:    true
							selfHeal: true
						}
						syncOptions: [
							"CreateNamespace=true",
							"ApplyOutOfSyncOnly=true",
						]
					}
				}
			}
		}]
	}
}

// https://holos.run/docs/api/author/v1alpha5/#Kubernetes
#Kubernetes: close({
	#ComponentConfig
	author.#Kubernetes
})

// https://holos.run/docs/api/author/v1alpha5/#Kustomize
#Kustomize: close({
	#ComponentConfig
	author.#Kustomize
})

// https://holos.run/docs/api/author/v1alpha5/#Helm
#Helm: close({
	#ComponentConfig
	author.#Helm
})
