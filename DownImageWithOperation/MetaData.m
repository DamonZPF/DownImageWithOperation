//
//  MetaData.m
//  DownImageWithOperation
//
//  Created by Duomai on 15/9/28.
//  Copyright © 2015年 zpf. All rights reserved.
//

#import "MetaData.h"

@implementation MetaData
+(instancetype)metaDataWithDict:(NSDictionary*)dict{
    
    MetaData * data = [[MetaData alloc] init];
    data.name = dict[@"name"];
    data.icon = dict[@"icon"];
    data.download = dict[@"download"];
    
    return data;
}
@end
