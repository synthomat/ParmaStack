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
//  GeneralDaemon.h
//  ParmaStack
//

#import <Cocoa/Cocoa.h>


@interface GeneralDaemon : NSObject {
  NSString *workingDirectory;
  NSString *pidFilePath;
  NSString *daemonPath;
  
  NSArray *arguments;
  NSDictionary *env;
  
  NSTask *process;
}

@property (retain) NSString *workingDirectory;
@property (retain) NSString *pidFilePath;
@property (retain) NSString *daemonPath;
@property (retain) NSArray *arguments;
@property (retain) NSDictionary *env;


+ (id)initWithWorkingDirectory:(NSString *)directory andDaemon: (NSString *)daemon;
- (void)start;
- (void)stop;
- (BOOL)isRunning;
- (NSNumber *)pidFromPidFile;

@end