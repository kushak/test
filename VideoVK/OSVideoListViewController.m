//
//  OSVideoListViewController.m
//  VideoVK
//
//  Created by user on 17.03.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

#import "OSVideoListViewController.h"
#import "OSServerManager.h"
#import "OSUser.h"
#import "OSVideo.h"
#import "OSVideoTableViewCell.h"
#import "KeychainWrapper.h"
#import "OSPlayerViewController.h"

@interface OSVideoListViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray<OSVideo*>* videos;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UISearchBar * searchBar;
@property (assign, nonatomic) BOOL firstTimeAppear;

@end

@implementation OSVideoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.firstTimeAppear = YES;
    self.videos = [NSMutableArray array];
    [self initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    KeychainWrapper* keychain = [[KeychainWrapper alloc] init];
    NSLog(@"%@", [keychain myObjectForKey:(__bridge id)kSecAttrAccount]);
    if ([[keychain myObjectForKey:(__bridge id)kSecAttrAccount]  isEqual: @"Account"]) {
        [[OSServerManager sharedManager] authorizeUser:^(OSUser *user) {
            NSLog(@"%@", user.lastName);
        }];
    } else {
        [self getVideosFromServer];
    }
}


- (void) getVideosFromServer {
    [[OSServerManager sharedManager]
     getSearchVideos: self.searchBar.text
     onOffset: self.videos.count
     onSuccess:^(NSArray *videos) {
         [self.videos addObjectsFromArray:videos];
         
         NSMutableArray* newPath = [NSMutableArray array];
         for (NSInteger i = (self.videos.count - videos.count); i < self.videos.count; i++) {
             [newPath addObject:[NSIndexPath indexPathForRow:i inSection:0]];
         }
         dispatch_async(dispatch_get_main_queue(), ^{
             [self.tableView insertRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
         });
         for (OSVideo* video in videos) {
             [video downloadImage:^(UIImage *image) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                                          [self.tableView reloadData];
                 });
             }];
         }
     }
     onFailure:^{
         
     }];
}

-(void) initViews {
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 35, 44)];
    self.searchBar.placeholder = @"Поиск";
    self.searchBar.delegate = self;
    
    UIBarButtonItem *searchBarItem = [[UIBarButtonItem alloc]initWithCustomView:self.searchBar];
    searchBarItem.tag = 123;
    searchBarItem.customView.hidden = NO;
    searchBarItem.customView.alpha = 0.0f;
    self.navigationItem.leftBarButtonItem = searchBarItem;
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor=[UIColor blackColor];
    [self.tableView registerClass: [OSVideoTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview: self.tableView];
    
//    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
//    [self.view addGestureRecognizer:tap];
    
    [self createConstraints];
}

- (void)createConstraints {
    NSDictionary* views = @{@"tableView": self.tableView};
    
    NSArray* horizontalConstraint1 =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|"
                                            options:0
                                            metrics:nil
                                              views:views];
    NSArray* verticalConstraint1 =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|"
                                            options:0
                                            metrics:nil
                                              views:views];
    
    [self.view addConstraints:horizontalConstraint1];
    [self.view addConstraints:verticalConstraint1];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OSPlayerViewController* vc = [[OSPlayerViewController alloc] init];
    vc.url = self.videos[indexPath.row].videoURL;
    
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void) tapAction {
//    [self.searchBar resignFirstResponder];
//}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videos.count;
}

-(OSVideoTableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OSVideoTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    [cell fillWithModel:self.videos[indexPath.row]];
    
    if(indexPath.row + 1 == self.videos.count && indexPath.row + 1 < 1000) {
        [self getVideosFromServer];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.tableView.bounds.size.height / 10;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self getVideosFromServer];
    [self.searchBar resignFirstResponder];
}


@end
