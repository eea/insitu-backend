FROM eeacms/plone-backend:6.0.15-11
#ENV PROFILES="eea.insitu.policy:default"

COPY requirements.txt constraints.txt /app/
COPY ./etc/zodbpack.conf /app/etc/zodbpack.conf
RUN ./bin/pip install -r requirements.txt -c constraints.txt ${PIP_PARAMS} \
 && ./bin/pip install git+https://github.com/eea/eea.volto.policy.git@update_internal_api_path \
 && find /app -not -user plone -exec chown plone:plone {} \+
