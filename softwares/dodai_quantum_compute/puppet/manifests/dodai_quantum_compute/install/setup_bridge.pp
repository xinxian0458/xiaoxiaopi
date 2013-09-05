class dodai_quantum_compute::dodai_quantum_compute::install::setup_bridge (
	$br_names = []
) {
	$br_names.each |$index, $value| {
		exec { "ip link set $value up":
    		onlyif => [
                "ip addr | grep $value"
              ]
		}
	}
}