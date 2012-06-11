//
//  F3EqualizerGauge.h
//  F3BarGaugeDemo
//
//  Created by Sergey Klimov on 6/8/12.
//  Copyright (c) 2012 Self-Employed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface F3EqualizerGauge : UIView
@property (readwrite, nonatomic, retain)     UIColor   *outerBorderColor;
@property (readwrite, nonatomic, retain)     UIColor   *innerBorderColor;
@property (readwrite, nonatomic, retain)     UIColor   *backgroundColor;
@property (readwrite, nonatomic, retain)     UIColor   *normalBarColor;
@property (readwrite, nonatomic, retain)     UIColor   *warningBarColor;
@property (readwrite, nonatomic, retain)     UIColor   *dangerBarColor;
@property (readwrite, nonatomic)  BOOL      litEffect;

@property (readwrite, nonatomic)  float     maxLimit;
@property (readwrite, nonatomic)  float     minLimit;
@property (readwrite, nonatomic)  int       numBars;
@property (readwrite, nonatomic)  int       numGauges;
@property (readwrite, nonatomic)  float vibration;
@property (readwrite, nonatomic)  float     value;


@end
