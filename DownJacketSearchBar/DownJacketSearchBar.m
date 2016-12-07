//
//  DownJacketSearchBar.m
//  <https://github.com/snail-z/DownJacketSearchBar>
//
//  Created by zhanghao on 16/11/1.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "DownJacketSearchBar.h"
#import "UIView+DownJacketLayout.h"
#import "UITextField+DownJacketDeleteBackward.h"

@implementation DownJackets

@end

@interface DownJacketItem : UIButton

@property (nonatomic, strong) DownJackets *downJackets;

@end

@implementation DownJacketItem

- (void)setDownJackets:(DownJackets *)downJackets {
    _downJackets = downJackets;
    [self setImage:downJackets.image forState:UIControlStateNormal];
}

@end

@interface DownJacketsField : UITextField

@property (nonatomic, assign) CGFloat textInsetLeft;

@end

@implementation DownJacketsField

/*  Overriding -textRectForBounds: will only change the inset of the placeholder text. To change the inset of the editable text, you need to also override -editingRectForBounds:
    <http://stackoverflow.com/questions/2694411/text-inset-for-uitextfield>
*/
- (CGRect)textRectForBounds:(CGRect)bounds {
//    CGRect inset = CGRectMake(bounds.origin.x + _textInsetLeft, bounds.origin.y, bounds.size.width - _textInsetLeft, bounds.size.height);
//    return inset;
    return CGRectInset(bounds, _textInsetLeft, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, _textInsetLeft, 0);
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    if (!self.isEditing) return self.bounds;
    return CGRectInset(bounds, _textInsetLeft, 0);
}

- (void)setTextInsetLeft:(CGFloat)textInsetLeft {
    _textInsetLeft = textInsetLeft;
    [self setNeedsDisplay];
}

@end

@interface DownJacketSearchBar ()<DownJacketTextFieldDelegate>

@property (nonatomic, strong) UIScrollView *scrollContainer;
@property (nonatomic, strong) DownJacketsField *searchTextField;
@property (nonatomic, strong) DownJacketItem *searchItem;
@property (nonatomic, strong) NSMutableArray<DownJacketItem *> *items;
@property (nonatomic, strong) NSMutableArray<DownJackets *> *dataDownJackets;

@end

static NSString * const dataDownJacketsKey = @"dataDownJackets";

@implementation DownJacketSearchBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = [UIScreen mainScreen].bounds.size.width;
        frame.size.height = 60;
    }
    self = [super initWithFrame:frame];
    if (!self) return nil;
    _dataDownJackets = @[].mutableCopy;
    _items = @[].mutableCopy;
    
    // default value
    _scrollConstraintCount = 5;
    _leftPadding = 15;
    _textInsetLeft = 10;
    
    _scrollContainer = [UIScrollView new];
    _scrollContainer.bounces = NO;
    _scrollContainer.backgroundColor = [UIColor whiteColor];
    [self addSubview:_scrollContainer];
    
    _searchItem = [DownJacketItem new];
    _searchItem.backgroundColor =[ UIColor whiteColor];
    _searchItem.contentMode = UIViewContentModeCenter;
    _searchItem.x = _leftPadding;
    _searchItem.size = CGSizeMake(self.height / 2, self.height / 2);
    _searchItem.centerY = self.height / 2;
    _scrollContainer.size = CGSizeMake(_searchItem.right, self.height);
    [_scrollContainer addSubview:_searchItem];
    
    _searchTextField = [DownJacketsField new];
    _searchTextField.font = [UIFont systemFontOfSize:14];
    _searchTextField.delegate = self;
    _searchTextField.backgroundColor = [UIColor whiteColor];
    _searchTextField.size = CGSizeMake(self.width - _scrollContainer.width, self.height);
    _searchTextField.x = _scrollContainer.right;
    _searchTextField.textInsetLeft = _textInsetLeft;
    [self addSubview:_searchTextField];

    UIView *horizontalLine = [UIView new];
    horizontalLine.backgroundColor = [UIColor colorWithWhite:0.782 alpha:1.000];
    horizontalLine.size = CGSizeMake(self.width, 1 / UIScreen.mainScreen.scale);
    horizontalLine.y = self.height - horizontalLine.height;
    [self addSubview:horizontalLine];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [self addObserver:self forKeyPath:dataDownJacketsKey options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    return self;
}

#pragma mark - setter

- (void)setLeftPadding:(CGFloat)leftPadding {
    _searchItem.x = _leftPadding = leftPadding;
    [self updateLayout:_searchItem.right];
}

- (void)setTextInsetLeft:(CGFloat)textInsetLeft {
    _searchTextField.textInsetLeft = textInsetLeft;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _searchTextField.placeholder = placeholder;
}

- (void)setPresetImage:(UIImage *)presetImage {
    [_searchItem setImage:presetImage forState:UIControlStateNormal];
}

#pragma mark - update Layout

- (void)updateLayout:(CGFloat)scrollWidth {
    _scrollContainer.width = scrollWidth;
    _searchTextField.x = _scrollContainer.right;
    _searchTextField.width = self.width - scrollWidth;
}

- (void)endEditing {
    if ([_searchTextField isFirstResponder]) [_searchTextField resignFirstResponder];
    if (!_dataDownJackets.count) {
        if (![_scrollContainer.subviews containsObject:_searchItem]) {
            [_scrollContainer addSubview:_searchItem];
        }
        [self updateLayout:_searchItem.right];
    } else {
        [self changeStatusToDeselect];
    }
}

