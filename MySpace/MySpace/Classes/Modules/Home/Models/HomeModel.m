//
//  HomeModel.m
//  CYSDemo
//
//  Created by Paul on 2017/5/3.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "HomeModel.h"



@implementation HomeModel

#pragma mark - Lazy Load
- (NSMutableArray *)bannerModel
{
    if (!_bannerModel) {
        _bannerModel = [NSMutableArray array];
    }
    return _bannerModel;
}

//- (LiverModel *)liverModel
//{
//    if (!_liverModel) {
//        _liverModel = [[LiverModel alloc] init];
//    }
//    return _liverModel;
//}
//
//- (RecommendModel *)recommendModel
//{
//    if (!_recommendModel) {
//        _recommendModel = [[RecommendModel alloc] init];
//    }
//    return _recommendModel;
//}

- (NSMutableArray *)articleListModels
{
    if (!_articleListModels) {
        _articleListModels = [NSMutableArray array];
    }
    return _articleListModels;
}


#pragma mark - Request Data

- (void)requestHomeData:(void(^)(HomeModel *homeModel))completion
{
    @weakify(self)
    RACSignal *signalBanner = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self reqeustBannerModel:^{
            [subscriber sendNext:nil];
        }];
        return nil;
    }];
    
    RACSignal *signalLiver = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self reqeustLiverModel:^{
            [subscriber sendNext:nil];
        }];
        return nil;
    }];
    
    RACSignal *signalRecommend = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self reqeustRecommandModel:^{
            [subscriber sendNext:nil];
        }];
        return nil;
    }];
    
    
    [[RACSignal combineLatest:@[signalBanner,signalLiver,signalRecommend]] subscribeNext:^(id x) {
        @strongify(self);

        if (completion) {
            completion(self);
        }
        
    }];
}


- (void)reqeustArtcilesListWithId:(NSString *)categoryId
                       pageNum:(NSInteger)pageNum
                       completion:(void(^)(BOOL hasNext))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        ArticleListModel *listModel;
        if (!self.articleListModels.count) {
            
            listModel = [[ArticleListModel alloc] init];
            listModel.categoryId = categoryId;
            listModel.currentPageNum = 0;
            // HomeModel没有该类ListModel
            [self.articleListModels addObject:listModel];
        }
        else {
            
            // 判断当前是否已存在该类ListModel
            for (ArticleListModel *model in self.articleListModels) {
                
                if ([model.categoryId isEqualToString:categoryId]) {
                    
                    // 已存在
                    listModel = model;
                    break;
                }
                
            }
            
            if (!listModel) {
                
                // 不存在，添加articleListModel
                listModel = [[ArticleListModel alloc] init];
                listModel.categoryId = categoryId;
                listModel.currentPageNum = 0;
                // HomeModel没有该类ListModel
                [self.articleListModels addObject:listModel];
            }
        }
        
        [self reqeustArtcileListModelWithId:categoryId
                           articleListModel:listModel
                                    pageNum:listModel.currentPageNum
                                 completion:^(BOOL hasNext) {
                                     
             if (completion) {
                 
                 if (hasNext) {
                     completion(YES);
                 } else {
                     completion(NO);
                 }
                 
             }
             
         }];
        
        
    });
}

- (void)reqeustBannerModel:(void(^)(void))completion
{
    [HttpRequestManager GET:@"genericapi/public/banner/" parameters:@{@"type" : @"patient_app_ios"} success:^(id responseObject, BOOL success) {
        
        if (success) {
            
            NSArray *array = (NSArray *)responseObject;
            
            for (NSDictionary *item in array) {
                
                BannerModel *model = [[BannerModel alloc] init];
                [model mj_setKeyValues:item];
                [self.bannerModel addObject:model];
            }
        }
        
        if(completion) {
            completion();
        }
        
        
    } failure:^(NSError *error) {
        
        if(completion) {
            completion();
        }
    }];
}

