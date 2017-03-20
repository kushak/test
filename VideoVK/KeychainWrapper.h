//
//  KeychainWrapper.h
//  VideoVK
//
//  Created by user on 19.03.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

//Объявляем Objective-C класс-оболочку для Keychain Services.
@interface KeychainWrapper : NSObject {
    NSMutableDictionary        *keychainData;
    NSMutableDictionary        *genericPasswordQuery;
}

@property (nonatomic, strong) NSMutableDictionary *keychainData;
@property (nonatomic, strong) NSMutableDictionary *genericPasswordQuery;

- (void)mySetObject:(id)inObject forKey:(id)key;
- (id)myObjectForKey:(id)key;
- (void)resetKeychainItem;

@end

/* ********************************************************************** */
//Уникальная строка используемая для идентификации keychain элемента:
static const UInt8 kKeychainItemIdentifier[]    = "com.apple.dts.KeychainUI\0";

@interface KeychainWrapper (PrivateMethods)


// Следующие два метода транслируют словари между форматом, используемом
// Контроллером вида (NSString *) и API Keychain Services:
- (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert;
- (NSMutableDictionary *)dictionaryToSecItemFormat:(NSDictionary *)dictionaryToConvert;
// Метод, используемый для записи в keychain:
- (void)writeToKeychain;

@end
