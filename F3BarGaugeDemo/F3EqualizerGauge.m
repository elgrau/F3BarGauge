//
//  F3EqualizerGauge.m
//  F3BarGaugeDemo
//
//  Created by Sergey Klimov on 6/8/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "F3EqualizerGauge.h"
#import "F3BarGauge.h"
@implementation F3EqualizerGauge {
    NSArray *barGauges;
}
@synthesize outerBorderColor = _outerBorderColor;
@synthesize backgroundColor = _backgroundColor;
@synthesize maxLimit = _maxLimit;
@synthesize innerBorderColor = _innerBorderColor;
@synthesize dangerBarColor = _dangerBarColor;
@synthesize minLimit = _minLimit;
@synthesize numGauges = _numGauges;
@synthesize warningBarColor = _warningBarColor;
@synthesize numBars = _numBars;
@synthesize normalBarColor = _normalBarColor;
@synthesize vibration = _vibration;
@synthesize value = _value;
@synthesize litEffect = _litEffect;


-(void) runOnAllGauges:(void(^)(F3BarGauge* barGauge))runBlock{
    [barGauges enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        runBlock(obj);
    }];
}


- (void)setInnerBorderColor:(UIColor *)anInnerBorderColor
{
    [self runOnAllGauges:^(F3BarGauge *barGauge) {
        barGauge.innerBorderColor = anInnerBorderColor;
    }];
    [_innerBorderColor release];
    _innerBorderColor = [anInnerBorderColor retain];
}

- (void) setOuterBorderColor:(UIColor *)outerBorderColor {
    [self runOnAllGauges:^(F3BarGauge *barGauge) {
        barGauge.outerBorderColor = outerBorderColor;
    }];
    [_outerBorderColor release];
    
    _outerBorderColor   = [outerBorderColor retain];

}

- (void)setBackgroundColor:(UIColor *)aBackgroundColor
{
    [self runOnAllGauges:^(F3BarGauge *barGauge) {
        barGauge.backgroundColor = aBackgroundColor;
    }];
    [_backgroundColor release];
    _backgroundColor = [aBackgroundColor retain];
}


- (void)setNormalBarColor:(UIColor *)aNormalBarColor
{
    [self runOnAllGauges:^(F3BarGauge *barGauge) {
        barGauge.normalBarColor = aNormalBarColor;
    }];
    [_normalBarColor release];
    _normalBarColor = [aNormalBarColor retain];
}


- (void)setDangerBarColor:(UIColor *)aDangerBarColor
{
    [self runOnAllGauges:^(F3BarGauge *barGauge) {
        barGauge.dangerBarColor = aDangerBarColor;
    }];
    [_dangerBarColor release];
    _dangerBarColor = [aDangerBarColor retain];
}

-(void) setWarningBarColor:(UIColor *)warningBarColor {
    [self runOnAllGauges:^(F3BarGauge *barGauge) {
        barGauge.warningBarColor = warningBarColor;
    }];
    [_warningBarColor release];
    _warningBarColor = [warningBarColor retain];
}


- (void)setNumBars:(int)aNumBars
{
    [self runOnAllGauges:^(F3BarGauge *barGauge) {
        barGauge.numBars = aNumBars;
    }];
    
    _numBars = aNumBars;
}




- (void)setLitEffect:(BOOL)aLitEffect
{
    [self runOnAllGauges:^(F3BarGauge *barGauge) {
        barGauge.litEffect = aLitEffect;
    }];
    _litEffect = aLitEffect;
}





- (void)setNumGauges:(int)aNumGauges
{
    _numGauges = aNumGauges;
    [self resetGauges];
}

- (float)randomValueForOldValue:(float)d
{
    float absoluteVibration = (_vibration/2.0)*(_maxLimit-_minLimit);
    float result = [self randomFloatBetween:d-absoluteVibration and:d];
    return result;
}

- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

- (void)setValue:(float)aValue
{
    float segmentWidth = (_maxLimit-_minLimit)/_numGauges;
    [barGauges enumerateObjectsUsingBlock:^(F3BarGauge *gauge, NSUInteger idx, BOOL*stop) {
        gauge.minLimit = 0.0;
        gauge.maxLimit = segmentWidth;
        float currentMin = _minLimit+idx*segmentWidth;
        float currentMax = _minLimit+(idx+1)*segmentWidth;
        BOOL currentGauge = NO;
        if (_value<currentMax&&_value>currentMin) {
             gauge.value = [self randomFloatBetween:gauge.minLimit and:gauge.maxLimit];

        }
        if (aValue<currentMax&&aValue>currentMin) {
            currentGauge = YES;
            gauge.value = aValue-currentMin;
        }
        if (!currentGauge) {
            gauge.value = [self randomValueForOldValue:gauge.value];
        }
    }];
    _value = aValue;

}


-(void) setDefaults
{

    _numGauges = 7;
    _minLimit = 0;
    _maxLimit = 100;
    _vibration = 0.0024;
}


- (void)resetGauges
{
    for (F3BarGauge * gauge in barGauges) {
        [gauge removeFromSuperview];
    }
    NSMutableArray *mBarGauges = [NSMutableArray array];

    for (int i=0; i<_numGauges; i++) {
        CGFloat width = self.frame.size.width/_numGauges;
        CGFloat height = self.frame.size.height;

        CGRect frame = CGRectMake(i*width, 0, width, height);
        F3BarGauge *gauge = [[[F3BarGauge alloc] initWithFrame:frame] autorelease];
        gauge.litEffect = _litEffect;
        gauge.numBars = _numBars;
        gauge.backgroundColor = _backgroundColor;
        gauge.dangerBarColor = _dangerBarColor;
        gauge.innerBorderColor = _innerBorderColor;
        gauge.normalBarColor = _normalBarColor;
        gauge.outerBorderColor = _outerBorderColor;
        gauge.warningBarColor = _warningBarColor;
        [mBarGauges addObject:gauge];
        [self addSubview:gauge];
    }

    [barGauges release];
    barGauges = [[NSArray alloc] initWithArray:mBarGauges];

}

//  Method: initWithFrame:
//    Designated initializer
//
-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        // Assign default values
        [self setDefaults];
        [self resetGauges];

    }
    return self;
}


//------------------------------------------------------------------------
// Method:  initWithCoder:
//  Initializes the instance when brought from nib, etc.
//
-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        // Assign default values
        [self setDefaults];
        [self resetGauges];
    }
    return self;
}


- (void)dealloc
{
    [super dealloc];
    [barGauges release];

    [_outerBorderColor release];
    [_backgroundColor release];
    [_innerBorderColor release];
    [_dangerBarColor release];
    [_warningBarColor release];
    [_normalBarColor release];
}

@end
