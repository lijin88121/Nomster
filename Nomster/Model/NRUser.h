//
//  NRUser.h
//  Nomster
//
//  Created by Li Jin on 11/1/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NRUser : NSObject
@property (nonatomic, strong) NSString* userID;
@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* firstName;
@property (nonatomic, strong) NSString* lastName;
@property (nonatomic, strong) NSString* fullName;
@property (nonatomic, strong) NSString* phone;
@property (nonatomic, strong) NSString* gender;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* avatarURL;
@property (nonatomic, strong) NSString* createdDate;
@property (nonatomic, assign) NSInteger numberOfReviews;

@property (nonatomic, strong) UIImage*  avatar;
@property (nonatomic, strong) NSMutableArray* followings;
@property (nonatomic, strong) NSMutableArray* followers;

- (id) initWithDictionary: (NSDictionary*) dict;
+ (NRUser*) userFromDictionary: (NSDictionary*) dict;
+ (NSDictionary*) dictFromUser: (NRUser*) user;
+ (NRUser*) userWithID: (NSString*) userID;
@end
