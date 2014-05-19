//
//  Tools.h
//  BHLibraries
//
//  Created by hepeilin on 14-5-19.
//  Copyright (c) 2014年 boyce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject
//获取序列号
+ (NSString*)getDeviceSerialNumber;
//验证是否是合法的email
+ (BOOL)isValidEmail:(NSString*)emailAdr;
//获取设备类型
+ (NSString*)getDeviceModel;

/**
 加文字随意
 @param img 需要加文字的图片
 @param text1 文字描述
 @returns 加好文字的图片
 */
+ (UIImage *)addText:(UIImage *)img text:(NSString *)text1;

/**
 加图片水印
 @param img 需要加logo图片的图片
 @param logo logo图片
 @returns 加好logo的图片
 */
+ (UIImage *)addImageLogo:(UIImage *)img text:(UIImage *)logo;
/**
 加半透明水印
 @param useImage 需要加水印的图片
 @param addImage1 水印
 @returns 加好水印的图片
 */
+ (UIImage *)addImage:(UIImage *)useImage addMsakImage:(UIImage *)maskImage;
@end
