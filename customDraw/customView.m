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
@property(nonatomic, strong) UITapGestureRecognizer* tapGesture;
@property(nonatomic, strong) NSNotificationCenter* notificationCenter;
@property (nonatomic,weak) UITextField* myTextField;
@property (nonatomic, strong) UITapGestureRecognizer* dissmissKeyTapGesture;

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
        [self.notificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [self.notificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

-(NSNotificationCenter *)notificationCenter{
    return [NSNotificationCenter defaultCenter];
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
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addTextField:)];
    [self addGestureRecognizer:tapGesture];
    self.tapGesture = tapGesture;
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

-(void)addTextField:(UITapGestureRecognizer*)sender{
    if ([self.delegate delegateTextModeisON]){
        [self.myTextField resignFirstResponder];
        CGPoint touchLocation = [sender locationInView:self];
        UITextField* textField = [[UITextField alloc]initWithFrame:CGRectMake(touchLocation.x - 100, touchLocation.y, 200,50)];
        textField.backgroundColor = [UIColor whiteColor];
        self.myTextField = textField;
        [self addSubview:textField];
    } else{
        
    }
}

-(void)keyboardWillShow:(NSNotification*)notification{
     [self removeGestureRecognizer:self.tapGesture];
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeKeyBoard:)];
        [self addGestureRecognizer:tapGesture];
        self.dissmissKeyTapGesture = tapGesture;
    
}

-(void)removeKeyBoard:(UITapGestureRecognizer*)sender{
    [self endEditing:YES];
}

-(void)keyboardWillHide:(NSNotification*)notification{
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addTextField:)];
    [self addGestureRecognizer:tapGesture];
    self.tapGesture = tapGesture;
}



- (void) dealloc{
    [self.notificationCenter removeObserver:self];
}
@end
