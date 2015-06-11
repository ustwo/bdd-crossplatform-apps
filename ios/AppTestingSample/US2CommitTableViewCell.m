//
//  US2CommitTableViewCell.m
//  AppTestingSample
//
//  Created by Martin on 08/01/2015.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 ustwo™
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
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
    
    self.dateLabel.text = _dateString;
}

@end
