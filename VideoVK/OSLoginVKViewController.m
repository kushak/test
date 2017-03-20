//
//  OSLoginVKViewController.m
//  VideoVK
//
//  Created by user on 17.03.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

#import "OSLoginVKViewController.h"
#import "OSAccesToken.h"

@interface OSLoginVKViewController () <UIWebViewDelegate>

@property (copy, nonatomic) OSLoginCompletionBlock completionBlock;
@property (weak, nonatomic) UIWebView* webView;

@end

@implementation OSLoginVKViewController

-(id) initWithCompletionBlock: (OSLoginCompletionBlock) completionBlock {
    
    self = [super init];
    if (self) {
        self.completionBlock = completionBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rect = self.view.bounds;
    rect.origin = CGPointZero;
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:rect];
    
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:webView];
    webView.delegate = self;
    self.webView = webView;
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                          target:self
                                                                          action:@selector(actionCancel:)];
    [self.navigationItem setRightBarButtonItem:item animated:NO];
    
    self.navigationItem.title = @"Вход";
    
    NSString* urlString = [NSString stringWithFormat:
                           @"https://oauth.vk.com/authorize?"
                           "client_id=5930935&"
                           "display=mobile&"
                           "redirect_uri=https://oauth.vk.com/blank.html&"
                           "scope=video,offline&"
                           "response_type=token&"
                           "v=5.52"];
    NSURL* url = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    [webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) dealloc {
    self.webView.delegate = nil;
}

#pragma mark - Actions

-(void) actionCancel: (UIBarButtonItem*) item {
    
    if (self.completionBlock) {
        self.completionBlock(nil);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([[[request URL] description] rangeOfString:@"#access_token="].location != NSNotFound) {
        OSAccesToken* token = [[OSAccesToken alloc] init];
        NSString* query = [[request URL] description];
        
        NSArray* array = [query componentsSeparatedByString:@"#"];
        
        if (array.count > 1) {
            query = [array lastObject];
        }
        NSArray* pairs = [query componentsSeparatedByString:@"&"];
        
        for (NSString* pair in pairs) {
            NSArray* parametrs = [pair componentsSeparatedByString:@"="];
            if (parametrs.count == 2){
                NSString* key = [parametrs firstObject];
                
                if ([key isEqualToString:@"access_token"]){
                    token.token = [parametrs lastObject];
                } else if ([key isEqualToString:@"expires_in"]){
                    NSTimeInterval interval = [[parametrs lastObject] doubleValue];
                    token.expirationDate = [NSDate dateWithTimeIntervalSinceNow:interval];
                } else if ([key isEqualToString:@"user_id"]) {
                    token.userID = [parametrs lastObject];
                }
            }
        }
        
        [token writeInKeychain];
        
        self.webView.delegate = nil;
        
        if (self.completionBlock) {
            self.completionBlock(token);
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        return NO;
    }
    return YES;
}

@end