#pragma mark - DownJacketTextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (!_dataDownJackets.count) {
        [self updateLayout:0];
    }
    [_searchItem removeFromSuperview];
    if ([_delegate respondsToSelector:@selector(searchBarShouldBeginEditing:)]) {
        [_delegate searchBarShouldBeginEditing:self];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (!_dataDownJackets.count && !textField.hasText) {
        [self endEditing];
    }
    if ([_delegate respondsToSelector:@selector(searchBarShouldEndEditing:)]) {
        [_delegate searchBarShouldEndEditing:self];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isFirstResponder]) [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidDeleteBackward:(UITextField *)textField {
    if (textField.hasText) return;
    if (!_dataDownJackets.count) {
        [self endEditing];
        return;
    }
    DownJackets *downJackets = [_dataDownJackets lastObject];
    if ([self currentStatus:downJackets]) {
        [self removeDownJackets:downJackets];
    } else {
        [self changeStatusToSelected:downJackets];
    }
}

#pragma mark - UITextFieldTextDidChangeNotification

- (void)textFieldDidChange:(NSNotification *)notification {
    if (!notification) return;
    UITextField *textField = notification.object;
    if (textField == _searchTextField) {
        [self changeStatusToDeselect];
        if ([_delegate respondsToSelector:@selector(searchBar:textDidChange:)]) {
            [_delegate searchBar:self textDidChange:textField.text];
        }
        if (!textField.hasText && !_dataDownJackets.count) {
            [self endEditing];
        }
    }
}

#pragma mark - KVO NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (![keyPath isEqualToString:dataDownJacketsKey]) return;
    
    if (!_dataDownJackets.count) {
        [self endEditing];
    } else {
        // margin: subviews spacing
        // width: subviews width and height
        CGFloat margin = 7, width = self.height - 20;
        CGFloat scrollContentWidth = (width + margin)*_dataDownJackets.count + _leftPadding - margin;
        if (_dataDownJackets.count <= self.scrollConstraintCount) {
            [_searchItem removeFromSuperview];
            [self updateLayout:scrollContentWidth];
        }
        
        __weak typeof(self) _self = self;
        [_items enumerateObjectsUsingBlock:^(DownJacketItem * _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
            [button setFrame:CGRectMake(idx * (width + margin) + _self.leftPadding, margin, width, width)];
            button.center = CGPointMake(button.center.x, self.frame.size.height / 2);
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            CGFloat offsetX = scrollContentWidth -_scrollContainer.width;
            _scrollContainer.contentOffset = CGPointMake(offsetX, 0);
        } completion:^(BOOL finished) {
            [_scrollContainer setContentSize:CGSizeMake(scrollContentWidth, 0)];
        }];
    }
}

#pragma mark - item status

- (BOOL)currentStatus:(DownJackets *)downJackets {
    if (!downJackets) return NO;
    NSInteger idx = [_dataDownJackets indexOfObject:downJackets];
    if (idx < _items.count) {
        DownJacketItem *item = [_items objectAtIndex:idx];
        return item.selected;
    }
    return NO;
}

- (void)changeStatusToSelected:(DownJackets *)downJackets {
    if (!downJackets) return;
    NSInteger idx = [_dataDownJackets indexOfObject:downJackets];
    if (idx < _items.count) {
        DownJacketItem *item = [_items objectAtIndex:idx];
        item.highlighted = YES;
        item.selected = YES;
    }
}

- (void)changeStatusToDeselect {
    __weak typeof(self) _self = self;
    [_dataDownJackets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < _self.items.count) {
            DownJacketItem *item = [_self.items objectAtIndex:idx];
            item.highlighted = NO;
            item.selected = NO;
        }
    }];
}

#pragma mark - add or delete

- (void)addDownJackets:(DownJackets *)downJackets {
    if (!downJackets || [_dataDownJackets containsObject:downJackets]) {
        return;
    }
    DownJacketItem *item = [DownJacketItem new];
    item.downJackets = downJackets;
    [item addTarget:self action:@selector(downJacketItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_items addObject:item];
    [_scrollContainer addSubview:item];
    [[self mutableArrayValueForKey:dataDownJacketsKey] addObject:downJackets];
    [self changeStatusToDeselect];
}

- (void)downJacketItemClicked:(DownJacketItem *)downJacketItem {
    [self removeDownJackets:downJacketItem.downJackets];
}

- (void)removeDownJackets:(DownJackets *)downJackets {
    if (!downJackets || ![_dataDownJackets containsObject:downJackets] ) {
        return;
    }
    NSInteger idx = [_dataDownJackets indexOfObject:downJackets];
    if (idx < _items.count) {
        DownJacketItem *item = [_items objectAtIndex:idx];
        [UIView animateWithDuration:0.25 animations:^{
            [item removeFromSuperview];
            [_items removeObjectAtIndex:idx];
            [self changeStatusToDeselect];
            [[self mutableArrayValueForKey:dataDownJacketsKey] removeObject:downJackets];
            if ([_delegate respondsToSelector:@selector(searchBar:removeDownJackets:)]) {
                [_delegate searchBar:self removeDownJackets:downJackets];
            }
        } completion:NULL];
    }
}

@end
