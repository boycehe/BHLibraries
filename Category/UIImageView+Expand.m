//
//  UIImageView+Expand.m
//  BHLibraries
//
//  Created by hepeilin on 11/13/14.
//  Copyright (c) 2014 boyce. All rights reserved.
//

#import "UIImageView+Expand.h"
#import "UIImage+ImageTools.h"

@implementation UIImageView (Expand)

- (void)adjustCenralFrame{
    
    
    UIImage *image = self.image;
    
    CGFloat w = image.size.width*image.scale;
    CGFloat h = image.size.height*image.scale;
    
    CGFloat rateImage = w/h;
    CGFloat rateView = self.frame.size.width/self.frame.size.height;
    
    CGSize  imageSize = image.size;
    
    
    if (rateImage > rateView) {
        
        imageSize.height = h;
        imageSize.width = rateView*h;
        
    }else if (rateView > rateImage){
        
        imageSize.width = w;
        imageSize.height =  1/rateView*w;
        
        
    }

    NSLog(@"new size ::%@",NSStringFromCGSize(imageSize));
    
    image = [image getCentralImage:imageSize];
    self.image = image;

}

@end
