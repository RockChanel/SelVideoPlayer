//
//  SelBackControl.h
//  SelVideoPlayer
//
//  Created by zhuku on 2018/1/26.
//  Copyright © 2018年 selwyn. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 播放器控制面板代理 */
@protocol SelPlaybackControlsDelegate <NSObject>

@required
/**
 播放按钮点击事件
 @param selected 按钮选中状态
 */
- (void)playButtonAction:(BOOL)selected;

/** 全屏切换按钮点击事件 */
- (void)fullScreenButtonAction;

@optional
/** 控制面板单击事件 */
- (void)tapGesture;
/** 控制面板双击事件 */
- (void)doubleTapGesture;

@end

@interface SelPlaybackControls : UIView

/** 播放按钮 */
@property (nonatomic, strong) UIButton *playButton;
/** 全屏切换按钮 */
@property (nonatomic, strong) UIButton *fullScreenButton;
/** 播放器控制面板代理 */
@property (nonatomic, weak) id<SelPlaybackControlsDelegate> delegate;

@end