- (void)reqeustLiverModel:(void(^)(void))completion
{
    [HttpRequestManager GET:@"hmapi/public/live/recent" parameters:nil success:^(id responseObject, BOOL success) {
        if (success) {
            
            NSDictionary *liver = (NSDictionary *)responseObject;
            LiverModel *model = [[LiverModel alloc] init];
            [model mj_setKeyValues:liver];
            self.liverModel = model;
        }
        
        if(completion) {
            completion();
        }
        
        
    } failure:^(NSError *error) {
        if(completion) {
            completion();
        }
        
    }];
}

- (void)reqeustRecommandModel:(void(^)(void))completion
{
    [HttpRequestManager GET:@"genericapi/public/patient_edu/article_sick/recommend" parameters:nil success:^(id responseObject, BOOL success) {
        
        if (success) {
            
            NSDictionary *response = (NSDictionary *)responseObject;
            RecommendModel *model = [[RecommendModel alloc] init];
            model.moreArticlesUrl = [response valueForKey:@"more_article_url"];
            
            //增加默认的 推荐
            [model.recommendCategories addObject:@{@"name" : @"推荐" , @"sickCategoryId": kRecommandCategoryId}];
            
            NSArray *categories = [response valueForKey:@"recommend_sick_categories"];
            if (categories.count) {
                for (NSDictionary *dict in categories) {
                    [model.recommendCategories addObject:dict];
                }
            }
            self.recommendModel = model;
        }
        
        if(completion) {
            completion();
        }
        
    } failure:^(NSError *error) {
        if(completion) {
            completion();
        }
        
    }];
}

- (void)reqeustArtcileListModelWithId:(NSString *)categoryId
                     articleListModel:(ArticleListModel *)listModel
                          pageNum:(NSInteger)pageNum
                       completion:(void(^)(BOOL hasNext))completion
{
    NSDictionary *parameter;
    NSString *pageNumber = [NSString stringWithFormat:@"%ld",(long)pageNum];
    if ([categoryId isEqualToString:kRecommandCategoryId]) {
        parameter = @{@"page_num" : pageNumber, @"page_size" : @"10"};
    } else {
        
        parameter = @{@"sick_category_id" : categoryId, @"page_num" : pageNumber, @"page_size" : @"10"};
    }
    
    [HttpRequestManager GET:@"genericapi/public/patient_edu/articles" parameters:parameter success:^(id responseObject, BOOL success) {
        
        if (success) {
            
            NSDictionary *response = (NSDictionary *)responseObject;
            [listModel mj_setKeyValues:response];
            listModel.currentPageNum = pageNum + 1;
            NSArray *articles = [response valueForKey:@"content"];
            if (articles.count) {
                for (NSDictionary *dict in articles) {
                    
                    ArticleModel *model = [[ArticleModel alloc] init];
                    [model mj_setKeyValues:dict];
                    [listModel.articleList addObject:model];
                }
            }
            
            if(completion) {
                if (listModel.has_next) {
                    completion(YES);
                } else {
                    completion(NO);
                }
                
            }
            
        } else {
            if(completion) {
                completion(NO);
            }
        }
        
        
    } failure:^(NSError *error) {
        if(completion) {
            completion(NO);
        }
        
    }];
    
    
    
    
}




@end

@implementation BannerModel



@end

@implementation LiverModel

- (void)setStart_time:(NSString *)start_time
{
    NSString *time = [DateUtils transferTimeWithStampTime:start_time];
    
    _start_time = time;
}



@end

@implementation RecommendModel

- (NSMutableArray *)recommendCategories
{
    if (!_recommendCategories) {
        _recommendCategories = [NSMutableArray array];
    }
    return _recommendCategories;
}


@end

@implementation ArticleListModel

- (NSMutableArray *)articleList
{
    if (!_articleList) {
        _articleList = [NSMutableArray array];
    }
    return _articleList;
}

@end

@implementation ArticleModel




@end
