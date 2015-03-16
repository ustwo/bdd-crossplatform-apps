//
//  US2CommitTableViewCell.m
//  AppTestingSample
//
//  Created by Martin on 08/01/2015.
//  Copyright (c) 2015 ustwo. All rights reserved.
//

#import "US2CommitTableViewCell.h"

@interface US2CommitTableViewCell ()
@property (nonatomic, strong, readwrite) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong, readwrite) IBOutlet UILabel *dateLabel;
@end

@implementation US2CommitTableViewCell

- (void)awakeFromNib {
    self.nameLabel.text = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Name

- (void)setNameString:(NSString *)nameString {
    _nameString = [nameString copy];
    
    self.nameLabel.text = _nameString;
}

#pragma mark - Date

- (void)setDateString:(NSString *)dateString {
    _dateString = [dateString copy];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss'Z'"];
    NSDate *date = [dateFormatter dateFromString:_dateString];
    
    NSString *formatedDateString = [NSDateFormatter localizedStringFromDate:date
                                                                  dateStyle:NSDateFormatterMediumStyle
                                                                  timeStyle:NSDateFormatterLongStyle];
    
    self.dateLabel.text = formatedDateString;
}

@end
