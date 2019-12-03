//
//  LSYNoteModel.m
//  LSYReader
//
//  Created by Labanotation on 16/5/31.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYNoteModel.h"

@implementation LSYNoteModel
-(instancetype)init
{
    self = [super init];
    if (self)
    {
        _recordModel = [[LSYRecordModel alloc]init];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.note forKey:@"note"];
  //  [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.recordModel forKey:@"recordModel"];
    [aCoder encodeObject:[NSValue valueWithRange:self.ChapterRange] forKey:@"ChapterRange"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.date = [aDecoder decodeObjectForKey:@"date"];
        self.note = [aDecoder decodeObjectForKey:@"note"];
     //   self.content = [aDecoder decodeObjectForKey:@"content"];
        self.recordModel = [aDecoder decodeObjectForKey:@"recordModel"];
        self.ChapterRange = ((NSValue*)[aDecoder decodeObjectForKey:@"ChapterRange"]).rangeValue;
    }
    return self;
}
@end
