//
//  OSAccesToken.h
//  VideoVK
//
//  Created by user on 18.03.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSAccesToken : NSObject

@property (strong, nonatomic) NSString* token;
@property (strong, nonatomic) NSDate* expirationDate;
@property (strong, nonatomic) NSString* userID;

- (void) writeInKeychain;

@end
