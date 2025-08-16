ARG VER_APP=v2.13.2

FROM ghcr.io/goharbor/harbor-portal:${VER_APP} AS builder

COPY setting.json /usr/share/nginx/html/setting.json
COPY login_bg_transp_800x600.png /usr/share/nginx/html/images/
COPY logo_transp.svg /usr/share/nginx/html/images/
COPY logo_yellow.png /usr/share/nginx/html/images/
COPY logo_yellow_wide.png /usr/share/nginx/html/images/
COPY logo_z_400x400.jpg /usr/share/nginx/html/images/