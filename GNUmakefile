include $(GNUSTEP_MAKEFILES)/common.make

APP_NAME = BhumiApp

BhumiApp_HEADER_FILES = src/objc/framework/Bug.h src/objc/framework/NSMutableArray+Shuffle.h src/objc/framework/World.h src/objc/framework/BugProtocol.h src/objc/framework/ToStringSerializerProtocol.h src/objc/framework/WorldToStringSerializer.h src/objc/framework/BugToStringSerializer.h src/objc/framework/SerializerFormat.h src/objc/framework/WorldJsonSerializer.h src/objc/domain/RandomBug.h src/objc/domain/RandomBugJsonSerializer.h src/objc/domain/InfectableBug.h src/objc/InfectableBugJsonSerializer.h
BhumiApp_OBJC_FILES = src/objc/framework/Bug.m src/objc/framework/World.m src/objc/framework/WorldToStringSerializer.m src/objc/framework/BugToStringSerializer.m src/objc/framework/WorldJsonSerializer.m src/objc/framework/NSMutableArray+Shuffle.m src/objc/domain/RandomBug.m src/objc/domain/RandomBugJsonSerializer.m src/objc/domain/InfectableBug.m src/objc/domain/InfectableBugJsonSerializer.m src/objc/main.m 
ADDITIONAL_TOOL_LIBS = -l:libbsd.so.0
ADDITIONAL_FLAGS += -std=gnu99

include $(GNUSTEP_MAKEFILES)/application.make

