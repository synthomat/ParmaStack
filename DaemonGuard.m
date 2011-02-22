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
#import "GeneralDaemon.h"

@implementation DaemonGuard
@synthesize httpdButton;
@synthesize mongoButton;

- (id)init {
  self = [super init];
  
  NSString *unixPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/Unix"];

  httpd = [GeneralDaemon initWithWorkingDirectory:unixPath
                                                  andDaemon:@"httpd"];
  
  httpd.arguments = [NSArray arrayWithObjects:@"-DFOREGROUND",
                    [@"-d" stringByAppendingString:unixPath],
                    nil];

  httpd.env = [NSDictionary dictionaryWithObjectsAndKeys:@"8080", @"PORT",
              // [unixPath stringByAppendingPathComponent:@"var/web/htdocs"], @"HTDOCS",
              nil];

  [httpd retain];
  

  mongod = [GeneralDaemon initWithWorkingDirectory:unixPath
                                        andDaemon:@"mongod"];
  
  mongod.arguments = [NSArray arrayWithObjects:
                      [@"--dbpath=" stringByAppendingString: [unixPath stringByAppendingPathComponent:@"var/mongo-data"]],
                      [@"--pidfilepath=" stringByAppendingString: [mongod pidFilePath]],
                     nil];
  
  [mongod retain];
  
  return self;
}

- (void)awakeFromNib {
	[httpdButton setState:[httpd isRunning]];
 	[mongoButton setState:[mongod isRunning]];
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

- (IBAction)toggleMongo:(id)sender {
	if (![mongod isRunning]) {
		// start mongod daemon
		[mongod start];
	} else {
		// stop mongod daemon
		[mongod stop];
	}
}

@end
