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
@property(nonatomic, strong) NSMutableArray* pathArray;
@property(nonatomic, strong) NSMutableArray* colorArray;
@property(nonatomic, strong) UIPanGestureRecognizer* panGesture;
@property(nonatomic,strong) NSMutableArray* velocityArray;
@property(nonatomic, assign) CGPoint velocity;

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
        _pathArray = [[NSMutableArray alloc]init];
        _colorArray = [[NSMutableArray alloc]init];
        _velocityArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    for (int i = 0; i < self.pathArray.count; i++) {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(ctx, [self.colorArray[i]CGColor]);
        [self.pathArray[i] setLineWidth: [self.velocityArray[i] floatValue]];
        [self.pathArray[i] stroke];
    }
}

-(void)setupGestureRecog{
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(addPoint:)];
    [self addGestureRecognizer:panGesture];
    self.panGesture = panGesture;
}

-(void)addPoint:(UIPanGestureRecognizer*)sender{
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.path = [[UIBezierPath alloc]init];
        [self.path moveToPoint:[sender locationInView:self]];
        [self.pathArray addObject:self.path];
        CGPoint velocity = [sender velocityInView:self];
        [self.velocityArray addObject: [NSNumber numberWithFloat: MAX(velocity.x, velocity.y) / 15]];
        if ([self.delegate getColor] == nil) {
            [self.colorArray addObject:[UIColor blackColor]];
        } else{
        [self.colorArray addObject:[self.delegate getColor]];
        }
    } else if (sender.state == UIGestureRecognizerStateChanged){
        [self.path addLineToPoint:[sender locationInView:self]];
        [self setNeedsDisplay];
    } else if (sender.state == UIGestureRecognizerStateEnded){

    }
}

@end
