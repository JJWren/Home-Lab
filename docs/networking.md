
# 🌐 Networking & Traffic Flow

## Ingress Strategy

I utilize **Nginx Proxy Manager (NPM)** to manage traffic for several subdomains on a single public IP.

### Security Measures:

- **SSL/TLS:** Wildcard certificates managed via Let's Encrypt (DNS-01 challenge with Cloudflare).
- **HSTS:** Enabled to ensure all browser connections are forced over HTTPS.
- **Port Minimization:** Only ports 80 and 443 are open at the router level; all internal services are mapped via NPM.

## Privacy & Egress

To prevent IP leakage for acquisition services, I utilize **Network Namespacing**:

- **Gluetun Sidecar:** Acts as the network gateway for the media stack.
- **Killswitch Logic:** Because services like `qbittorrent` use the `gluetun` network stack, they lack a network interface if the VPN tunnel fails, preventing accidental clear-net exposure.
