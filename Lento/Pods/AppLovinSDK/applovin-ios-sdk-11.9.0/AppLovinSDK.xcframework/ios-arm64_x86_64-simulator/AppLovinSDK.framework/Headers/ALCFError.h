//
//  ALCFError.h
//  AppLovinSDK
//
//  Created by Santosh Bagadi on 11/20/22.
//

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ALCFErrorCode)
{
    /**
     * Indicates that the flow ended in an unexpected state.
     */
    ALCFErrorCodeUnspecified = -1,
    
    /**
     * Indicates that the consent flow has not been integrated correctly.
     */
    ALCFErrorCodeInvalidIntegration = -100,
    
    /**
     * Indicates that the consent flow is already being shown.
     */
    ALCFErrorCodeFlowAlreadyInProgress = -200,
    
    /**
     * Indicates that the user is not in a GDPR region if the {@link AppLovinCFService#scf(Activity, AppLovinCFService.OnCFCompletionCallback)} is called for a non GDPR user.
     */
    ALCFErrorCodeNotInGDPRRegion = -300
};

@interface ALCFError : NSObject

/**
 * The error code for this error. Will be one of the codes listed under the @c ALCFErrorCode enum.
 */
@property (nonatomic, assign, readonly) ALCFErrorCode code;

/**
 * The error message for this error.
 */
@property (nonatomic, copy, readonly) NSString *message;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
