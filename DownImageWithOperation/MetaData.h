//
//  MetaData.h
//  DownImageWithOperation
//
//  Created by Duomai on 15/9/28.
//  Copyright © 2015年 zpf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MetaData : NSObject
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * icon;
@property(nonatomic,copy)NSString * download;

+(instancetype)metaDataWithDict:(NSDictionary*)dict;

@end
