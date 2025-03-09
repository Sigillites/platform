package holos

// Helm chart values for cert-manager that comply with CIS, BSI and NSA
// security benchmarks and best practices for production deployments

Helm: Values: {

	crds: enabled: true

	global: priorityClassName: "system-cluster-critical"

	replicaCount: int | *1

	podDisruptionBudget: {
		enabled:      true
		minAvailable: 1
	}

	automountServiceAccountToken: false

	serviceAccount: automountServiceAccountToken: false

	volumes: [{
		name: "serviceaccount-token"
		projected: {
			defaultMode: 444
			sources: [
				{
					serviceAccountToken: {
						expirationSeconds: 3607
						path:              "token"
					}
				},
				{
					configMap: {
						name: "kube-root-ca.crt"
						items: [{
							key:  "ca.crt"
							path: "ca.crt"
						}]
					}
				},
				{
					downwardAPI: items: [{
						path: "namespace"
						fieldRef: {
							apiVersion: "v1"
							fieldPath:  "metadata.namespace"
						}
					}]
				},
			]
		}
	}]

	volumeMounts: [{
		mountPath: "/var/run/secrets/kubernetes.io/serviceaccount"
		name:      "serviceaccount-token"
		readOnly:  true
	}]

	webhook: {
		replicaCount: int | *1

		podDisruptionBudget: {
			enabled:      true
			minAvailable: 1
		}

		automountServiceAccountToken: false

		serviceAccount: automountServiceAccountToken: false

		volumes: [{
			name: "serviceaccount-token"
			projected: {
				defaultMode: 444
				sources: [
					{
						serviceAccountToken: {
							expirationSeconds: 3607
							path:              "token"
						}
					},
					{
						configMap: {
							name: "kube-root-ca.crt"
							items: [{
								key:  "ca.crt"
								path: "ca.crt"
							}]
						}
					},
					{
						downwardAPI: items: [{
							path: "namespace"
							fieldRef: {
								apiVersion: "v1"
								fieldPath:  "metadata.namespace"
							}
						}]
					},
				]
			}
		}]

		volumeMounts: [{
			mountPath: "/var/run/secrets/kubernetes.io/serviceaccount"
			name:      "serviceaccount-token"
			readOnly:  true
		}]
	}

	cainjector: {
		replicaCount: int | *1

		extraArgs: [
			"--namespace=cert-manager",
			"--enable-certificates-data-source=false",
		]

		podDisruptionBudget: {
			enabled:      true
			minAvailable: 1
		}

		automountServiceAccountToken: false

		serviceAccount: automountServiceAccountToken: false

		volumes: [{
			name: "serviceaccount-token"
			projected: {
				defaultMode: 444
				sources: [
					{
						serviceAccountToken: {
							expirationSeconds: 3607
							path:              "token"
						}
					},
					{
						configMap: {
							name: "kube-root-ca.crt"
							items: [{
								key:  "ca.crt"
								path: "ca.crt"
							}]
						}
					},
					{
						downwardAPI: items: [{
							path: "namespace"
							fieldRef: {
								apiVersion: "v1"
								fieldPath:  "metadata.namespace"
							}
						}]
					},
				]
			}
		}]

		volumeMounts: [{
			mountPath: "/var/run/secrets/kubernetes.io/serviceaccount"
			name:      "serviceaccount-token"
			readOnly:  true
		}]
	}

	startupapicheck: {
		automountServiceAccountToken: false

		serviceAccount: automountServiceAccountToken: false

		volumes: [{
			name: "serviceaccount-token"
			projected: {
				defaultMode: 444
				sources: [
					{
						serviceAccountToken: {
							expirationSeconds: 3607
							path:              "token"
						}
					},
					{
						configMap: {
							name: "kube-root-ca.crt"
							items: [{
								key:  "ca.crt"
								path: "ca.crt"
							}]
						}
					},
					{
						downwardAPI: items: [{
							path: "namespace"
							fieldRef: {
								apiVersion: "v1"
								fieldPath:  "metadata.namespace"
							}
						}]
					},
				]
			}
		}]

		volumeMounts: [{
			mountPath: "/var/run/secrets/kubernetes.io/serviceaccount"
			name:      "serviceaccount-token"
			readOnly:  true
		}]
	}
}
