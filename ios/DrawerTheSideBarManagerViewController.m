//
//  DarwerTheSideBarManagerViewController.m
//  ReactNativeControllers
//
//  Created by Ran Greenberg on 22/03/2016.
//  Copyright © 2016 artal. All rights reserved.
//

#import "DrawerTheSideBarManagerViewController.h"
#import "RCCViewController.h"

@interface DrawerTheSideBarManagerViewController ()

@property (nonatomic) BOOL isOpen;
@property (nonatomic, strong) UIButton *closeOnTopButton;
@property (nonatomic) SidebarTransitionStyle animationStyle;

@property (nonatomic, strong) RCCViewController *leftViewController;
@property (nonatomic, strong) RCCViewController *rightViewController;
@property (nonatomic, strong) RCCViewController *centerViewController;

@end

@implementation DrawerTheSideBarManagerViewController

-(UIButton*)closeOnTopButton {
    if (!_closeOnTopButton) {
        _closeOnTopButton = [[UIButton alloc] init];
        [_closeOnTopButton addTarget:self action:@selector(onTopButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeOnTopButton;
}


- (instancetype)initWithProps:(NSDictionary *)props children:(NSArray *)children bridge:(RCTBridge *)bridge {
    
    
    
    // center
    if ([children count] < 1) return nil;
    self.centerViewController = [RCCViewController controllerWithLayout:children[0] bridge:bridge];
    
    // left

    NSString *componentLeft = props[@"componentLeft"];
    NSDictionary *passPropsLeft = props[@"passPropsLeft"];
    
    if (componentLeft)  {
        self.leftViewController = [[RCCViewController alloc] initWithComponent:componentLeft passProps:passPropsLeft navigatorStyle:nil bridge:bridge];
    }
    
    
    // right

    NSString *componentRight = props[@"componentRight"];
    NSDictionary *passPropsRight = props[@"passPropsRight"];
    
    if (componentRight) {
        self.rightViewController = [[RCCViewController alloc] initWithComponent:componentRight passProps:passPropsRight navigatorStyle:nil bridge:bridge];
    }
    
    self = [super initWithContentViewController:self.centerViewController
                      leftSidebarViewController:self.leftViewController
                     rightSidebarViewController:self.rightViewController];
    [self setDrawerType:props[@"drawerType"]];
    
    
    CGRect leftSideBarFrame = self.view.frame;
    leftSideBarFrame.size.width = DRAWER_WIDTH;
    self.leftViewController.view.frame = leftSideBarFrame;
    
    CGRect rightSideBarFrame = self.view.frame;
    rightSideBarFrame.size.width = DRAWER_WIDTH;
    rightSideBarFrame.origin.x = self.view.frame.size.width - self.visibleWidth;
    self.rightViewController.view.frame = rightSideBarFrame;
    
    self.isOpen = NO;
    
    if (!self) return nil;
    return self;
}

-(void)setDrawerType:(NSString*)type {
    if ([type isEqualToString:@"airbnb"]) self.animationStyle = SidebarTransitionStyleAirbnb;
    else if ([type isEqualToString:@"facebook"]) self.animationStyle = SidebarTransitionStyleFacebook;
    else if ([type isEqualToString:@"luvocracy"]) self.animationStyle = SidebarTransitionStyleLuvocracy;
    else if ([type isEqualToString:@"feedly"]) self.animationStyle = SidebarTransitionStyleFeedly;
    else if ([type isEqualToString:@"flipboard"]) self.animationStyle = SidebarTransitionStyleFlipboard;
    else if ([type isEqualToString:@"wunderlist"]) self.animationStyle = SidebarTransitionStyleWunderlist;
}

- (void)performAction:(NSString*)performAction actionParams:(NSDictionary*)actionParams bridge:(RCTBridge *)bridge {
    
    NSLog(@"performAction:%@", performAction);
    
    TheSideBarSide side = TheSideBarSideLeft;
    
    if ([actionParams[@"side"] isEqualToString:@"right"]) side = TheSideBarSideRight;
    
    
    // open
    if ([performAction isEqualToString:@"open"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self openSideMenu:side];
            
        });
        return;
    }
    
    // close
    if ([performAction isEqualToString:@"close"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [self onTopButtonPressed:self.closeOnTopButton];
            
        });
        return;
    }
    
    // toggle
    if ([performAction isEqualToString:@"toggle"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.isOpen) {
                [self onTopButtonPressed:self.closeOnTopButton];
                
            }
            else {
                [self openSideMenu:side];
                
            }
            
            self.isOpen = !self.isOpen;
            
        });
        return;
    }
    
    // setStyle
    if ([performAction isEqualToString:@"setStyle"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (actionParams[@"animationType"]) {
                NSString *animationTypeString = actionParams[@"animationType"];
                
                CGRect leftSideBarFrame = self.leftViewController.view.frame;
                leftSideBarFrame.origin.x = 0;
                self.leftViewController.view.frame = leftSideBarFrame;
                
                CGRect rightSideBarFrame = self.rightViewController.view.frame;
                rightSideBarFrame.origin.x = self.view.frame.size.width - self.visibleWidth;
                self.rightViewController.view.frame = rightSideBarFrame;
                
                if ([animationTypeString isEqualToString:@"airbnb"])  {
                    self.animationStyle = SidebarTransitionStyleAirbnb;
                }
                else if ([animationTypeString isEqualToString:@"facebook"]){
                    self.animationStyle = SidebarTransitionStyleFacebook;
                }
                else if ([animationTypeString isEqualToString:@"luvocracy"]) {
                    self.animationStyle = SidebarTransitionStyleLuvocracy;
                }
                else if ([animationTypeString isEqualToString:@"feedly"]) {
                    self.animationStyle = SidebarTransitionStyleFeedly;
                    
                    leftSideBarFrame.origin.x = self.view.frame.size.width - leftSideBarFrame.size.width;
                    self.leftViewController.view.frame = leftSideBarFrame;
                    
                    rightSideBarFrame.origin.x = 0;
                    self.rightViewController.view.frame = rightSideBarFrame;
                }
                else if ([animationTypeString isEqualToString:@"flipboard"]) {
                    self.animationStyle = SidebarTransitionStyleFlipboard;
                    
                    leftSideBarFrame.origin.x = self.view.frame.size.width - leftSideBarFrame.size.width;
                    self.leftViewController.view.frame = leftSideBarFrame;
                    
                    rightSideBarFrame.origin.x = 0;
                    self.rightViewController.view.frame = rightSideBarFrame;
                }
                else if ([animationTypeString isEqualToString:@"wunderlist"]) {
                    self.animationStyle = SidebarTransitionStyleWunderlist;
                }
                
            }
            
        });
        return;
    }
}


-(void)openSideMenu:(TheSideBarSide)side{
    
    CGRect buttonFrame = self.view.bounds;
    
    switch (side) {
        case TheSideBarSideLeft:
        {
            [self presentLeftSidebarViewControllerWithStyle:self.animationStyle];
            buttonFrame.origin.x = self.visibleWidth;
            
        }
            
            break;
        case TheSideBarSideRight:
        {
            [self presentRightSidebarViewControllerWithStyle:self.animationStyle];
            buttonFrame.origin.x = 0;
        }
            
            break;
            
        default:
            break;
    }
    [self.closeOnTopButton setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.closeOnTopButton];
    
    
    buttonFrame.size.width = buttonFrame.size.width - self.visibleWidth;
    
    self.closeOnTopButton.frame = buttonFrame;
}


-(void)onTopButtonPressed:(UIButton*)button {
    [self dismissSidebarViewController];
    [button removeFromSuperview];
    self.isOpen = NO;
    
}

- (id) clone {
    NSData *archivedViewData = [NSKeyedArchiver archivedDataWithRootObject: self];
    id clone = [NSKeyedUnarchiver unarchiveObjectWithData:archivedViewData];
    return clone;
}


@end
