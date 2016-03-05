//
//  ViewController.m
//  ChatLexer
//
//  Created by Nabeel Arif on 3/4/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import "ViewController.h"
#import "Lexer/MNParser.h"

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
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITextView Delegate
-(void)textViewDidChange:(UITextView *)textView
{
    if (self.switchLive.on) {
        [self displayOutputForText:textView.text];
    }
}

//- (BOOL)textView:(UITextView*) textView shouldChangeTextInRange: (NSRange) range replacementText: (NSString*) text
//{
//    if ([text isEqualToString:@"\n"]) {
//        [textView resignFirstResponder];
//        return NO;
//    }
//    return YES;
//    
//}
#pragma mark - Actions
- (IBAction)actionAnalyze:(id)sender {
    
    [self displayOutputForText:self.tvInput.text];
    [self.tvInput resignFirstResponder];
}
#pragma mark - methods
-(void)displayOutputForText:(NSString*)text
{
    NSDictionary *dictionary = [MNParserKit parseText:text];
    NSString *jsonString = [MNParser jsonForDictionary:dictionary prettyPrint:YES];
    self.tvOutput.text = jsonString;
}
@end
