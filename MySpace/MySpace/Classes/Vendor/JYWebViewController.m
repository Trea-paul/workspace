//
//  JYWebViewController.m
//  CYSDemo
//
//  Created by Paul on 2017/5/11.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "JYWebViewController.h"
#import <WebKit/WebKit.h>

@interface JYWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,UINavigationControllerDelegate,UINavigationBarDelegate>

@property (nonatomic, strong) WKWebView *webView;

//设置加载进度条
@property (nonatomic,strong) UIProgressView *progressView;
//仅当第一次的时候加载本地JS
@property(nonatomic,assign) BOOL needLoadJSPOST;
//网页加载的类型
//@property(nonatomic,assign) wkWebLoadType loadType;
//保存的网址链接
@property (nonatomic, copy) NSString *URLString;
//保存POST请求体
@property (nonatomic, copy) NSString *postData;
//保存请求链接
@property (nonatomic)NSMutableArray* snapShotsArray;
//返回按钮
@property (nonatomic)UIBarButtonItem* customBackBarItem;
//关闭按钮
@property (nonatomic)UIBarButtonItem* closeButtonItem;
// 刷新按钮（更多按钮）
@property (nonatomic, strong) UIBarButtonItem *reloadButtonItem;

@property (nonatomic, strong) UIButton *retryButton;

@end

@implementation JYWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
}


- (void)setupUI
{
//    self.webView = [[WKWebView alloc] init];
//    self.webView.frame = CGRectMake(0, self.navigationHeight, SCREEN_WIDTH, SCREENH_HEIGHT - self.navigationHeight);
//    //创建一个NSURLRequest 的对象
    
    if (!self.requestUrl.length || ![self.requestUrl hasPrefix:@"http"]) {

        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
        
        self.retryButton.hidden = NO;
        
        return;
    }
    
    [self.view addSubview:self.webView];
    
    self.webView.frame = CGRectMake(0, self.navigationHeight, SCREEN_WIDTH, SCREENH_HEIGHT - self.navigationHeight);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.requestUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    [self.webView loadRequest:request];
    
    [self.view addSubview:self.progressView];
    
    self.navigationItem.hidesBackButton = YES;
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_isNavHidden == YES) {
        self.navigationController.navigationBarHidden = YES;
        //创建一个高20的假状态栏
        UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
        //设置成绿色
        statusBarView.backgroundColor=[UIColor whiteColor];
        // 添加到 navigationBar 上
        [self.view addSubview:statusBarView];
    }else{
//        self.navigationController.navigationBarHidden = NO;
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)loadRequest
{
    
}


#pragma mark - Lazy Load

- (WKWebView *)webView
{
    if (!_webView) {
        //设置网页的配置文件
        WKWebViewConfiguration * Configuration = [[WKWebViewConfiguration alloc]init];
        //允许视频播放
        Configuration.allowsAirPlayForMediaPlayback = YES;
        // 允许在线播放
        Configuration.allowsInlineMediaPlayback = YES;
        // 允许可以与网页交互，选择视图
        Configuration.selectionGranularity = YES;
        // web内容处理池
        Configuration.processPool = [[WKProcessPool alloc] init];
        //自定义配置,一般用于 js调用oc方法(OC拦截URL中的数据做自定义操作)
        WKUserContentController * UserContentController = [[WKUserContentController alloc]init];
        // 添加消息处理，注意：self指代的对象需要遵守WKScriptMessageHandler协议，结束时需要移除
        [UserContentController addScriptMessageHandler:self name:@"WXPay"];
        // 是否支持记忆读取
        Configuration.suppressesIncrementalRendering = YES;
        // 允许用户更改网页的设置
        Configuration.userContentController = UserContentController;
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:Configuration];
        _webView.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0];
        // 设置代理
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        //kvo 添加进度监控  WkwebBrowserContext
        [_webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:nil];
        //开启手势触摸
        _webView.allowsBackForwardNavigationGestures = YES;
        // 设置 可以前进 和 后退
        //适应你设定的尺寸
        [_webView sizeToFit];
    }
    return _webView;
}

static void *WkwebBrowserContext = &WkwebBrowserContext;

- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        if (_isNavHidden == YES) {
            _progressView.frame = CGRectMake(0, 20, self.view.bounds.size.width, 3);
        }else{
            _progressView.frame = CGRectMake(0, self.navigationHeight, self.view.bounds.size.width, 3);
        }
        // 设置进度条的色彩
        [_progressView setTrackTintColor:JYRandomColor];
        _progressView.progressTintColor = [UIColor orangeColor];
        
    }
    return _progressView;
}

- (UIBarButtonItem*)customBackBarItem
{
    if (!_customBackBarItem) {
        _customBackBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backItemImage"] style:UIBarButtonItemStylePlain target:self action:@selector(customBackItemClicked)];
        
    }
    return _customBackBarItem;
}

-(UIBarButtonItem*)closeButtonItem
{
    if (!_closeButtonItem) {
        
        _closeButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"edit"] style:UIBarButtonItemStylePlain target:self action:@selector(closeItemClicked)];
        
    }
    return _closeButtonItem;
}

- (UIBarButtonItem *)reloadButtonItem
{
    if (!_reloadButtonItem) {
        _reloadButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadItemClicked)];
    }
    return _reloadButtonItem;
}


- (NSMutableArray*)snapShotsArray{
    if (!_snapShotsArray) {
        _snapShotsArray = [NSMutableArray array];
    }
    return _snapShotsArray;
}

- (UIButton *)retryButton
{
    if (!_retryButton)
    {
        _retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_retryButton setImage:[UIImage imageNamed:@"error_link"] forState:UIControlStateNormal];
        [_retryButton setTitle:@"该页面无法访问，轻触返回" forState:UIControlStateNormal];
        [_retryButton setTitleColor:JYRandomColor forState:UIControlStateNormal];
        
        _retryButton.imageView.bounds = CGRectMake(0, 0, 60, 60);
        
        WeakSelf(self);
        [[_retryButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            
            
            [weakself.navigationController popViewControllerAnimated:YES];
            
        }];
        
        
        [self.view addSubview:_retryButton];
        
        
        
        [_retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.centerY.mas_equalTo(weakself.view.mas_centerY);
            make.centerX.mas_equalTo(weakself.view.mas_centerX);
            make.height.mas_equalTo(100);
            
        }];
        
        [_retryButton buttonLayoutStyle:JYButtonLayoutStyleTop imageTitleSpace:50];
    }
    
    
    return _retryButton;
}


#pragma mark ================ Actions ====================

- (void)reloadItemClicked
{
    [self.webView reload];
    
}

- (void)customBackItemClicked
{
    if (self.webView.canGoBack)
    {
        [self.webView goBack];
        
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)closeItemClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma mark ================ 自定义返回/关闭按钮 ================

-(void)updateNavigationItems
{
    if (self.webView.canGoBack)
    {
//        UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//        spaceButtonItem.width = -6.5;
        
        [self.navigationItem setLeftBarButtonItems:@[self.customBackBarItem,self.closeButtonItem] animated:NO];
    } else
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        [self.navigationItem setLeftBarButtonItems:@[self.customBackBarItem]];
    }
}

//请求链接处理
-(void)pushCurrentSnapshotViewWithRequest:(NSURLRequest*)request{
    //    NSLog(@"push with request %@",request);
    NSURLRequest *lastRequest = (NSURLRequest*)[[self.snapShotsArray lastObject] objectForKey:@"request"];
    
    //如果url是很奇怪的就不push
    if ([request.URL.absoluteString isEqualToString:@"about:blank"]) {
        //        NSLog(@"about blank!! return");
        return;
    }
    //如果url一样就不进行push
    if ([lastRequest.URL.absoluteString isEqualToString:request.URL.absoluteString]) {
        return;
    }
    
    UIView *currentSnapShotView = [self.webView snapshotViewAfterScreenUpdates:YES];
    [self.snapShotsArray addObject:
     @{@"request":request,@"snapShotView":currentSnapShotView}];
}

#pragma mark - Delegates

#pragma mark ================ WKNavigationDelegate ================

//这个是网页加载完成，导航的变化
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    /*
     主意：这个方法是当网页的内容全部显示（网页内的所有图片必须都正常显示）的时候调用（不是出现的时候就调用），，否则不显示，或则部分显示时这个方法就不调用。
     */
    // 判断是否需要加载（仅在第一次加载）
