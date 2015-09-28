//
//  ViewController.m
//  DownImageWithOperation
//
//  Created by Duomai on 15/9/28.
//  Copyright © 2015年 zpf. All rights reserved.
//

#import "ViewController.h"
#import "MetaData.h"
#import "DownImageOperation.h"
@interface ViewController ()
@property(nonatomic,strong)NSMutableArray * contentsData;

@property(nonatomic,strong)NSMutableDictionary * imagesDict;

@property(nonatomic,strong)NSMutableDictionary * operationDict;

@property(nonatomic,strong)NSOperationQueue * queue;

@end

@implementation ViewController

-(NSOperationQueue*)queue{
    
    if (_queue == nil) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

-(NSMutableArray*)contentsData{
    
    if (_contentsData == nil) {
        _contentsData = [NSMutableArray array];
    }
    
    return _contentsData;
}


-(NSMutableDictionary*)imagesDict{
    
    if (_imagesDict == nil) {
        _imagesDict = [NSMutableDictionary dictionary];
    }
    return _imagesDict;
}

-(NSMutableDictionary*)operationDict{
    
    if (_operationDict == nil) {
        _operationDict = [NSMutableDictionary dictionary];
    }
    return _operationDict;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.contentsData.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CellId" forIndexPath:indexPath];
    
    MetaData * dataModel = self.contentsData[indexPath.row];
    cell.textLabel.text = dataModel.name;
    
    UIImage * image = self.imagesDict[dataModel.icon];
    
    if (image) { //从内存中取出图片
        cell.imageView.image = image;
    }else{
        
        NSString * filePath = [self filePath:dataModel.icon];
        NSData * imageData = [NSData dataWithContentsOfFile:filePath];
        if (imageData) { //从沙盒中取出图片
            cell.imageView.image = [UIImage imageWithData:imageData];
        }else{
        
            // 显示占位图片
            cell.imageView.image = [UIImage imageNamed:@"placeholder"];
            //下载
            [self downImageWithImageURL:dataModel.icon indexPath:indexPath];
        }
        
    }
    
    return cell;
}

-(void)downImageWithImageURL:(NSString*)imageurl indexPath:(NSIndexPath*)indexPath{
    DownImageOperation * blockOperation = self.operationDict[imageurl];
    if (blockOperation) {
        return;
    }
    blockOperation = [[DownImageOperation alloc] init];
    blockOperation.imageurl = imageurl;
    blockOperation.indexPath = indexPath;
    __weak typeof(self) weakSelf = self;
    blockOperation.downImageOperationFinished = ^(DownImageOperation * operation,UIImage * image){
        if (image) {
            [weakSelf.imagesDict setObject:image forKey:operation.imageurl];
            //写入沙盒
            NSData * imageData = UIImagePNGRepresentation(image);
            [imageData writeToFile:[weakSelf filePath:operation.imageurl] atomically:YES];
        }
        
        //移除已完成下载的队列
        [weakSelf.operationDict removeObjectForKey:imageurl];
        //刷新当前下载好的cell
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    };
    
    [self.queue addOperation:blockOperation];
    [self.operationDict setObject:blockOperation forKey:imageurl];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    NSArray * tempArray = [NSArray arrayWithContentsOfFile:[self filePath]];
    for (NSDictionary * dic in tempArray) {
        [self.contentsData addObject:[MetaData metaDataWithDict:dic]];
    }
    
    
}

-(NSString*)filePath{
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"apps" ofType:@"plist"];
    return filePath;
}

/**
 *  当用户开始拖拽表格时调用
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 暂停下载
    [self.queue setSuspended:YES];
}

/**
 *  当用户停止拖拽表格时调用
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // 恢复下载
    [self.queue setSuspended:NO];
}

-(NSString*)filePath:(NSString*)imageurl{

    NSString * file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString * filePath = [file stringByAppendingPathComponent:[imageurl lastPathComponent]];
    
    return filePath;

}
@end
