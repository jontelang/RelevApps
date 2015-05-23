ARCHS = armv7 armv7s arm64

TARGET = iphone:clang:latest:7.0

THEOS_BUILD_DIR = Packages

include theos/makefiles/common.mk

BUNDLE_NAME = relevapps
relevapps_CFLAGS = -fobjc-arc
relevapps_FILES = relevappsSection.m relevappsSectionView.m
relevapps_INSTALL_PATH = /Library/CCLoader/Bundles
relevapps_FRAMEWORKS = Foundation UIKit

include $(THEOS_MAKE_PATH)/bundle.mk

after-install::
	install.exec "killall -9 backboardd"
SUBPROJECTS += relevappspreferences
# SUBPROJECTS += relevappstweakpart
include $(THEOS_MAKE_PATH)/aggregate.mk
