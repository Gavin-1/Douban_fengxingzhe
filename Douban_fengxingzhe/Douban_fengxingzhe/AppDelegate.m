//
//  AppDelegate.m
//  Douban_quanxin
//
//  Created by lk on 16/5/5.
//  Copyright © 2016年 唐家文. All rights reserved.
//

#import "AppDelegate.h"
#import "ChannelInfo.h"
#import "SongInfo.h"

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self loadArchiver];
        //[application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
        [self initChannelsData];
        //后台播放
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        [session setActive:YES error:nil];
    });
    return YES;
}
- (void)loadArchiver{
    NSString *homePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *appdelegatePath = [homePath stringByAppendingPathComponent:@"appdelegate.archiver"];
    //添加储存的文件名
    NSData *data = [[NSData alloc]initWithContentsOfFile:appdelegatePath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    _userInfo = [unarchiver decodeObjectForKey:@"userInfo"];
    [unarchiver finishDecoding];
    
    if ([ChannelInfo currentChannel].ID == nil) {
        ChannelInfo *currentChannel = [[ChannelInfo alloc]init];
        currentChannel.name = @"我的私人";
        currentChannel.ID = @"0";
        [ChannelInfo updateCurrentCannel:currentChannel];
    }
    if (_userInfo == nil) {
        _userInfo = [[UserInfo alloc]init];
    }
}

- (void)initChannelsData{
    //初始化数据源Array
    [ChannelInfo updateChannelsTitleArray:@[@"我的兆赫",@"推荐频道",@"上升最快兆赫",@"热门兆赫"]];
    NSMutableArray *channels = [ChannelInfo channels];
    //我的兆赫
    ChannelInfo *myPrivateChannel = [[ChannelInfo alloc]init];
    myPrivateChannel.name = @"我的私人";
    myPrivateChannel.ID = @"0";
    ChannelInfo *myRedheartChannel = [[ChannelInfo alloc]init];
    myRedheartChannel.name = @"我的红心";
    myRedheartChannel.ID = @"-3";
    NSArray *myChannels = @[myPrivateChannel, myRedheartChannel];
    [channels addObject:myChannels];
    //推荐兆赫
    NSArray *recommendChannels = [NSMutableArray array];
    [channels addObject:recommendChannels];
    //上升最快兆赫
    NSMutableArray *upTrendingChannels = [NSMutableArray array];
    [channels addObject:upTrendingChannels];
    //热门兆赫
    NSMutableArray *hotChannels = [NSMutableArray array];
    [channels addObject:hotChannels];
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
