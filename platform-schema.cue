package holos

#Parameters: [string]: _

#Cluster: close({
	addons: [string]: #Addon
	parameters: #Parameters & {
		name:        string
		data_region: "eu" | "usa" | "apac"
		host:        "hetzner" | "aws"
		os:          "talos"
	}
})

#Fleet: close({
	clusters: [clusterName=string]: #Cluster & {
		parameters: name: clusterName
	}
	parameters: #Parameters & {
		name:   string
		prod:   bool | *false
		meshed: bool | *true
	}
})

#Addon: close({
	path:       string
	parameters: #Parameters
})

Fleets: [fleetName=string]: #Fleet & {parameters: name: fleetName}

Addons: [string]: #Addon
