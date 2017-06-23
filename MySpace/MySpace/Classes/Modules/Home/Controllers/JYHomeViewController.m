//
//  JYHomeViewController.m
//  CYSDemo
//
//  Created by Paul on 2017/5/2.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "JYHomeViewController.h"
#import "JYNewsListViewController.h"
#import "HomeModel.h"
#import "JYHomeNewsTableViewCell.h"
#import "JYHomeTableHeaderListCell.h"
#import "JYNewsTableHeaderView.h"
#import "JYBannerTableViewCell.h"
#import "JYSubTitleScrollView.h"
#import "JYLiverTableViewListCell.h"

@interface JYHomeViewController ()<UINavigationControllerDelegate,JYTableViewControllerDelegate, JYNewsTableHeaderViewDelegate>

@property (nonatomic, strong) JYTableViewController *tableViewController;
@property (nonatomic, strong) JYTableViewModel *viewModel;
@property (nonatomic, strong) JYTableViewSectionModel *articleSectionModel;

@property (nonatomic, strong) HomeModel *homeModel;
@property (nonatomic, copy) NSString *currentCategoryId;

@property (nonatomic, strong) NSNumber *showNavigation;

// 封装资讯的ViewModel
@property (nonatomic, strong) NSMutableDictionary *newsViewModelDict;



@end

@implementation JYHomeViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.delegate = self;
    
    self.title = @"心脑百问";

    [self setupUI];
}

