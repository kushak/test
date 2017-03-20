//
//  OSVideoTableViewCell.h
//  VideoVK
//
//  Created by user on 18.03.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OSVideo;

@interface OSVideoTableViewCell : UITableViewCell

- (void)fillWithModel:(OSVideo*)model;

@end
