static NSMutableDictionary *temporaryDictionary = Nil;

static void addApp(NSString* appname){
	NSLog(@"[secret-tweak] +++ addApp +++");

	NSDate *date = [NSDate date];
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[dateFormatter setDateFormat:@"HH"]; // :mm
	NSString *hour = [dateFormatter stringFromDate:date];
	CFAbsoluteTime at = CFAbsoluteTimeGetCurrent();
	CFTimeZoneRef tz = CFTimeZoneCopySystem();
	SInt32 WeekdayNumber = CFAbsoluteTimeGetDayOfWeek(at, tz);
	NSLog(@"[secret-tweak] %@ %i", hour, (int)WeekdayNumber);
	NSString *day = [NSString stringWithFormat:@"%i",(int)WeekdayNumber];

	NSLog(@"[secret-tweak] %@",temporaryDictionary);
	// if(temporaryDictionary==Nil){temporaryDictionary=[[NSMutableDictionary alloc] init];}

	if( [temporaryDictionary objectForKey:day] == Nil ){
		[temporaryDictionary setObject:[[NSMutableDictionary alloc] init] forKey:day];
	}

	NSMutableDictionary *dayDict = [temporaryDictionary objectForKey:day];

	if( [dayDict objectForKey:hour] == Nil ){
		[dayDict setObject:[[NSMutableDictionary alloc] init] forKey:hour];	
	}

	NSMutableDictionary *hourDict = [dayDict objectForKey:hour];

	if( [hourDict objectForKey:appname] == Nil ){
		[hourDict setObject:@1 forKey:appname];
	}else{
		int uses = [[hourDict valueForKey:appname] integerValue];
		uses++;
		[hourDict setObject:[NSNumber numberWithInt:uses] forKey:appname];
	}

	NSLog(@"[secret-tweak]  - -- - - ");
	NSLog(@"[secret-tweak]  - -- - - ");
	NSLog(@"[secret-tweak] %@", temporaryDictionary);
	NSLog(@"[secret-tweak]  - -- - - ");
	NSLog(@"[secret-tweak]  - -- - - ");
	BOOL didWrite = [temporaryDictionary writeToFile:@"/Library/appstat/data.plist" atomically:YES];
	if(didWrite){
		NSLog(@"[secret-tweak] did write it");
	}else{
		NSLog(@"[secret-tweak] did NOT write it");
	}
	NSDictionary* onFile = [[NSDictionary alloc] initWithContentsOfFile:@"/Library/appstat/data.plist"];
	NSLog(@"[secret-tweak] on file: %@",onFile);
}

%hook SBWorkspace

// - (void)workspace:(id)arg1 applicationDidFinishLaunching:(id)arg2 withInfo:(id)arg3{NSLog(@"[secret-tweak] ------ applicationDidFinishLaunching, %@",arg2);%orig();}
// - (void)workspace:(id)arg1 applicationDidStartLaunching:(id)arg2{NSLog(@"[secret-tweak] ------ applicationDidStartLaunching, %@",arg2);%orig();}

- (void)workspace:(id)arg1 applicationActivated:(id)arg2{
	NSLog(@"[secret-tweak] ------ applicationActivated, %@",arg2);
	%orig();
	addApp(arg2);
}

%end

%ctor{
	NSLog(@"[secret-tweak] +++ ctor secretappppppppppp +++");
	if( [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/appstat/data.plist"] ){
		NSLog(@"[secret-tweak] +++ has file +++");
		// NSError *e;
		// [[NSFileManager defaultManager] createDirectoryAtPath:@"/Library/appstat/" 
		// 								withIntermediateDirectories:NO attributes:nil error:&e];
		// NSLog(@"[secret-tweak] %@",e);
		system("cat /Library/appstat/data.plist >> /tmp/whatever.plist");
		temporaryDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/Library/appstat/data.plist"];
		NSLog(@"[secret-tweak] loaded from disk");
		NSLog(@"[secret-tweak] %@",temporaryDictionary);
	}else{
		NSLog(@"[secret-tweak] === didnt have file try to write one ===");
		system("touch /Library/appstat/data.plist");
	}

	if(temporaryDictionary==Nil){
		temporaryDictionary = [[NSMutableDictionary alloc] init];
	}
	NSLog(@"[secret-tweak] +++ ctor end +++");
}