<h3 id="section-5-6">5.6 Decoupling Pods from Site-Specific Storage</h3>

* The purpose of configuring a Pod with PVC storage is to decouple site-specific information (like the specific cloud disk or host path) from a generic Pod specification.
* The `pod.volume.spec` is set to `PersistentVolumeClaim`, shifting the responsibility to the PVC to find available PV storage that meets its requirements.
* When a Pod specification is distributed with a PVC specification, it will always bind to available site-specific storage, without the Pod knowing or caring about the underlying storage details (e.g., whether it's an AWS EBS volume or a local host path).
