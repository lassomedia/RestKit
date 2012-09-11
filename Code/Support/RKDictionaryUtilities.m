//
//  RKDictionaryUtilities.m
//  RestKit
//
//  Created by Blake Watters on 9/11/12.
//  Copyright (c) 2012 RestKit. All rights reserved.
//

#import "RKDictionaryUtilities.h"

NSDictionary * RKDictionaryByReverseMergingDictionaryWithDictionary(NSDictionary *dictionary, NSDictionary *anotherDictionary)
{
    NSMutableDictionary *mergedDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([mergedDictionary objectForKey:key] && [obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *newVal = RKDictionaryByReverseMergingDictionaryWithDictionary([mergedDictionary objectForKey:key], obj);
            [mergedDictionary setObject:newVal forKey:key];
        } else {
            [mergedDictionary setObject:obj forKey:key];
        }
    }];
    
    return mergedDictionary;
}

NSDictionary * RKDictionaryByReplacingPercentEscapesInEntriesFromDictionary(NSDictionary *dictionary)
{
    NSMutableDictionary *results = [NSMutableDictionary dictionaryWithCapacity:[dictionary count]];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop)
     {
         NSString *escapedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
         id escapedValue = value;
         if ([value respondsToSelector:@selector(stringByReplacingPercentEscapesUsingEncoding:)])
             escapedValue = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
         [results setObject:escapedValue forKey:escapedKey];
     }];
    return results;
}
