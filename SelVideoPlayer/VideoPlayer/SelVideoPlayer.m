    //
//  SelVideoPlayer.m
//  SelVideoPlayer
//
//  Created by zhuku on 2018/1/26.
//  Copyright © 2018年 selwyn. All rights reserved.
//

#import "SelVideoPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "SelPlayerConfiguration.h"
#import "SelPlaybackControls.h"
#import <CoreMotion/CoreMotion.h>

@interface SelVideoPlayer()<SelPlaybackControlsDelegate>

/** 播放器 */
@property (nonatomic, strong) AVPlayerItem *playerItem;
/** 播放器item */
@property (nonatomic, strong) AVPlayer *player;
/** 播放器layer */
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
/** 是否处于播放状态 */
@property (nonatomic, assign) BOOL isPlaying;
/** 是否播放完毕 */
@property (nonatomic, assign) BOOL isFinish;
/** 是否处于全屏状态 */
@property (nonatomic, assign) BOOL isFullScreen;
/** 播放器配置信息 */
@property (nonatomic, strong) SelPlayerConfiguration *playerConfiguration;
/** 视频播放控制面板 */
@property (nonatomic, strong) SelPlaybackControls *playbackControls;
/** 非全屏状态下播放器 superview */
@property (nonatomic, strong) UIView *originalSuperview;
/** 非全屏状态下播放器 frame */
@property (nonatomic, assign) CGRect originalRect;

//@property (nonatomic, assign) BOOL isStatusBarHidden;

@property (nonatomic, assign) BOOL isLandscape;

@end

@implementation SelVideoPlayer

/**
 初始化播放器
 @param configuration 播放器配置信息
 */
- (instancetype)initWithFrame:(CGRect)frame configuration:(SelPlayerConfiguration *)configuration
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _playerConfiguration = configuration;
        [self _setupPlayer];
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

/** 根据屏幕旋转方向改变当前视频屏幕状态 */
- (void)orientationAspect
{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationLandscapeLeft){
        if (!_isFullScreen){
            if (_isLandscape) {
                //播放器所在控制器页面支持旋转情况下，和正常情况是相反的
                [self _videoZoomInWithDirection:UIInterfaceOrientationLandscapeRight];
            }else{
                [self _videoZoomInWithDirection:UIInterfaceOrientationLandscapeLeft];
            }
        }
    }
    else if (orientation == UIDeviceOrientationLandscapeRight){
        if (!_isFullScreen){
            if (_isLandscape) {
                [self _videoZoomInWithDirection:UIInterfaceOrientationLandscapeLeft];
            }else{
                [self _videoZoomInWithDirection:UIInterfaceOrientationLandscapeRight];
            }
        }
    }
    else if(orientation == UIDeviceOrientationPortrait){
        if (_isFullScreen){
            [self _videoZoomOut];
        }
    }
}


/**
 视频放大全屏幕
 @param orientation 旋转方向
 */
- (void)_videoZoomInWithDirection:(UIInterfaceOrientation)orientation
{
    _originalSuperview = self.superview;
    _originalRect = self.frame;
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    if (_isLandscape){
        //手动点击需要旋转方向
        
        CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
        [UIView animateWithDuration:duration animations:^{
            self.transform = CGAffineTransformMakeRotation(M_PI / 2);
        }completion:^(BOOL finished) {
           
        }];
            
    }else{
        //播放器所在控制器不支持旋转，采用旋转view的方式实现
        CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
        if (orientation == UIInterfaceOrientationLandscapeLeft){
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
            [UIView animateWithDuration:duration animations:^{
                self.transform = CGAffineTransformMakeRotation(M_PI / 2);
            }completion:^(BOOL finished) {
                
            }];
        }else if (orientation == UIInterfaceOrientationLandscapeRight) {
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:YES];
            [UIView animateWithDuration:duration animations:^{
                self.transform = CGAffineTransformMakeRotation( - M_PI / 2);
            }completion:^(BOOL finished) {
                
            }];
        }
    }

    self.frame = keyWindow.bounds;
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    self.isFullScreen = YES;
}

