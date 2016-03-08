[![Build Status](https://travis-ci.org/nabeelarif100/MNChatLexer.svg?branch=master)](https://travis-ci.org/nabeelarif100/MNChatLexer)
# MNChatLexer
* MNSChatLexer addresses one of the challenges to programmers to extract valuable information from provided text strings. It is designed in a customizable way, so that future users can include their own rules 'MNLexeme' elements into 'MNParser'.
* It also has a URLTitleManager, which executes an NSURLSessionDataTask to grab title of a given URL.
* The Facade API i.e MNParserAPI interact with 'MNParser' and URLTitleManager to provide a single interface to end user.
* [Problem Statement] Explains the problem in more detail.

<img src="https://github.com/nabeelarif100/MNChatLexer/blob/master/AnalyzeDemo.gif" alt="alt text" width="308" height="550">
<img src="https://github.com/nabeelarif100/MNChatLexer/blob/master/LiveDemo.gif" alt="alt text" width="308" height="550">

## Requirements
* Xcode 7 or higher
* iOS 7.0 or higher
* ARC
* Objective-C

## Installation
Copy the project from git OR
Git Clone using following command
```sh
$ git clone https://github.com/nabeelarif100/MNChatLexer.git
```
You need to install pods before running the project
```sh
$ pod install
```

## Usage
Import the header file
```objective-c
#import "MNParserAPI.h"
```
Call the Facade API i.e ParserKit - A shared instance of MNParser to parser input text
```objective-c
NSString *text = @"@nabeel (success) twitter.com";
[ParserKit parseText:text isFinal:YES completion:^(NSDictionary * _Nonnull result, NSString * _Nonnull originalText) {
    //Parsing complete
    NSString *jsonString = [MNParserAPI jsonForDictionary:result prettyPrint:YES];
    weakSelf.tvOutput.text = jsonString;
}];
```
## Configuring Parser Rules
Create a parser object
```objective-c
MNParser *parser = [[MNParser alloc] init];
```
Add Rules i.e MNLexeme elements to parser object
```objective-c
//Lexeme for @mention
MNLexeme *lexemeMention = [[MNLexeme alloc] init];
[lexemeMention setRegexWithQuery:@"(?<=^|\\W)@([\\w]+)(?=$|[^a-zA-Z0-9_.])"];
lexemeMention.numberOfComponentToUse = 1;

//Lexeme for URLs
MNLexeme *lexemeUrl = [[MNLexeme alloc] init];
lexemeUrl.regex = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
lexemeUrl.parseLexeme = ^id(NSTextCheckingResult * match,NSUInteger numberOfComponentToUse, NSString *text)
{
    NSMutableDictionary *urlDictionary;
    if ([match resultType] == NSTextCheckingTypeLink) {
        //Ignore emails we only need urls
        if (([[match.URL scheme] isEqualToString:@"mailto"]==NO)) {
            urlDictionary = [NSMutableDictionary new];
            [urlDictionary setObject:[text substringWithRange:match.range] forKey:kParserKeyUrl];
            [urlDictionary setObject:@"" forKey:kParserKeyTitle];
        }
    }
    return urlDictionary;
};
[parser setLexeme:lexemeMention forKey:kParserKeyMentions];
[parser setLexeme:lexemeUrl forKey:kParserKeyLinks];
```
## Todo
1. Add network checks
2. Add Unit Tests
3. Add UI Tests

## Author
Muhammad Nabeel Arif

## License
MNChatLexer is available under the MIT license. See the LICENSE file for more info.

[Problem Statement]: <https://github.com/nabeelarif100/MNChatLexer/wiki#problem-statement>
