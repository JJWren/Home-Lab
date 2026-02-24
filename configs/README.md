# ⚙️ Configuration Management

This directory contains sanitized versions of the configuration files used to tune services within the home lab. Storing these here allows for version-controlled infrastructure while maintaining security.

## 📂 Directory Structure

### 🌐 [nginx/](./nginx/)

* **Contains:** Custom Nginx advanced configuration snippets and site-level optimizations.
* **Focus:** Security headers, proxy pass optimizations, and WebSocket support for services like Overseerr.

### 🛡️ [gluetun/](./gluetun/)

* **Contains:** Sanitized VPN provider configurations.
* **Focus:** Wireguard endpoint definitions and killswitch logic.

## 🤫 Sanitization Strategy

All files in this directory have been processed to remove:

* **Passwords & API Keys:** Replaced with placeholders like `{{SECRET_KEY}}`.
* **Local IPs/Paths:** Replaced with generic variables consistent with the `.env.example` file.
* **Personal Domains:** Replaced with `yourdomain.dev`.

## 🛠️ Usage

To use these configurations in a live environment, copy the desired file to your local persistent storage (e.g., `Z:/docker/config/`) and replace the placeholders with your specific environment variables.
