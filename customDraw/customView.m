//
//  customView.m
//  customDraw
//
//  Created by Frank Chen on 2019-05-10.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

#import "customView.h"

@interface customView ()

@property(nonatomic, strong) UIBezierPath* path;
@end

@implementation customView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupGestureRecog];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupGestureRecog];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    NSLog(@"drawing");
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, [[UIColor redColor]CGColor]);
    [self.path setLineWidth:10];
    [self.path stroke];
}

-(void)setupGestureRecog{
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPoint:)];
    [self addGestureRecognizer:tapGesture];
}

-(void)addPoint:(UITapGestureRecognizer*)sender{
    
        if (!self.path) {
            self.path = [[UIBezierPath alloc]init];
            [self.path moveToPoint:[sender locationInView:self]];
        } else{
            [self.path addLineToPoint:[sender locationInView:self]];
        }
    [self setNeedsDisplay];
}

@end
