//
//
//  Bet2earnSwift
//
//  Created by Pratap Mondal on 08/07/18.
//  Copyright © 2017 Pratap Mondal. All rights reserved.
//

#import "NSBundle+Language.h"
#import <objc/runtime.h>

static const char associatedLanguageBundle=0;

@interface PrivateBundle : NSBundle
@end

@implementation PrivateBundle
-(NSString*)localizedStringForKey:(NSString *)key
                            value:(NSString *)value
                            table:(NSString *)tableName
{
    NSBundle* bundle=objc_getAssociatedObject(self, &associatedLanguageBundle);
    return bundle ? [bundle localizedStringForKey:key
                                            value:value
                                            table:tableName] : [super localizedStringForKey:key
                                                                                      value:value
                                                                                      table:tableName];
}
@end

@implementation NSBundle (Language)
+(void)setLanguage:(NSString*)language
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object_setClass([NSBundle mainBundle],[PrivateBundle class]);
    });
    
    objc_setAssociatedObject([NSBundle mainBundle], &associatedLanguageBundle, language ?
                             [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:language ofType:@"lproj"]] : nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
