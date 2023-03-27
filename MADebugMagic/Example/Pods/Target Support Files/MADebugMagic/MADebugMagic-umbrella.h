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

#import "Action+MADebug.h"
#import "MADebugLogItem.h"
#import "MADebugLogManager.h"
#import "MADebugMagic.h"
#import "MADebugUtility.h"
#import "NSObject+MASwizzle.h"
#import "UIViewController+MADebug.h"

FOUNDATION_EXPORT double MADebugMagicVersionNumber;
FOUNDATION_EXPORT const unsigned char MADebugMagicVersionString[];

