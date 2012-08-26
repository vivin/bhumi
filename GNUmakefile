include $(GNUSTEP_MAKEFILES)/common.make

APP_NAME = BhumiApp

BhumiApp_HEADER_FILES = src/objc/framework/Bug.h src/objc/framework/NSMutableArray+Shuffle.h src/objc/framework/World.h src/objc/framework/BugProtocol.h src/objc/domain/RandomBug.h 
BhumiApp_OBJC_FILES = src/objc/framework/Bug.m src/objc/framework/World.m src/objc/framework/NSMutableArray+Shuffle.m src/objc/domain/RandomBug.m src/objc/main.m 
ADDITIONAL_TOOL_LIBS = -l:libbsd.so.0

include $(GNUSTEP_MAKEFILES)/application.make

