package holos

import ("encoding/json")

Addons: {
	"cilium": {
		path:               "addons/cni/cilium"
		_clusterParameters: _
		_fleetParameters:   _
		parameters: #CiliumParameters & {
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
		parameters: #IstioBaseParameters & {}
	}

	"istio-cni": {
		path:               "addons/istio/cni"
		_clusterParameters: _
		_fleetParameters:   _
		parameters: #IstioCniParameters & {}
	}

	"istio-gateway": {
		path:               "addons/istio/gateway"
		_clusterParameters: _
		_fleetParameters:   _
		parameters: #IstioGatewayParameters & {}
	}

	"istio-istiod": {
		path:               "addons/istio/istiod"
		_clusterParameters: _
		_fleetParameters:   _
		parameters: #IstioIstiodParameters & {}
	}

	"istio-ztunnel": {
		path:               "addons/istio/ztunnel"
		_clusterParameters: _
		_fleetParameters:   _
		parameters: #IstioZtunnelParameters & {}
	}

	"cert-manager": {
		path:             "addons/cert-manager"
		_fleetParameters: _
		parameters: #CertManagerParameters & {
			highlyAvailable: _fleetParameters.prod
		}
	}

	"metrics-server": {
		path:             "addons/metrics-server"
		_fleetParameters: _
		parameters: #MetricsServerParameters & {
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
