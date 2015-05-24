ARCHS = armv7 armv7s arm64

TARGET = iphone:clang:latest:7.0

include theos/makefiles/common.mk

BUNDLE_NAME = relevappspreferences
relevappspreferences_FILES = relevappspreferences.mm
relevappspreferences_INSTALL_PATH = /Library/PreferenceBundles
relevappspreferences_FRAMEWORKS = UIKit
relevappspreferences_PRIVATE_FRAMEWORKS = Preferences
relevappspreferences_LIBRARIES = applist

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/relevappspreferences.plist$(ECHO_END)