- (void)setupUI
{
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"edit"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    
    self.tableViewController.view.frame = CGRectMake(0, self.navigationHeight, SCREEN_WIDTH, SCREENH_HEIGHT - 64);
    
    [self.tableViewController.tableView registerClass:[JYHomeNewsTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JYHomeNewsTableViewCell class])];
    
    self.tableViewController.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        DLog(@"下拉刷新");
        [self.tableViewController.tableView.mj_header endRefreshing];
    }];
    
    self.tableViewController.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        
        DLog(@"上拉刷新");
        [self requestArticleListData];
        [self.tableViewController.tableView.mj_footer endRefreshing];
    }];
    
    
    [self requestData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
//    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
//    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

#pragma mark - Lazy Load

- (JYTableViewController *)tableViewController
{
    if (!_tableViewController) {
        _tableViewController = [[JYTableViewController alloc] initWithStyle:UITableViewStylePlain];
        _tableViewController.view.userInteractionEnabled = YES;
        _tableViewController.delegate = self;
        _tableViewController.automaticallyAdjustsScrollViewInsets = YES;
        _tableViewController.tableView.backgroundView.backgroundColor = HexRGB(0xFFFFF0);
        [self addChildViewController:_tableViewController];
        [self.view addSubview:_tableViewController.view];
    }
    return _tableViewController;
}


- (NSMutableDictionary *)newsViewModelDict
{
    if (!_newsViewModelDict) {
        _newsViewModelDict = [NSMutableDictionary dictionary];
    }
    return _newsViewModelDict;
}

- (HomeModel *)homeModel
{
    if (!_homeModel) {
        _homeModel = [[HomeModel alloc] init];
    }
    return _homeModel;
}


#pragma mark - Request Data
- (void)requestData
{
    [[HUDHepler sharedHelper] showLoading:@"正在加载中" inView:self.view];
    
    WeakSelf(self);
    [self.homeModel requestHomeData:^(HomeModel *homeModel) {
        
        [weakself updateBaseTableView];
        
        [[HUDHepler sharedHelper] hideHUDInView:weakself.view];
        
    }];
}

- (void)requestArticleListData
{
    // 请求推荐列表 (推荐列表设置一个特定Id标识，便于记录ListModel)  id = @"recommand"
    if (!self.currentCategoryId.length) {
        self.currentCategoryId = kRecommandCategoryId;
    }
    WeakSelf(self);
    [self.homeModel reqeustArtcilesListWithId:self.currentCategoryId pageNum:0 completion:^ (BOOL hasNext) {
        
        DLog(@"+++ %@",self.homeModel.articleListModels);
        
        // 判断页数，是否还能加载更多
        if (!hasNext) {
            [self.tableViewController.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [weakself updateArticleListTableView];
        
    }];
}



#pragma mark - Update TableView

- (void)updateBaseTableView
{
    if (!self.homeModel.bannerModel) {
        return;
    }
    self.viewModel = [[JYTableViewModel alloc] initWithStyle:UITableViewStyleGrouped sectionModelsBlock:^(NSMutableArray *sectionModels) {
        
          JYTableViewSectionModel *firstSectionModel = [[JYTableViewSectionModel alloc] initWithCellModelsBlock:^(NSMutableArray *cellModels)
            {
                JYTableViewListCellModel *bannerCellModel = [[JYTableViewListCellModel alloc] init];
                
                bannerCellModel.cellClass = [JYBannerTableViewCell class];
                
                bannerCellModel.model = self.homeModel.bannerModel;
                
                [cellModels addObject:bannerCellModel];
                
            }];
          
          
          
          [sectionModels addObject:firstSectionModel];
          
          // 直播
          JYTableViewSectionModel *liveSectionModel = [[JYTableViewSectionModel alloc] initWithCellModelsBlock:^(NSMutableArray *cellModels) {
              
              LiverModel *liverModel = self.homeModel.liverModel;
              
              JYTableViewListCellModel *cellModel = [[JYTableViewListCellModel alloc] init];
              
              cellModel.topLeftLbTitle     = (liverModel.display_area == 1) ? @"直播" : @"录播";;
              cellModel.topCenterLbTitle   = liverModel.title;
              cellModel.centerLbTitle      = liverModel.brief;
              cellModel.centerRightLbTitle = liverModel.start_time;
              cellModel.linkUrl            = liverModel.url;
              
              cellModel.cellClass = [JYLiverTableViewListCell class];
              
              [cellModels addObject:cellModel];
              
          }];
          
          liveSectionModel.sectionHeaderHeight = 40.0f;
          [sectionModels addObject:liveSectionModel];
        
        // 咨询
        self.articleSectionModel = [[JYTableViewSectionModel alloc] initWithCellModelsBlock:^(NSMutableArray *cellModels)
         {
             
         }];
        
        RecommendModel *recommendModel = self.homeModel.recommendModel;
        self.articleSectionModel.dataModel = recommendModel;
        
        self.articleSectionModel.sectionHeaderHeight = 40.0f;
        [sectionModels addObject:self.articleSectionModel];
        
    }];
    
    self.tableViewController.viewModel = self.viewModel;
    
    [self requestArticleListData];
}

- (void)updateArticleListTableView
{
    ArticleListModel *listModel;
    for (ArticleListModel *model in self.homeModel.articleListModels) {
        
        if ([model.categoryId isEqualToString:self.currentCategoryId]) {
            
            listModel = model;
        }
    }
    
    if (!listModel) {
        return;
    }
    
    NSMutableArray *cellModels = [NSMutableArray array];
    
    for (ArticleModel *article in listModel.articleList) {
        
        JYTableViewListCellModel *cellModel = [[JYTableViewListCellModel alloc] init];
        
        cellModel.topCenterLbTitle  = article.title;
        cellModel.centerLeftLbTitle = article.tags;
        cellModel.value             = article.article_url;
        cellModel.topLeftLbTitle    = article.icon;
        
        // 计算尺寸
        cellModel.rowHeight = [JYHomeNewsTableViewCell heightForRowWithModel:article];
        
        cellModel.cellClass = [JYHomeNewsTableViewCell class];
        
        [cellModels addObject:cellModel];
    }
    
    self.articleSectionModel.cellModels = cellModels;
    
    [self.tableViewController.tableView reloadData];
    
}



#pragma mark - TableView DataSource

- (CGFloat)tableViewModel:(JYTableViewModel *)tableViewModel heightForFooterInSection:(NSInteger)section
{
    if (section <= 1) {
        return 12;
    }
    else
    {
        return 0.01f;
    }
}


- (UIView *)tableView:(UITableView *)tableView tableViewModel:(JYTableViewModel *)tableViewModel viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        // 心脑讲堂
        
        JYNewsTableHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:liveHeaderViewIdentifier];
        if (!view) {
            view = [[JYNewsTableHeaderView alloc] initWithTitle:@"心脑讲堂" reuseIdentifier:liveHeaderViewIdentifier];
        }
        
        view.delegate = self;

        return view;
    }
    else if (section == 2) {
        
        JYTableViewSectionModel *sectionModel = tableViewModel.sectionModels[section];
        RecommendModel *model = sectionModel.dataModel;
        NSArray *categories = model.recommendCategories;
        // 推荐
        JYNewsTableHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:newsHeaderViewIdentifier];
        if (!view) {
            view = [[JYNewsTableHeaderView alloc] initWithTitleArray:categories reuseIdentifier:newsHeaderViewIdentifier];
            view.moreButtonUrl = model.moreArticlesUrl;
        }
        
        view.showMoreButton = @YES;
        
        view.delegate = self;
        
        return view;
    }
    else
    {
        UITableViewHeaderFooterView *view = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0.0f,0.0f,0.0f,0.01f)];
        return view;
    }
    
    
}

