//
//  WebHandlerClass.h
//  NumberKing
//
//  Created by Rajni on 12/13/16.
//  Copyright © 2016 Rajni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@class WebHandlerClass;
//Delegate Methods for WebHandler Success and failure
@protocol WebHandlerDelegate <NSObject>
-(void)responseSuccessWithObject : (NSDictionary*)responseObject webservice:(WebHandlerClass*)handler;
-(void)failedWithError : (NSError*)error webservice:(WebHandlerClass*)handler;
@end


@interface WebHandlerClass : NSObject
@property (weak,nonatomic)      id<WebHandlerDelegate> webserviceDelegate;
@property (nonatomic, strong)   NSString* servicePath;
@property (nonatomic, strong)   NSDictionary* parameter;
@property (nonatomic)           NSInteger webserviceTag;
@property (nonatomic, assign)   NSInteger responseCode;


+(WebHandlerClass*)sharedInstance;

//Check Internet Connection
-(BOOL)internetAvailable;

#pragma mark LOGIN WEBSERVICE
-(void)loginWebservice : (NSDictionary*)parameters delegate:(id)webDelegate;

#pragma mark REGISTRATION WEBSERVICE
-(void)registerWebservice : (NSDictionary*)parameters delegate:(id)webDelegate;

#pragma mark FACEBOOK REGISTRATION WEBSERVICE
-(void)fbRegisterWebservice : (NSDictionary*)parameters delegate:(id)webDelegate;

#pragma mark FACEBOOK LOGIN WEBSERVICE
-(void)fbLoginWebservice : (NSDictionary*)parameters delegate:(id)webDelegate;

#pragma mark FORGOT PASSWORD WEBSERVICE
-(void)forgotPassWebservice : (NSDictionary*)parameters delegate:(id)webDelegate;

#pragma mark VERIFY EMAIL WEBSERVICE
-(void)verifyEmailWebservice : (NSDictionary*)parameters delegate:(id)webDelegate;

#pragma mark RESET PASSWORD WEBSERVICE
-(void)resetPassWebservice : (NSDictionary*)parameters delegate:(id)webDelegate;

#pragma mark GET CATEGORIES LIST WEBSERVICE
-(void)getCategoriesListWebservice : (NSDictionary*)parameters delegate:(id)webDelegate;

#pragma mark ADD CATEGORIES WEBSERVICE
-(void)addCategoriesWebservice : (NSDictionary*)parameters delegate:(id)webDelegate;

#pragma mark COUNTRIES_WEBSERVICES
-(void)getCountriesList;

#pragma mark LOGOUT WEBSERVICE
-(void)logoutWebservice : (NSDictionary*)parameters delegate:(id)webDelegat;

#pragma mark DASHBOARD WEBSERVICE
-(void)dashboardWebservice : (NSDictionary*)parameters delegate:(id)webDelegate;

#pragma mark EDIT USERNAME WEBSERVICE
-(void)editNameWebservice : (NSDictionary*)parameters delegate:(id)webDelegate;

#pragma mark CHANGE PASSWORD WEBSERVICE
-(void)changePasswordWebservice : (NSDictionary*)parameters delegate:(id)webDelegate;

#pragma mark EDIT COUNTRY WEBSERVICE
-(void)editCountryWebservice : (NSDictionary*)parameters delegate:(id)webDelegat;

#pragma mark CHANGE SETTINGS WEBSERVICE
-(void)changeSettingsWebservice : (NSDictionary*)parameters delegate:(id)webDelegate;

#pragma mark UPDATE USER ONLINE WEBSERVICE
-(void)updateUserOnlineWebservice : (NSDictionary*)parameters delegate:(id)webDelegate;

#pragma mark GET ONLINE USERS WEBSERVICE
-(void)getUsersOnlineWebservice : (NSDictionary*)parameters delegate:(id)webDelegate;

#pragma mark SELECTED CATEGORY WEBSERVICE
-(void)getSelectedCategoryWebservice : (NSDictionary*)parameters delegate:(id)webDelegate;

#pragma mark USERONLINE STATUS
-(void)updateOnlineStatus : (NSDictionary*)parameters;

#pragma mark PLAY ONE VS ONE GAME WEBSERVICE
-(void)playGameWebservice : (NSDictionary*)parameters delegate:(id)webDelegate;

#pragma mark ACCEPT PLAY GAME WEBSERVICE
-(void)acceptGameWebservice : (NSDictionary*)parameters delegate:(id)webDelegate;



@end
