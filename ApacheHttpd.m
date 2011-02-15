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
//  ApacheHttpd.m
//  ParmaStack
//

#import "ApacheHttpd.h"


@implementation ApacheHttpd

- (id)init {
	// call parent constructor
	self = [super init];

	// set default options for the daemon
	options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
			   @"8080", @"Port",
			   @"etc/apache2/httpd.conf", @"Config",
			   nil];
    
	[options retain];

	return self;
}

- (void)setOptions:(id)dict
{
	// merge new options with old ones
	[options addEntriesFromDictionary:dict];
}

- (void)start {

	// check whether the task is already running
	// prevent double starting
	if ([self isRunning]) {
		return;
	}

	// initialize a new NSTask object
	task = [[NSTask alloc] init];

	// set various options as env
	[task setEnvironment: [NSDictionary dictionaryWithObjectsAndKeys:
						   [options objectForKey:@"Port"], @"PORT",
						   nil]];

	// arguments for the executable
	[task setArguments: [NSArray arrayWithObjects:
						 // we want our httpd daemon to run in foreground
						 // otherwise it will fork and terminate the init process
						 @"-DFOREGROUND",

						 // the server root directory
						 [@"-d" stringByAppendingString: [options objectForKey:@"ServerRoot"]],

						 // the configuration file
						 [@"-f" stringByAppendingString: [options objectForKey:@"Config"]],
						 nil]];

	[task setLaunchPath: [[options objectForKey:@"ServerRoot"] stringByAppendingString: @"/bin/httpd"]];

	// launch the httpd daemon
	[task launch];

}

- (void)stop {
	if (![self isRunning]) {
		return;
	}

	// terminate httpd daemon
	[task terminate];
}

- (BOOL)isRunning {
	// test whether our httpd daemon is running
	return (task != Nil && [task isRunning]);
}
@end
