//
//  ToDoItem.h
//  ToDoList
//
//  Created by Dave Sienk on 1/27/15.
//  Copyright (c) 2015 Dave Sienk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToDoItem : NSObject

@property NSString *itemName;
@property BOOL completed;
@property (readonly) NSDate *creationDate;

@end
