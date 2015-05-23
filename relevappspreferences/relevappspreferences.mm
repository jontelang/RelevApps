#import <Preferences/Preferences.h>

@interface relevappspreferencesListController: PSListController {
}
@end

@implementation relevappspreferencesListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"relevappspreferences" target:self] retain];
	}
	return _specifiers;
}
@end

// vim:ft=objc
