FROM eeacms/plone-backend:6.0.15-12
#ENV PROFILES="eea.insitu.policy:default"

COPY requirements.txt constraints.txt /app/
COPY ./etc/zodbpack.conf /app/etc/zodbpack.conf
RUN ./bin/pip install -r requirements.txt -c constraints.txt ${PIP_PARAMS} \
 && ./bin/pip install git+https://github.com/eea/eea.volto.policy.git@fix_internal_urls \
 && find /app -not -user plone -exec chown plone:plone {} \+

