//
//  GoogleMapController.m
//  Test
//
//  Created by tangtianshuai on 2017/8/2.
//  Copyright © 2017年 tangtianshuai. All rights reserved.
//

#import "GoogleMapController.h"

@interface GoogleMapController ()<UIWebViewDelegate>

@property(nonatomic,weak)IBOutlet UIWebView *web;

@end

@implementation GoogleMapController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.web.delegate=self;
    
    self.web.scrollView.bounces=NO;
    
    self.web.scrollView.scrollEnabled=NO;
    
    NSString *path=[[NSBundle mainBundle] bundlePath];
    
    NSURL *baseUrl=[NSURL fileURLWithPath:path];
    
    NSString *htmlPath=[[NSBundle mainBundle] pathForResource:@"map" ofType:@"html"];
    
    NSString *htmlString=[[NSString alloc]initWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    
    //[self.web loadHTMLString:htmlString baseURL:baseUrl];
    
    
    NSURL *url=[NSURL URLWithString:htmlPath];
    
    url=[NSURL URLWithString:@"" relativeToURL:url];
    
    [self.web loadRequest:[NSURLRequest requestWithURL:url]];
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{

    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    CGRect frame = webView.frame;
    
    webView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height);
    
    webView.scrollView.contentSize = CGSizeMake(frame.size.width, webView.frame.size.height);

}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@",[self decodeFromPercentEscapeString:request.URL.absoluteString]);
    
    return YES;
}

- (NSString *)decodeFromPercentEscapeString: (NSString *) input
{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@""
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0,[outputStr length])];
    return
    [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
