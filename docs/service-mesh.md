# Service Mesh (Istio)

## Install
- scripts/install-istio.sh

## Notes
- Namespace openedx is labeled for sidecar injection in k8s/namespace.yaml
- Namespace openedx-db disables injection in k8s/db/namespace.yaml
- Enable mTLS if required using PeerAuthentication and DestinationRule policies
