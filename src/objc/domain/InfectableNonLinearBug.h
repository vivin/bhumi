//
// Created by vivin on 9/30/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "Bug.h"
#import "InfectableNonLinearBugState.h"

@class World;
@class World;

@interface InfectableNonLinearBug : Bug

    @property InfectableNonLinearBugState state;
    @property(readonly) NSUInteger infectionStartIteration;
    @property(readonly) NSUInteger incubationPeriod;
    @property(readonly) NSUInteger infectionPeriod;
    @property(readonly) NSUInteger infectionRadius;
    @property(readonly) NSUInteger alertRadius;
    @property(readonly) NSUInteger mortalityRate;

- (id) initWithWorld: (World *) aWorld
                name: (NSString *) aName
               layer: (NSString *) aLayer
               state: (InfectableNonLinearBugState) aState
    incubationPeriod: (NSUInteger) anIncubationPeriod
     infectionPeriod: (NSUInteger) anInfectionPeriod
     infectionRadius: (NSUInteger) anInfectionRadius
         alertRadius: (NSUInteger) anAlertRadius
       mortalityRate: (NSUInteger) aMortalityRate;

+ (id) objectWithWorld: (World *) aWorld
                  name: (NSString *) aName
                 layer: (NSString *) aLayer
                 state: (InfectableNonLinearBugState) aState
      incubationPeriod: (NSUInteger) anIncubationPeriod
       infectionPeriod: (NSUInteger) anInfectionPeriod
       infectionRadius: (NSUInteger) anInfectionRadius
           alertRadius: (NSUInteger) anAlertRadius
         mortalityRate: (NSUInteger) aMortalityRate;

- (NSArray *) scanForState: (InfectableNonLinearBugState) bugState withinRadius: (NSUInteger) radius;
- (void) infect;

@end