//
//  DemoViewController.m
//  Demo CMActionSheet
//
//  Created by Constantine Mureev on 09.08.12.
//  Copyright (c) 2012 Team Force LLC. All rights reserved.
//

#import "DemoViewController.h"
#import "CMActionSheet.h"

@interface DemoViewController ()

- (void)showActionSheet;

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton* actionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [actionButton setTitle:@"Show" forState:UIControlStateNormal];
    [actionButton addTarget:self action:@selector(showActionSheet) forControlEvents:UIControlEventTouchUpInside];
    actionButton.frame = CGRectMake(0, 0, 220, 44);
    actionButton.center = self.view.center;
    actionButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:actionButton];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)showActionSheet {
    CMActionSheet *actionSheet = [[[CMActionSheet alloc] init] autorelease];
    //actionSheet.title = @"Test Action sheet";
    
    // Customize
    [actionSheet addButtonWithTitle:@"First Button" type:CMActionSheetButtonTypeWhite block:^{
        NSLog(@"Dismiss action sheet with \"First Button\"");
    }];
    [actionSheet addSeparator];
    [actionSheet addButtonWithTitle:@"Close Button" type:CMActionSheetButtonTypeBlue block:^{
        NSLog(@"Dismiss action sheet with \"Close Button\"");
    }];
    
    // Present
    [actionSheet present];
}

@end
