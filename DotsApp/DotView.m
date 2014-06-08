//
//  DotView.m
//  DotsApp
//
//  Created by Zakk Hoyt on 6/7/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "DotView.h"

@interface DotView (){
    UIColor *_color;
    UIColor *_highlightedColor;
}

@end
@implementation DotView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor*)color
{
    self = [super initWithFrame:frame];
    if (self) {
        _color = color;
        
        CGFloat r, g, b, a;
        [_color getRed:&r green:&g blue:&b alpha:&a];
        _highlightedColor = [UIColor colorWithRed:r/2.0 green:g/2.0 blue:b/2.0 alpha:a];
        self.backgroundColor = _color;
        self.layer.cornerRadius = self.bounds.size.width / 2.0;
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    self.backgroundColor = _highlightedColor;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self endTouches:touches withEvent:event];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self endTouches:touches withEvent:event];
}

-(void)endTouches:(NSSet *)touches withEvent:(UIEvent *)event{
        self.backgroundColor = _color;
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    CGRect touchBounds = self.bounds;
    if(self.bounds.size.width < 44.0){
        CGFloat expansion = 44 - self.bounds.size.width;
        touchBounds = CGRectInset(touchBounds, -expansion, -expansion);
    }
    return CGRectContainsPoint(touchBounds, point);
}


@end
