//
//  OSVideoTableViewCell.m
//  VideoVK
//
//  Created by user on 18.03.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

#import "OSVideoTableViewCell.h"
#import "OSVideo.h"

@interface OSVideoTableViewCell()

@property (strong, nonatomic) UILabel* name;
@property (strong, nonatomic) UILabel* duration;
@property (strong, nonatomic) UIImageView* image;

@end

@implementation OSVideoTableViewCell

-(id) init {
    self = [super init];
    if(self) {
        [self createConstraints];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void) prepareForReuse {
    self.imageView.image = nil;
    self.name.text = @"";
    self.duration.text = @"";
}

- (void)fillWithModel:(OSVideo*)model {
    [self initViews];
    self.name.text = model.title;
    self.duration.text = model.duration;
    [self.duration setTextAlignment:NSTextAlignmentRight];
    [self.duration setTextColor:[UIColor grayColor]];
    self.image.image = model.image;
}

- (void)initViews {
    self.name = [[UILabel alloc] init];
    [self.name setNumberOfLines:0];
    self.name.font = [UIFont systemFontOfSize:14];
    
    self.duration = [[UILabel alloc] init];
    self.duration.font = [UIFont systemFontOfSize:14];
    
    self.image = [[UIImageView alloc] init];
    [self.image.inputView setContentMode:UIViewContentModeScaleAspectFill];
    
    [self.name setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.duration setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.image setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addSubview:self.name];
    [self addSubview:self.duration];
    [self addSubview:self.image];
    
    [self createConstraints];
}

- (void)createConstraints {
    [self.image addConstraint:[NSLayoutConstraint
                                  constraintWithItem:self.image
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:self.image
                                  attribute:NSLayoutAttributeWidth
                                  multiplier:0.75
                                  constant:0]];
    NSDictionary* views = @{@"name": self.name,
                            @"duration": self.duration,
                            @"image": self.image};
    
    NSArray* horizontalConstraint1 =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-4-[image]-[name]-[duration(60)]-|"
                                            options:0
                                            metrics:nil
                                              views:views];
    NSArray* verticalConstraint1 =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-2-[image]-2-|"
                                            options:0
                                            metrics:nil
                                              views:views];
    NSArray* verticalConstraint2 =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[name]-|"
                                            options:0
                                            metrics:nil
                                              views:views];
    NSArray* verticalConstraint3 =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[duration]-|"
                                            options:0
                                            metrics:nil
                                              views:views];
    
    [self addConstraints:horizontalConstraint1];
    [self addConstraints:verticalConstraint1];
    [self addConstraints:verticalConstraint2];
    [self addConstraints:verticalConstraint3];
}

@end
