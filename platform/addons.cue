package holos

import ("encoding/json")

let istioVersion = "1.24.3"

Addons: {
	"cilium": {
		path:               "addons/cni/cilium"
		_clusterParameters: _
		_fleetParameters:   _
		parameters: #CiliumParameters & {
			version:     "1.17.1"
			clusterName: _clusterParameters.name
			os:          _clusterParameters.os
			meshed:      _fleetParameters.meshed
		}
	}

	"gateway-api": {
		path: "addons/gateway-api"
	}

	"istio-base": {
		path:               "addons/istio/base"
		_clusterParameters: _
		_fleetParameters:   _
		parameters: #IstioBaseParameters & {
			version: istioVersion
		}
	}

	"istio-cni": {
		path:               "addons/istio/cni"
		_clusterParameters: _
		_fleetParameters:   _
		parameters: #IstioCniParameters & {
			version: istioVersion
		}
	}

	"istio-istiod": {
		path:               "addons/istio/istiod"
		_clusterParameters: _
		_fleetParameters:   _
		parameters: #IstioIstiodParameters & {
			version: istioVersion
		}
	}

	"istio-ztunnel": {
		path:               "addons/istio/ztunnel"
		_clusterParameters: _
		_fleetParameters:   _
		parameters: #IstioZtunnelParameters & {
			version: istioVersion
		}
	}

	"cert-manager": {
		path:             "addons/cert-manager"
		_fleetParameters: _
		parameters: #CertManagerParameters & {
			version:         "1.17.1"
			highlyAvailable: _fleetParameters.prod
		}
	}

	"metrics-server": {
		path:             "addons/metrics-server"
		_fleetParameters: _
		parameters: #MetricsServerParameters & {
			version:         "3.12.2"
			highlyAvailable: _fleetParameters.prod
		}
	}

	"kubelet-serving-cert-approver": {
		path:       "addons/kubelet-serving-cert-approver"
		parameters: #KubletServingCertApproverParameters
	}
}

// === Render ===

for fleetName, fleet in Fleets {
	for clusterName, cluster in fleet.clusters {
		for addonName, rawAddon in Addons {
			let addon = rawAddon & {
				_fleetParameters:   fleet.parameters
				_clusterParameters: cluster.parameters
			}
			Platform: Components: {
				"\(fleetName).\(clusterName).addons.\(addonName)": {
					name: addonName
					path: addon.path
					parameters: {
						params:          json.Marshal(addon.parameters)
						output_base_dir: "\(fleetName)/\(clusterName)/addons"
					}
				}
			}
		}
	}
}
