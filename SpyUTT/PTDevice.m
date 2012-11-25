//
//  PTDevice.m
//  ProcTest
//
//  Created by Zhang on 23/10/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import "PTDevice.h"
#import <dlfcn.h>

@implementation UIDevice (ProcessesAdditions)

- (NSDictionary *)runningProcesses {
    
	int mib[4] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0};
    //int mib[4] = {CTL_KERN, KERN_PROC, KERN_PROC_RUID, 0};
	size_t miblen = 4;
	
	size_t size;
	int st = sysctl(mib, miblen, NULL, &size, NULL, 0);
	
	struct kinfo_proc * process = NULL;
	struct kinfo_proc * newprocess = NULL;
	
    do {
		
        size += size / 10;
        newprocess = realloc(process, size);
		
        if (!newprocess){
			
            if (process){
                free(process);
            }
			
            return nil;
        }
		
        process = newprocess;
        st = sysctl(mib, miblen, process, &size, NULL, 0);
		
    } while (st == -1 && errno == ENOMEM);
	
	if (st == 0){
		
		if (size % sizeof(struct kinfo_proc) == 0){
			int nprocess = size / sizeof(struct kinfo_proc);
            
			if (nprocess){
                NSMutableArray * appArray = [[NSMutableArray alloc] init];
                NSMutableArray *sysArray = [[NSMutableArray alloc] init];
                NSMutableArray * builtInArray = [[NSMutableArray alloc] init];
                NSString *systemProcs = @"kernel_task launchd UserEventAgent wifid syslogd powerd lockdownd mediaserverd mDNSResponder locationd imagent iaptransportd fseventsd fairplayd.N88 configd backboardd kbd CommCenterClassi BTServer notifyd SpringBoard networkd aggregated apsd distnoted dataaccessd aosnotifyd tccd filecoordination installd itunesstored networkd_privile lsd ptpd afcd notification_pro mobile_assertion syslog_relay syslog_relay springboardservi  assetsd accountsd timed lockbot syncdefaultsd keybagd debugserver profiled amfid mediaremoted pasteboardd securityd sandboxd CommCenterRootHe fairplayd.N94 assistivetouchd imavagent absinthed.N94 coresymbolicatio AppleIDAuthAgent geod gamed ubd eapolclient assistantd assistant_servic xpcd calaccessd mobile_installat backupd MobileStorageMou softwareupdatese recentsd mDNSResponderHel RRSpring sociald librariand commCenterMobile mstreamd ReportCrash deleted blueTool quicklookd misd vsassetd passd webbookmarksd";
                NSString *builtInProcs = @"MobileCal MobileNotes MobileMail MobilePhone MobileSMS Preferences Maps Videos Weather AppStore MobileTimer Calculator Camera VoiceMemos MobileSafari Shoebox MobileSlideShow Compass";
                //NSMutableString *sysProc = [[NSMutableString alloc]init];
				for (int i = nprocess - 1; i >= 0; i--){
                    //NSLog(@"name=%s, uid=%d\n",process[i].kp_proc.p_comm,process[i].kp_proc.p_pid);
                    NSString * processID = [[NSString alloc] initWithFormat:@"%d", process[i].kp_proc.p_pid];
                    NSString * processName = [[NSString alloc] initWithFormat:@"%s", process[i].kp_proc.p_comm];
                    NSString * processStat = [[NSString alloc] initWithFormat:@"%hhd", process[i].kp_proc.p_stat];
                    
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:process[i].kp_proc.p_un.__p_starttime.tv_sec];
                    
                    //NSString *description = [[NSString alloc]init];
                    /*if([processName isEqualToString:@"Launchd"]){
                        description = @"takes over many tasks from cron, xinetd, mach_init, and init, which are UNIX programs that traditionally have handled system initialization, called systems scripts, run startup items, and generally prepared the system for the user.";
                    }else if([processName isEqualToString:@"TQServer"]){
                        description = @"Net Long Company PC Suit daemon";
                    }*/
                    NSDictionary * dict = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:processID, processName, processStat, date, nil]
                                                                        forKeys:[NSArray arrayWithObjects:@"ProcessID", @"ProcessName", @"ProcessStat", @"StartTime", nil]];
                    if([systemProcs rangeOfString:processName].location != NSNotFound){
                        [sysArray addObject:dict];
                    }else if ([builtInProcs rangeOfString:processName].location != NSNotFound){
                        [builtInArray addObject:dict];
                    }else{
                        [appArray addObject:dict];
                    }
				}
                free(process);
                //NSLog(@"%@", sysProc);
                return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:appArray, builtInArray,sysArray, nil] forKeys:[NSArray arrayWithObjects:@"app",@"builtin",@"sys", nil]];
			}
		}
	}
    return nil;
}


#define SBSERVPATH "/System/Library/PrivateFrameworks/SpringBoardServices.framework/SpringBoardServices"

- (NSDictionary *) getActiveApps
{
    
    mach_port_t *port;
    void *lib = dlopen(SBSERVPATH, RTLD_LAZY);
    int (*SBSSpringBoardServerPort)() =
    dlsym(lib, "SBSSpringBoardServerPort");
    port = (mach_port_t *)SBSSpringBoardServerPort();
    dlclose(lib);
    
    
    /*mach_port_t *p;
    void *uikit = dlopen(UIKITPATH, RTLD_LAZY);
    int (*SBSSpringBoardServerPort)() =
    dlsym(uikit, "SBSSpringBoardServerPort");
    p = (mach_port_t *)SBSSpringBoardServerPort();
    dlclose(uikit);*/
    
    void *sbserv = dlopen(SBSERVPATH, RTLD_LAZY);
    void* (*SBFrontmostApplicationDisplayIdentifier)(mach_port_t* port,char * result) =
    dlsym(sbserv, "SBFrontmostApplicationDisplayIdentifier");
    
    //http://itunes.apple.com/lookup?bundleId=com.skype.skype
    
    //Get frontmost application
    char frontmostAppS[256];
    memset(frontmostAppS,sizeof(frontmostAppS),0);
    SBFrontmostApplicationDisplayIdentifier(port,frontmostAppS);
    NSString * frontmostApp=[NSString stringWithFormat:@"%s",frontmostAppS];
    //NSLog(@"Frontmost app is %@",frontmostApp);
    
    dlclose(sbserv);
    
    return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSDate date], frontmostApp, nil] forKeys: [NSArray arrayWithObjects: @"time", @"bundleid", nil]];
}

@end
