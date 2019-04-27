FROM alpine

# Install transmission
RUN apk --no-cache add tini transmission-daemon\
  && mkdir\
	  /var/lib/transmission/config\
	  /var/lib/transmission/downloads\
	  /var/lib/transmission/incomplete\
	  /var/lib/transmission/watch\
  && chown -R transmission:transmission /var/lib/transmission\
  && chmod -R o+rwX /var/lib/transmission   # Required to make the image work with arbitrary users

USER transmission

EXPOSE 9091 51413/tcp 51413/udp

HEALTHCHECK --interval=60s --timeout=15s \
  CMD wget -q --spider 'https://api.ipify.org'

VOLUME ["/var/lib/transmission"]

ENTRYPOINT ["tini", "--"]

CMD ["transmission-daemon",\
  "--foreground",\
  "--config-dir",     "/var/lib/transmission/config",\
  "--download-dir",   "/var/lib/transmission/downloads",\
  "--incomplete-dir", "/var/lib/transmission/incomplete",\
  "--watch-dir",      "/var/lib/transmission/watch"]
