TARGET = :clang
ARCHS = armv7 arm64

include theos/makefiles/common.mk

TWEAK_NAME = MorningApp
MorningApp_FILES = Tweak.xm
MorningApp_LIBRARIES = applist
MorningApp_FRAMEWORKS = UIKit
SHARED_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 backboardd"

SUBPROJECTS += morningappprefs
include $(THEOS_MAKE_PATH)/aggregate.mk