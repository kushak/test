//
//  OSUser.h
//  VideoVK
//
//  Created by user on 18.03.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSUser : NSObject

@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (strong, nonatomic) NSURL* imageURL;

- (id) initWithServerResponse:(NSDictionary*) responseObject;

@end
