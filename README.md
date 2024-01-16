
[![master](https://ci.eionet.europa.eu/buildStatus/icon?job=plone/eea-website-backend/master)](https://ci.eionet.europa.eu/blue/organizations/jenkins/plone%2Feea-website-backend/activity/)
[![Release](https://img.shields.io/docker/v/eeacms/eea-website-backend?sort=semver)](https://hub.docker.com/r/eeacms/eea-website-backend/tags)


# EEA Main Website backend (Plone 6)

Plone 6 backend for EEA Main website. See also [Plone 6 frontend for EEA Main website](https://github.com/eea/eea-website-frontend).

## Getting started

See [Plone 6 frontend for EEA Main website](https://github.com/eea/eea-website-frontend)

## Try it using Docker

    docker pull eeacms/eea-website-backend
    docker run -it --rm -p 8080:8080 -e SITE=Plone eeacms/eea-website-backend

See Plone backend at http://localhost:8080/Plone

## Develop

See [develop](https://github.com/eea/eea-website-backend/tree/master/develop)

## Release

See [release](https://github.com/eea/eea-website-backend/tree/master/RELEASE.md)

## Copyright and license

The Initial Owner of the Original Code is European Environment Agency (EEA).
All Rights Reserved.

See [LICENSE.md](https://github.com/eea/eea-website-backend/blob/master/LICENSE.md) for details.

## Funding

[European Environment Agency (EU)](http://eea.europa.eu)