/** 视频缩小屏幕 */
- (void)_videoZoomOut
{
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    [UIView animateWithDuration:duration animations:^{
        self.transform = CGAffineTransformMakeRotation(0);
    }completion:^(BOOL finished) {

    }];
    self.frame = _originalRect;
    [_originalSuperview addSubview:self];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    self.isFullScreen = NO;
}

- (void)orientationChanged:(NSNotification *)notify
{
    [self orientationAspect];
}

/** 播放视频 */
- (void)_playVideo
{
    [_player play];
}

/** 暂停播放 */
- (void)_pauseVideo
{
    [_player pause];
}

/** 创建播放器 以及控制面板*/
- (void)_setupPlayer
{
    _playerItem = [AVPlayerItem playerItemWithURL:_playerConfiguration.sourceUrl];
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.backgroundColor = _playerConfiguration.playerBackgroundColor;
    [self _setVideoGravity:_playerConfiguration.videoGravity];
    [self.layer insertSublayer:_playerLayer atIndex:0];
    
    [self addSubview:self.playbackControls];
    
    if (_playerConfiguration.shouldAutoPlay) {
        [self _playVideo];
    }
}

- (void)_deallocPlayer
{
    [self _pauseVideo];
    
    [self.playbackControls removeFromSuperview];
    [self.playerLayer removeFromSuperlayer];
    [self removeFromSuperview];
    self.playerLayer = nil;
    self.player = nil;
    self.playbackControls = nil;
}

/**
 配置playerLayer拉伸方式
 @param videoGravity 拉伸方式
 */
- (void)_setVideoGravity:(SelVideoGravity)videoGravity
{
    NSString *fillMode = AVLayerVideoGravityResize;
    switch (videoGravity) {
        case SelVideoGravityResize:
            fillMode = AVLayerVideoGravityResize;
            break;
        case SelVideoGravityResizeAspect:
            fillMode = AVLayerVideoGravityResizeAspect;
            break;
        case SelVideoGravityResizeAspectFill:
            fillMode = AVLayerVideoGravityResizeAspectFill;
            break;
        default:
            break;
    }
    _playerLayer.videoGravity = fillMode;
}

/** 改变全屏切换按钮状态 */
- (void)setIsFullScreen:(BOOL)isFullScreen
{
    _isFullScreen = isFullScreen;
    _playbackControls.fullScreenButton.selected = isFullScreen;
}

- (void)setIsPlaying:(BOOL)isPlaying
{
    _isPlaying = isPlaying;
    if (isPlaying) {
        [self _playVideo];
    }else
    {
        [self _pauseVideo];
    }
}

/** 播放器控制面板 */
- (SelPlaybackControls *)playbackControls
{
    if (!_playbackControls) {
        _playbackControls = [[SelPlaybackControls alloc]init];
        _playbackControls.delegate = self;
    }
    return _playbackControls;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
    self.playbackControls.frame = self.bounds;
}

- (void)dealloc
{
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
}

#pragma mark 播放器控制面板代理
/**
 播放按钮点击事件
 @param selected 播放按钮选中状态
 */
- (void)playButtonAction:(BOOL)selected
{
    self.isPlaying = !self.isPlaying;
}

/** 全屏切换按钮点击事件 */
- (void)fullScreenButtonAction
{
    if (!_isFullScreen) {
        [self _videoZoomInWithDirection:UIInterfaceOrientationLandscapeRight];
    }else
    {
        [self _videoZoomOut];
    }
}

/** 控制面板单击事件 */
- (void)tapGesture
{

}

/** 控制面板双击事件 */
- (void)doubleTapGesture
{
    NSLog(@"doubleTap");
    if (_playerConfiguration.supportedDoubleTap) {
        self.isPlaying = !self.isPlaying;
        self.playbackControls.playButton.selected = self.isPlaying;
    }
}

@end
