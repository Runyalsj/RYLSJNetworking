//
//  RYLSJ_HomeViewController.m
//  RYLSJNetworking_Example
//
//  Created by tutu on 2019/7/27.
//  Copyright © 2019 RunyaLsj. All rights reserved.
//

#import "RYLSJ_HomeViewController.h"
#import "RYLSJ_Networking.h"
#import "RYLSJ_RootModel.h"

@interface RYLSJ_HomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)UIRefreshControl *refreshControl;
@end

@implementation RYLSJ_HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"GET请求";
    /**
     *  RYLSJ_RequestTypeCache 为 有缓存使用缓存 无缓存就重新请求
     *  默认缓存路径/Library/Caches/RYLSJ_Kit/AppCache
     */
    [self getDataWithApiType:RYLSJ_RequestTypeCache];
    
    
    [self.tableView addSubview:self.refreshControl];
    [self.view addSubview:self.tableView];
    
    [self addItemWithTitle:@"设置缓存" selector:@selector(btnClick) location:NO];
    
    [self addItemWithTitle:@"其他方法" selector:@selector(otherbtnClick) location:YES];
    
}

#pragma mark - AFNetworking
//apiType 是请求类型 在RYLSJ_RequestConst 里
- (void)getDataWithApiType:(apiType)requestType{
    
    [RYLSJ_RequestManager requestWithConfig:^(RYLSJ_URLRequest *request){
        request.URLString=list_URL;
        request.methodType=RYLSJ_MethodTypeGET;//默认为GET
        request.apiType=requestType;//默认为RYLSJ_RequestTypeRefresh
        // request.requestSerializer=RYLSJ_HTTPRequestSerializer;//默认RYLSJ_HTTPRequestSerializer 上传参数默认为二进制 格式
        // request.responseSerializer=RYLSJ_JSONResponseSerializer;//默认RYLSJ_JSONResponseSerializer  返回的数据默认为json格式
        // request.timeoutInterval=10;//默认30
    }  success:^(id responseObject,apiType type,BOOL isCache){
        //如果是刷新的数据
        if (type==RYLSJ_RequestTypeRefresh) {
            [self.dataArray removeAllObjects];
            
        }
        //上拉加载 要添加 apiType 类型 RYLSJ_RequestTypeCacheMore(读缓存)或RYLSJ_RequestTypeRefreshMore(重新请求)， 也可以不遵守此枚举
        if (type==RYLSJ_RequestTypeRefreshMore) {
            //上拉加载
        }
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            NSArray *array=[dict objectForKey:@"authors"];
            
            for (NSDictionary *dic in array) {
                RYLSJ_RootModel *model= [[RYLSJ_RootModel alloc]initWithDict:dic];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];    //结束刷新
            if (isCache==YES) {
                NSLog(@"使用了缓存");
            }else{
                NSLog(@"重新请求");
            }
        }
        
    } failure:^(NSError *error){
        if (error.code==NSURLErrorCancelled)return;
        if (error.code==NSURLErrorTimedOut){
            [self alertTitle:@"请求超时" andMessage:@""];
        }else{
            [self alertTitle:@"请求失败" andMessage:@""];
        }
        [self.refreshControl endRefreshing];  //结束刷新
    }];
}

#pragma mark - 刷新
- (UIRefreshControl *)refreshControl{
    if (!_refreshControl) {
        
        //下拉刷新
        _refreshControl = [[UIRefreshControl alloc] init];
        //标题
        _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新..."];
        //事件
        [_refreshControl addTarget:self action:@selector(refreshDown) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}

- (void)refreshDown{
    //开始刷新
    [self.refreshControl beginRefreshing];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"加载中"];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timer) userInfo:nil repeats:NO];
}

- (void)timer{
    /**
     *  下拉刷新是不读缓存的 要添加 apiType 类型 RYLSJ_RequestTypeRefresh  每次就会重新请求url
     *  请求下来的缓存会覆盖原有的缓存文件
     */
    
    [self getDataWithApiType:RYLSJ_RequestTypeRefresh];
    
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新..."];
    
    /**
     * 上拉加载 要添加 apiType 类型 RYLSJ_RequestTypeLoadMore(读缓存)或RYLSJ_RequestTypeRefreshMore(重新请求)
     */
}

#pragma mark tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *iden=@"iden";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:iden];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    RYLSJ_RootModel *model=[self.dataArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text=model.name;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"更新时间:%@",model.detail];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RYLSJ_RootModel *model=[self.dataArray objectAtIndex:indexPath.row];
//    DetailViewController *detailsVC=[[DetailViewController alloc]init];
//
//    NSString *url=[NSString stringWithFormat:details_URL,model.wid];
//    detailsVC.urlString=url;
//    [self.navigationController pushViewController:detailsVC animated:YES];
    
}

//懒加载
- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.tableFooterView=[[UIView alloc]init];
    }
    
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (void)otherbtnClick{
//    otherMethodViewController *settingVC=[[otherMethodViewController alloc]init];
//    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)btnClick{
    
//    SettingViewController *settingVC=[[SettingViewController alloc]init];
//    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)viewDidLayoutSubviews{
    [self.refreshControl.superview sendSubviewToBack:self.refreshControl];
}
@end