//    if (self.needLoadJSPOST) {
//        // 调用使用JS发送POST请求的方法
//        [self postRequestWithJS];
//        // 将Flag置为NO（后面就不需要加载了）
//        self.needLoadJSPOST = NO;
//    }
    
    [self.navigationItem setRightBarButtonItem:self.reloadButtonItem animated:YES];
    
    // 获取加载网页的标题
    self.title = self.webView.title;
    
    
    
    [self updateNavigationItems];
}

//开始加载
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    //开始加载的时候，让加载进度条显示
    self.progressView.hidden = NO;
    [self updateNavigationItems];
}

//内容返回时调用
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{}

//服务器请求跳转的时候调用
-(void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{}

//服务器开始请求的时候调用
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //    NSString* orderInfo = [[AlipaySDK defaultService]fetchOrderInfoFromH5PayUrl:[navigationAction.request.URL absoluteString]];
    //    if (orderInfo.length > 0) {
    //        [self payWithUrlOrder:orderInfo];
    //    }
    //    //拨打电话
    //    //兼容安卓的服务器写法:<a class = "mobile" href = "tel://电话号码"></a>
    //    NSString *mobileUrl = [[navigationAction.request URL] absoluteString];
    //    mobileUrl = [mobileUrl stringByRemovingPercentEncoding];
    //    NSArray *urlComps = [mobileUrl componentsSeparatedByString:@"://"];
    //    if ([urlComps count]){
    //
    //        if ([[urlComps objectAtIndex:0] isEqualToString:@"tel"]) {
    //
    //            UIAlertController *mobileAlert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"拨号给 %@ ？",urlComps.lastObject] preferredStyle:UIAlertControllerStyleAlert];
    //            UIAlertAction *suerAction = [UIAlertAction actionWithTitle:@"拨号" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //
    //                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mobileUrl]];
    //            }];
    //            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    //                return ;
    //            }];
    //
    //            [mobileAlert addAction:suerAction];
    //            [mobileAlert addAction:cancelAction];
    //
    //            [self presentViewController:mobileAlert animated:YES completion:nil];
    //        }
    //    }
    
    
    switch (navigationAction.navigationType) {
        case WKNavigationTypeLinkActivated: {
            [self pushCurrentSnapshotViewWithRequest:navigationAction.request];
            break;
        }
        case WKNavigationTypeFormSubmitted: {
            [self pushCurrentSnapshotViewWithRequest:navigationAction.request];
            break;
        }
        case WKNavigationTypeBackForward: {
            break;
        }
        case WKNavigationTypeReload: {
            break;
        }
        case WKNavigationTypeFormResubmitted: {
            break;
        }
        case WKNavigationTypeOther: {
            [self pushCurrentSnapshotViewWithRequest:navigationAction.request];
            break;
        }
        default: {
            break;
        }
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 内容加载失败时候调用
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"页面加载超时");
    self.navigationItem.hidesBackButton = NO;
}

//跳转失败的时候调用
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    
}

//进度条
-(void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{}

#pragma mark ================ WKUIDelegate ================

// 获取js 里面的提示
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

// js 信息的交流
-(void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

// 交互。可输入的文本。
-(void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"textinput" message:@"JS调用输入框" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor redColor];
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
    
}

//KVO监听进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.webView) {
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.webView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.webView.estimatedProgress animated:animated];
        
        // Once complete, fade out UIProgressView
        if(self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark ================ WKScriptMessageHandler ================

//拦截执行网页中的JS方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    //服务器固定格式写法 window.webkit.messageHandlers.名字.postMessage(内容);
    //客户端写法 message.name isEqualToString:@"名字"]
    if ([message.name isEqualToString:@"WXPay"]) {
        NSLog(@"%@", message.body);
        //调用微信支付方法
        //        [self WXPayWithParam:message.body];
    }
}




-(void)viewWillDisappear:(BOOL)animated{
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"WXPay"];
    [self.webView setNavigationDelegate:nil];
    [self.webView setUIDelegate:nil];
}

//注意，观察的移除
-(void)dealloc{
    [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
