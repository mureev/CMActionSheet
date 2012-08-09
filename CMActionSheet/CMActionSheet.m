//
//  CMActionSheet.m
//
//  Created by Constantine Mureev on 09.08.12.
//  Copyright (c) 2012 Team Force LLC. All rights reserved.
//

#import "CMActionSheet.h"
#import "CMRotatableModalViewController.h"
#import "UIControl+ActionBlock.h"


@interface CMActionSheet ()

@property (retain) UIImageView *backgroundActionView;
@property (retain) UIWindow *overlayWindow;
@property (retain) UIWindow *mainWindow;
@property (retain) NSMutableArray *buttons;

@end

@implementation CMActionSheet

@synthesize title, backgroundActionView, overlayWindow, mainWindow, buttons;

- (id)init {
    self = [super init];
    if (self) {
        UIImage *backgroundImage = [UIImage imageNamed:@"action-sheet-panel.png"];
        backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:0 topCapHeight:30];
        
        self.backgroundActionView = [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];
        self.backgroundActionView.alpha = 0.8;
        self.backgroundActionView.contentMode = UIViewContentModeScaleToFill;
        self.backgroundActionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.overlayWindow = [[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
        self.overlayWindow.windowLevel = UIWindowLevelStatusBar;
        self.overlayWindow.userInteractionEnabled = YES;
        self.overlayWindow.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5f];
        self.overlayWindow.hidden = YES;
    }
    return self;
}

- (void)dealloc {
    self.backgroundActionView = nil;
    self.overlayWindow = nil;
    self.mainWindow = nil;
    self.buttons = nil;
    
    [super dealloc];
}

- (void)addButtonWithTitle:(NSString *)buttonTitle type:(CMActionSheetButtonType)type block:(void (^)())block {
	NSAssert(buttonTitle, @"Button title must not be nil!");
    
    NSUInteger index = 0;
    
    if (!self.buttons) {
        self.buttons = [NSMutableArray array];
    }
    
    NSString* color = nil;
    if (CMActionSheetButtonTypeBlue == type) {
        color = @"blue";
    } else if (CMActionSheetButtonTypeRed == type) {
        color = @"red";
    } else if (CMActionSheetButtonTypeWhite == type) {
        color = @"white";
    } else if (CMActionSheetButtonTypeGray == type) {
        color = @"gray";
    } else {
        color = @"white";
    }
    
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"action-%@-button.png", color]];
    image = [image stretchableImageWithLeftCapWidth:(int)(image.size.width)>>1 topCapHeight:0];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    button.titleLabel.minimumFontSize = 6;
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleLabel.textAlignment = UITextAlignmentCenter;
    button.titleLabel.shadowOffset = CGSizeMake(0, -1);
    button.backgroundColor = [UIColor clearColor];
    
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.accessibilityLabel = title;
    
    [button addEventHandler:^(id sender, UIEvent *event) {
        [self dismissWithClickedButtonIndex:index animated:YES];
    } forControlEvent:UIControlEventTouchUpInside];
    
    [self.buttons addObject:button];
    
    index++;
}

- (void)addSeparator {
    
}

- (void)present {
    if (self.buttons && self.buttons.count > 0) {
        self.mainWindow = [UIApplication sharedApplication].keyWindow;
        CMRotatableModalViewController *viewController = [[CMRotatableModalViewController new] autorelease];
        viewController.rootViewController = mainWindow.rootViewController;
        
        // Build action sheet view
        UIView* actionSheet = [[[UIView alloc] initWithFrame:CGRectMake(0, viewController.view.frame.size.height, viewController.view.frame.size.width, 220)] autorelease];
        actionSheet.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [viewController.view addSubview:actionSheet];
        
        // Add background
        self.backgroundActionView.frame = CGRectMake(0, 0, actionSheet.frame.size.width, actionSheet.frame.size.height);
        [actionSheet addSubview:self.backgroundActionView];
        
        CGFloat offset = 15;
        
        // Add Title
        if (self.title) {
            CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:18]
                            constrainedToSize:CGSizeMake(actionSheet.frame.size.width-10*2, 1000)
                                lineBreakMode:UILineBreakModeWordWrap];
            
            UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(10, offset, actionSheet.frame.size.width-10*2, size.height)];
            labelView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            labelView.font = [UIFont systemFontOfSize:18];
            labelView.numberOfLines = 0;
            labelView.lineBreakMode = UILineBreakModeWordWrap;
            labelView.textColor = [UIColor whiteColor];
            labelView.backgroundColor = [UIColor clearColor];
            labelView.textAlignment = UITextAlignmentCenter;
            labelView.shadowColor = [UIColor blackColor];
            labelView.shadowOffset = CGSizeMake(0, -1);
            labelView.text = title;
            [actionSheet addSubview:labelView];
            
            offset += size.height + 10;
        }
        
        // Add action sheet items
        for (UIView *item in self.buttons) {
            item.frame = CGRectMake(10, offset, actionSheet.frame.size.width - 10*2, 45);
            [actionSheet addSubview:item];
            
            offset += 45 + 10;
        }
        
        // Present window and action sheet
        self.overlayWindow.rootViewController = viewController;
        self.overlayWindow.alpha = 0.0f;
        self.overlayWindow.hidden = NO;
        [self.overlayWindow makeKeyWindow];
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationCurveEaseOut animations:^{
            self.overlayWindow.alpha = 1.0;
            CGPoint center = actionSheet.center;
            center.y -= actionSheet.frame.size.height;
            actionSheet.center = center;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                CGPoint center = actionSheet.center;
                center.y += 10;
                actionSheet.center = center;
            } completion:nil];
        }];
    }
}

- (void)dismissWithClickedButtonIndex:(NSUInteger)index animated:(BOOL)animated {
    // Hide window and action sheet
    
    // Call callback
}


#pragma mark - Private


- (void)buttonClicked:(id)sender {
    NSUInteger buttonIndex = ((UIView *)sender).tag - 100;
    [self dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

@end
