package holos

Helm: Values: {
	installCRDs:          true
	kubeProxyReplacement: true
	operator: replicas: 1
	cluster: name:      params.clusterName
	ipam: mode:         "kubernetes"
}
