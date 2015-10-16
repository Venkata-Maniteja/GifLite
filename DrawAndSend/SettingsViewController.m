//
//  SettingsViewController.m
//  DrawAndSend
//
//  Created by Venkata Maniteja on 2015-10-15.
//  Copyright © 2015 Venkata Maniteja. All rights reserved.
//

#import "SettingsViewController.h"
#import "cvCell.h"

@interface SettingsViewController ()<UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
   
    IBOutlet UICollectionView *themecollectionView;
    
}

- (IBAction)doneAction:(id)sender;

-(IBAction)sliderAction:(id)sender;

@property (strong,nonatomic) IBOutlet UISlider *slider;

@property (strong,nonatomic) IBOutlet UILabel *sliderValueLabel;

@property (nonatomic, strong) NSArray *dataArray;

@property (assign) NSUInteger themeSelected;


@end

@implementation SettingsViewController

@synthesize slider,sliderValueLabel,themeSelected;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    themeSelected=100;
    
    NSMutableArray *firstSection = [[NSMutableArray alloc] init];
           [firstSection addObject:@"Black and White"];
    [firstSection addObject:@"Neon"];
    [firstSection addObject:@"Lovely Hearts"];
    
    self.dataArray = [[NSArray alloc] initWithObjects:firstSection, nil];
    
    [self->themecollectionView registerClass:[cvCell class] forCellWithReuseIdentifier:@"cvCell"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(300, 150)];
    [flowLayout setSectionInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    [self->themecollectionView setCollectionViewLayout:flowLayout];
    
//   self.delegate = self.navigationController.delegate;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
}

-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    //  [self.view setFrame:CGRectMake(100, 100, 100, 100)];
    
    
    
}

-(void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
   // [self.view setFrame:CGRectMake(100, 100, 100, 100)];
}

-(IBAction)sliderAction:(id)sender{
    
    sliderValueLabel.text = [NSString stringWithFormat:@"%d", (int)slider.value];
}

- (IBAction)doneAction:(id)sender {
    
    [self.delegate sliderValue:(int)slider.value];
    
    [self.delegate themeSelected:themeSelected];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark -Collection view delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.dataArray count];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSMutableArray *sectionArray = [self.dataArray objectAtIndex:section];
    return [sectionArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cvCell";
    
    cvCell *cell = (cvCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.borderColor=[[UIColor clearColor]CGColor];
    cell.layer.borderWidth=0.0;

    
    NSMutableArray *data = [self.dataArray objectAtIndex:indexPath.section];
    
    NSString *cellData = [data objectAtIndex:indexPath.row];
    
    [cell.titleLabel setText:cellData];
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    cvCell *cell = (cvCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    cell.layer.borderColor=[[UIColor colorWithRed:13/255.0 green:79/255.0 blue:139/255.0 alpha:1]CGColor];
    cell.layer.borderWidth=3.0;
    
    themeSelected=indexPath.row;
    
   // cell.backgroundColor = [UIColor magentaColor];
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    cvCell *cell = (cvCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderColor=[[UIColor clearColor]CGColor];
    cell.layer.borderWidth=0.0;
    cell.backgroundColor = [UIColor whiteColor];
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
