//
//  WebHandlerClass.m
//  NumberKing
//
//  Created by Rajni on 12/13/16.
//  Copyright © 2016 Rajni. All rights reserved.
//

#import "WebHandlerClass.h"
#import "Reachability.h"
#import "CategoryInfo.h"
@interface WebHandlerClass ()<NSURLSessionDelegate>
{
    
}
@property (nonatomic, strong) NSURLSessionDataTask *sessionTask;

@end
@implementation WebHandlerClass

static WebHandlerClass *singleInstance = nil;
+(WebHandlerClass*)sharedInstance
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        singleInstance = [[WebHandlerClass alloc]init];
    });
    return singleInstance;
}

-(void)start
{
    __weak typeof(self) weakSelf = self;
    NSURL *url = [NSURL URLWithString:[BASE_URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer =  [AFJSONRequestSerializer serializer];
    NSLog(@"Webservice URL %@%@",BASE_URL,self.servicePath);
    NSLog(@"Parameters %@",self.parameter);
    self.sessionTask = [manager POST:self.servicePath parameters:self.parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSLog(@"Response Object %@",responseObject);
        [weakSelf.webserviceDelegate responseSuccessWithObject:responseObject webservice:weakSelf];
    }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Error %@",error);
            [weakSelf.webserviceDelegate failedWithError:error webservice:weakSelf];
    }];
}


#pragma mark Common Methods for all Services
-(void)parsedResponseForWebserviceResponse :(id)responseObject error:(NSString*)error
{
    NSDictionary* dictionary = (NSDictionary*)responseObject;
    NSInteger responseCode = ResponseCodeNotOK;
    id val = [dictionary objectForKey:@"success"];
    if (val && ![val isEqual:[NSNull null]]) {
        responseCode = [val integerValue];
        self.responseCode = responseCode;
    }
    if (dictionary && ![dictionary isEqual:[NSNull null]]) {
        if (responseCode==ResponseCodeOK) {
            switch (self.webserviceTag) {
                case CATEGORIES_LIST_TAG:
                    break;
            }
        }
        else
        {
           // id val = [dictionary objectForKey:@"message"];
            //*errorMessage = [self stringValueFromObject:val];
        }
    }
    else
    {
       // id val = [dictionary objectForKey:@"message"];
       // *errorMessage = [self stringValueFromObject:val];
    }
}

#pragma mark COUNTRIES_WEBSERVICES
-(void)getCountriesList
{
    NSError *error;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,COUNTRIESLIST_PATH]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    NSDictionary *mapData = @{@"api_key" :API_KEY};
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        NSError *error1;
        id dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error1];
        if (dict)
        {
            NSMutableArray *countryList = [dict objectForKey:@"data"];
            NSString *countyFile = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Countries List"];
            [countryList writeToFile:countyFile atomically:YES];
        }
        else
        {
            
        }
    }];
    
    [postDataTask resume];
}
#pragma mark USERONLINE STATUS
-(void)updateOnlineStatus : (NSDictionary*)parameters
{
    NSError *error;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,UPDATEONLINESTATUS_PATH]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    NSDictionary *mapData = parameters;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if (data!= nil)
        {
            NSError *error1;
            id dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error1];
            if (dict)
            {
                
            }
            else
            {
                
            }
        }
    }];
    [postDataTask resume];
}

#pragma mark LOGIN WEBSERVICE
-(void)loginWebservice : (NSDictionary*)parameters delegate:(id)webDelegate
{
    self.servicePath = LOGIN_PATH;
    self.webserviceTag = LOGIN_PATH_TAG;
    self.parameter = parameters;
    self.webserviceDelegate = webDelegate;
    [self start];
}

#pragma mark REGISTRATION WEBSERVICE
-(void)registerWebservice : (NSDictionary*)parameters delegate:(id)webDelegate
{
    self.servicePath = REGISTER_PATH;
    self.webserviceTag = REGISTER_PATH_TAG;
    self.parameter = parameters;
    self.webserviceDelegate = webDelegate;
    [self start];
}
#pragma mark FACEBOOK REGISTRATION WEBSERVICE
-(void)fbRegisterWebservice : (NSDictionary*)parameters delegate:(id)webDelegate
{
    self.servicePath = FBREGISTER_PATH;
    self.webserviceTag = FBREGISTER_PATH_TAG;
    self.parameter = parameters;
    self.webserviceDelegate = webDelegate;
    [self start];
}

#pragma mark FACEBOOK LOGIN WEBSERVICE
-(void)fbLoginWebservice : (NSDictionary*)parameters delegate:(id)webDelegate
{
    self.servicePath = FBLOGIN_PATH;
    self.webserviceTag = FBLOGIN_PATH_TAG;
    self.parameter = parameters;
    self.webserviceDelegate = webDelegate;
    [self start];
}

#pragma mark FORGOT PASSWORD WEBSERVICE
-(void)forgotPassWebservice : (NSDictionary*)parameters delegate:(id)webDelegate
{
    self.servicePath = FORGOTPASS_PATH;
    self.webserviceTag = FORGOTPASS_TAG;
    self.parameter = parameters;
    self.webserviceDelegate = webDelegate;
    [self start];
}
#pragma mark VERIFY EMAIL WEBSERVICE
-(void)verifyEmailWebservice : (NSDictionary*)parameters delegate:(id)webDelegate
{
    self.servicePath = VERIFYEMAIL_PATH;
    self.webserviceTag = VERIFYEMAIL_TAG;
    self.parameter = parameters;
    self.webserviceDelegate = webDelegate;
    [self start];
}
#pragma mark RESET PASSWORD WEBSERVICE
-(void)resetPassWebservice : (NSDictionary*)parameters delegate:(id)webDelegate
{
    self.servicePath = RESETPASS_PATH;
    self.webserviceTag = RESETPASS_TAG;
    self.parameter = parameters;
    self.webserviceDelegate = webDelegate;
    [self start];
}

