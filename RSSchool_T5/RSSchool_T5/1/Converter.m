#import "Converter.h"

// Do not change
NSString *KeyPhoneNumber = @"phoneNumber";  
NSString *KeyCountry = @"country";

@implementation PNConverter
- (NSDictionary*)converToPhoneNumberNextString:(NSString*)string {
    NSDictionary* countryCodesDictionary = @{@"RU": @"7", @"KZ": @"77",
                                             @"MD": @"373", @"AM": @"374",
                                             @"BY": @"375", @"UA": @"380",
                                             @"TJ": @"992", @"TM": @"993",
                                             @"AZ": @"994", @"KG": @"996",
                                             @"UZ": @"998"};
    NSMutableString* phoneNumberString = [string mutableCopy];
    NSString* numString = @"0123456789";
    NSCharacterSet* charSet = [NSCharacterSet characterSetWithCharactersInString:numString];
    for (NSInteger i = 0; i < [phoneNumberString length]; i++) {
        if (![charSet characterIsMember:[phoneNumberString characterAtIndex:i]]) {
            [phoneNumberString deleteCharactersInRange:NSMakeRange(i, 1)];
            i = 0;
        }
    }
    NSMutableString* formattedNumberString = [@"+" mutableCopy];
    if (![[self findCountryCodeInString:string]  isEqual: @""]) {
        if ([[self findCountryCodeInString:string]  isEqual: @"KZ"]) {
            [phoneNumberString deleteCharactersInRange:NSMakeRange(0, [[countryCodesDictionary objectForKey: [self findCountryCodeInString:string]] length]-1)];
            [formattedNumberString appendString:[countryCodesDictionary objectForKey: [self findCountryCodeInString:string]]];
            [formattedNumberString deleteCharactersInRange:NSMakeRange([formattedNumberString length]-1, 1)];
        } else {
            [phoneNumberString deleteCharactersInRange:NSMakeRange(0, [[countryCodesDictionary objectForKey: [self findCountryCodeInString:string]] length])];
            [formattedNumberString appendString:[countryCodesDictionary objectForKey: [self findCountryCodeInString:string]]];
        }
        
        NSInteger providerCodeLength = 0;
        
        if([formattedNumberString length] == 4) {
            providerCodeLength = 2;
        } else if ([formattedNumberString length] == 2) {
            providerCodeLength = 3;
        } else if ([formattedNumberString length] == 3) {
            providerCodeLength = 3;
        }
        
        if ([phoneNumberString length] > 0) {
            [formattedNumberString appendString: [self findProviderCodeInString:phoneNumberString withCodeLength:providerCodeLength]];
        }
        for (NSInteger i = 0; i < [phoneNumberString length]; i++) {
            NSRange range = NSMakeRange(i, 1);
            if (i >= 12) {
                [phoneNumberString deleteCharactersInRange:range];
                i = 0;
            }
        }
        
        if ([[self findCountryCodeInString:string] isEqual:@"BY"] || [[self findCountryCodeInString:string] isEqual:@"RU"] || [[self findCountryCodeInString:string] isEqual:@"TJ"] || [[self findCountryCodeInString:string] isEqual:@"AZ"] || [[self findCountryCodeInString:string] isEqual:@"KG"] || [[self findCountryCodeInString:string] isEqual:@"UZ"] || [[self findCountryCodeInString:string] isEqual:@"UA"] || [[self findCountryCodeInString:string] isEqual:@"KZ"]) {
            for (NSInteger i = 0; i < [phoneNumberString length]; i++) {
                if (i > 6) {
                    [phoneNumberString deleteCharactersInRange:NSMakeRange(i, 1)];
                    i = 0;
                }
            }
            
            for (NSInteger i = 0; i < [phoneNumberString length]; i++) {
                if(i == 3 || i == 5) {
                    [formattedNumberString appendString:@"-"];
                }
                [formattedNumberString appendString:[NSString stringWithFormat:@"%c", [phoneNumberString characterAtIndex:i]]];
            }
            
        } else if ([[self findCountryCodeInString:string] isEqual:@"MD"] || [[self findCountryCodeInString:string] isEqual:@"TM"] || [[self findCountryCodeInString:string] isEqual:@"AM"]) {
            for (NSInteger i = 0; i < [phoneNumberString length]; i++) {
                if (i > 5) {
                    [phoneNumberString deleteCharactersInRange:NSMakeRange(i, 1)];
                    i = 0;
                }
            }
            
            for (NSInteger i = 0; i < [phoneNumberString length]; i++) {
                if(i == 3) {
                    [formattedNumberString appendString:@"-"];
                }
                [formattedNumberString appendString:[NSString stringWithFormat:@"%c", [phoneNumberString characterAtIndex:i]]];
            }
        }
    } else {
        for (NSInteger i = 0; i < [phoneNumberString length]; i++) {
            NSRange range = NSMakeRange(i, 1);
            if (i >= 12) {
                [phoneNumberString deleteCharactersInRange:range];
                i = 0;
            }
        }
        
        [formattedNumberString appendString:phoneNumberString];
    }
    return @{KeyPhoneNumber: formattedNumberString,
             KeyCountry: [self findCountryCodeInString:string]};
}

