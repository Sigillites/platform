package holos

// === Define Parameter Schema ===
params: #ArgoCDAvpParameters

// === Build Plan ===
holos: Component.BuildPlan

Component: #Kustomize & {
	KustomizeConfig: Files: {
		"raw/cmp-plugin.yaml": _
	}
}
