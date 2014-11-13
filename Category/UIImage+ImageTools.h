//
//  UIImage+ImageTools.h
//  JingYingHui
//
//  Created by hepeilin on 14-4-4.
//  Copyright (c) 2014年 YiPin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageTools)

-(UIImage*)getSubImage:(CGRect)rect;
-(UIImage*)getCentralImage:(CGSize)size;
+(UIImage*)createImageWithColor:(UIColor*)color;
+(UIImage*)imageWithUIView:(UIView*)view;
+ (UIImage *)createRoundedRectImage:(UIImage *)image size:(CGSize)size roundRadius:(CGFloat)radius;
-(UIImage*)fixImage;

- (UIImage *) renderAtSize:(const CGSize) size;
- (UIImage *) maskWithImage:(const UIImage *) maskImage;
- (UIImage *) maskWithColor:(UIColor *) color;

//******************* 2014.09.01 *****************************

+(UIImage *)imageFromText:(NSArray*)arrContent withFont:(CGFloat)fontSize;

//************************************************************



@end
