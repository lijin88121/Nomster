//
//  NRConnection.h
//  NR
//
//  Created by Li Jin on 01/05/13.
//  Copyright 2012-2013 Li Jin, Inc. All rights reserved.

#ifndef _NRCONNECTION_H_
#define _NRCONNECTION_H_

#import "NR_categories.h"
#import "NRData.h"


@class NRConnection;

// block types
typedef id(^NRParseBlock)(NRConnection *, NSError **);
typedef void(^NRCompletionBlock)(NRConnection *);
typedef void(^NRProgressBlock)(NRConnection *);


// http methods
// add additional http methods as necessary
// non-http request methods could also go here
typedef enum {
    NRRequestMethodGET = 0, // default
    NRRequestMethodPOST,
} NRRequestMethod;


// NSNotification names
extern NSString * const NRConnectionActivityBegan;
extern NSString * const NRConnectionActivityEnded;

// string function for request enum
NSString* stringForRequestMethod(NRRequestMethod method);

@interface NRConnection : NSObject <NSURLConnectionDelegate>

// NOTE: object property declarations in header are explicity 'strong' so that non-arc code may include the header.

@property (nonatomic, strong) NSURL *url;
@property (nonatomic) NRRequestMethod method;

#if TARGET_OS_IPHONE
@property (nonatomic) BOOL shouldRunInBackground; // defaults to YES for POST method
#endif

@property (nonatomic, strong) NSDictionary *headers;    // optional custom http headers
@property (nonatomic, strong) NSDictionary *parameters; // GET or POST parameters, including POST form data

@property (nonatomic, copy) NRParseBlock parseBlock;           // executed in background thread
@property (nonatomic, copy) NRCompletionBlock completionBlock; // executed in main thread
@property (nonatomic, copy) NRProgressBlock progressBlock;     // executed in main thread

@property (nonatomic, strong, readonly) NSURLResponse *response;        // response from NSURLConnection
@property (nonatomic, strong, readonly) NSHTTPURLResponse *httpResponse; // response or nil if not an http response
@property (nonatomic, strong, readonly) NSData *responseData;           // populated with data unless responseStream is set.
@property (nonatomic, strong) NSOutputStream *responseStream;           // if this is set then responseData will be nil

@property (nonatomic, strong, readonly) id<NSObject> parseResult;       // result of parseBlock; may be nil on success
@property (nonatomic, strong, readonly) NSError *error;                 // if set then the request or parse failed

@property (nonatomic, readonly) BOOL didStart;          // start was called
@property (nonatomic, readonly) BOOL didFinishLoading;  // underlying connection finished loading
@property (nonatomic, readonly) BOOL didComplete;       // underlying connection either finished or failed
@property (nonatomic, readonly) BOOL didSucceed;        // finished with no error

@property (nonatomic, readonly) long long uploadProgressBytes;
@property (nonatomic, readonly) long long uploadExpectedBytes;
@property (nonatomic, readonly) long long downloadProgressBytes;
@property (nonatomic, readonly) long long downloadExpectedBytes;
@property (nonatomic, readonly) float uploadProgress;
@property (nonatomic, readonly) float downloadProgress;

@property (nonatomic, readonly) int concurrencyCountAtStart;
@property (nonatomic, readonly) NSTimeInterval startTime;
@property (nonatomic, readonly) NSTimeInterval challengeInterval;
@property (nonatomic, readonly) NSTimeInterval responseInterval;
@property (nonatomic, readonly) NSTimeInterval finishOrFailInterval;
@property (nonatomic, readonly) NSTimeInterval parseInterval;


+ (id)withUrl:(NSURL *)url
       method:(NRRequestMethod)method
      headers:(NSDictionary *)headers
   parameters:(NSDictionary *)parameters
   parseBlock:(NRParseBlock)parseBlock
completionBlock:(NRCompletionBlock)completionBlock
progressBlock:(NRProgressBlock)progressBlock;


+ (NSSet *)connections;
+ (void)cancelAllConnections;


// call this method to allow the request to complete but ignore the response.
- (void)clearBlocks;

- (NRConnection *)start; // returns self for chaining convenience, or nil if start fails.

- (void)cancel; // no blocks will be called after request is cancelled, unless a call to finish is already scheduled.

@end


#endif
