//
//  customView.h
//  customDraw
//
//  Created by Frank Chen on 2019-05-10.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol getColor <NSObject>

-(UIColor*)getColor;
-(UIColor*)eraserModeOn;

@end

@interface customView : UIView

@property (nonatomic,weak) id<getColor>delegate;

@end

NS_ASSUME_NONNULL_END
