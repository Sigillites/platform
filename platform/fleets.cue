package holos

Fleets: {
	"cloud_controller": {
		clusters: {
			"core": {
				parameters: {
					data_region: "eu"
					host:        "hetzner"
					os:          "talos"
					cni:         "cilium"
				}
			}
		}
	}

	//"aws-prod": {
	//	parameters: {
	//		prod: true
	//	}
	//	clusters: {
	//		"eu": {
	//			parameters: {
	//				data_region: "eu"
	//				host:        "aws"
	//				os:          "talos"
	//				cni:         "cilium"
	//			}
	//		}
	//	}
	//}
}
