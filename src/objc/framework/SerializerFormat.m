//
// Created by vivin on 9/21/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "SerializerFormat.h"

@implementation SerializerFormat

- (id) initWithFormatName: (NSString *) aFormatName {
    self = [super init];
    if (self) {
        _formatName = aFormatName;
    }

    return self;
}

- (NSString *) format {
    return _formatName;
}

@end