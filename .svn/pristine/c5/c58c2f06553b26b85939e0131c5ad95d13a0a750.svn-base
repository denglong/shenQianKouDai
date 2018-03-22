//
//  CaptureViewController.m
//  image
//
//  Created by lihualin on 14-11-28.
//  Copyright (c) 2014年 lihualin. All rights reserved.
//

#import "CaptureViewController.h"
#import "AGSimpleImageEditorView.h"
@interface CaptureViewController ()

@property (nonatomic ,retain) AGSimpleImageEditorView * editorView;

@end

@implementation CaptureViewController
@synthesize editorView ;
#pragma mark - init

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"编辑";
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.


     //保存按钮
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveButton)];

    self.navigationItem.rightBarButtonItem = doneItem;
    
    //image为上一个界面传过来的图片资源
    editorView = [[AGSimpleImageEditorView alloc] initWithImage:self.image];
    editorView.frame = CGRectMake(0, 0, self.view.frame.size.width,  self.image.size.width*self.view.frame.size.height/self.view.frame.size.width);
    editorView.center = self.view.center;
    //外边框的宽度及颜色
    editorView.borderWidth = 1.f;
    editorView.borderColor = [UIColor blackColor];
    
    //截取框的宽度及颜色
    editorView.ratioViewBorderWidth = 3.f;
    editorView.ratioViewBorderColor = [UIColor orangeColor];
    
    //截取比例，我这里按正方形1:1截取（可以写成 3./2. 16./9. 4./3.）
    editorView.ratio =1;
    
    [self.view addSubview:editorView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//完成截取
-(void)saveButton
{
    //output为截取后的图片，UIImage类型
    UIImage *resultImage = editorView.output;
    
    //通过代理回传给上一个界面显示
    [self.delegate passImage:resultImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)viewDidUnload
{
    [super viewDidUnload];
}

@end
