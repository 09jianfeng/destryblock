//
//  CollectionViewControllerPlay.m
//  CoreAnimationLearning
//
//  Created by JFChen on 15/4/24.
//  Copyright (c) 2015年 JFChen. All rights reserved.
//

#import "CollectionViewControllerPlay.h"
#import <AVFoundation/AVFoundation.h>
#import "GameAlgorithm.h"

@interface CollectionViewControllerPlay ()
@property(nonatomic, retain) AVAudioPlayer *audioplayerCorrect;
@property(nonatomic, retain) AVAudioPlayer *audioplayerError;
@property(nonatomic, retain) GameAlgorithm *gameAlgorithm;
@end

@implementation CollectionViewControllerPlay

const float widthNum = 19.0;
static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.delegate = self;
    self.collectionView.scrollEnabled = NO;
    // Do any additional setup after loading the view.
    
    CGFloat width = self.view.frame.size.width/widthNum;
    int heightnum = self.view.frame.size.height/width + 1;
    self.gameAlgorithm = [[GameAlgorithm alloc] initWithWidthNum:widthNum heightNum:heightnum];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.collectionView.backgroundColor = [UIColor grayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark logic
-(void)playAudioIsCorrect:(BOOL)isCorrect{
    
    NSString *stringCottect = @"";
    if (isCorrect) {
        stringCottect = @"correct.mp3";
    }else{
        stringCottect = @"error.mp3";
    }
    //1.音频文件的url路径
    NSURL *url=[[NSBundle mainBundle]URLForResource:stringCottect withExtension:Nil];
    //2.创建播放器（注意：一个AVAudioPlayer只能播放一个url）
    self.audioplayerCorrect=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:Nil];
    //3.缓冲
    [self.audioplayerCorrect prepareToPlay];
    [self.audioplayerCorrect play];
}

-(int)numberOfblock{
    CGFloat width = self.view.frame.size.width/widthNum;
    int heightnum = self.view.frame.size.height/width + 1;
    return heightnum*widthNum;
}

-(UIColor *)getColorInColorType:(blockcolor)blockcolorType{
    switch (blockcolorType) {
        case blockcolornone:
            return nil;
            break;
        case blockcolor1:
            return [UIColor colorWithRed:0.83 green:0.92 blue:0.91 alpha:1.0];
            break;
        case blockcolor2:
            return [UIColor colorWithRed:0.89 green:0.82 blue:0.71 alpha:1.0];
            break;
        case blockcolor3:
            return [UIColor colorWithRed:0.80 green:0.82 blue:0.96 alpha:1.0];
            break;
        case blockcolor4:
            return [UIColor colorWithRed:0.88 green:0.79 blue:0.71 alpha:1.0];
            break;
        
        case blockcolor5:
            return [UIColor colorWithRed:0.78 green:0.82 blue:0.61 alpha:1.0];
            break;
        case blockcolor6:
            return [UIColor colorWithRed:0.94 green:0.72 blue:0.72 alpha:1.0];
            break;
        case blockcolor7:
            return [UIColor colorWithRed:0.93 green:0.62 blue:0.81 alpha:1.0];
            break;
        case blockcolor8:
            return [UIColor colorWithRed:0.73 green:0.92 blue:0.91 alpha:1.0];
            break;
        case blockcolor9:
            return [UIColor colorWithRed:0.63 green:0.82 blue:0.91 alpha:1.0];
            break;
        case blockcolor10:
            return [UIColor colorWithRed:0.83 green:0.52 blue:0.91 alpha:1.0];
            break;

        default:
            return nil;
            break;
    }
    return nil;
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self numberOfblock];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    // Configure the cell
    if (!cell) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    if (indexPath.row%2) {
        UIImage *imageBlack = [UIImage imageNamed:@"backgroundwhite.png"];
        cell.layer.contents = (__bridge id)(imageBlack.CGImage);
    }else{
        UIImage *imageBlack = [UIImage imageNamed:@"background.png"];
        cell.layer.contents = (__bridge id)(imageBlack.CGImage);
    }
    
    cell.layer.borderColor = [UIColor blackColor].CGColor;
    UILabel *label = (UILabel *)[cell viewWithTag:1001];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:cell.bounds];
        [cell addSubview:label];
        label.tag = 1001;
    }
    
    int colorType = [self.gameAlgorithm getColorInthisPlace:(int)indexPath.row];
    UIColor *color = [self getColorInColorType:colorType];
    label.backgroundColor = color;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = self.view.frame.size.width/widthNum;
    return CGSizeMake(width, width);
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//cell被选择时被调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    [UIView animateWithDuration:0.3 animations:^{
        cell.alpha = 0.5;
    } completion:^(BOOL finish){
        cell.alpha = 1;
    }];
    [self playAudioIsCorrect:YES];
}

//cell反选时被调用(多选时才生效)
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
}
@end
