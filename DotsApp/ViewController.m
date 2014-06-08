//
//  ViewController.m
//  DotsApp
//
//  Created by Zakk Hoyt on 6/7/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//


#import "ViewController.h"
#import "DotsView.h"
#import "DotView.h"
#import "UIColor+Custom.h"
#import "OverlayScrollView.h"
#import "TouchDelayGestureRecognizer.h"


@interface ViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet DotsView *canvasView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIVisualEffectView *drawerView;
@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat w = self.view.bounds.size.width;
    CGFloat h = self.view.bounds.size.height;
    CGFloat drawerHeight = 650;
    [self addDots:30 toView:self.canvasView];
    
    self.scrollView = [[OverlayScrollView alloc]initWithFrame:self.view.bounds];
    self.scrollView.bounces = NO;
    self.scrollView.alwaysBounceVertical = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(w, h + drawerHeight);
    self.scrollView.backgroundColor = [UIColor colorWithRed:0.5 green:0 blue:0 alpha:0.2];
    
    [self.view addSubview:self.scrollView];
    
    TouchDelayGestureRecognizer *touchDelay = [[TouchDelayGestureRecognizer alloc]initWithTarget:nil action:nil];
    [self.canvasView addGestureRecognizer:touchDelay];
    
    self.drawerView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    self.drawerView.frame = CGRectMake(0, 0, w, drawerHeight);
    [self addDots:10 toView:self.drawerView.contentView];
    
    [self.scrollView addSubview:self.drawerView];
    self.scrollView.contentOffset = CGPointMake(0, drawerHeight);
    
    [self.view addGestureRecognizer:self.scrollView.panGestureRecognizer];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addDots:(NSUInteger)count toView:(UIView*)view{
    for(NSUInteger index = 0; index < 20; index++){
        // random from 22 - 64
        float radius = arc4random() % 40;
        radius += 8;
        
        float x = arc4random() % (NSInteger)self.view.bounds.size.width - radius;
        float y = arc4random() % (NSInteger)self.view.bounds.size.height - radius;
        
        DotView *dotView = [[DotView alloc]initWithFrame:CGRectMake(x, y, radius * 2, radius * 2) color:[UIColor randomColor]];
        [view addSubview:dotView];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
        longPress.cancelsTouchesInView = NO;
        longPress.delegate = self;
        [dotView addGestureRecognizer:longPress];
    }

}

-(void)handleLongPress:(UILongPressGestureRecognizer*)gesture{
    UIView *dot = gesture.view;
    
    switch (gesture.state){
        case UIGestureRecognizerStateBegan:
            [self grabDot:dot withGesture:gesture];
            break;
        case UIGestureRecognizerStateChanged:
            [self moveDot:dot withGesture:gesture];
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            [self dropDot:dot withGesture:gesture];
            break;
        default:
            break;
    }
}


-(void)grabDot:(UIView*)dot withGesture:(UIGestureRecognizer*)gesture{
    dot.center = [self.view convertPoint:dot.center fromView:dot.superview];
    [self.view addSubview:dot];
    
    [UIView animateWithDuration:0.2 animations:^{
        dot.transform = CGAffineTransformMakeScale(1.2, 1.2);
        dot.alpha = 0.8;
        [self moveDot:dot withGesture:gesture];
    }];
    
    
    self.scrollView.panGestureRecognizer.enabled = NO;
    self.scrollView.panGestureRecognizer.enabled = YES;
}

-(void)moveDot:(UIView*)dot withGesture:(UIGestureRecognizer*)gesture{
    dot.center = [gesture locationInView:self.view];
}

-(void)dropDot:(UIView*)dot withGesture:(UIGestureRecognizer*)gesture{
    [UIView animateWithDuration:0.2 animations:^{
        dot.transform = CGAffineTransformIdentity;
        dot.alpha = 1.0;
    }];

    CGPoint locationInDrawer = [gesture locationInView:self.drawerView];
    if(CGRectContainsPoint(self.drawerView.bounds, locationInDrawer)){
        [self.drawerView.contentView addSubview:dot];
    } else {
        [self.canvasView addSubview:dot];
    }
    
    dot.center = [self.view convertPoint:dot.center toView:dot.superview];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
    
}
@end
