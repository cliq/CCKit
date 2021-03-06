//
//  CCGradientView.h
//  CCKit
//
//  Created by Glenn Marcus on 10/5/14.
//
//

#import <UIKit/UIKit.h>

@interface CCGradientView : UIView
// CAGradientLayer requires you to pass only CGColorRefs.
// However CZGradientView will covert the UIColors to CGColorRefs for you, and will pass back UIColors
@property (copy) NSArray *colors;


/* An optional array of NSNumber objects defining the location of each
 * gradient stop as a value in the range [0,1]. The values must be
 * monotonically increasing. If a nil array is given, the stops are
 * assumed to spread uniformly across the [0,1] range. When rendered,
 * the colors are mapped to the output colorspace before being
 * interpolated. Defaults to nil. Animatable. */
@property (copy) NSArray *locations;


/* The start and end points of the gradient when drawn into the layer's
 * coordinate space. The start point corresponds to the first gradient
 * stop, the end point to the last gradient stop. Both points are
 * defined in a unit coordinate space that is then mapped to the
 * layer's bounds rectangle when drawn. (i.e. [0,0] is the bottom-left
 * corner of the layer, [1,1] is the top-right corner.) The default values
 * are [.5,0] and [.5,1] respectively. Both are animatable. */
@property CGPoint startPoint, endPoint;


/* When positive, the background of the layer will be drawn with
 * rounded corners. Also effects the mask generated by the
 * `masksToBounds' property. Defaults to zero. Animatable. */
@property CGFloat cornerRadius;


/* The width of the layer's border, inset from the layer bounds. The
 * border is composited above the layer's content and sublayers and
 * includes the effects of the `cornerRadius' property. Defaults to
 * zero. Animatable. */
@property CGFloat borderWidth;


/* The color of the layer's border. Defaults to opaque black. Colors
 * created from tiled patterns are supported. Animatable. */
@property (copy) UIColor *borderColor;


/* The kind of gradient that will be drawn. Currently the only allowed
 * value is `kCAGradientLayerAxial' (the default value.). */
@property (copy) NSString *type;

@end
