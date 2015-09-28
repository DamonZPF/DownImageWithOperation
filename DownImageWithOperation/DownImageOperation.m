//
//  DownImageOperation.m
//  DownImageWithOperation
//
//  Created by Duomai on 15/9/28.
//  Copyright © 2015年 zpf. All rights reserved.
//

#import "DownImageOperation.h"

@implementation DownImageOperation


-(void)main{
    @autoreleasepool {
        if (self.isCancelled) {
            return;
        }
        
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageurl]];
        UIImage * image   = [UIImage imageWithData:data];
        
        if (self.isCancelled) {
            return;
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (self.downImageOperationFinished) {
                self.downImageOperationFinished(self,image);
            }
        }];
        
        
    }
}

@end
