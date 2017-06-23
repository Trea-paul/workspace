//
//  HomeModel.h
//  CYSDemo
//
//  Created by Paul on 2017/5/3.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "BaseModel.h"

#define kRecommandCategoryId @"recommand"

@class BannerModel, LiverModel, RecommendModel, ArticleListModel, ArticleModel;

@interface HomeModel : BaseModel

@property (nonatomic, strong) NSMutableArray<BannerModel *> *bannerModel;
@property (nonatomic, strong) LiverModel *liverModel;
@property (nonatomic, strong) RecommendModel *recommendModel;
@property (nonatomic, strong) NSMutableArray<ArticleListModel *> *articleListModels;



#pragma mark - 请求数据


/**
 请求首页数据 包括Banner、直播信息、类别
 */
- (void)requestHomeData:(void(^)(HomeModel *homeModel))completion;


/**
 获取文章列表

 @param categoryId 类别Id 为空时默认请求推荐列表
 */
- (void)reqeustArtcilesListWithId:(NSString *)categoryId
                          pageNum:(NSInteger)pageNum
                       completion:(void(^)(BOOL hasNext))completion;


@end


/**
 Banner页
 */
@interface BannerModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *image_url;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *seq;             // 顺序
@property (nonatomic, copy) NSString *type;            // 类型  ios传patient_app_ios
@property (nonatomic, copy) NSString *type_desc;       // 类型描述




@end


/**
 直播页
 */
@interface LiverModel : NSObject


@property (nonatomic, copy) NSString *brief;              // 副标题
@property (nonatomic, assign) NSInteger display_area;     // 直播1 录播2
@property (nonatomic, copy) NSString *start_time;         // 开始时间
@property (nonatomic, copy) NSString *title;              // 标题
@property (nonatomic, copy) NSString *url;                // 链接


@end


/**
 推荐文章类别
 */
@interface RecommendModel : NSObject

@property (nonatomic, copy) NSString *moreArticlesUrl;              // 查看全部

// name sickCategoryId
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *recommendCategories;  // 推荐类别


@end


/**
 文章列表
 */
@interface ArticleListModel : NSObject

@property (nonatomic, strong) NSMutableArray<ArticleModel *> *articleList;

@property (nonatomic, copy)   NSString *categoryId;        // 该ListModel的id

@property (nonatomic, assign) BOOL has_next;               // 下一页
@property (nonatomic, assign) BOOL has_previous;           // 上一页
@property (nonatomic, assign) NSInteger records_in_page;   // 当前记录所在页
@property (nonatomic, assign) NSInteger currentPageNum;    // 当前页
@property (nonatomic, assign) NSInteger total_pages;       // 总页数
@property (nonatomic, assign) NSInteger total_records;     // 总记录数



@end


/**
 文章
 */
@interface ArticleModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *article_url;
@property (nonatomic, copy) NSString *tags;
@property (nonatomic, copy) NSString *sick_category_name;


@end
