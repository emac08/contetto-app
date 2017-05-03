//
//  ViewController.m
//  Contetto
//
//  Created by Joe Harris on 4/27/17.
//  Copyright © 2017 Joe Harris. All rights reserved.
//

#import "ViewController.h"
#import "ErrorViewController.h"
#import "Reachability.h"

@interface ViewController () <UINavigationControllerDelegate, UINavigationBarDelegate, WKNavigationDelegate>

@property (strong, nonatomic) NSString *productURL;

@end

@implementation ViewController

MBProgressHUD *hud;
WKWebView *webView;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    hud = [[MBProgressHUD alloc] init];
    hud.label.text = @"Loading";
    [hud setBackgroundColor:[UIColor blackColor]];
    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
    webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:theConfiguration];
    webView.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    webView.navigationDelegate = self;
    webView.allowsBackForwardNavigationGestures = YES;
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    NSURL *nsurl=[NSURL URLWithString:@"https://app.contetto.io"];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [webView loadRequest:nsrequest];
    [self.view addSubview:webView];
    [self.view addSubview:hud];
}

- (void)viewWillAppear:(BOOL)animated {
    
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        // keep in mind this is called on a background thread
        // and if you are updating the UI it needs to happen
        // on the main thread, like this:
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"REACHABLE!");
        });
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        NSLog(@"UNREACHABLE!");
        [self showErrorViewController];
    };
    
    // Start the notifier, which will cause the reachability object to retain itself!
    [reach startNotifier];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [hud showAnimated:YES];
}

- (nullable WKNavigation *)loadRequest:(NSURLRequest *)request{
    return NULL;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [hud hideAnimated:YES];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [hud hideAnimated:YES];
    [self showErrorViewController];
}

- (void) showErrorViewController {
    ErrorViewController *errorviewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"errorviewcontroller"];
    [self presentViewController:errorviewcontroller animated:YES completion:nil];
}
- (IBAction)goforward:(id)sender {
    [webView canGoBack];
}

- (IBAction)goback:(id)sender {
    [webView canGoBack];
}
@end
