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
@synthesize arguments;
@synthesize env;

+ (GeneralDaemon *)initWithWorkingDirectory:(NSString *)directory andDaemon: (NSString *)daemon{
  GeneralDaemon *gd = [[GeneralDaemon alloc] init];
  
  // working directory
  gd.workingDirectory = directory;
  
  // decide whether to use absolute or relative paths
  if ([[daemon substringToIndex:1] isEqualTo:@"/"]) {
    gd.daemonPath = daemon;
  } else {
    gd.daemonPath = [NSString pathWithComponents:
                     [NSArray arrayWithObjects: directory, @"bin", daemon, nil]];
  }
  
  // guess |pidFilePath|
  gd.pidFilePath = [[NSString pathWithComponents:
                     [NSArray arrayWithObjects:gd.workingDirectory,
                                               @"var/run",
                                               [gd.daemonPath lastPathComponent],
                                               nil]] stringByAppendingPathExtension:@"pid"];
  return [gd autorelease];
}

- (void)start {
  // We won't start, if another process is still running.
  if ([self isRunning]) {
    return;
  }


  // Does an old object exist? if yes: drop it.
  if (process) {
    [process release];
  }
  process = [[NSTask alloc] init];
  
  // Provide arguments.
  if (arguments) {
    [process setArguments:arguments];
  }
  
  // Provide environment variables
  if (env) {
    [process setEnvironment:env];
  }

  // Set working directory.
  [process setCurrentDirectoryPath:workingDirectory];

  // Set path to the executable.
  [process setLaunchPath: daemonPath];

  // Launch the task.
  [process launch];
}

- (void)stop {
  // If nothing is running, we can't stop anything.
  if (![self isRunning]) {
    return;
  }
  
  if (!process && [self pidFromPidFile]) {
    [NSTask launchedTaskWithLaunchPath:@"/bin/kill"
                             arguments:[NSArray arrayWithObject:
                                        [[self pidFromPidFile] stringValue]]];

  } else {
    [process terminate];
  }
}

// gets the pid from a file
// returns Nil when file does not exist or is empty
- (NSNumber *)pidFromPidFile {

  NSString *pid = [NSString stringWithContentsOfFile:pidFilePath
                                            encoding:NSUTF8StringEncoding
                                               error:NULL];

  // if file does not exist, return Nil
  if(!pid)
    return Nil;

  // trim whitespaces
  pid = [pid stringByTrimmingCharactersInSet:
         [NSCharacterSet whitespaceAndNewlineCharacterSet]];

  // return |pid| as number or Nil
  return [[[NSNumberFormatter alloc] init] numberFromString:pid];
}

- (BOOL)isRunning {
  // checking
  // 1. Process object exists
  // 2. and Process is running
  // 3. or PidFile exists.

  return ((process && [process isRunning])) || [self pidFromPidFile] ? YES : NO;
}
@end
