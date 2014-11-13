//
//  UIImage+ImageTools.m
//  JingYingHui
//
//  Created by hepeilin on 14-4-4.
//  Copyright (c) 2014年 YiPin. All rights reserved.
//

#import "UIImage+ImageTools.h"
#define CONTENT_MAX_WIDTH   300.0f



void getOrinetationFixTransform(UIImage *image, CGAffineTransform *T)
{
    UIImageOrientation orientation = image.imageOrientation;
    
    CGAffineTransform fixT = CGAffineTransformIdentity;
    
    switch (orientation) {
        case UIImageOrientationUp: // EXIF 1
            break;
        case UIImageOrientationDown: // EXIF 3
            fixT = CGAffineTransformRotate(fixT, M_PI);
            break;
        case UIImageOrientationLeft: // EXIF 6
            fixT = CGAffineTransformRotate(fixT, M_PI/2.0);
            break;
        case UIImageOrientationRight: // EXIF 8
            fixT = CGAffineTransformRotate(fixT, 3.0*M_PI/2.0);
            break;
        case UIImageOrientationUpMirrored: // EXIF 2
            fixT = CGAffineTransformScale(fixT, -1, 1);
            break;
        case UIImageOrientationDownMirrored: // EXIF 4
            fixT = CGAffineTransformScale(fixT, 1, -1);
            break;
        case UIImageOrientationLeftMirrored: // EXIF 5
            fixT = CGAffineTransformScale(fixT, -1, 1);
            fixT = CGAffineTransformRotate(fixT, 3.0*M_PI/2.0);
            break;
        case UIImageOrientationRightMirrored: // EXIF 7
            fixT = CGAffineTransformScale(fixT, -1, 1);
            fixT = CGAffineTransformRotate(fixT, M_PI/2.0);
            break;
    }
    
    *T = fixT;
}

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

@implementation UIImage (ImageTools)

-(UIImage*)getSubImage:(CGRect)rect
{
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
 
}

+ (UIImage *)createRoundedRectImage:(UIImage *)image size:(CGSize)size roundRadius:(CGFloat)radius {
    
    if (!radius)
        radius = 8;

    int w = image.size.width;
    int h = image.size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, radius, radius);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage:imageMasked];
    
}


-(UIImage*)getCentralImage:(CGSize)size
{
    float w = 0;
    float h = 0;
    float x = 0;
    float y = 0;
    
    if (size.width > self.size.width*self.scale) {
        
         w = self.size.width*self.scale;
    }
    else
    {
       w = size.width;
    }
    
    if (size.height > self.size.height*self.scale) {
        
         h = self.size.height*self.scale;
    }
    else
    {
       h = size.height;
    }
    
    x = (self.size.width*self.scale - size.width)/2.0;
    y = (self.size.height*self.scale - size.height)/2.0;

    CGRect rect = CGRectMake(x, y, w, h);
    return [self getSubImage:rect];
  
}

+(UIImage*)createImageWithColor:(UIColor*)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage*)imageWithUIView:(UIView*)view
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef currnetContext = UIGraphicsGetCurrentContext();
    //[view.layer drawInContext:currnetContext];
    [view.layer renderInContext:currnetContext];
    // 从当前context中创建一个改变大小后的图片
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    return image;
}


-(UIImage*)fixImage
{
    CGSize imageSize = self.size;
    
    CGImageRef cgImage = [self CGImage];
    CGFloat cgWidth = CGImageGetWidth(cgImage);
    CGFloat cgHeight = CGImageGetHeight(cgImage);
    
    UIGraphicsBeginImageContext(imageSize);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(ctx, 0.3, 0, 0, 1.0);
    CGContextFillRect(ctx, CGRectMake(0, 0, imageSize.width, imageSize.height));
    
    CGAffineTransform T = CGAffineTransformIdentity;
    CGAffineTransform reorientT = CGAffineTransformMakeRotation(M_PI/12.0);
    
    getOrinetationFixTransform(self, &reorientT);
    
    T = CGAffineTransformConcat(T, CGAffineTransformMakeTranslation(-cgWidth*0.5, -cgHeight*0.5) );
    T = CGAffineTransformConcat(T, reorientT);
    T = CGAffineTransformConcat(T, CGAffineTransformMakeScale(1, -1));
    T = CGAffineTransformConcat(T, CGAffineTransformMakeTranslation(imageSize.width*0.5, imageSize.height*0.5));
    
    CGContextConcatCTM(ctx, T);
    
    CGContextDrawImage(ctx, CGRectMake(0, 0, cgWidth, cgHeight), cgImage);
    
    UIImage *fixed = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return fixed;
    

}


