# Demo nginx port-stripping redirect bug

## Status

Worked around, not fixed. `bin/demo.sh` now opens `/creator/home` directly to
sidestep the redirect. The underlying nginx behaviour is still present and
worth looking into.

## Symptom

`make demo` (which runs `bin/demo.sh`) brings the creator demo up correctly on
host port 81:

```
$ docker ps
... 0.0.0.0:81->80/tcp, [::]:81->80/tcp   creator-nginx-1
```

But the browser tab it opens lands on `http://localhost/creator/home` (port 80,
no port shown) instead of port 81. With the demo published on 81 (and nothing on
80), that page fails to load.

## Cause

`bin/demo.sh` opened the bare root URL `http://localhost:81`. The cyber-dojo
nginx image rewrites `/` to `/creator/home` and issues it as an absolute 301
built from its own listen port, not the client's `Host` header. Because nginx
listens on 80 inside the container, the redirect target is port 80.

Evidence, taken against the running demo nginx on port 81:

```
$ curl -sSI http://localhost:81/
HTTP/1.1 301 Moved Permanently
Location: http://localhost/creator/home        <-- port 81 dropped

$ curl -sSI http://localhost:81/creator/home
HTTP/1.1 200 OK                                 <-- no redirect, stays on 81
```

Relevant nginx config (from `docker exec creator-nginx-1 nginx -T`):

```
listen 80;
server_name localhost;
rewrite ^/$ /creator/home permanent;
```

Chain of events:

1. `bin/demo.sh` opens `http://localhost:81/`.
2. nginx matches `rewrite ^/$ /creator/home permanent;`.
3. With `absolute_redirect` on (the nginx default), nginx builds an absolute
   `Location` from `server_name` (`localhost`) and its internal listen port
   (`80`), ignoring the client `Host: localhost:81`. Result:
   `http://localhost/creator/home`.
4. The browser follows the 301 to port 80, where the creator demo is not
   published, so the page fails.

This only affects the bare `/` path. `/creator/home` requested directly returns
200 and keeps the port.

## Why it surfaced now

The demo used to publish nginx on host port 80, so the stripped-to-80 redirect
happened to point back at the same demo and worked by accident. Moving the demo
to host port 81 (so the web and creator demos can run side by side without a
port clash) exposed the mismatch between nginx's internal listen port and the
published host port.

## Workaround in place

`bin/demo.sh` now opens the final URL directly:

```
open "http://localhost:${CYBER_DOJO_NGINX_HOST_PORT}/creator/home"
```

## Options for a proper fix (to investigate)

- Set `absolute_redirect off;` in the nginx config so the `^/$` rewrite emits a
  relative `Location: /creator/home`; the browser then keeps whatever port it
  is already on. This lives in the cyber-dojo nginx image, not this repo.
- Or set `port_in_redirect off;` (weaker: only affects the port, and still
  depends on the absolute form).
- Confirm whether any other absolute redirects in the nginx config have the
  same host-port assumption.
```
