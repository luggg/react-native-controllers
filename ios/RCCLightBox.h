
#import <UIKit/UIKit.h>

@interface RCCLightBox : NSObject
+(UIWindow *)getWindow;
+(void)showWithParams:(NSDictionary*)params;
+(void)dismiss;
@end
