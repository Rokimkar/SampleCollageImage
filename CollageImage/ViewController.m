//
//  ViewController.m
//  CollageImage
//
//  Created by S@nchit on 8/12/16.
//  Copyright © 2016 S@nchit. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageViewForCollage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [self makeCollageWithImages:[self getImageArray] forRect:self.imageViewForCollage.frame];
    self.imageViewForCollage.image = image;
    // Do any additional setup after loading the view, typically from a nib.
}

-(NSArray *)getImageArray{
    UIImage *lion = [UIImage imageNamed:@"lion.jpg"];
    UIImage *firstSwim = [UIImage imageNamed:@"First_Swim.png"];
    UIImage *bulls = [UIImage imageNamed:@"bulls.png"];
    UIImage *sharks = [UIImage imageNamed:@"sharks.png"];
    NSArray *imageArray = [NSArray arrayWithObjects:lion,firstSwim,bulls,sharks,nil];
    return imageArray;
}

-(UIImage *)makeCollageWithImages:(NSArray *)imageArray forRect:(CGRect )rect{
    CIImage *resultImage = [[CIImage alloc]init];
    NSInteger maxRow = 2;
    CGFloat maxSide = 0.0;
    maxSide = MAX(rect.size.width/maxRow, rect.size.height/maxRow);
    NSInteger index = 0;
    NSInteger currentRow = 1;
    CGFloat xTransform = 0.0;
    CGFloat yTransform = 0.0;
    CGRect smallRect = CGRectZero;
    for (UIImage *image in imageArray){
        NSInteger x = ++index % maxRow; //used to change the row when modulus is zero.
        if (x==0){
            smallRect = CGRectMake(xTransform, yTransform, maxSide, maxSide);
            ++currentRow;
            xTransform = 0.0;
            yTransform = (maxSide * (currentRow - 1));
        }else {
            
            //not a new row
            smallRect = CGRectMake(xTransform, yTransform, maxSide, maxSide);
            xTransform += maxSide;
        }
        CIImage *compositeImage = [[CIImage alloc]initWithImage:image];
        compositeImage = [compositeImage imageByApplyingTransform:CGAffineTransformMakeScale(maxSide / image.size.width, maxSide / image.size.height)];
        compositeImage = [compositeImage imageByApplyingTransform:CGAffineTransformMakeTranslation(smallRect.origin.x, smallRect.origin.y)];
        if (resultImage){
            resultImage = [compositeImage imageByCompositingOverImage:resultImage];
        }else{
            
        }
    }
    CGRect resultRect = CGRectMake(0, 0, 241, 241);
    UIImage *image = [UIImage imageWithCGImage:[[CIContext contextWithOptions:nil]createCGImage:resultImage fromRect:resultRect]];
    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
