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
@property (nonatomic, strong, nonnull) NSMutableSet *setUrlsInProgress;
@property (nonatomic, strong, nonnull) NSRegularExpression *regexHtmlPageTitle;

//- (void)fetchTitleForUrlString:(nonnull NSString*)urlStr;
- (nullable NSURLSessionDataTask*)fetchTitleForURL:(nonnull NSURL*)url group:(dispatch_group_t) group;
@end

@implementation URLTitlesManager

+ (instancetype)sharedInstance {
    static URLTitlesManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        sharedMyManager.cache = [[NSCache alloc]init];
        [sharedMyManager.cache setCountLimit:100];
        sharedMyManager.setUrlsInProgress = [[NSMutableSet alloc] init];
        sharedMyManager->_servicesQueue = dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT);
        sharedMyManager.regexHtmlPageTitle = [[NSRegularExpression alloc] initWithPattern:kRegexHtmlTitle options:NSRegularExpressionCaseInsensitive error:NULL];
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
//-(void)fetchTitleForUrlString:(NSString*)urlStr
//{
//    NSURL *sUrl = [NSURL URLWithString:urlStr];
//    [self fetchTitleForURL:sUrl];
//}
-(NSURLSessionDataTask *)fetchTitleForURL:(NSURL*)url group:(dispatch_group_t)group
{
    //Return if URL's title is fetched already
    if ([self.cache objectForKey:url]) {
        return nil;
    }
    //Return if URL's title is already being fetched
    if ([self.setUrlsInProgress containsObject:url]) {
        return  nil;
    }
    __weak typeof(self) weakSelf = self;
    __block NSURL *urlBlock = url;
    
    //Perform write operation in barrier block to avoid simaltaneous writes
    //in multithreaded environment
    dispatch_barrier_async(_servicesQueue, ^{
        [weakSelf.setUrlsInProgress addObject:urlBlock];
    });
    // Entering into a block
    NSLog(@"Entering Block: %@",urlBlock);
    dispatch_group_enter(group);
    NSURLSessionDataTask *dataTask =
    [[NSURLSession sharedSession]
     dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
         
         __block NSString *title;
         if (!error) {
             NSString* dataStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
             if (dataStr.length>0) {
                 
                 NSRange range = [weakSelf.regexHtmlPageTitle rangeOfFirstMatchInString:dataStr options:kNilOptions range:NSMakeRange(0, [dataStr length])];
                 if(range.location != NSNotFound)
                 {
                     title = [dataStr substringWithRange:range];
                 }
             }
         }else{
             NSLog(@"Error in retrieving title: %@", error);
         }
         
         dispatch_barrier_sync(_servicesQueue, ^{
             if (title) {
                 [weakSelf.cache setObject:title forKey:urlBlock];
             }
             [weakSelf.setUrlsInProgress removeObject:urlBlock];
         });
         // Leaving from a block
         NSLog(@"Leaving Block: %@",urlBlock);
         dispatch_group_leave(group);
     }];
    [dataTask resume];
    return dataTask;
}
-(void)fetchTitleForUrls:(NSArray<NSURL *> *)urls completion:(URLFetchCompletion)completion
{
    if (urls.count==0) {
        if (completion) {
            completion(@{},urls);
        }
        return;
    }
    // create a group
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    for (NSURL *url in urls) {
        [self fetchTitleForURL:url group:group];
    }
    dispatch_group_leave(group);
    
    __weak typeof(self) weakSelf = self;
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSMutableDictionary *dictionary = [NSMutableDictionary new];
        for (NSURL *url in urls) {
            NSString *title = [weakSelf titleForURL:url];
            if (title) {
                [dictionary setObject:title forKey:url];
            }
        }
        if (completion) {
            completion(dictionary, urls);
        }
        NSLog(@"Group Notify!");
    });
}
@end
