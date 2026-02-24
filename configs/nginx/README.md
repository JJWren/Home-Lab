# 🌐 Nginx Configuration Snippets

While **Nginx Proxy Manager** provides a GUI for basic routing, I utilize the "Advanced" tab to inject custom Nginx directives for enterprise-grade security and performance.

## 🛡️ Global Security Headers

I apply the following snippet to all public-facing services (FairShare, Portfolio, Overseerr) to harden the browser-side security posture:

```nginx
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-XSS-Protection "1; mode=block" always;
add_header Referrer-Policy "no-referrer-when-downgrade" always;
add_header Content-Security-Policy "upgrade-insecure-requests";
```

## 🚀 Performance Optimizations

For high-traffic or media-heavy services, the following proxy buffers are tuned to prevent "Header too large" errors and improve load times:

```nginx
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto $scheme;

proxy_buffering on;
proxy_buffer_size 128k;
proxy_buffers 4 256k;
proxy_busy_buffers_size 256k;
```
