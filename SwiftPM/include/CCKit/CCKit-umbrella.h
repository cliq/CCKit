//
//  CCKit-umbrella.h
//  CCKit
//
//  Swift Package Manager umbrella header. Mirrors the umbrella CocoaPods
//  generates from CCKit.podspec so `#import <CCKit/...>` and `@import CCKit`
//  expose the same API under both integrations.
//

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#endif

#import "CCCollectionFooterCell.h"
#import "CCCollectionHeaderCell.h"
#import "CCCollectionViewCell.h"
#import "CCCollectionViewDropShadowFlowLayout.h"
#import "CCCollectionViewFlowLayoutAligned.h"
#import "CCCollectionViewPagedLayout.h"
#import "CCDefines.h"
#import "CCDevice.h"
#import "CCDropShadowDecorationView.h"
#import "CCGradientView.h"
#import "CCGroupModel.h"
#import "CCHTTPModel.h"
#import "CCHTTPModelJSONResponse.h"
#import "CCHTTPModelResponse.h"
#import "CCInsetLabel.h"
#import "CCKit.h"
#import "CCLoadingController.h"
#import "CCModel.h"
#import "CCModelDelegate.h"
#import "CCModelTableViewController.h"
#import "CCModelViewController.h"
#import "CCRequestModel.h"
#import "CCTableRow.h"
#import "CCTableSection.h"
#import "CCZipper.h"
