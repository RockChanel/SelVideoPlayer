//
//  SelPlayerConfiguration.h
//  SelVideoPlayer
//
//  Created by zhuku on 2018/1/26.
//  Copyright © 2018年 selwyn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,SelVideoGravity){
    SelVideoGravityResize,       //非均匀拉伸。两个维度完全填充至整个视图区域
    SelVideoGravityResizeAspect,     //等比例拉伸，直到一个维度到达区域边界
    SelVideoGravityResizeAspectFill, //等比例拉伸，直到填充满整个视图区域，其中一个维度的部分区域会被裁剪
};

@interface SelPlayerConfiguration : NSObject

/** 视频数据源 */
@property (nonatomic, strong) NSURL *sourceUrl;
/** 是否自动播放 */
@property (nonatomic, assign) BOOL shouldAutoPlay;
/** 视频拉伸方式 */
@property (nonatomic, assign) SelVideoGravity videoGravity;
/** 播放器背景色 default is white */
@property CGColorRef playerBackgroundColor;
/** 是否重复播放 */
@property (nonatomic, assign) BOOL repeatPlay;
/** 是否支持双击暂停或播放 */
@property (nonatomic, assign) BOOL supportedDoubleTap;
/** 是否支持自动转屏 */
@property (nonatomic, assign) BOOL shouldAutorotate;



/** 是否支持横屏全屏播放 */
//@property (nonatomic, assign) BOOL supportedFullScreen;

@end
