//
//  TransactionCell.m
//  Family Farm
//
//  Created by Axel Trajano on 5/11/14.
//  Copyright (c) 2014 Axel S. Trajano. All rights reserved.
//

#import "TransactionCell.h"
#import "TransactionHeader.h"

@implementation TransactionCell

- (void)awakeFromNib
{
    // Initialization code
    TransactionHeader * cellView = [TransactionHeader new];
    [self addSubview:cellView.view];
    [cellView.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:cellView.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:cellView.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:cellView.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:cellView.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:cellView.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:cellView.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    _serviceOffered = [cellView serviceLabel];
    _serviceFee = [cellView serviceFeeLabel];
    _landArea = [cellView landAreaLabel];
    _balance = [cellView balanceLabel];
    _transactionDate = [cellView dateLabel];
    _notes = [cellView noteLabel];
    
    UIColor * black = [UIColor blackColor];
    [_serviceOffered setTextColor:black];
    [_serviceFee setTextColor:black];
    [_balance setTextColor:black];
    [_landArea setTextColor:black];
    [_transactionDate setTextColor:black];
    [_notes setTextColor:black];
    
    [self setAccessoryType:UITableViewCellAccessoryDetailButton];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
