//
//  ViewController.m
//  customDraw
//
//  Created by Frank Chen on 2019-05-10.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

#import "ViewController.h"
#import "customView.h"

@interface ViewController () <getColor>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet customView *drawView;
@property (nonatomic,strong) UIColor* colorChosen;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    customView* customDrawView = self.drawView;
    customDrawView.delegate = self;
    
    self.containerView.hidden = YES;
    UITapGestureRecognizer* tapGestureRecog = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [self.containerView addGestureRecognizer:tapGestureRecog];
}

- (IBAction)changeColor:(UIButton *)sender {
    self.containerView.hidden = !self.containerView.hidden;
    if (self.containerView.isHidden) {
        self.drawView.userInteractionEnabled = YES;
    } else{
        self.drawView.userInteractionEnabled = NO;

    }
}

-(void)handleTap:(UITapGestureRecognizer*)sender{
    NSLog(@"tapping");

    CGPoint point = [sender locationInView:self.containerView];
    UIView* tappedView = [self.containerView hitTest:point withEvent:nil];
    
    self.colorChosen = tappedView.backgroundColor;
    NSLog(@"%@", self.colorChosen);
}

- (UIColor *)getColor{
    return self.colorChosen ? self.colorChosen : [UIColor blackColor];
}

@end
