//
//  ViewController.m
//  ChatLexer
//
//  Created by Nabeel Arif on 3/4/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import "ViewController.h"
#import "MNParserAPI.h"

@interface ViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *tvInput;
@property (weak, nonatomic) IBOutlet UIButton *btnAnalyze;
@property (weak, nonatomic) IBOutlet UITextView *tvOutput;
@property (weak, nonatomic) IBOutlet UISwitch *switchLive;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tvInput.delegate = self;
    self.tvInput.layer.cornerRadius = 5;
    self.tvOutput.layer.cornerRadius = 5;
    self.btnAnalyze.layer.cornerRadius = 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITextView Delegate
-(void)textViewDidChange:(UITextView *)textView
{
    if (self.switchLive.on) {
        [self displayOutputForText:textView.text isFinal:NO];
    }
}

#pragma mark - Actions
- (IBAction)actionAnalyze:(id)sender {
    [self displayOutputForText:self.tvInput.text isFinal:YES];
    [self.tvInput resignFirstResponder];
}
#pragma mark - methods
-(void)displayOutputForText:(NSString*)text isFinal:(BOOL)isFinal
{
    __weak typeof(self) weakSelf = self;
    [ParserKit parseText:text isFinal:isFinal completion:^(NSDictionary * _Nonnull result, NSString * _Nonnull originalText) {
        NSString *jsonString = [MNParserAPI jsonForDictionary:result prettyPrint:YES];
        weakSelf.tvOutput.text = jsonString;
    }];
}
@end
