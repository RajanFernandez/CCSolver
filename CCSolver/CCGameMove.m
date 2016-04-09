//
//  CCGameMove.m
//  Code Cracker Solver
//
//  Created by Rajan Fernandez on 7/02/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

#import "CCGameMove.h"

@implementation CCGameMove

+(instancetype)initWithOptions:(NSArray *)options andOptionIndex:(NSUInteger)index forWord:(CCWord *)word {
    CCGameMove *instance = [[[self class] alloc] init];
    instance.options = [options copy];
    instance.optionIndex = index;
    instance.unsolvedWord = [word copy];
    return instance;
}

-(NSString *)solution {
    return _options[_optionIndex];
}

-(char)characterForIndex:(NSUInteger)index {
    char character = [self.solution characterAtIndex:index];
    return character;
}

-(BOOL)isOnLastOption {
    return _optionIndex == [_options count] - 1;
}

-(void)goToNextOption {
    if (![self isOnLastOption]) {
        _optionIndex++;
    }
}

@end
