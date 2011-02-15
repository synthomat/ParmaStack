//
//  ParmaStackAppDelegate.h
//  ParmaStack
//
//  Created by Anton Zering on 15.02.11.
//  Copyright 2011 private. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ParmaStackAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
