//
//  RouteTimesView.m
//  BostonTMap
//
//  Created by Elliot Schrock on 5/22/15.
//
//

#import "RouteTimesView.h"
#import "Route.h"
#import "Prediction.h"
#import "UIImage+Colorize.h"
#import "GPUImage.h"

@interface RouteTimesView ()
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *prediction1Label;
@property (weak, nonatomic) IBOutlet UIImageView *prediction1ArrowImage;
@property (weak, nonatomic) IBOutlet UILabel *prediction2Label;
@property (weak, nonatomic) IBOutlet UIImageView *prediction2ArrowImage;

@end

static NSMutableDictionary *imageDictionary;

@implementation RouteTimesView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    [[NSBundle mainBundle] loadNibNamed:@"RouteTimesView" owner:self options:nil];
    [self addSubview:self.view];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_view)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_view)]];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self setCornerRadiusForView:self.nameLabel];
    [self setCornerRadiusForView:self.prediction1ArrowImage];
    [self setCornerRadiusForView:self.prediction2ArrowImage];
}

- (void)setCornerRadiusForView:(UIView *)view
{
    view.layer.cornerRadius = 6;
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor clearColor];
}

- (void)setPredictions:(NSArray *)predictions
{
    _predictions = predictions;
    [self setupPredictions];
}

- (void)setupPredictions
{
    self.prediction1ArrowImage.image = nil;
    self.prediction1Label.text = @"";
    self.prediction2ArrowImage.image = nil;
    self.prediction2Label.text = @"";
    self.nameLabel.alpha = 0;
    
    for (Prediction *prediction in self.predictions){
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"_%@_", prediction.route.routeName.uppercaseString]];
        [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(attributedText.length-1,1)];
        [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(0,1)];
        self.nameLabel.attributedText = attributedText;
        self.nameLabel.backgroundColor = prediction.route.color;
        self.nameLabel.alpha = 1;
        
        if ([prediction.directionId intValue] == 1) {
            self.prediction1ArrowImage.image = [self imageForRoute:prediction.route direction:prediction.directionId];
            
            self.prediction1Label.text = [NSString stringWithFormat:@"%im", prediction.predictionInSeconds / 60];
            [self.prediction1Label sizeToFit];
        }else if ([prediction.directionId intValue] == 0){
            self.prediction2ArrowImage.image = [self imageForRoute:prediction.route direction:prediction.directionId];
            
            self.prediction2Label.text = [NSString stringWithFormat:@"%im", prediction.predictionInSeconds / 60];
            [self.prediction2Label sizeToFit];
        }
    }
}

- (UIImage *)imageForRoute:(Route *)route direction:(NSNumber *)direction
{
    if (imageDictionary[route.color][direction]) {
        return imageDictionary[route.color][direction];
    }else{
        UIImage *image;
        if ([direction intValue] == 1) {
            image = [UIImage imageNamed:@"arrow_up_white"];
        }else if ([direction intValue] == 0){
            image = [UIImage imageNamed:@"arrow_down_white"];
        }
        
        GPUImageFalseColorFilter *filter = [[GPUImageFalseColorFilter alloc] init];
        filter.firstColor = [self vectorForRoute:route];
        filter.secondColor = (GPUVector4){1,1,1,1};
        UIImage *filteredImage = [filter imageByFilteringImage:image];
        
        NSMutableDictionary *colorDict = imageDictionary[route.color];
        if (!colorDict) colorDict = [[NSMutableDictionary alloc] init];
        colorDict[direction] = filteredImage;
        if (!imageDictionary) imageDictionary = [[NSMutableDictionary alloc] init];
        imageDictionary[route.color] = colorDict;
        return filteredImage;
    }
}

- (GPUVector4)vectorForRoute:(Route *)route
{
    if ([route isEqual:[Route braintree]] || [route isEqual:[Route ashmont]]) {
        return (GPUVector4){1,0,0,1};
    }else if ([route isEqual:[Route blue]]){
        return (GPUVector4){0,0,1,1};
    }else if ([route isEqual:[Route orange]]){
        return (GPUVector4){1,.5,0,1};
    }else if ([route isEqual:[Route greenB]] || [route isEqual:[Route greenC]] || [route isEqual:[Route greenD]] || [route isEqual:[Route greenE]]){
        return (GPUVector4){0,.8,0,1};
    }
    return (GPUVector4){0,0,0,0};
}

@end
