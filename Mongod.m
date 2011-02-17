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
//  Mongod.m
//  ParmaStack
//

#import "Mongod.h"


@implementation Mongod

- (id)init {
	// call parent constructor
	self = [super init];

	// set default options for the daemon
	options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
	           nil];

	// we want to keep our options for later usage
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

	if (task != Nil) {
		[task release];
	}
	// initialize a new NSTask object
	task = [[NSTask alloc] init];

	// arguments for the executable
	[task setArguments: [NSArray arrayWithObjects:
	                     // the server root directory
	                     [@"--dbpath=" stringByAppendingString: [[options objectForKey:@"ServerRoot"] stringByAppendingString:@"/var/mongo-data"]],
	                     [@"--pidfilepath=" stringByAppendingString: [[options objectForKey:@"ServerRoot"] stringByAppendingString:@"/var/run/mongod.pid"]],
	                     nil]];

	[task setCurrentDirectoryPath: [options objectForKey:@"ServerRoot"]];
	[task setLaunchPath: [[options objectForKey:@"ServerRoot"] stringByAppendingString: @"/bin/mongod"]];
	// launch the mongod daemon
	[task launch];

}

- (void)stop {
	if (![self isRunning]) {
		return;
	}
	
	// terminate mongod daemon
	if ([self oldProcessExists]) {
		// pid of an existing process which was launched within a previous session
		NSString *pid = [NSString stringWithContentsOfFile:[[options objectForKey:@"ServerRoot"] stringByAppendingString:@"/var/run/mongod.pid"]
												  encoding:NSUTF8StringEncoding
		                                             error:NULL];
		// trim newline
		pid = [pid stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];

		// kill process by pid
		[NSTask launchedTaskWithLaunchPath:@"/bin/kill" arguments: [NSArray arrayWithObject: pid]];
	} else {
		// terminate process from current session
		[task terminate];
	}
}

- (BOOL)isRunning {
	// test whether our mongod daemon is running
	return (task != Nil && [task isRunning]) || [self oldProcessExists];
}

- (BOOL)oldProcessExists {
	NSFileManager *fm = [[NSFileManager alloc] init];

	// check whether a pid file exists
	return [fm fileExistsAtPath: [[options objectForKey:@"ServerRoot"] stringByAppendingString:@"/var/run/mongod.pid"]];
}
@end
