//
//  URLTitlesManager.m
//  ChatLexer
//
//  Created by Nabeel Arif on 3/5/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import "URLTitlesManager.h"
#import "Constants.h"

@interface URLTitlesManager ()
{
    dispatch_queue_t _servicesQueue;
}
@property (nonatomic, strong, nonnull) NSCache *cache;
@property (nonatomic, strong, nonnull) NSRegularExpression *regex;
@end

@implementation URLTitlesManager

+ (id)sharedInstance {
    static URLTitlesManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        sharedMyManager.cache = [[NSCache alloc]init];
        [sharedMyManager.cache setCountLimit:100];
        sharedMyManager->_servicesQueue = dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT);
        sharedMyManager.regex = [[NSRegularExpression alloc] initWithPattern:kRegexHtmlTitle options:NSRegularExpressionCaseInsensitive error:NULL];
    });
    return sharedMyManager;
}
-(NSString *)titleForUrlString:(NSString *)urlStr
{
    NSURL *sUrl = [NSURL URLWithString:urlStr];
    return [self titleForURL:sUrl];
}
-(NSString *)titleForURL:(NSURL *)url{
    return [self.cache objectForKey:url];
}
-(void)fetchTitleForUrlString:(NSString*)urlStr
{
    NSURL *sUrl = [NSURL URLWithString:urlStr];
    [self fetchTitleForURL:sUrl];
}
-(void)fetchTitleForURL:(NSURL*)url
{
    if ([self.cache objectForKey:url]) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    __block NSURL *urlBlock = url;
    
    // 2
    NSURLSessionDataTask *downloadTask =
    [[NSURLSession sharedSession]
     dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
         // 4: Handle response here
         NSString* dataStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
         if (dataStr.length>0) {
             
             NSString *title;
             NSRange range = [weakSelf.regex rangeOfFirstMatchInString:dataStr options:kNilOptions range:NSMakeRange(0, [dataStr length])];
             if(range.location != NSNotFound)
             {
                 title = [dataStr substringWithRange:range];
                 dispatch_barrier_async(_servicesQueue, ^{
                     [weakSelf.cache setObject:title forKey:urlBlock];
                 });
             }
         }
     }];
    // 3
    [downloadTask resume];
}
@end
