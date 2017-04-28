//
//  IDStudent.m
//  SkutHW31EditingTableTest
//
//  Created by Mac on 6/10/16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "IDStudent.h"

@implementation IDStudent



static NSString* firstNames[]={@"Ira",@"Masha",@"Lena",@"Sasha",@"Dasha",@"Katya",@"Sveta",@"Olya",@"Natasha",@"Marina",@"Iulya",@"Vika",@"Dina",@"Toma",@"Sveta",@"Galya",@"Liuba",@"Zoya",@"Vera",@"Rita",@"Zina",@"Anya",@"Alla",@"Ada",@"Tanya"
};

static NSString* lastNames[]={@"Popova",@"Malahova",@"Vishneva",@"Soloveikina",@"Verbova",@"Antipova",@"Komarova",@"Golovleva",@"Petrova",@"Makarova",@"Dobrinina",@"Kotova",@"Borisova",@"Pilnova",@"Durova",@"Takmakoba",@"Sirebriakova",@"Zagorodkina",@"Kopchenko",@"Ligova",
    @"Makova",@"Romova",@"Golubkina",@"Pechkina",@"Matroskina"
};
static int namesCount = 25;

+ (IDStudent*) randomStudent{


    IDStudent* student = [[IDStudent alloc] init];
    student.firstName= firstNames[arc4random() % namesCount];
    student.lastName= lastNames[arc4random() % namesCount];
    student.averageGrade = ((CGFloat)(arc4random()%301 + 200)) / 100;
    
    return student;
};

@end
