//
//  ContentSearchCell.m
//  LSYReader
//
//  Created by 张文强 on 2016/12/14.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "ContentSearchCell.h"
@implementation ContentSearchModel

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.nChapter = [aDecoder decodeIntegerForKey:@"nChapter"];
        self.rangeInChapter = [[aDecoder decodeObjectForKey:@"rangeInChaper"]rangeValue];
        self.pChapterName = [aDecoder decodeObjectForKey:@"pChapterName"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.pChapterName forKey:@"pChapterName"];
    [aCoder encodeInteger:self.nChapter forKey:@"nChapter"];
    [aCoder encodeObject:[NSValue valueWithRange:self.rangeInChapter] forKey:@"rangeInChapter"];
}
@end
@implementation ContentSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
