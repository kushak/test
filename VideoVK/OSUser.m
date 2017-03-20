//
//  OSUser.m
//  VideoVK
//
//  Created by user on 18.03.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

#import "OSUser.h"

@implementation OSUser

- (id) initWithServerResponse:(NSDictionary*) responseObject
{
    self = [super init];
    if (self) {
        
        self.firstName = [responseObject objectForKey:@"first_name"];
        self.lastName = [responseObject objectForKey:@"last_name"];
        
        NSString* urlString = [responseObject objectForKey:@"photo_50"];
        
        if (urlString) {
            self.imageURL = [NSURL URLWithString:urlString];
        }
    }
    return self;
}

@end
