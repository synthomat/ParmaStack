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
//  GeneralDaemon.m
//  ParmaStack
//

#import "GeneralDaemon.h"


@implementation GeneralDaemon

@synthesize workingDirectory;
@synthesize pidFilePath;
@synthesize daemonPath;

+ (id)initWithWorkingDirectory:(NSString *)directory andDaemonPath: (NSString *)dPath {
  GeneralDaemon *gd = [[GeneralDaemon alloc] init];
  
  // working directory
  gd.workingDirectory = directory;
  
  // decide whether to use absolute or relative paths
  if ([[dPath substringToIndex:1] isEqualTo:@"/"]) {
    gd.daemonPath = dPath;
  } else {
    gd.daemonPath = [NSString pathWithComponents:[NSArray arrayWithObjects: directory, dPath, nil]];
  }
  
  // guess |pidFilePath|
  gd.pidFilePath = [[gd.daemonPath lastPathComponent] stringByAppendingPathExtension:@"pid"];

  return gd;
}

- (void)start {
  process = [[NSTask alloc] init];
  
}

- (void)stop {
  
}

// gets the pid from a file
// returns Nil when file does not exist or is empty
- (id)pidFromPidFile {
  NSString *pid = [NSString stringWithContentsOfFile:pidFilePath
                                            encoding:NSUTF8StringEncoding
                                               error:NULL];

  // if file does not exist, return Nil
  if(!pid)
    return Nil;
  
  // trim whitespaces
  pid = [pid stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

  // return |pid| as number or Nil
  return [[[[NSNumberFormatter alloc] init] autorelease] numberFromString:pid];
}

- (BOOL)isRunning {
  return [self pidFromPidFile] != Nil ? YES : NO;
}
@end
