####
# MakeFileManager
####

ifndef MAKEFILEDIR
$(info MAKEFILEDIR is not defined, please define where your makefiles are stored)
else
include $(MAKEFILEDIR)/packages
endif

# first checking if package is defined
# then check if defined package exists
# if defined package exists check if version is defined
# if version is not defined set to latest version
# then check if version of package exists
# if package does not exist give error
# if version does not exist give error

package_add:
	@if [[ -z "$$package" ]]; \
	then echo $$(tput setaf 1)package not defined, please define a package $$(tput setaf 7); \
	else if [[ -d $(MAKEFILEDIR)/$$package ]]; \
	then if [[ -z "$$version" ]]; \
	then echo $$(tput setaf 3)version not defined, using latest version $$(tput setaf 7); \
	version=latest ; fi ; \
	if [[ -e $(MAKEFILEDIR)/$$package/$$package-$$version.mk ]]; \
	then echo $$(tput setaf 2)adding $$package:$$version$$(tput setaf 7); \
	echo "include $(MAKEFILEDIR)/$$package/$$package-$$version.mk" >> $(MAKEFILEDIR)/packages ; \
	else \
	echo $$(tput setaf 1)version $$version of package $$package does not exist, doing nothing $$(tput setaf 7); \
	fi; \
	else echo $$(tput setaf 1)package $$package does not exist $$(tput setaf 7); \
	fi; \
	fi ;

test_remove: