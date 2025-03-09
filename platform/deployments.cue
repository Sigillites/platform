package holos

import ("encoding/json")

ControllerDeployments: {
	"argocd": {
		path:       "deployments/argocd"
		parameters: #ArgoCDParameters
	}
}

for deploymentName, rawDeployment in ControllerDeployments {
	let deployment = rawDeployment & {
		_fleetParameters:   Fleets."cloud_controller".parameters
		_clusterParameters: Fleets."cloud_controller".clusters.parameters
	}
	Platform: Components: {
		"cloud_controller.hetzner.deployments.\(deploymentName)": {
			name: deploymentName
			path: deployment.path
			parameters: {
				params:          json.Marshal(deployment.parameters)
				output_base_dir: "cloud_controller/hetzner/deployments"
			}
		}
	}
}
