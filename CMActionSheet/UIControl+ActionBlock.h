//
//  UIControl+ActionBlock.h
//  Demo CMActionSheet
//
//  Created by Constantine Mureev on 09.08.12.
//  Copyright (c) 2012 Team Force LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^UIControlEventHandler)(id sender, UIEvent *event);

@interface UIControl (ActionBlock)

- (void)addEventHandler:(UIControlEventHandler)handler forControlEvent:(UIControlEvents)controlEvent;
- (void)removeEventHandlersForControlEvent:(UIControlEvents)controlEvent;

@end
