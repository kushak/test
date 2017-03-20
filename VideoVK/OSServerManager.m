//
//  OSServerManager.m
//  VideoVK
//
//  Created by user on 18.03.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

#import "OSServerManager.h"
#import "OSUser.h"
#import "OSLoginVKViewController.h"
#import "OSAccesToken.h"
#import "OSVideo.h"
#import "KeychainWrapper.h"

@interface OSServerManager ()

@property (strong, nonatomic) OSAccesToken* accessToken;

@end

@implementation OSServerManager

+(OSServerManager*) sharedManager {
    
    static OSServerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[OSServerManager alloc] init];
    });
    
    return manager;
}

-(void) authorizeUser:(void (^)(OSUser *))completion {
    OSLoginVKViewController* vc = [[OSLoginVKViewController alloc] initWithCompletionBlock:^(OSAccesToken *token) {
        self.accessToken = token;
        if (token){
            [self getUser:self.accessToken.userID
                onSuccess:^(OSUser *user) {
                    if (completion) {
                        completion(user);
                    }
                } onFailure:^{
                    if (completion) {
                        completion(nil);
                    }
                }];
        } else if (completion) {
            completion(nil);
        }
    }];
    
    UINavigationController* navigationVc = [[UINavigationController alloc] initWithRootViewController:vc];
    UIViewController* mainVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    [mainVc presentViewController:navigationVc animated:YES completion:nil];
}

-(void) getUser: (NSString*) userID
      onSuccess: (void(^)(OSUser* user)) success
      onFailure: (void(^)(void)) failure {
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject];
    NSURL * url = [NSURL URLWithString: [NSString stringWithFormat:@"https://api.vk.com/method/users.get?user_id=%@&v=5.52", userID]];

    NSURLSessionDataTask * dataTask =
    [defaultSession dataTaskWithURL:url
                  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                      if(error == nil) {
                          NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                               options:0
                                                                                 error:nil];
                          NSArray* usersArr = [json objectForKey:@"response"];
                          if (usersArr.count > 0) {
                              NSDictionary* userDictionary = [usersArr firstObject];
                              if (userDictionary){
                                  OSUser* user = [[OSUser alloc] initWithServerResponse: userDictionary];
                                  success(user);
                              }
                          }
                      }
                  }];
    
    [dataTask resume];
}

-(void) getSearchVideos: (NSString*) searchingString
               onOffset: (NSInteger) offset
              onSuccess: (void(^)(NSArray* videos)) success
              onFailure: (void(^)(void)) failure {
    KeychainWrapper* keychain = [[KeychainWrapper alloc] init];
    NSDictionary *myDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:[keychain myObjectForKey:(__bridge id)kSecAttrAccount]];
    NSString* token = [myDictionary objectForKey:@"token"];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject];
    NSURL * url = [NSURL URLWithString:
                   [NSString stringWithFormat:
                    @"https://api.vk.com/method/video.search?"
                    "access_token=%@&"
                    "q=%@&"
                    "sort=2&"
                    "hd=0&"
                    "adult=0&"
                    "filters=mp4&"
                    "search_own=1&"
                    "offset=%ld&"
                    "count=40&"
                    "v=5.62",
                    token, searchingString, (long)offset]];
    
    NSURLSessionDataTask * dataTask =
    [defaultSession dataTaskWithURL:url
                  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                      if(error == nil) {
                          NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                               options:0
                                                                                 error:nil];
                          NSDictionary* responseDic = [json objectForKey:@"response"];
                          NSMutableArray* videos = [NSMutableArray array];
                          if (responseDic) {
                              NSArray* videosArr = [responseDic objectForKey:@"items"];
                              for (NSDictionary* videoDic in videosArr) {
                                  OSVideo* video = [[OSVideo alloc] initWithServerResponse:videoDic];
                                  [videos addObject:video];
                              }
                          }
                          if (success) {
                              success(videos);
                          }
                      }
                  }];
    
    [dataTask resume];
}

-(void) getImage: (NSURL*) imageURL
       onSuccess: (void(^)(UIImage* image)) success
       onFailure: (void(^)(void)) failure {
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject];
    
    NSURLSessionDataTask * dataTask =
    [defaultSession dataTaskWithURL:imageURL
                  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                      if(error == nil) {
                          UIImage* img = [UIImage imageWithData:data];
                          if (success) {
                              success(img);
                          }
                      } else {
                          failure();
                      }
                  }];
    
    [dataTask resume];
}

@end
