####
# MakeFileManager
####

#ifndef MAKEFILEDIR
#$(info MAKEFILEDIR is not defined, please define where your makefiles are stored)
#endif

package_add:

	if -n $(package); then echo package is not defined, please define package to add; else ; echo $(package);

test:
	@if [[ -z "$$package" ]]; \
	then echo package not defined, please define a package ; \
	else \
	if [[ -z "$$version" ]]; \
	then echo version not defined, using latest version ; \
	version=latest ; fi ; \
	echo we geraken hier echo $$package:$$version; \
	unset package; fi
