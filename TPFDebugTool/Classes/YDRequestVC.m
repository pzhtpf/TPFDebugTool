//
//  YDRequestVC.m
//  Pods
//
//  Created by Roc.Tian on 2017/3/16.
//
//

#import "YDRequestVC.h"
#import "YDRequestCell.h"
#import "JxbDebugTool.h"
#import "YDNameValueModel.h"

@interface YDRequestVC ()<UITableViewDelegate,UITableViewDataSource>

@property (unsafe_unretained, nonatomic) IBOutlet UISegmentedControl *segment;
- (IBAction)segmentValueChanged:(id)sender;
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YDRequestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}
-(void)initView{

    NSBundle *bundle = [NSBundle bundleForClass:[YDRequestVC class]];
    NSURL *bundleURL = [bundle URLForResource:@"AtourlifeFoundationDebugTool" withExtension:@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithURL: bundleURL];
    [self.tableView registerNib:[UINib nibWithNibName:@"YDRequestCell" bundle:resourceBundle] forCellReuseIdentifier:@"YDRequestCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.segment setTintColor:[JxbDebugTool shareInstance].mainColor];
    
    [self setIsHeader:_isHeader];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark private method
-(void)handleFormData{

    _formData = [self getParams:self.content];
}
-(NSMutableArray *)getParams:(NSString *)parameterString{
    
    NSMutableArray *params = [NSMutableArray new];
    NSArray *parameterArray = [parameterString componentsSeparatedByString:@"&"];
    for (NSString *parameter in parameterArray) {
        NSArray *tempArray = [parameter componentsSeparatedByString:@"="];
        if(tempArray.count==2){
            
            YDNameValueModel *model = [YDNameValueModel new];
            model.name = tempArray[0];
            model.value = tempArray[1];
            [params addObject:model];
        }
    }
    return params;
}
-(NSMutableArray *)dictionaryToArray:(NSDictionary *)dictionary{
    
    NSMutableArray *params = [NSMutableArray new];
    NSArray *allKeys = [dictionary allKeys];
    for (NSString *key in allKeys) {
      
        YDNameValueModel *model = [YDNameValueModel new];
        model.name = key;
        model.value = [dictionary valueForKey:key];
        [params addObject:model];
     
    }
    return params;
}
#pragma mark setter
-(void)setContent:(NSString *)content{

    _content = content;
    [self.tableView reloadData];
}
-(void)setIsHeader:(BOOL)isHeader{

    _isHeader = isHeader;
    
    if(_isHeader){
    
    
        [self.segment setTitle:@"Request Header" forSegmentAtIndex:0];
        [self.segment setTitle:@"Response Header" forSegmentAtIndex:1];
    }
}
#pragma mark action
- (IBAction)segmentValueChanged:(id)sender {
    
    [self.tableView reloadData];
}
#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if(self.segment.selectedSegmentIndex==0)
        return self.formData.count;
    else
        return self.cookiesData.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    YDNameValueModel *temp;
    if(self.segment.selectedSegmentIndex==0)
        temp = self.formData[indexPath.row];
    else
        temp = self.cookiesData[indexPath.row];
    
    return temp.height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    YDRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDRequestCell"];
    
    YDNameValueModel *temp;
    if(self.segment.selectedSegmentIndex==0)
        temp = self.formData[indexPath.row];
    else
        temp = self.cookiesData[indexPath.row];
    
    cell.nameLabel.text = temp.name;
    cell.valueLabel.text = temp.value;
    cell.height = temp.height;
    
    if(indexPath.row%2==0)
        cell.contentView.backgroundColor = [UIColor whiteColor];
    else
        cell.contentView.backgroundColor = kColorWithRGB(0xf5f5f5);
    
    return cell;
}
#pragma mark getter
-(NSMutableArray *)formData{

    if(!_formData){
    
        if(!_isHeader)
         [self handleFormData];
        else
          _formData = [self dictionaryToArray:_model.requestAllHTTPHeaderFields];
         
    }
    return _formData;
}
-(NSMutableArray *)cookiesData{
    
    if(!_cookiesData){
        
        if(!_isHeader)
            _cookiesData = [self.model.cookies mutableCopy];
        else
            _cookiesData = [self dictionaryToArray:_model.responseAllHTTPHeaderFields];

    }
    return _cookiesData;
}
@end
