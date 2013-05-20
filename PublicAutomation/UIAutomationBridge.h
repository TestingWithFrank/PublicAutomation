//
//  UIAutomationBridge.h
//  PublicAutomation
//
//  Created by Pete Hodgson on 8/12/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//
@class UIASyntheticEvents;
@class UIATarget;

typedef enum  {
    PADirectionLeft,
    PADirectionRight,
    PADirectionUp,
    PADirectionDown
}PADirection;


@interface UIAutomationBridge : NSObject

+ (UIASyntheticEvents *) uia;
+ (UIATarget *) uiat;

+ (BOOL) checkForKeyboard;
+ (BOOL) typeIntoKeyboard:(NSString *)string;
+ (void) setOrientation:(UIDeviceOrientation)orientation;

// It would be a slightly nicer API if we used CLLocation here instead of CGPoint, but that would
/// mean pulling in the whole CoreLocation framework, which seems a bit over-the-top for just this one method.
+ (void) setLocation:(CGPoint)locationAsPoint;

+ (CGPoint) tapView:(UIView *)view;
+ (CGPoint) tapPoint:(CGPoint)point;
+ (CGPoint) tapView:(UIView *)view atPoint:(CGPoint)point;
+ (CGPoint) downView:(UIView *)view;
+ (CGPoint) downView:(UIView *)view atPoint:(CGPoint)point;
+ (CGPoint) downPoint:(CGPoint)point;
+ (CGPoint) upView:(UIView *)view;
+ (CGPoint) upView:(UIView *)view atPoint:(CGPoint)point;
+ (CGPoint) upPoint:(CGPoint)point;
+ (CGPoint) longTapView:(UIView *)view forDuration:(NSTimeInterval)duration;
+ (CGPoint) longTapView:(UIView *)view atPoint:(CGPoint)point forDuration:(NSTimeInterval)duration;
+ (CGPoint) longTapPoint:(CGPoint)point forDuration:(NSTimeInterval)duration;
+ (CGPoint) doubleTapView:(UIView *)view;
+ (CGPoint) doubleTapPoint:(CGPoint)point;
+ (CGPoint) doubleTapView:(UIView *)view atPoint:(CGPoint)point;

+ (void) dragViewWithInitialDelay:(UIView *)view toPoint:(CGPoint)destPoint duration:(NSTimeInterval)duration;
+ (void) dragViewWithInitialDelay:(UIView *)view toPoint:(CGPoint)destPoint;

+ (NSArray *) swipeView:(UIView *)view inDirection:(PADirection)dir;


+ (PADirection) parseDirection:(NSString *)direction;

// Returns false if value is outside of the slider's range. Returns true otherwise.
+ (BOOL)dragThumbInSlider:(UISlider*)slider toValue:(double)value withDuration:(NSTimeInterval)duration;
+ (BOOL)dragThumbInSlider:(UISlider*)slider toValue:(double)value;
@end
