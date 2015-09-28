//
//  DownImageOperation.h
//  DownImageWithOperation
//
//  Created by Duomai on 15/9/28.
//  Copyright © 2015年 zpf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DownImageOperation : NSOperation

@property(nonatomic,copy)NSString * imageurl;
@property(nonatomic,strong)NSIndexPath * indexPath;

@property(nonatomic,copy)void (^downImageOperationFinished)(DownImageOperation  * operation, UIImage * image);

@end
