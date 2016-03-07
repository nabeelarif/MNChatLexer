//
//  MNParserAPI.h
//  ChatLexer
//
//  Created by Nabeel Arif on 3/6/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 A simple shorthand notation to interact with MNParserAPI's shared instance.
 */
#define ParserKit [MNParserAPI sharedInstance]
/**
 Completion block for parsing and URL title fetching. The ParserKit performs all the operations 
 in background thread and calls this method once done.
 */
typedef void (^ParsingComplete)(NSDictionary * _Nonnull result, NSString * _Nonnull originalText);
/**
 @link https://www.raywenderlich.com/46988/ios-design-patterns
 The Facade design pattern provides a single interface to a complex subsystem. Instead of exposing the user to a set of classes and their APIs, you only expose one simple unified API.
 
 Like Facade API MNParserAPI provides the client app a single point to parse the chat message into
 meaningfull components and also interact with URLs to fetch the title associated with it.
 
 */
@interface MNParserAPI : NSObject
/**
 Signleton design pattern. To return MNParserAPI instance.
 */
+ (nonnull instancetype)sharedInstance;
/**
 Parses the text on current thread and returns result in the form of dictionary. The URL titles 
 are not fetched in this process.
 @param text Chat text
 @param isFinal NO: if user is currently typing in the chat field. YES if user is done with entering 
 text. Based on this varialbe we decide wheter we need to parse last URL or not, as if user is typing
 URL could be in initial form.
 @return Parsed data in the form of NSDictionary object
 */
- (nonnull NSDictionary*)parseText:(nonnull NSString*)text isFinal:(BOOL)isFinal;
/**
 Parses the text on Background thread and returns result in the form of dictionary via ParsingComplete block. The URL titles are added into group for title retrieval and once done, titles are added
 to parsed result.
 @param text Chat text
 @param isFinal NO: if user is currently typing in the chat field. YES if user is done with entering
 text. Based on this varialbe we decide wheter we need to parse last URL or not, as if user is typing
 URL could be in initial form.
 @param completion A completion block. This block is called on main thread so that user can display 
 the parsed data on UI.
 */
- (void)parseText:(nonnull NSString*)text isFinal:(BOOL)isFinal
       completion:(_Nullable ParsingComplete)completion;
/**
 Converts the NSDictionary object into JSON String
 @param dictionary NSDictionary object containing parsed data of Chat text
 @param prettyPrint YES: to indent the JSON text. NO: to Not indent the JSON text.
 @return A JSON string representation of dictionary object
 */
+ (nonnull NSString*)jsonForDictionary:(nonnull NSDictionary*)dictionary
                           prettyPrint:(BOOL)prettyPrint;

@end
