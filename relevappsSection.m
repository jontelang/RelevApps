//
//  relevappsSection.m
//  relevapps
//
//  Created by Jonathan Winger-lang on 05.09.2014.
//  Copyright (c) 2014 Jonathan Winger-lang. All rights reserved.
//

#import "relevappsSection.h"

@interface relevappsSection ()

@property (nonatomic, strong) NSBundle *bundle;
@property (nonatomic, strong) relevappsSectionView *view;

@property (nonatomic, weak) UIViewController <CCSectionDelegate> *delegate;

@end

@implementation relevappsSection

- (instancetype)init {
    self = [super init];
    if (self) {
        self.bundle = [NSBundle bundleForClass:[self class]];
    }
    return self;
}

- (CGFloat)sectionHeight {
    return 90.0f;
}

- (void)loadView {
    self.view = [[relevappsSectionView alloc] init];
}

- (UIView *)view {
    if (!_view) {
        [self loadView];
    }
    
    return _view;
}

- (void)dealloc {
    self.view = nil;
    self.bundle = nil;
}

- (void)controlCenterWillAppear {
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // [self.view layoutSubviews];
}

- (void)controlCenterDidDisappear {
    
}

@end
