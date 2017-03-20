//
//  OSPlayerViewController.m
//  VideoVK
//
//  Created by user on 20.03.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

#import "OSPlayerViewController.h"

@interface OSPlayerViewController ()

@property (strong, nonatomic) UIWebView* webView;

@end

@implementation OSPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}

-(void) initViews {
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    
    [self.view addSubview:self.webView];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
