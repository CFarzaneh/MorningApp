#import <UIKit/UIKit.h>
#import <AppList/AppList.h>

@interface SBApplicationController
+(id)sharedInstance;
-(id)applicationWithBundleIdentifier:(id)arg1;
-(id)applicationWithDisplayIdentifier:(id)arg1;
@end

@interface SBApplication
-(id)bundleIdentifier;
-(id)displayIdentifier;
@end

@interface SBUIController : NSObject
-(void)activateApplication:(id)arg1;
-(void)activateApplicationAnimated:(id)arg1;
@end

static NSString *appToOpen;
static NSString *timeForWake;
static NSDictionary *prefs;
BOOL enabled;

static void loadMorningAppPrefs() {
    prefs = [[NSDictionary alloc] initWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.cfarzaneh.morningappprefs.plist"]];
    appToOpen = [prefs objectForKey:@"App"];
    timeForWake = [prefs objectForKey:@"waketimestring"];
    enabled = [[prefs objectForKey:@"killswitch"] boolValue];
}

static NSDate *morningAppDate(NSDate *datDate) {
    
    if( datDate == nil ) {
        datDate = [NSDate date];
    }
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:datDate];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
    
}

static BOOL morningAppCanOpenApp() {
    
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.cfarzaneh.morningapptime.plist"] ?: [[NSMutableDictionary alloc] init];
    
    NSDate *lastDate = [prefs objectForKey:@"lastDate"] ? : [NSDate dateWithTimeIntervalSinceNow:-86400];
    
    NSDate *zDate = morningAppDate(nil);
    
    if ([zDate compare:morningAppDate(lastDate)] == NSOrderedDescending) {
        
        [prefs setObject:zDate forKey:@"lastDate"];
        
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm:ss"];
        NSDate *todaysDate;
        todaysDate = [NSDate date];
        
        NSString *string = timeForWake;
        
        if ([string length] == 0) {
            string = @"06:15:00";
        }
        
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        NSDateFormatter *timeOnlyFormatter = [[NSDateFormatter alloc] init];
        [timeOnlyFormatter setLocale:locale];
        [timeOnlyFormatter setDateFormat:@"HH:mm:ss"];
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *today = [NSDate date];
        NSDateComponents *todayComps = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
        
        NSDateComponents *comps = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:[timeOnlyFormatter dateFromString:string]];
        comps.day = todayComps.day;
        comps.month = todayComps.month;
        comps.year = todayComps.year;
        NSDate *date = [calendar dateFromComponents:comps];
        
        
        
        //NSLog(@"%@",[timeOnlyFormatter stringFromDate:date]);
        
        
        if ([todaysDate compare:date] == NSOrderedDescending) {
            //NSLog(@"open");
            [prefs writeToFile:@"/var/mobile/Library/Preferences/com.cfarzaneh.morningapptime.plist" atomically:YES];
            return YES;
        } else if ([todaysDate compare:date] == NSOrderedAscending) {
            //NSLog(@"dont open");
            return NO;
        } else {
            //NSLog(@"open");
            [prefs writeToFile:@"/var/mobile/Library/Preferences/com.cfarzaneh.morningapptime.plist" atomically:YES];
            return YES;
        }
        
    } else {
        
        return NO;
        
    }
    
}

static void morningAppDoOpenApp() {
    if([[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/Preferences/com.cfarzaneh.morningapptime.plist"]) {
        if([[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/Preferences/com.cfarzaneh.morningappprefs.plist"]) {
                        
            loadMorningAppPrefs();
            if (enabled) {
                    if (morningAppCanOpenApp()) {

                    	NSString *version = [UIDevice currentDevice].systemVersion;
   						 if (version.intValue >= 9.0) {

							SBApplication *app = [(SBApplicationController *) [objc_getClass("SBApplicationController") sharedInstance] applicationWithBundleIdentifier:appToOpen];
							[(SBUIController *) [objc_getClass("SBUIController") sharedInstance] activateApplication:app];

    					} else {

                            SBApplication *app = [[%c(SBApplicationController) sharedInstance] applicationWithDisplayIdentifier:appToOpen];
                            [[%c(SBUIController) sharedInstance] activateApplicationAnimated:app];
        
    				}
                    	    
            
                    }
            }
        }
        else {
                
                NSMutableDictionary *prefss = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.cfarzaneh.morningapptime.plist"] ?: [[NSMutableDictionary alloc] init];
                
                NSDate *zDatee = morningAppDate(nil);
                
                [prefss setObject:zDatee forKey:@"lastDate"];
                [prefss writeToFile:@"/var/mobile/Library/Preferences/com.cfarzaneh.morningapptime.plist" atomically:YES];
            }
    
    }
    else {
        
        //First launch
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"MorningApp"
                              message:@"Thank you for installing MorningApp! To configure your launch application, please visit settings."
                              delegate:nil
                              cancelButtonTitle:@"Dismiss"
                              otherButtonTitles:nil];
        [alert show];
        
        NSMutableDictionary *prefss = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.cfarzaneh.morningapptime.plist"] ?: [[NSMutableDictionary alloc] init];
        
        NSDate *zDatee = morningAppDate(nil);
        
            
        [prefss setObject:zDatee forKey:@"lastDate"];
        [prefss writeToFile:@"/var/mobile/Library/Preferences/com.cfarzaneh.morningapptime.plist" atomically:YES];
            
    }

}

%hook SBLockScreenViewController

- (void)finishUIUnlockFromSource:(int)arg1 {
    
    %orig;
    morningAppDoOpenApp();
    
}
%end