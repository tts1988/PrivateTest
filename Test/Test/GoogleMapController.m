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
#import "URLParameterParser.h"
#import <WebKit/WebKit.h>

#define GoogleMapActionScheme @"vbox"
#define GoogleMapActionKey    @"action"
#define GoogleMapActionSubmit @"submit"
#define GoogleMapActionClose  @"close"

@interface GoogleMapController ()<UIWebViewDelegate>

@property(nonatomic,weak)UIWebView *web;

@end

@implementation GoogleMapController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIWebView *web=[[UIWebView alloc]init];
    
    self.web=web;
    
    [self.view addSubview:web];
  
    
    web.delegate=self;
    
    web.scrollView.bounces=NO;
    
    web.scrollView.scrollEnabled=NO;
    
    NSString *htmlPath=[[NSBundle mainBundle] bundlePath];
    

    NSURL *url=[NSURL fileURLWithPath:htmlPath];
    
    CLLocationCoordinate2D location=CLLocationCoordinate2DMake(30.4886480000, 114.4179640000);
    
    location=[LocationTransformer transformLocation:location fromType:LocationTypeBD_09 toType:LocationTypeGCJ_02];
    
    NSString *para=[NSString stringWithFormat:@"GoogleMap/map.html?lat=%f&lon=%f",location.latitude,location.longitude];
    
    url=[NSURL URLWithString:para relativeToURL:[NSURL fileURLWithPath:htmlPath]];

    
    [web loadRequest:[NSURLRequest requestWithURL:url]];
    
    
    
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
    
    NSString *url=[request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if ([request.URL.scheme isEqualToString:GoogleMapActionScheme])
    {
        NSDictionary *parameter=[URLParameterParser parserParametersFromURL:url];
        
        [self handleGoogleMapAction:parameter];
    }
    
    
    
    
    return YES;
}

- (void)handleGoogleMapAction:(NSDictionary *)parameter
{
    if ([[parameter valueForKey:GoogleMapActionKey] isEqualToString:GoogleMapActionSubmit])
    {
        NSLog(@"**%@**",[parameter valueForKey:GoogleMapActionKey]);
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([[parameter valueForKey:GoogleMapActionKey] isEqualToString:GoogleMapActionClose])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
