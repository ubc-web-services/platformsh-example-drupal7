core = 7.x
api = 2

includes[] = project-core.make

;DEFAULT MODULES

projects[smtp][version] = "1.7"
projects[smtp][patch][] = "https://raw.githubusercontent.com/ubc-web-services/patches/master/smtp.phpmailer.inc.mail.ubc.ca.patch"

projects[seckit][version] = "1.9"

projects[ubc_healthcheck][download][type] = "git"
projects[ubc_healthcheck][download][url] = "https://github.com/ubc-web-services/ubc_healthcheck.git"
projects[ubc_healthcheck][subdir] = "custom"
projects[ubc_healthcheck][type] = "module"


; THEMES


; MODULES


; LIBRARIES
