//
//  OverlayScrollView.m
//  DotsApp
//
//  Created by Zakk Hoyt on 6/7/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "OverlayScrollView.h"

@implementation OverlayScrollView


-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitView = [super hitTest:point withEvent:event];
    if(hitView == self){
        return nil;
    }
    return hitView;
}

@end
