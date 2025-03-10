package holos

import ("encoding/json")

let externalSecretsVersion = "0.14.3"

ControllerDeployments: {
	"argocd": {
		path:       "deployments/argocd"
		parameters: #ArgoCDParameters
	}

	"argocd-avp": {
		path:       "deployments/argocd-avp"
		parameters: #ArgoCDAvpParameters
	}

	"external-secrets": {
		path: "deployments/external-secrets"
		parameters: #ExternalSecretsParameters & {
			version: externalSecretsVersion
		}
	}

	"external-secrets-crds": {
		path: "deployments/external-secrets-crds"
		parameters: #ExternalSecretsCrdsParameters & {
			version: externalSecretsVersion
		}
	}
}

for deploymentName, rawDeployment in ControllerDeployments {
	let deployment = rawDeployment & {
		_fleetParameters:   Fleets."cloud_controller".parameters
		_clusterParameters: Fleets."cloud_controller".clusters.parameters
	}
	Platform: Components: {
		"cloud_controller.core.deployments.\(deploymentName)": {
			name: deploymentName
			path: deployment.path
			parameters: {
				params:          json.Marshal(deployment.parameters)
				output_base_dir: "cloud_controller/core/deployments"
			}
		}
	}
}
