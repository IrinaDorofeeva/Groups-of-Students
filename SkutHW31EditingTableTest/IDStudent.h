//
//  IDStudent.h
//  SkutHW31EditingTableTest
//
//  Created by Mac on 6/10/16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IDStudent : NSObject

@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (assign, nonatomic) CGFloat averageGrade;

+(IDStudent*) randomStudent;


@end
