#import <Foundation/Foundation.h>
#import "../framework/Bug.h"

@interface InfectableBug : Bug
    @property BOOL infected;
    @property(readonly) NSUInteger infectionStartIteration;
    @property NSUInteger incubationPeriod;
    @property NSUInteger infectionRadius;

- (id)    initWithWorld: (World*) aWorld
                   name: (NSString*) aName
                  layer: (NSString*) aLayer
               infected: (BOOL) anInfected
        infectionRadius: (NSUInteger) anInfectionRadius
       incubationPeriod: (NSUInteger) anIncubationPeriod
infectionStartIteration: (NSUInteger) anInfectionStartIteration;

- (NSArray*) scan;
- (void) infect;

@end
