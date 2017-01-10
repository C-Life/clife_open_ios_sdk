//
//  ColorButton.m
//  HETOpenSDKDemo
//
//  Created by mr.cao on 16/4/16.
//  Copyright © 2016年 mr.cao. All rights reserved.
//

#import "ColorButton.h"

@implementation ColorButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // add subviews
    }
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    //// Bezier Drawing
    if(self.selected)
    {
      UIBezierPath* bezierPath = UIBezierPath.bezierPath;
      [bezierPath moveToPoint: CGPointMake(self.frame.size.width*0.2, self.frame.size.height/2)];
      [bezierPath addCurveToPoint: CGPointMake(self.frame.size.width*0.5,self.frame.size.height/2+self.frame.size.height*0.2) controlPoint1: CGPointMake(self.frame.size.width*0.5-1,self.frame.size.height/2 +self.frame.size.height*0.2) controlPoint2: CGPointMake(self.frame.size.width*0.5,self.frame.size.height/2+self.frame.size.height*0.2)];
      [bezierPath addLineToPoint: CGPointMake(self.frame.size.width*0.8, 10.5)];
      [UIColor.whiteColor setStroke];
      bezierPath.lineWidth = 1;
      [bezierPath stroke];
    }

    
    
}


@end
