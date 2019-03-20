#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "AFHttpAPIClient.h"
#import "LYKHttpBaseModel.h"
#import "LYKHttpManger.h"

FOUNDATION_EXPORT double LYKHttpMangerVersionNumber;
FOUNDATION_EXPORT const unsigned char LYKHttpMangerVersionString[];

