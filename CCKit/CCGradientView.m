//
//  CCGradientView.m
//  CCKit
//
//  Created by Glenn Marcus on 10/5/14.
//
//

#import "CCGradientView.h"

#import <QuartzCore/QuartzCore.h>

@interface CCGradientView ()
@property (nonatomic, readonly, strong) CAGradientLayer *layer;
@end

@implementation CCGradientView

#pragma mark NSObject

+ (Class)layerClass
{
    return [CAGradientLayer class];
}


- (id)initWithFrame:(CGRect)frame
{
    if( self = [super initWithFrame:frame] )
    {
        // Initialization code
    }
    return self;
}


- (void)setColors:(NSArray*)newColors
{
    NSMutableArray *normalizedColors = [[NSMutableArray alloc] initWithCapacity:newColors.count];
    
    for( id color in newColors )
    {
        if( [color isKindOfClass:[UIColor class]] )
        {
            [normalizedColors addObject:(id)[(UIColor*)color CGColor]];
        }
        else
        {
            [normalizedColors addObject:color];
        }
    }
    
    self.layer.colors = normalizedColors;
}


- (NSArray*)colors
{
    NSMutableArray *uiColors = [[NSMutableArray alloc] initWithCapacity:self.layer.colors.count];
    
    for( id cgColor in self.layer.colors ){
        [uiColors addObject:[UIColor colorWithCGColor:(CGColorRef)cgColor]];
    }
    
    NSArray *colors = [NSArray arrayWithArray:uiColors];
    
    return colors;
}


- (void)setLocations:(NSArray*)locations
{
    self.layer.locations = locations;
}


- (NSArray*)locations
{
    return self.layer.locations;
}


- (void)setStartPoint:(CGPoint)point
{
    self.layer.startPoint = point;
}


- (CGPoint)startPoint
{
    return self.layer.startPoint;
}


- (void)setEndPoint:(CGPoint)point
{
    self.layer.endPoint = point;
}


- (CGPoint)endPoint
{
    return self.layer.endPoint;
}


- (void)setCornerRadius:(CGFloat)radius
{
    self.layer.cornerRadius = radius;
}


- (CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}


- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}


- (CGFloat)borderWidth
{
    return self.layer.borderWidth;
}


- (void)setBorderColor:(UIColor*)color
{
    self.layer.borderColor = color.CGColor;
}


- (UIColor*)borderColor
{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}


- (void)setType:(NSString*)type
{
    self.layer.type = type;
}


- (NSString*)type
{
    return self.layer.type;
}



@end
