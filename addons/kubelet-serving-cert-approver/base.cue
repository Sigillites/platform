package holos

// === Define Parameter Schema ===

params: #KubletServingCertApproverParameters

// === Build Plan ===

holos: Kustomize.BuildPlan

Kustomize: #Kustomize & {
	KustomizeConfig: {
		Resources: "github.com/alex1989hu/kubelet-serving-cert-approver//deploy/standalone?ref=385fd8001583276444ed0131d9ba5b85da0d5ca3": _
	}
}