#pragma mark - TableView Delegate


- (void)tableViewModel:(JYTableViewModel *)tableViewModel didSelectCellModel:(JYTableViewCellModel *)cellModel atIndexPath:(NSIndexPath *)indexPath
{
    JYWebViewController *webVC = [[JYWebViewController alloc] init];
    webVC.hidesBottomBarWhenPushed = YES;
    webVC.requestUrl = cellModel.value;
    [self.navigationController pushViewController:webVC animated:YES];
    
}

-(void)tablevView:(UITableView *)tableView scrollViewDidScroll:(UIScrollView *)scrollView
{
    
//    CGFloat sectionHeaderHeight = 170;
//    DLog(@"%f",scrollView.contentOffset.y);
////
//    if (scrollView.contentOffset.y >= sectionHeaderHeight && scrollView.contentOffset.y <= sectionHeaderHeight + 10) {
//        
//        self.statusView.hidden = NO;
//        
//        CGFloat viewAlpha = scrollView.contentOffset.y - sectionHeaderHeight;
////        self.statusView.alpha = viewAlpha / 10;
//        self.statusView.backgroundColor = HexRGBAlpha(0XFFFFFF, viewAlpha / 10);
////        self.tableViewController.tableView.contentInset = UIEdgeInsetsMake(20, 0, 50, 0);
//    }
//    else if (scrollView.contentOffset.y > sectionHeaderHeight + 10)
//    {
//        self.statusView.hidden = NO;
//        
//        self.statusView.alpha = 1;
//    }
//    else
//    {
//        
//        self.statusView.hidden = YES;
////        self.statusView.opaque = NO;
//        self.statusView.alpha = 0;
//        self.tableViewController.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
//    }
    
    
    
}


#pragma mark - Action

- (void)rightItemClick
{
    JYNewsListViewController *newsVC = [[JYNewsListViewController alloc] init];
    newsVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:newsVC animated:YES];
    
}



- (void)didTouchUpInsideHeaderViewButton:(UIButton *)button buttonUrl:(NSString *)buttonUrl
{
//    JYNewsListViewController *listVC = [[JYNewsListViewController alloc] init];
//    listVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:listVC animated:YES];
    
    JYWebViewController *webVC = [[JYWebViewController alloc] init];
    webVC.requestUrl = buttonUrl;
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
    
    
}

//- (void)didTouchUpInsideSubTitle:(NSString *)title
//{
//    [self touchUpInsideDataURL:@"local://home2.json"];
//}

- (void)didTouchUpScrollViewSubTitle:(NSString *)title titleId:(NSString *)titleId
{
//    [self.tableViewController.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.viewModel.sectionModels.count - 1] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    [self.tableViewController.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]atScrollPosition:UITableViewScrollPositionNone animated:YES];
    
    self.currentCategoryId = titleId;
    
    // 判断需要请求数据还是直接加载列表
    for (ArticleListModel *model in self.homeModel.articleListModels) {
        
        if ([model.categoryId isEqualToString:self.currentCategoryId]) {
            
            [self updateArticleListTableView];
            return;
        }
    }
    
    [self requestArticleListData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
