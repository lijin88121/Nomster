//
//  NRSDK.h
//  Nomster
//
//  Created by Li Jin on 11/1/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#ifndef Nomster_NRSDK_h
#define Nomster_NRSDK_h

#define RGBA(r, g, b, a)    [UIColor colorWithRed: (r)/255.0f green: (g)/255.0f blue: (b)/255.0f alpha: (a)]
#define RGB(r, g, b)        [UIColor colorWithRed: (r)/255.0f green: (g)/255.0f blue: (b)/255.0f alpha: 1.0f]

#import "NRComment.h"
#import "NRLike.h"
#import "NRVenue.h"
#import "NRUser.h"
#import "NRReview.h"
#import "NRCategory.h"
#import "NRMaster.h"
#import "NRCircularImageView.h"
#import "NRButtonActionItem.h"
#import "NRAPIManager.h"
#import "NRUIManager.h"
#import "NRReviewListView.h"
#import "NR_categories.h"

#define NR_COLOR            RGB(48, 41, 123)
#define NR_COLOR_BRIGHT     RGB(47, 33, 130)

#define NR_COLOR_ORANGE     RGB(252,104,9)
//#define NR_COLOR_GREEN      RGB(28, 130, 26)
#define NR_COLOR_GREEN      RGB(0,174,239)

#define NR_COLOR_WHITE      RGB(255, 255, 255)

#define NR_COLOR_LIGHT_GRAY       RGB(219, 219, 219)
#define NR_COLOR_DARK_GRAY  RGB(93, 93, 93)

//#define NR_COLOR            RGB(8, 150, 39)
//#define NR_COLOR_BRIGHT     RGB(8, 150, 39)

/*FourSquare Credentials*/
#define kClientID       @"HGDGBQ2O2LLF3GLRURNZBHJL5BGLJKBQQTGQ3RMY2EI3GIH0"
#define kCallbackURL    @"nomsterapp://foursquare"
#define kClientSecret   @"AWRW344UJJXBIIDAQCTK5CFTGQBBYZMPDO400IDQUCZDGVQO"

#define MILES_TO_KILOMETERS(n)      (((CGFloat)n)*1.609f)
#define KILOMETERS_TO_MILES(n)      (((CGFloat)n)/1.609f)

//Fonts
#define FONT_ARISTA                     @"Arista2.0"
#define FONT_ARISTA_FAT                 @"Arista2.0Fat"
#define FONT_ARISTA_LIGHT               @"Arista2.0Light"
#define FONT_ARISTA_ALTERNATE           @"Arista2.0Alternate"
#define FONT_ARISTA_ALTERNATE_LIGHT     @"Arista2.0AlternateLight"
#define FONT_ARISTA_ALTERNATE_FULL      @"Arista2.0Alternatefull"

#define FONT_HELVETICANEUE_ULTRA_LIGHT  @"HelveticaNeue-UltraLight"
#define FONT_HELVETICANEUE_NORMAL       @"HelveticaNeue-Medium"
#define FONT_HELVETICANEUE_LIGHT        @"HelveticaNeue-Light"
#define FONT_HELVETICANEUE_BOLD         @"Helvetica-Bold"
#define FONT_HELVETICANEUE_THIN         @"HelveticaNeue-Thin"
//
//2013-12-09 11:15:25.574 Nomster[2113:a0b] font - HelveticaNeue-Italic
//2013-12-09 11:15:25.575 Nomster[2113:a0b] font - HelveticaNeue-Thin_Italic
//2013-12-09 11:15:25.575 Nomster[2113:a0b] font - HelveticaNeue-Bold
//2013-12-09 11:15:25.576 Nomster[2113:a0b] font - HelveticaNeue-UltraLight
//2013-12-09 11:15:25.576 Nomster[2113:a0b] font - HelveticaNeue-CondensedBlack
//2013-12-09 11:15:25.577 Nomster[2113:a0b] font - HelveticaNeue-BoldItalic
//2013-12-09 11:15:25.577 Nomster[2113:a0b] font - HelveticaNeue-CondensedBold
//2013-12-09 11:15:25.577 Nomster[2113:a0b] font - HelveticaNeue-Medium
//2013-12-09 11:15:25.578 Nomster[2113:a0b] font - HelveticaNeue-Light
//2013-12-09 11:15:25.578 Nomster[2113:a0b] font - HelveticaNeue-Thin
//2013-12-09 11:15:25.579 Nomster[2113:a0b] font - HelveticaNeue-LightItalic
//2013-12-09 11:15:25.579 Nomster[2113:a0b] font - HelveticaNeue-UltraLightItalic
//2013-12-09 11:15:25.579 Nomster[2113:a0b] font - HelveticaNeue-MediumItalic
//2013-12-09 11:15:25.580 Nomster[2113:a0b] font - HelveticaNeue
//2013-12-09 11:15:25.580 Nomster[2113:a0b] font - Helvetica-Bold
//2013-12-09 11:15:25.581 Nomster[2113:a0b] font - Helvetica
//2013-12-09 11:15:25.581 Nomster[2113:a0b] font - Helvetica-LightOblique
//2013-12-09 11:15:25.582 Nomster[2113:a0b] font - Helvetica-Oblique
//2013-12-09 11:15:25.583 Nomster[2113:a0b] font - Helvetica-BoldOblique
//2013-12-09 11:15:25.583 Nomster[2113:a0b] font - Helvetica-Light
//
#endif
