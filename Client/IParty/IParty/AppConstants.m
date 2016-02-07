//
//  AppConstants.m
//  IParty
//
//  Created by Swifty on 2/3/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AppConstants.h"

NSString *const SERVER_URL = @"http://192.168.168.1:59651/";

NSString *const REGISTRATION_URI = @"api/account/register";
NSString *const LOGIN_URI = @"token";
NSString *const CREATE_PARTY_URI = @"api/party";
NSString *const UPLOAD_IMAGE_URI = @"api/images";
NSString *const GET_USER_PARTIES_URI = @"api/party";
NSString *const FIND_NEARBY_PARTIES_URI = @"api/party/search";

NSString *const MIME_TYPE_BOUNDARY = @"ipartyyoupartywepartytheyparty";

int const HTTP_STATUS_OK = 200;
int const HTTP_STATUS_CREATED = 201;