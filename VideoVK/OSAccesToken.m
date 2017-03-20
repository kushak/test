//
//  OSAccesToken.m
//  VideoVK
//
//  Created by user on 18.03.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

#import <CoreFoundation/CoreFoundation.h>
#import <Security/Security.h>
#import "OSAccesToken.h"
#import "KeychainWrapper.h"

@implementation OSAccesToken

- (void) writeInKeychain {
    KeychainWrapper *keychain = [[KeychainWrapper alloc] init];
    NSDictionary* dic = @{@"userID": self.userID,
                          @"token": self.token};
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
    
    [keychain mySetObject:data forKey:(__bridge id)kSecAttrAccount];
    NSLog(@"User id: %@", [keychain myObjectForKey:(__bridge id)kSecAttrAccount]);
    NSDictionary *myDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:[keychain myObjectForKey:(__bridge id)kSecAttrAccount]];
    NSLog(@"%@", myDictionary);
}

@end