// Render a UIImage at the specified size. This is needed to render out the resizable image mask before sending it to maskImage:withMask:
- (UIImage *) renderAtSize:(const CGSize) size
{
    UIGraphicsBeginImageContext(size);
    const CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    const CGImageRef cgImage = CGBitmapContextCreateImage(context);
    UIImage *renderedImage = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    UIGraphicsEndImageContext();
    
    return renderedImage;
}

- (UIImage *) maskWithImage:(const UIImage *) maskImage
{
    const CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    const CGImageRef maskImageRef = maskImage.CGImage;
    
    const CGContextRef mainViewContentContext = CGBitmapContextCreate (NULL, maskImage.size.width, maskImage.size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    
    if (! mainViewContentContext)
    {
        return nil;
    }
    
    CGFloat ratio = maskImage.size.width / self.size.width;
    
    if (ratio * self.size.height < maskImage.size.height)
    {
        ratio = maskImage.size.height / self.size.height;
    }
    
    const CGRect maskRect  = CGRectMake(0, 0, maskImage.size.width, maskImage.size.height);
    
    const CGRect imageRect  = CGRectMake(-((self.size.width * ratio) - maskImage.size.width) / 2,
                                         -((self.size.height * ratio) - maskImage.size.height) / 2,
                                         self.size.width * ratio,
                                         self.size.height * ratio);
    
    CGContextClipToMask(mainViewContentContext, maskRect, maskImageRef);
    CGContextDrawImage(mainViewContentContext, imageRect, self.CGImage);
    
    CGImageRef newImage = CGBitmapContextCreateImage(mainViewContentContext);
    CGContextRelease(mainViewContentContext);
    
    UIImage *theImage = [UIImage imageWithCGImage:newImage];
    
    CGImageRelease(newImage);
    
    return theImage;
    
}

/*
 maskWithColor
 takes a (grayscale) image and 'tints' it with the supplied color.
 */
- (UIImage *) maskWithColor:(UIColor *) color
{
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    CGRect bounds = CGRectMake(0,0,width,height);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL, width, height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextClipToMask(bitmapContext, bounds, self.CGImage);
    CGContextSetFillColorWithColor(bitmapContext, color.CGColor);
    CGContextFillRect(bitmapContext, bounds);
    
    CGImageRef cImage = CGBitmapContextCreateImage(bitmapContext);
    UIImage *coloredImage = [UIImage imageWithCGImage:cImage];
    
    CGContextRelease(bitmapContext);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(cImage);
    
    return coloredImage;
    
}

//******************* 2014.09.01 *****************************


+(UIImage *)imageFromText:(NSArray*)arrContent withFont: (CGFloat)fontSize
{
    // set the font type and size
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSMutableArray *arrHeight = [[NSMutableArray alloc] initWithCapacity:arrContent.count];
    
    CGFloat fHeight = 0.0f;
    for (NSString *sContent in arrContent) {
        CGSize stringSize = [sContent sizeWithFont:font constrainedToSize:CGSizeMake(CONTENT_MAX_WIDTH, 10000) lineBreakMode:NSLineBreakByWordWrapping];
        [arrHeight addObject:[NSNumber numberWithFloat:stringSize.height]];
        
        fHeight += stringSize.height;
    }
    
    
    CGSize newSize = CGSizeMake(CONTENT_MAX_WIDTH+20, fHeight+50);
    
    UIGraphicsBeginImageContextWithOptions(newSize,NO,0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetCharacterSpacing(ctx, 10);
  //  CGContextSetTextDrawingMode (ctx, kCGTextFillStroke);
    CGContextSetRGBFillColor (ctx, 0.1, 0.2, 0.3, 1); // 6
    CGContextSetRGBStrokeColor (ctx, 0, 0, 0, 1);
    
    int nIndex = 0;
    CGFloat fPosY = 20.0f;
    for (NSString *sContent in arrContent) {
        NSNumber *numHeight = [arrHeight objectAtIndex:nIndex];
        CGRect rect = CGRectMake(10, fPosY, CONTENT_MAX_WIDTH , [numHeight floatValue]);
        
        [sContent drawInRect:rect withFont:font lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
        
        fPosY += [numHeight floatValue];
        nIndex++;
    }
    // transfer image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}


//************************************************************





@end
