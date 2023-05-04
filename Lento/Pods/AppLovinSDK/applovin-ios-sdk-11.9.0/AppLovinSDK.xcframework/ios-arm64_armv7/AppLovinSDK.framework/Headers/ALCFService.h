//
//  ALUserService.h
//  AppLovinSDK
//
//  Created by Santosh Bagadi on 6/1/22.
//

@class ALCFError;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ALCFType)
{
    /**
     * The flow type is not known.
     */
    ALCFTypeUnknown,
    
    /**
     * A standard flow where a TOS/PP alert is shown.
     */
    ALCFTypeStandard,
    
    /**
     * A detailed modal shown to users in GDPR region.
     */
    ALCFTypeDetailed
};

@interface ALCFService : NSObject

/**
 * @return The consent flow type that will be displayed.
 */
@property (nonatomic, assign, readonly) ALCFType cfType;

/**
 * Called when we finish showing the consent flow.
 */
typedef void (^ALCFCompletionHandler) (ALCFError *__nullable error);

/**
 * Starts the consent flow and notifys the completion handler when the flow has been completed.
 *
 * Note: The flow will only be shown to users in GDPR region.
 */
- (void)scfWithCompletionHander:(ALCFCompletionHandler)completionHandler;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
