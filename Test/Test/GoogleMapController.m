//
//  GoogleMapController.m
//  Test
//
//  Created by tangtianshuai on 2017/8/2.
//  Copyright © 2017年 tangtianshuai. All rights reserved.
//

#import "GoogleMapController.h"
#import <CoreLocation/CoreLocation.h>
#import "LocationTransformer.h"

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
    
    NSString *htmlPath=[[NSBundle mainBundle] pathForResource:@"map" ofType:@"html"];
    

    NSURL *url=[NSURL fileURLWithPath:htmlPath];
    
    CLLocationCoordinate2D location=CLLocationCoordinate2DMake(30.4886480000, 114.4179640000);
    
    location=[LocationTransformer transformLocation:location fromType:LocationTypeBD_09 toType:LocationTypeGCJ_02];
    
    NSString *para=[NSString stringWithFormat:@"?lat=%f&lon=%f",location.latitude,location.longitude];
    
    url=[NSURL URLWithString:para relativeToURL:url];
    
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
