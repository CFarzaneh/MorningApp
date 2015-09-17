#import <Preferences/Preferences.h>

@interface morningappprefsListController: PSListController {
}
@end

@implementation morningappprefsListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"morningappprefs" target:self] retain];
	}
	return _specifiers;
}

-(void)openTwitterLink:(id)arg1 {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/persian_cam"]];
}

-(void)installPrefsDonate:(id)arg1 {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://bit.ly/1N2lQve"]];
}


-(void)resetMorningPrefs:(id)arg1 {
    NSFileManager *fileManager= [NSFileManager defaultManager];
    NSString *peath = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/com.cfarzaneh.morningappprefs.plist"];
    NSString *peathtwo = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/com.cfarzaneh.morningapptime.plist"];
    
    [fileManager removeItemAtPath:peath error:nil];
    [fileManager removeItemAtPath:peathtwo error:nil];
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"MorningApp"
                          message:@"Preferences have been reset"
                          delegate:nil
                          cancelButtonTitle:@"Dismiss"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    
}

@end

// vim:ft=objc
