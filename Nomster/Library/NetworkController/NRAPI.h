//
//  NR_API.h
//
//  Created by Mountain on 5/7/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#ifndef NR_API_h
#define NR_API_h

#define SERVER                      @"http://nomster.co/Nomster/api"
//#define SERVER                      @"http://192.168.1.75/Nomster/api"

#define     URL_LOGIN               [NSString stringWithFormat: @"%@/index.php?action=login", SERVER]
#define     URL_REGISTER            [NSString stringWithFormat: @"%@/index.php?action=register", SERVER]
#define     URL_UPDATE_PROFILE      [NSString stringWithFormat: @"%@/index.php?action=update_profile", SERVER]
#define     URL_CREATE_REVIEW       [NSString stringWithFormat: @"%@/index.php?action=create_review", SERVER]
#define     URL_FINISH_REVIEW       [NSString stringWithFormat: @"%@/index.php?action=finish_review", SERVER]
#define     URL_LIKE_REVIEW         [NSString stringWithFormat: @"%@/index.php?action=like_review", SERVER]
#define     URL_UNLIKE_REVIEW       [NSString stringWithFormat: @"%@/index.php?action=unlike_review", SERVER]
#define     URL_COMMENT_REVIEW      [NSString stringWithFormat: @"%@/index.php?action=comment_review", SERVER]
#define     URL_SEARCH_REVIEW       [NSString stringWithFormat: @"%@/index.php?action=search_review", SERVER]
#define     URL_TOP_REVIEW          [NSString stringWithFormat: @"%@/index.php?action=get_top_review", SERVER]
#define     URL_USER_REVIEW         [NSString stringWithFormat: @"%@/index.php?action=user_review", SERVER]
#define     URL_REVIEW_DETAIL       [NSString stringWithFormat: @"%@/index.php?action=review_detail", SERVER]

#define     URL_FOLLOW_USER         [NSString stringWithFormat: @"%@/index.php?action=following", SERVER]
#define     URL_UNFOLLOW_USER       [NSString stringWithFormat: @"%@/index.php?action=unfollowing", SERVER]

#define     URL_RECOMMENDED_REVIEW  [NSString stringWithFormat: @"%@/index.php?action=recommended_review", SERVER]
#define     URL_FOLLOWER_REVIEW     [NSString stringWithFormat: @"%@/index.php?action=followers_review", SERVER]

#define     URL_GET_FOLLOWINGS      [NSString stringWithFormat: @"%@/index.php?action=get_followings", SERVER]
#define     URL_GET_FOLLOWERS       [NSString stringWithFormat: @"%@/index.php?action=get_followers", SERVER]

#define     URL_GET_CATEGORIES      [NSString stringWithFormat: @"%@/index.php?action=get_categories", SERVER]
#endif
