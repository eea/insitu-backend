#!/usr/bin/env bash
globalTests+=(
        utc
        # no-hard-coded-passwords
        override-cmd
)

imageTests+=(
	[eeacms/advisory-board-backend]='
		plone-basics
		plone-site
		plone-addons
		plone-cors
		plone-arbitrary-user
		plone-listenport
		plone-zeoclient
		plone-relstorage
	'
)

globalExcludeTests+=(

)