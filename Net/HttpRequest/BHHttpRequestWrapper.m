//
//  BHHttpRequestWrapper.m
//  BHJingYingHui
//
//  Created by hepeilin on 14-6-3.
//  Copyright (c) 2014年 boyce. All rights reserved.
//

#import "BHHttpRequestWrapper.h"
#import "NetWork.h"
#import "TMCache.h"

@interface BHHttpRequestWrapper()
@property (nonatomic,strong)AFHTTPRequestOperationManager  *apiManager;
@property (nonatomic,strong)AFHTTPRequestOperationManager  *imgManager;



@end


@implementation BHHttpRequestWrapper

+ (BHHttpRequestWrapper*)shareManger
{
    // dispatch_once不仅意味着代码仅会被运行一次，而且还是线程安全的
    static BHHttpRequestWrapper *singleton = nil;
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

- (id)init{

    self = [super init];
    
    if (self) {
        
        _apiManager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:Eliteall_Base_Api_Url]];
        _imgManager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:Eliteall_Base_Img_Url]];
        
    }
    
    return self;
}

- (id)BHHttpRequestGET:(NSString *)URLString
            parameters:(id)parameters
            SaveCache:(BOOL)isSave
              success:(void (^)(AFHTTPRequestOperationManager *manager, id responseObject))succBlock
              failure:(void (^)(AFHTTPRequestOperationManager *manager, NSError *error))failBlock
{

    id  object = nil;
    
    
    NSString *cacheKey = @"";
    
  //NSDictionary
   
    object = [[TMCache sharedCache] objectForKey:cacheKey];
    
    [_apiManager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        NSDictionary *dic = (NSDictionary*)responseObject;
        
        if ([[dic objectForKey:API_Result_Code_Key] intValue]  != API_Result_Succ_Code) {
            
            //TODO
            NSError *error = [NSError errorWithDomain:[dic objectForKey:API_Result_Desc] code:[[dic objectForKey:API_Result_Code_Key] intValue] userInfo:nil];
            
             failBlock(_apiManager,error);

        }else{
    
            succBlock(_apiManager,responseObject);
        }
        
        if (isSave) {
            [[TMCache sharedCache] setObject:responseObject forKey:cacheKey];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        failBlock(_apiManager,error);
        
    }];
    
    
    return object;

}

- (id)BHHttpRequestPOST:(NSString *)URLString
             parameters:(id)parameters
              SaveCache:(BOOL)isSave
                success:(void (^)(AFHTTPRequestOperationManager *manager, id responseObject))succBlock
                failure:(void (^)(AFHTTPRequestOperationManager *manager, NSError *error))failBlock{


    id  object = nil;
    
    NSString *cacheKey = @"";
    
    object = [[TMCache sharedCache] objectForKey:cacheKey];
    
    
    [_apiManager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = (NSDictionary*)responseObject;
        
        if ([[dic objectForKey:API_Result_Code_Key] intValue]  != API_Result_Succ_Code) {
            
            //TODO
            NSError *error = [NSError errorWithDomain:@"" code:[[dic objectForKey:API_Result_Code_Key] intValue] userInfo:nil];
            
            failBlock(_apiManager,error);
            
        }else{
            
            succBlock(_apiManager,responseObject);
        }
        
        if (isSave) {
            [[TMCache sharedCache] setObject:responseObject forKey:cacheKey];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
         failBlock(_apiManager,error);
        
    }];
    
    
    return object;
}


- (void)BHHttpDataPOST:(NSString *)URLString
          parameters:(id)parameters
            formData:(NSDictionary*)dataDic
             success:(void (^)(AFHTTPRequestOperationManager *manager, id responseObject))succBlock
             failure:(void (^)(AFHTTPRequestOperationManager *manager, NSError *error))failBlock
{

    [_apiManager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
     
        NSArray*keyArr = [dataDic allKeys];
        NSMutableDictionary *fileDic = [NSMutableDictionary new];
        
        for (int i = 0; i < [keyArr count]; i++) {
            
            
            
        }
        
        
        [formData appendPartWithFileURL:[NSURL URLWithString:@""] name:@"image" error:nil];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = (NSDictionary*)responseObject;
        
        if ([[dic objectForKey:API_Result_Code_Key] intValue]  != API_Result_Succ_Code) {
            
            //TODO
            NSError *error = [NSError errorWithDomain:@"" code:[[dic objectForKey:API_Result_Code_Key] intValue] userInfo:nil];
            
            failBlock(_apiManager,error);
            
        }else{
            
            succBlock(_apiManager,responseObject);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failBlock(_apiManager,error);
    }];
}


- (void)BHHttpLoadImageWithUrl:(NSString*)URLString resultBlock:(void (^)(AFHTTPRequestOperationManager *manager, NSString*url,id responseObject))resultBlock{


    id  object = nil;
    
    NSString *cacheKey = @"";
    
    object = [[TMCache sharedCache] objectForKey:cacheKey];
    
    [_apiManager GET:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
         resultBlock(_imgManager,URLString,responseObject);
        
        
        [[TMCache sharedCache] setObject:responseObject forKey:cacheKey];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
       resultBlock(_imgManager,URLString,nil);
        
    }];
    
    
 
    

}



@end
