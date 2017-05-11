//
//  FEMAttribute+listsAttributes.h
//  Lists
//
//  Created by Alex Linkov on 5/5/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

#import <FastEasyMapping/FastEasyMapping.h>

@interface FEMAttribute (listsAttributes)

+ (FEMAttribute *)falconryIDAttribute;
+ (FEMAttribute *)dateAttributeWithProperty:(NSString *)property keyPath:(NSString *)keyPath;
+ (FEMAttribute *)bdayDateAttributeWithProperty:(NSString *)property keyPath:(NSString *)keyPath;

@end
