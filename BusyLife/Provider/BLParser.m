//
//  LibParser.m
//  XPathParse
//
//  Created by chuan li on 10/19/10.
//  Copyright 2010 USTC. All rights reserved.
//

#import "BLParser.h"
#import <objc/runtime.h>

typedef void (*charSetter_t)(id, SEL, char);
typedef void (*intSetter_t)(id, SEL, int);
typedef void (*shortSetter_t)(id, SEL, short);
typedef void (*longSetter_t)(id, SEL, long);
typedef void (*longlongSetter_t)(id, SEL, long long);
typedef void (*ucharSetter_t)(id, SEL, unsigned char);
typedef void (*uintSetter_t)(id, SEL, unsigned int);
typedef void (*ushortSetter_t)(id, SEL, unsigned short);
typedef void (*ulongSetter_t)(id, SEL, unsigned long);
typedef void (*ulonglongSetter_t)(id, SEL, unsigned long long);
typedef void (*floatSetter_t)(id, SEL, float);
typedef void (*doubleSetter_t)(id, SEL, double);
typedef void (*cstringSetter_t)(id, SEL, char*);
typedef void (*objectSetter_t)(id, SEL, id);

@interface BLParser()

- (NSDictionary *)_dictForAttribute:(Class)cls;
- (NSString *)_upperFirstChar:(NSString *)name;

@end


@implementation BLParser

- (id)parseDict:(NSDictionary *)dict toClass:(Class)clazz{
	id object = [clazz new];
	
	NSDictionary* typeDict = [self _dictForAttribute:clazz];
	for (NSString* key in [dict allKeys]){
		NSString* attrType  = [typeDict objectForKey:key];
		NSString* selectorDesp = [NSString stringWithFormat:@"set%@:", [self _upperFirstChar:key]];
		SEL selector = NSSelectorFromString(selectorDesp);
		IMP imp = [object methodForSelector:selector];
		
		unichar type = [attrType characterAtIndex:1];
		
		switch (type){
			case 'i':{
                int value = [[dict objectForKey:key] intValue];
				intSetter_t setter = (intSetter_t)imp;
				setter(object, selector, value);
			}
				break;
            case 'd': {
                double value = [[dict objectForKey:key] doubleValue];
                doubleSetter_t setter = (doubleSetter_t)imp;
                setter(object, selector, value);
            }
                break;
			case '@':{
				NSArray* typeArray = [attrType componentsSeparatedByString:@"\""];
				NSString* detailType = [typeArray objectAtIndex:1];
				if ( [detailType isEqualToString:@"NSString"] ){
					objectSetter_t setter = (objectSetter_t)imp;
                    setter(object, selector, [dict objectForKey:key]);
				}
                else if ( [detailType isEqualToString:@"NSDate"]) {
                    NSTimeInterval interval = (NSTimeInterval)[[dict objectForKey:key] doubleValue];
                    NSDate* value = [NSDate dateWithTimeIntervalSince1970:interval];
                    objectSetter_t setter = (objectSetter_t)imp;
                    setter(object, selector, value);
                }
				else if ( [detailType isEqualToString:@"NSArray"] ){
					NSMutableArray* eleArray = [NSMutableArray new];
                    NSArray* valueArray = [dict objectForKey:key];
					for (int i = 0; i < [valueArray count]; ++i){
						id arrayElem = [self parseDict:[valueArray objectAtIndex:i] toClass:NSClassFromString(@"BLAttender")];
                        if (arrayElem) {
                            [eleArray addObject:arrayElem];
                        }
					}
					objectSetter_t setter = (objectSetter_t)imp;
					setter(object, selector, eleArray);
				}
			}
				break;
			default:
				break;
		}
	}
    return object;
}

#pragma mark - Private
- (NSString *)_upperFirstChar:(NSString *)className{
    unichar ch = [className characterAtIndex:0];
    if ( ch >= 'a' && ch <= 'z'){
        ch += 'A' - 'a';
    }
    
    NSMutableString* mString = [[NSMutableString alloc] initWithCharacters:&ch length:1];
    [mString appendString:[className substringFromIndex:1]];
    return mString;
}

- (NSDictionary *)_dictForAttribute:(Class)cls{
    unsigned int count;
    objc_property_t* properties = class_copyPropertyList(cls, &count);
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    for (int i = 0; i < count; ++i){
        NSString* attrName = [NSString stringWithUTF8String:property_getName( *(properties+i) )];
        NSString* attrType = [NSString stringWithUTF8String:property_getAttributes( *(properties+i) )];
        [dict setObject:attrType forKey:attrName];
    }
    return dict;
}

@end