#pragma mark GET CATEGORIES LIST WEBSERVICE
-(void)getCategoriesListWebservice : (NSDictionary*)parameters delegate:(id)webDelegate
{
    self.servicePath = CATEGORIES_LIST_PATH;
    self.webserviceTag = CATEGORIES_LIST_TAG;
    self.parameter = parameters;
    self.webserviceDelegate = webDelegate;
    [self start];
}
#pragma mark ADD CATEGORIES WEBSERVICE
-(void)addCategoriesWebservice : (NSDictionary*)parameters delegate:(id)webDelegate
{
    self.servicePath = ADDCATEGORIES_PATH;
    self.webserviceTag = ADDCATEGORIES_TAG;
    self.parameter = parameters;
    self.webserviceDelegate = webDelegate;
    [self start];
}
#pragma mark DASHBOARD WEBSERVICE
-(void)dashboardWebservice : (NSDictionary*)parameters delegate:(id)webDelegate
{
    self.servicePath = DASHBOARD_PATH;
    self.webserviceTag = DASHBOARD_TAG;
    self.parameter = parameters;
    self.webserviceDelegate = webDelegate;
    [self start];
}
#pragma mark EDIT USERNAME WEBSERVICE
-(void)editNameWebservice : (NSDictionary*)parameters delegate:(id)webDelegate
{
    self.servicePath = EDITNAME_PATH;
    self.webserviceTag = EDITNAME_TAG;
    self.parameter = parameters;
    self.webserviceDelegate = webDelegate;
    [self start];
}

#pragma mark CHANGE PASSWORD WEBSERVICE
-(void)changePasswordWebservice : (NSDictionary*)parameters delegate:(id)webDelegate
{
    self.servicePath = CHANGEPASSWORD_PATH;
    self.webserviceTag = CHANGEPASSWORD_TAG;
    self.parameter = parameters;
    self.webserviceDelegate = webDelegate;
    [self start];
}

#pragma mark EDIT COUNTRY WEBSERVICE
-(void)editCountryWebservice : (NSDictionary*)parameters delegate:(id)webDelegate
{
    self.servicePath = EDITCOUNTRY_PATH;
    self.webserviceTag = EDITCOUNTRY_TAG;
    self.parameter = parameters;
    self.webserviceDelegate = webDelegate;
    [self start];
}

#pragma mark CHANGE SETTINGS WEBSERVICE
-(void)changeSettingsWebservice : (NSDictionary*)parameters delegate:(id)webDelegate
{
    self.servicePath = CHANGESETTINGS_PATH;
    self.webserviceTag = CHANGESETTINGS_TAG;
    self.parameter = parameters;
    self.webserviceDelegate = webDelegate;
    [self start];
}

#pragma mark UPDATE USER ONLINE WEBSERVICE
-(void)updateUserOnlineWebservice : (NSDictionary*)parameters delegate:(id)webDelegate
{
    self.servicePath = UPDATEONLINESTATUS_PATH;
    self.webserviceTag = UPDATEONLINESTATUS_TAG;
    self.parameter = parameters;
    self.webserviceDelegate = webDelegate;
    [self start];
}

#pragma mark GET ONLINE USERS WEBSERVICE
-(void)getUsersOnlineWebservice : (NSDictionary*)parameters delegate:(id)webDelegate
{
    self.servicePath = GETONLINEUSERS_PATH;
    self.webserviceTag = GETONLINEUSERS_TAG;
    self.parameter = parameters;
    self.webserviceDelegate = webDelegate;
    [self start];
}

#pragma mark SELECTED CATEGORY WEBSERVICE
-(void)getSelectedCategoryWebservice : (NSDictionary*)parameters delegate:(id)webDelegate
{
    self.servicePath = SELECTEDCATEGORY_PATH;
    self.webserviceTag = SELECTEDCATEGORY_TAG;
    self.parameter = parameters;
    self.webserviceDelegate = webDelegate;
    [self start];
}
#pragma mark PLAY ONE VS ONE GAME WEBSERVICE
-(void)playGameWebservice : (NSDictionary*)parameters delegate:(id)webDelegate
{
    self.servicePath = PLAYGAME_PATH;
    self.webserviceTag = PLAYGAME_TAG;
    self.parameter = parameters;
    self.webserviceDelegate = webDelegate;
    [self start];
}

#pragma mark ACCEPT PLAY GAME WEBSERVICE
-(void)acceptGameWebservice : (NSDictionary*)parameters delegate:(id)webDelegate
{
    self.servicePath = ACCEPTGAME_PATH;
    self.webserviceTag = ACCEPTGAME_TAG;
    self.parameter = parameters;
    self.webserviceDelegate = webDelegate;
    [self start];
}
#pragma mark LOGOUT WEBSERVICE
-(void)logoutWebservice : (NSDictionary*)parameters delegate:(id)webDelegate
{
    self.servicePath = LOGOUT_PATH;
    self.webserviceTag = LOGOUT_TAG;
    self.parameter = parameters;
    self.webserviceDelegate = webDelegate;
    [self start];
}

#pragma mark Internet Check 
//Check Internet Connection
-(BOOL)internetAvailable
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}


@end
