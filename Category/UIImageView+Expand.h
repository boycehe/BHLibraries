//
//  UIImageView+Expand.h
//  BHLibraries
//
//  Created by hepeilin on 11/13/14.
//  Copyright (c) 2014 boyce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Expand)

/**
 *  根据UIImageView的Frame自动截取图片中间内容，防止图片压缩或者拉伸产生的变形
 */
- (void)adjustCenralFrame;

@end
