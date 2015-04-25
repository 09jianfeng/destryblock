//
//  CollectionViewControllerPlay.m
//  CoreAnimationLearning
//
//  Created by JFChen on 15/4/24.
//  Copyright (c) 2015年 JFChen. All rights reserved.
//

#import "CollectionViewControllerPlay.h"
#import <AVFoundation/AVFoundation.h>

@interface CollectionViewControllerPlay ()
@property(nonatomic, retain) AVAudioPlayer *audioplayerCorrect;
@property(nonatomic, retain) AVAudioPlayer *audioplayerError;
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
#pragma mark playaudio
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
