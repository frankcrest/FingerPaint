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
        self.backgroundColor = [UIColor magentaColor];
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
        if ([self.delegate getColor] == nil && [self.delegate eraserModeOn] == nil) {
            [self.velocityArray addObject: [NSNumber numberWithFloat: sqrt(velocity.x*velocity.x + velocity.y*velocity.y) / 20]];
            [self.colorArray addObject:[UIColor blackColor]];
        } else if ([self.delegate getColor] != nil && [self.delegate eraserModeOn] == nil){
            [self.velocityArray addObject: [NSNumber numberWithFloat: sqrt(velocity.x*velocity.x + velocity.y*velocity.y) / 20]];
            [self.colorArray addObject:[self.delegate getColor]];
        } else if ([self.delegate eraserModeOn]){
            [self.velocityArray addObject:[NSNumber numberWithFloat:100]];
            [self.colorArray addObject:[self.delegate eraserModeOn]];
        }
    } else if (sender.state == UIGestureRecognizerStateChanged){
        [self.path addLineToPoint:[sender locationInView:self]];
        [self setNeedsDisplay];
    } else if (sender.state == UIGestureRecognizerStateEnded){
        
    }
}

@end