-(NSString*)findCountryCodeInString:(NSString*)string {
    NSDictionary* countryCodesDictionary = @{@"7": @"RU", @"77": @"KZ",
                                             @"373": @"MD", @"374": @"AM",
                                             @"375": @"BY", @"380": @"UA",
                                             @"992": @"TJ", @"993": @"TM",
                                             @"994": @"AZ", @"996": @"KG",
                                             @"998": @"UZ"};
    if ([string length] == 1) {
        NSRange range = NSMakeRange(0, 1);
        NSMutableString* tempString = [[string substringWithRange:range] mutableCopy];
        if ([countryCodesDictionary valueForKey:tempString]){
            return [countryCodesDictionary valueForKey:tempString];
        }
    } else if ([string length] == 2) {
        NSRange range = NSMakeRange(0, 2);
        NSMutableString* tempString = [[string substringWithRange:range] mutableCopy];
        if ([countryCodesDictionary valueForKey:tempString]){
            return [countryCodesDictionary valueForKey:tempString];
        } else {
            NSRange range = NSMakeRange(0, 1);
            NSMutableString* tempString = [[string substringWithRange:range] mutableCopy];
            if ([countryCodesDictionary valueForKey:tempString]){
                return [countryCodesDictionary valueForKey:tempString];
            }
        }
    } else if ([string length] >= 3) {
        NSRange range = NSMakeRange(0, 3);
        NSMutableString* tempString = [[string substringWithRange:range] mutableCopy];
        for (NSInteger i = 3; i > 0; i--) {
            if ([countryCodesDictionary valueForKey:tempString]){
                return [countryCodesDictionary valueForKey:tempString];
            } else {
                [tempString deleteCharactersInRange:NSMakeRange([tempString length]-1, 1)];
            }
        }
    }
    return @"";
}

-(NSString* )findProviderCodeInString:(NSMutableString*)string withCodeLength:(NSInteger)length {
    NSMutableString* provideCodeString = [NSMutableString new];
    if ([string length] == 1) {
        NSRange rangeOfCode = NSMakeRange(0, 1);
        NSString* codeNumString = [string substringWithRange:rangeOfCode];
        [provideCodeString appendString:[NSString stringWithFormat:@" (%d", [codeNumString intValue]]];
        [string deleteCharactersInRange:rangeOfCode];
        return provideCodeString;
    }
    if ([string length] > length) {
        NSRange rangeOfCode = NSMakeRange(0, length);
        NSString* codeNumString = [string substringWithRange:rangeOfCode];
        [provideCodeString appendString:[NSString stringWithFormat:@" (%d) ", [codeNumString intValue]]];
        [string deleteCharactersInRange:rangeOfCode];
        return provideCodeString;
        
    } else if ([string length] == length) {
        NSRange rangeOfCode = NSMakeRange(0, length - 1);
        NSString* codeNumString = [string substringWithRange:rangeOfCode];
        [provideCodeString appendString:[NSString stringWithFormat:@" (%d", [codeNumString intValue]]];
        [string deleteCharactersInRange:rangeOfCode];
        return provideCodeString;
        
    } else if ([string length] < length) {
        NSRange rangeOfCode = NSMakeRange(0, length - 1);
        NSString* codeNumString = [string substringWithRange:rangeOfCode];
        [provideCodeString appendString:[NSString stringWithFormat:@" (%d", [codeNumString intValue]]];
        [string deleteCharactersInRange:rangeOfCode];
        return provideCodeString;
    }
    return @"";
}
@end
