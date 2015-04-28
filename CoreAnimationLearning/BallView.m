#import "BallView.h"

@implementation BallView {

}

- (id)initWithRadius:(int)radius {
    self = [super init];
    if (self) {
        [self setFrame:CGRectMake(0, 0, radius, radius)];
        self.layer.cornerRadius = radius/2;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 1;
    }
    return self;
}

@end