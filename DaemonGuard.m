/*
 * Copyright © 2011 sublink.de
 *
 * This file is part of ParmaStack.
 *
 * ParmaStack is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published
 * by the Free Software Foundation; either version 3 of the licence or (at
 * your option) any later version.
 *
 * ParmaStack is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General
 * Public License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307, USA.
 *
 * Authors: Anton Zering <info@sublink.de>
 */

//
//  DaemonGuard.m
//  ParmaStack
//

#import "DaemonGuard.h"


@implementation DaemonGuard
@synthesize httpdButton;

- (id)init {
	// call parent constructor
	self = [super init];

	// initialize http daemon
	httpd = [[ApacheHttpd alloc] init];

	// set options for our httpd daemon
	[httpd setOptions: [NSDictionary dictionaryWithObjectsAndKeys:
	                    // server root directory
	                    [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/Contents/Resources/Unix"], @"ServerRoot",
	                    nil]];

	return self;
}

- (void)awakeFromNib {
	[httpdButton setState:[httpd isRunning]];
}

- (IBAction)toggleHttpd:(id)sender {
	if (![httpd isRunning])	{
		// start httpd daemon
		[httpd start];
	} else {
		// stop httpd daemon
		[httpd stop];
	}
}

@end
