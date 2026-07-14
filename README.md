
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

## Secret Scanning

This repository uses the Betterleaks GitHub Action to scan the current
repository content on every push and pull request. The scan uses the rules in
`.gitleaks.toml` and uploads a `betterleaks-report` artifact when a finding is
detected.

If the optional SMTP secrets are configured, failed scans also send an email to
the last commit committer. The workflow expects these repository or
organization secrets:

- `SMTP_URL`
- `SMTP_PORT` (optional, defaults to `25`)
- `SMTP_EMAIL`
- `SMTP_PASSWORD` (optional if the SMTP server does not require authentication)

Port `465` is sent with direct TLS; other ports use the default SMTP handshake.
The email includes a short finding summary from the redacted Betterleaks report,
including the redacted matched line from each finding.

There are three common outcomes:

1. **Everything is OK.** The `Betterleaks / Scan for secrets` check is green and
   no action is needed. Regular references to runtime values are OK, for example:

   ```js
   const tokenFromCookie = req.universalCookies.get('auth_token');
   ```

2. **A real secret was found.** The check is red and the workflow log asks you to
   download the `betterleaks-report` artifact. Open the artifact from the GitHub
   Actions run and check the reported file, line and rule. Remove the committed
   value, move it to the proper secret store, and rotate it if it was exposed.
   A report entry looks like this:

   ```json
   {
     "RuleID": "secret-literal-assignment",
     "File": "src/config.js",
     "StartLine": 12,
     "Secret": "[REDACTED]"
   }
   ```

3. **The finding is a false positive.** Keep the value only if it is clearly not
   sensitive, such as a test fixture, placeholder, or public example. Add
   `betterleaks:allow` on the same line and include a short explanation in the
   pull request.

   ```js
   const testPassword = 'admin'; //betterleaks:allow
   ```

   ```yaml
   password: "admin" #betterleaks:allow
   ```

Do not add `betterleaks:allow` to real credentials.

## Copyright and license

The Initial Owner of the Original Code is European Environment Agency (EEA).
All Rights Reserved.

See [LICENSE.md](https://github.com/eea/eea-website-backend/blob/master/LICENSE.md) for details.

## Funding

[European Environment Agency (EU)](http://eea.europa.eu)