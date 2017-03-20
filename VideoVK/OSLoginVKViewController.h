//
//  OSLoginVKViewController.h
//  VideoVK
//
//  Created by user on 17.03.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OSAccesToken;

typedef void(^OSLoginCompletionBlock)(OSAccesToken* OSAccesToken);

@interface OSLoginVKViewController : UIViewController

-(id) initWithCompletionBlock: (OSLoginCompletionBlock) complitetion;

@end
