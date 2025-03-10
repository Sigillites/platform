package holos

// === Define Parameter Schema ===

params: #CiliumParameters

// === Build Plan ===

holos: Helm.BuildPlan

Helm: #Helm & {
	Namespace: "kube-system"

	Chart: {
		name:    "cilium"
		version: "1.17.1"
		repository: {
			name: "cilium"
			url:  "https://helm.cilium.io/"
		}
	}
}

// === Talos ===

if params.os == "talos" {
	Helm: Values: {
		k8sServiceHost: "localhost"
		k8sServicePort: 7445
		securityContext: {
			capabilities: {
				ciliumAgent: [
					"CHOWN",
					"KILL",
					"NET_ADMIN",
					"NET_RAW",
					"IPC_LOCK",
					"SYS_ADMIN",
					"SYS_RESOURCE",
					"DAC_OVERRIDE",
					"FOWNER",
					"SETGID",
					"SETUID",
				]
				cleanCiliumState: [
					"NET_ADMIN",
					"SYS_ADMIN",
					"SYS_RESOURCE",
				]
			}
		}
		cgroup: {
			hostRoot: "/sys/fs/cgroup"
			autoMount: enabled: false
		}
	} //!TODO this need to scream if the param does not exist
}

// === Meshed ===

if params.meshed {
	Helm: Values: {
		cni: exclusive:              false
		socketLB: hostNamespaceOnly: true
	}
}
