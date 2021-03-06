//
//  Constants.m
//  ChatLexer
//
//  Created by Nabeel Arif on 3/5/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

NSString *const kRegexMention = @"(?<=^|\\W)@([\\w]+)(?=$|[^a-zA-Z0-9_.])";
NSString *const kRegexEmoticon = @"\\((\\w+)\\)";
NSString *const kRegexHtmlTitle = @"(?<=<title>)(.*?)(?=</title>)";
NSString *const kParserKeyLinks = @"links";
NSString *const kParserKeyMentions = @"mentions";
NSString *const kParserKeyEmoticons = @"emoticons";
NSString *const kParserKeyData = @"data";
NSString *const kParserKeyTitle = @"title";
NSString *const kParserKeyUrl = @"url";