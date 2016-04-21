//
//  KnowlageInfoViewController.m
//  PetLife
//
//  Created by lanou3g on 16/4/19.
//  Copyright © 2016年 lanou3g. All rights reserved.
//

#import "KnowlageInfoViewController.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "UIActivityIndicatorView+AFNetworking.h"

#import "NSString+Html.h"

@interface KnowlageInfoViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *mainWebView;

@property (nonatomic,strong)AFHTTPSessionManager *session;
@property (nonatomic,strong)UIActivityIndicatorView *indView;

@end

@implementation KnowlageInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithRed:0.99 green:0.73 blue:0.74 alpha:1.00];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self.tabBarController.tabBar setHidden:YES];
    
    NSString *url = [NSString stringWithFormat:@"http://client-api.dingdone.com/content/%@?&tplId=Tpl2",self.number];
    
    NSLog(@"%@",url);
    
    _session = [AFHTTPSessionManager manager];
    _session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
    //设置是否开启状态栏动画
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    [self requestDataWithUrl:url];
    
}

-(void)viewWillDisappear:(BOOL)animated{

    [self.tabBarController.tabBar setHidden:NO];
}

-(void)requestDataWithUrl:(NSString *)url{
    
    [_session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = responseObject;
        NSString *pageContent = dic[@"data"][@"pageContent"];
        
        NSString *str = [NSString importStyleWithHtmlString:pageContent];
        NSURL *baseURL = [NSURL fileURLWithPath:[NSBundle mainBundle].bundlePath];
        
        [_mainWebView loadHTMLString:str baseURL:baseURL];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"失败");
        
    }];
    
    _indView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    _indView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [_indView setAnimatingWithStateOfTask:_session.tasks[0]];
    
    _indView.center = self.view.center;
    [self.view addSubview:_indView];
    [_indView startAnimating];
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
