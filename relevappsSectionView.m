#define PREFS_FILE @"/var/mobile/Library/Preferences/com.jontelang.relevappspreferences.plist"

@interface UIApplication ()
-(BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2;
@end
@interface SBIconModel : NSObject
-(id)applicationIconForDisplayIdentifier:(id)arg1; // ios 7
-(id)applicationIconForBundleIdentifier:(id)arg1; // ios 8
@end
@interface SBIconController : NSObject {
    SBIconModel *_iconModel;
}
+ (id)sharedInstance;
@end
@interface SBApplicationIcon
-(id)getIconImage:(int)arg1;
@end

#import "relevappsSectionView.h"

@implementation relevappsSectionView

- (void)layoutSubviews {
    [super layoutSubviews];
	float screenWidth = [UIScreen mainScreen].bounds.size.width;
	UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,screenWidth,90)];
	[scrollView addSubview:[self getIconsForGroupName:@"Night" atPositionIndex:0]];
	[scrollView addSubview:[self getIconsForGroupName:@"Morning" atPositionIndex:1]];
	[scrollView addSubview:[self getIconsForGroupName:@"Daytime" atPositionIndex:2]];
	[scrollView addSubview:[self getIconsForGroupName:@"Evening" atPositionIndex:3]];
	[scrollView addSubview:[self getIconsForGroupName:@"Night" atPositionIndex:4]];
	[scrollView setContentSize:CGSizeMake(screenWidth*5,90)];
	[scrollView setPagingEnabled:YES];
	NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
	timeFormatter.dateFormat = @"HH";
	NSString *datestringofHour= [timeFormatter stringFromDate:[NSDate date]];
	int offset = 0;
	switch([datestringofHour intValue]){
		default:
		case 0: 
		case 1:
		case 2: offset = 4; break; // Late night
		case 3:
		case 4: 
		case 5: offset = 0; break; // Late night (early morning)
		case 6: 
		case 7:
		case 8:
		case 9: 
		case 10:
		case 11: offset = 1; break;
		case 12: 
		case 13: 
		case 14:
		case 15:
		case 16:
		case 17: offset = 2; break;
		case 18:
		case 19:
		case 20:
		case 21:
		case 22:
		case 23: offset = 3; break;
	}
	[scrollView setContentOffset:CGPointMake(offset*screenWidth,0)],

	// scrollView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
	// self.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];

	[self addSubview:scrollView];
}

-(NSArray*)catchEmAll:(NSString*)groupKey{
	NSDictionary *prefs = [[NSDictionary alloc] initWithContentsOfFile:PREFS_FILE];
    NSMutableArray *found = [@[] mutableCopy];
    for (NSString *keyval in [prefs allKeys]) {
        NSString *realkey = [groupKey stringByAppendingString:@"-"];
        if( [keyval rangeOfString:realkey].length > 0 ){
            NSString *ident = [keyval substringFromIndex:[keyval rangeOfString:realkey].length];
            if( [[prefs valueForKey:keyval] boolValue] == YES ){
                [found addObject:ident];
            }
        }
    }
	return found;
}

-(UIView*)getIconsForGroupName:(NSString*)groupKey atPositionIndex:(int)index{
    NSArray *identifiers = [self catchEmAll:groupKey];
    
    SBIconController *ccc = (SBIconController*)[NSClassFromString(@"SBIconController") sharedInstance];
    SBIconModel *m = [ccc valueForKey:@"_iconModel"];
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(screenWidth*index,0,screenWidth,80)];
    int count = [identifiers count];
    float size = 50;
    float margin = 10;
    float containerWidth = (size * count) + ( margin * ( count - 1 ) );
    float containerPadding = (screenWidth - containerWidth) / 2;
    static int tagcount = 0;
    if( currentIdentifiers == nil ){
    	currentIdentifiers = [[NSMutableArray alloc] init];
    }
    for (int i = 0; i < count; i++){
    [currentIdentifiers addObject:identifiers[i]];

	SBApplicationIcon *appIcon;
    if( [m respondsToSelector:@selector(applicationIconForDisplayIdentifier:)] ){
		// ios 7
		appIcon = [m applicationIconForDisplayIdentifier:identifiers[i]];
	}else{
		// ios 8
		appIcon = [m applicationIconForBundleIdentifier:identifiers[i]];
	}
    UIImage *image = [appIcon getIconImage:2];
    UIImageView* bg = [[UIImageView alloc] initWithImage:image];
    bg.tag = tagcount;
    tagcount++;
        [bg setFrame:CGRectMake(containerPadding+(i*margin)+(i*size),20+9,size,size)];
		UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(highlightLetter:)];
        [bg addGestureRecognizer:letterTapRecognizer];
        bg.userInteractionEnabled = YES;
        [containerView addSubview:bg];
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,10,10,10)];
		[label setText:[groupKey stringByAppendingString:@" Apps"]];
		[label sizeToFit];
		[label setCenter:CGPointMake(screenWidth/2,29/2)];
		label.textAlignment = NSTextAlignmentCenter;
		label.font = [UIFont systemFontOfSize:14];
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor whiteColor];   
		[containerView addSubview:label];
	}
	return containerView;
}

- (void)highlightLetter:(UITapGestureRecognizer*)sender{
	[[UIApplication sharedApplication] launchApplicationWithIdentifier:[currentIdentifiers objectAtIndex:sender.view.tag] suspended:NO];
}


@end
