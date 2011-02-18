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
  
  NSTask *process;
}

@property (assign) NSString *workingDirectory;
@property (assign) NSString *pidFilePath;
@property (assign) NSString *daemonPath;

+ (id)initWithWorkingDirectory:(NSString *)directory andDaemonPath: (NSString *)dPath;
- (BOOL)isRunning;

@end