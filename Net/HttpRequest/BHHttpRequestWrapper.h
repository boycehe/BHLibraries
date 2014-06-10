//
//  BHHttpRequestWrapper.h
//  BHJingYingHui
//
//  Created by hepeilin on 14-6-3.
//  Copyright (c) 2014年 boyce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface BHHttpRequestWrapper : NSObject

+ (BHHttpRequestWrapper*)shareManger;
+ (void)cleanApiOperationQueue;
+ (void)cleanImgOperationQueue;

- (id)BHHttpRequestGET:(NSString *)URLString
            parameters:(id)parameters
             SaveCache:(BOOL)isSave
               success:(void (^)(AFHTTPRequestOperationManager *manager, id responseObject))succBlock
               failure:(void (^)(AFHTTPRequestOperationManager *manager, NSError *error))failBlock;

- (id)BHHttpRequestPOST:(NSString *)URLString
            parameters:(id)parameters
             SaveCache:(BOOL)isSave
               success:(void (^)(AFHTTPRequestOperationManager *manager, id responseObject))succBlock
               failure:(void (^)(AFHTTPRequestOperationManager *manager, NSError *error))failBlock;

- (void)BHHttpDataPOST:(NSString *)URLString
             parameters:(id)parameters
            formData:(NSDictionary*)dataDic
                success:(void (^)(AFHTTPRequestOperationManager *manager, id responseObject))succBlock
                failure:(void (^)(AFHTTPRequestOperationManager *manager, NSError *error))failBlock;

- (void)BHHttpLoadImageWithUrl:(NSString*)URLString resultBlock:(void (^)(AFHTTPRequestOperationManager *manager, NSString*url,id responseObject))resultBlock;

@end
