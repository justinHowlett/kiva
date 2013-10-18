//
//  MIT License
//
//  Copyright (c) 2012 Bob McCune http://bobmccune.com/
//  Copyright (c) 2012 TapHarmonic, LLC http://tapharmonic.com
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>

#define IMG(name) [UIImage imageNamed:name]
#define FACE_IMAGES [NSArray arrayWithObjects:IMG(@"group.jpg"),IMG(@"face.jpg"),IMG(@"face.png"), IMG(@"ali"), IMG(@"ayn"), IMG(@"kennedy"), IMG(@"hoff"), nil]

#define IMG_WIDTH 280.0f
#define IMG_HEIGHT 310.0f


@interface MainViewController ()

@property (nonatomic, strong) UIImageView *activeImageView;
@property (nonatomic, assign) BOOL useHighAccuracy;
@property (nonatomic, assign) NSUInteger currentIndex;

- (void)drawImageAnnotatedWithFeatures:(NSArray *)features;
- (void)drawFeatureInContext:(CGContextRef)context atPoint:(CGPoint)featurePoint;

@end


@implementation MainViewController

@synthesize scrollView = _scrollView;
@synthesize activityView = _activityView;
@synthesize detectingView = _detectingView;
@synthesize useHighAccuracy = _useHighAccuracy;
@synthesize activeImageView = _activeImageView;
@synthesize currentIndex = _currentIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.detectingView.hidden = YES;
    self.detectingView.layer.cornerRadius = 8.0f;
	
	CGFloat currentX = 0.0f;
	CGRect viewRect = CGRectMake(currentX, 0, IMG_WIDTH, IMG_HEIGHT);
	self.scrollView.contentSize = CGSizeMake(viewRect.size.width * [FACE_IMAGES count], viewRect.size.height);
	
	for (UIImage *image in FACE_IMAGES) {
		UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
		imageView.frame = CGRectMake(currentX, 0.0f, IMG_WIDTH, IMG_HEIGHT);
		[self.scrollView addSubview:imageView];
		currentX += IMG_WIDTH;
		if (!self.activeImageView) {
			self.activeImageView = imageView;
		}
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	self.currentIndex = scrollView.contentOffset.x / IMG_WIDTH;
	self.activeImageView = [[scrollView subviews] objectAtIndex:self.currentIndex];
}

- (IBAction)resetImage {
    self.activeImageView.image = [FACE_IMAGES objectAtIndex:self.currentIndex];
}

- (IBAction)useHighAccuracy:(id)sender {
    self.useHighAccuracy = [sender isOn];
}

- (IBAction)detectFacialFeatures:(id)sender {

    self.detectingView.hidden = NO;
	self.scrollView.scrollEnabled = NO;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSLog(@"face detect start");

        CIImage *image = [[CIImage alloc] initWithImage:[FACE_IMAGES objectAtIndex:self.currentIndex]];

        NSString *accuracy = self.useHighAccuracy ? CIDetectorAccuracyHigh : CIDetectorAccuracyLow;
        NSDictionary *options = [NSDictionary dictionaryWithObject:accuracy forKey:CIDetectorAccuracy];
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:options];

        NSArray *features = [detector featuresInImage:image];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self drawImageAnnotatedWithFeatures:features];
        });
        
        NSLog(@"face detect complete");

    });
}

- (void)drawImageAnnotatedWithFeatures:(NSArray *)features {
    
    NSLog(@"start face");

	UIImage *faceImage = [FACE_IMAGES objectAtIndex:self.currentIndex];
    UIGraphicsBeginImageContextWithOptions(faceImage.size, YES, 0);
    [faceImage drawInRect:self.activeImageView.bounds];

    // Get image context reference
    CGContextRef context = UIGraphicsGetCurrentContext();

    // Flip Context
    CGContextTranslateCTM(context, 0, self.activeImageView.bounds.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);

    CGFloat scale = [UIScreen mainScreen].scale;

    if (scale > 1.0) {
        // Loaded 2x image, scale context to 50%
        CGContextScaleCTM(context, 0.5, 0.5);
    }

    for (CIFaceFeature *feature in features) {
        
        CGContextSetLineWidth(context, 1.0);
        
        CGContextAddRect(context, feature.bounds);
        CGContextDrawPath(context, kCGPathStroke);
    }

    self.activeImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    self.detectingView.hidden = YES;
	self.scrollView.scrollEnabled = YES;
}

//- (void)drawFeatureInContext:(CGContextRef)context atPoint:(CGPoint)featurePoint {
//    CGFloat radius = 20.0f * [UIScreen mainScreen].scale;
//    CGContextAddArc(context, featurePoint.x, featurePoint.y, radius, 0, M_PI * 2, 1);
//    CGContextDrawPath(context, kCGPathFillStroke);
//}

@end
