#import <Foundation/Foundation.h>
#import "../framework/Bug.h"

@interface InfectableBug : Bug {
    @private
    BOOL infected;
    int infectionStartIteration;
    int incubationPeriod;
    int infectionRadius;
}

- (id)    initWithWorld: (World*) aWorld
                   name: (NSString*) aName
                  layer: (NSString*) aLayer
               infected: (BOOL) anInfected
        infectionRadius: (int) anInfectionRadius
       incubationPeriod: (int) anIncubationPeriod
infectionStartIteration: (int) anInfectionStartIteration
        serializerClass: (Class) serializerClass;

- (NSArray*) scan;
- (void) infect;
- (BOOL) infected;
- (int) infectionRadius;
- (int) incubationPeriod;

@end
