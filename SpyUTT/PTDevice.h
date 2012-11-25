//
//  PTDevice.h
//  ProcTest
//
//  Created by Zhang on 23/10/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/sysctl.h>

@interface UIDevice (ProcessesAdditions)

- (NSDictionary *)runningProcesses;
- (NSDictionary *) getActiveApps;

@end
