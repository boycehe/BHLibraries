//
//  DemoImageViewController.m
//  BHLibraries
//
//  Created by hepeilin on 11/14/14.
//  Copyright (c) 2014 boyce. All rights reserved.
//

#import "DemoImageViewController.h"
#import "UIImageView+Expand.h"

@interface DemoImageViewController ()

@end

@implementation DemoImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     NSValue *value1 = [NSValue valueWithCGRect:CGRectMake(5, 5, 100, 50)];
     NSValue *value2 = [NSValue valueWithCGRect:CGRectMake(110, 5, 30, 100)];
     NSValue *value3 = [NSValue valueWithCGRect:CGRectMake(145, 5, 90, 70)];
     NSValue *value4 = [NSValue valueWithCGRect:CGRectMake(240, 5, 60, 40)];
    
    
     NSValue *value5 = [NSValue valueWithCGRect:CGRectMake(5, 110, 10, 100)];
     NSValue *value6 = [NSValue valueWithCGRect:CGRectMake(20, 110, 100, 10)];
     NSValue *value7 = [NSValue valueWithCGRect:CGRectMake(125, 110, 190, 20)];
    
     NSValue *value8 = [NSValue valueWithCGRect:CGRectMake(5, 215, 50, 300)];
     NSValue *value9 = [NSValue valueWithCGRect:CGRectMake(60, 215, 200, 140)];
    
    
     NSMutableArray *valueArr = [NSMutableArray new];
    
     [valueArr addObject:value1];
     [valueArr addObject:value2];
     [valueArr addObject:value3];
     [valueArr addObject:value4];
     [valueArr addObject:value5];
     [valueArr addObject:value6];
     [valueArr addObject:value7];
     [valueArr addObject:value8];
     [valueArr addObject:value9];
    
    
    
    for (int i = 0; i < [valueArr count]; i++) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Test01.jpg"]];
        imageView.frame = [[valueArr objectAtIndex:i] CGRectValue];
        [imageView adjustCenralFrame];
        [self.view addSubview:imageView];
        
    }
    
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
