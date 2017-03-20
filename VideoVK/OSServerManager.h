//
//  OSServerManager.h
//  VideoVK
//
//  Created by user on 18.03.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OSUser;

@interface OSServerManager : NSObject

@property (nonatomic, strong, readonly) OSUser* currentUser;

+(OSServerManager*) sharedManager;

-(void) authorizeUser: (void(^)(OSUser* user)) completion;

-(void) getUser: (NSString*) userID
      onSuccess: (void(^)(OSUser* user)) success
      onFailure: (void(^)(void)) failure;

-(void) getSearchVideos: (NSString*) searchingString
               onOffset: (NSInteger) offset
              onSuccess: (void(^)(NSArray* videos)) success
              onFailure: (void(^)(void)) failure;

-(void) getImage: (NSURL*) imageURL
       onSuccess: (void(^)(UIImage* image)) success
       onFailure: (void(^)(void)) failure;

@end
