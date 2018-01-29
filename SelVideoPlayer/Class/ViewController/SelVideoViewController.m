//
//  SelVideoViewController.m
//  SelVideoPlayer
//
//  Created by zhuku on 2018/1/28.
//  Copyright © 2018年 selwyn. All rights reserved.
//

#import "SelVideoViewController.h"
#import "SelVideoPlayer.h"
#import "SelPlayerConfiguration.h"
#import "AppDelegate.h"

@interface SelVideoViewController ()

@property (nonatomic, strong) SelVideoPlayer *player;

@end

@implementation SelVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([[UIDevice currentDevice].systemVersion floatValue] > 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    SelPlayerConfiguration *configuration = [[SelPlayerConfiguration alloc]init];
    configuration.shouldAutoPlay = YES;
    configuration.supportedDoubleTap = YES;
    configuration.shouldAutorotate = YES;
    configuration.repeatPlay = NO;
    configuration.playerBackgroundColor = [UIColor blackColor].CGColor;
    configuration.sourceUrl = [NSURL URLWithString:@"http://baobab.kaiyanapp.com/api/v1/playUrl?vid=78677&editionType=high&source=aliyun&token=7a8e0311f923f77a&vc=3951&u=c0fbb99c266dce4384b138bac746b0cf33617168"];
    configuration.videoGravity = SelVideoGravityResizeAspect;
    
    _player = [[SelVideoPlayer alloc]initWithFrame:CGRectMake(0, 100, 375, 300) configuration:configuration];
    [self.view addSubview:_player];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_player _deallocPlayer];
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
