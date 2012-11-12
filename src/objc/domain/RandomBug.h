#import <Foundation/Foundation.h>
#import "../framework/Bug.h"

@interface RandomBug : Bug
    @property NSMutableArray* possibleDirectionDeltas;

- (id) init;
@end
