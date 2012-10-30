//
//  UIAutomationBridge.m
//  PublicAutomation
//
//  Created by Pete Hodgson on 8/12/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//
#import "UIAutomationBridge.h"
#import "UIAutomation.h"
#import "KIFTypist.h"

#import "CGGeometry-KIFAdditions.h"

@implementation UIAutomationBridge

+ (UIASyntheticEvents *)uia{
    return [NSClassFromString(@"UIASyntheticEvents") sharedEventGenerator];
}

+ (UIATarget *)uiat{
    return [NSClassFromString(@"UIATarget") localTarget];
}

+ (BOOL) checkForKeyboard {
    return [KIFTypist keyboardWindow] != nil;
}

+ (BOOL) typeIntoKeyboard:(NSString *)string {
    NSLog( @"typing into keyboard: %@", string );
    return [KIFTypist enterText:string];
}

+ (CGPoint) tapView:(UIView *)view {
    return [self tapView:view atPoint:CGPointCenteredInRect(view.bounds)];
}

+ (CGPoint) tapView:(UIView *)view atPoint:(CGPoint)point{
    CGPoint tapPoint = [view convertPoint:point toView:nil];
    NSLog(@"tapping at (%.2f,%.2f)", tapPoint.x,tapPoint.y);
    [[self uia] sendTap:tapPoint];
    
    return tapPoint;
}

+ (void) setOrientation:(UIDeviceOrientation)orientation{
    [[self uia] setOrientation:(int)orientation];
}

+ (void) setLocation:(NSDictionary *)location{
    [[self uiat] setLocation:location];
}



// THESE MAGIC NUMBERS ARE IMPORTANT. From experimentation it appears that too big or too small a ration leads to
// gestures not being recognized as such by the system. For example setting the big ratio to 0.4 leads to
// swipe-to-delete not working on UITableViewCells.
// Also note that we always include at least a small component in each axes because in the past totally 'right-angled'
//swipes weren't detected properly. But we were using a different approach to touch simulation then,
//so this might now be unnecessary.
#define BIG_RATIO (0.3)
#define SMALL_RATIO (0.05)
#define SWIPE_DURATION (0.1)

//returns what portion of the view to swipe along in the x and y axes.
CGSize swipeRatiosForDirection(PADirection direction){
    switch (direction) {
        case PADirectionLeft:
            return CGSizeMake(-BIG_RATIO, SMALL_RATIO);
        case PADirectionRight:
            return CGSizeMake(BIG_RATIO, SMALL_RATIO);
        case PADirectionUp:
            return CGSizeMake(SMALL_RATIO, -BIG_RATIO);
        case PADirectionDown:
            return CGSizeMake(SMALL_RATIO, BIG_RATIO);
        default:
            [NSException raise:@"invalid swipe direction" format:@"swipe direction '%i' is invalid", direction];
            return CGSizeZero; // just here to stop the compiler whining.
    }
    }

+ (NSArray *) swipeView:(UIView *)view inDirection:(PADirection)dir {
    
    CGPoint swipeStart = [view convertPoint:CGPointCenteredInRect(view.bounds) toView:nil];
    CGSize ratios = swipeRatiosForDirection(dir);
    CGSize viewSize = view.bounds.size;
    CGPoint swipeEnd = CGPointMake(
                                   swipeStart.x+(ratios.width*viewSize.width),
                                   swipeStart.y+(ratios.height*viewSize.height)
                                   );
        
    [[UIAutomationBridge uia] sendDragWithStartPoint:swipeStart endPoint:swipeEnd duration:SWIPE_DURATION];
    
    return [NSArray arrayWithObjects:[NSValue valueWithCGPoint:swipeStart], [NSValue valueWithCGPoint:swipeEnd], nil];
}


+ (PADirection) parseDirection:(NSString *)direction{
    NSString *dir = [direction lowercaseString];
    
    if([dir isEqualToString:@"left"]){
        return PADirectionLeft;
    }else if([dir isEqualToString:@"right"]){
        return PADirectionRight;
    }else if([dir isEqualToString:@"up"]){
        return PADirectionUp;
    }else if([dir isEqualToString:@"down"]){
        return PADirectionDown;
    }else{
        [NSException raise:@"invalid swipe direction" format:@"swipe direction '%@' is invalid", direction];
        return 0;
    }
}

@end
