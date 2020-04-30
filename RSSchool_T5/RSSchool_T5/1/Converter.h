#import <Foundation/Foundation.h>

extern NSString *KeyPhoneNumber;
extern NSString *KeyCountry;

@interface PNConverter : NSObject
- (NSDictionary*)converToPhoneNumberNextString:(NSString*)string;
@end


