//
//  ZXDropMenuView.m
//  ZXDropMenuView
//
//  Created by brice Mac on 2017/4/3.
//  Copyright © 2017年 briceZhao. All rights reserved.
//

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS

#import "ZXDropMenuView.h"
#import "ZXDropMenuItem.h"
#import "UIView+SeparatorLine.h"
#import <Masonry.h>
#import <ZxExtension.h>

static const NSTimeInterval kAnimationDuration = 0.3;

@interface ZXDropMenuView ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSUInteger currentIndex;

@property (nonatomic, copy) NSArray<UIButton *> *buttons;

@property (nonatomic, weak) UITapGestureRecognizer *tableViewTapGestureRecognizer;

@end

@implementation ZXDropMenuView

- (nullable ZXDropMenuItem *)currentItem
{
    if (_currentIndex == NSNotFound) {
        return nil;
    }
    return _items[_currentIndex];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.currentIndex = NSNotFound;
    self.separatorLinePosition = ZXViewPositionTop | ZXViewPositionBottom;
    self.backgroundColor = [UIColor whiteColor];
    @weakify(self);
    [[RACObserve(self, items) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self dismissDropMenuWithAnimated:NO];
        [self configureSubviews];
    }];
}

- (void)configureSubviews
{
    NSInteger count = _items.count;
    [_buttons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (count == 0) {
        return;
    }
    UIButton *lastButton;
    NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:count];
    for (ZXDropMenuItem *item in self.items)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsImageWhenHighlighted = NO;
        button.adjustsImageWhenDisabled = NO;
        
        [self configureButton:button forItem:item];
        
        [self addSubview:button];
        
        if (lastButton) {
            [button makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self);
                make.leading.equalTo(lastButton.trailing);
                make.width.equalTo(self).dividedBy(count);
            }];
            
            button.separatorLinePosition = ZXViewPositionLeft;
        }
        else {
            [button makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self);
                make.leading.equalTo(self);
                make.width.equalTo(self).dividedBy(count);
            }];
        }
        
        lastButton = button;
        
        [buttons addObject:button];
    }
    _buttons = buttons.copy;
}

- (void)configureButton:(UIButton *)button forItem:(ZXDropMenuItem *)item
{
    [button setAttributedTitle:[self createButtonTitleWithString:item.title] forState:UIControlStateNormal];
    [button setImage:item.image forState:UIControlStateNormal];
    [button setImage:item.selectedImage forState:UIControlStateSelected];
    
    RAC(button, selected) = RACObserve(item, selected);
    
    @weakify(self, item, button);
    [[[[RACObserve(item, selectedOptionIndex) skip:1] filter:^BOOL(id  _Nullable value) {
        
        @strongify(item);
        return item.usingOptionAsTitle;
        
    }] map:^id _Nullable(NSNumber *index) {
        
        @strongify(item);
        return [item.options[index.integerValue] componentsSeparatedByString:@" "].firstObject ? : @"";
        
    }] subscribeNext:^(NSString *title) {
        
        @strongify(self, button);
        [button setAttributedTitle:[self createButtonTitleWithString:title] forState:UIControlStateNormal];
        [self layoutContentForButton:button];
        
    }];
    
    [self layoutContentForButton:button];
    
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable x) {
        @strongify(self);
        
        NSUInteger idx = [self.buttons indexOfObject:x];
        
        NSCAssert(idx != NSNotFound, @"can't find index of button in self.buttons, maybe wrongs for setup self.buttons");
        
        [(RACSubject *)self.items[idx].itemClickSignal sendNext:self.items[idx]];
        
        if (self.currentIndex == idx)
        {
            self.currentIndex = NSNotFound;
            [self setDropMenuHidden:YES animated:YES completion:NULL];
            
            return;
        }
        
        void(^action)() = ^ {
            @strongify(self);
            self.currentIndex = idx;
            if (self.currentItem.options.count > 0)
            {
                [self.tableView reloadData];
                
                [self setDropMenuHidden:NO animated:YES completion:NULL];
                
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentItem.selectedOptionIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
        };
        
        if (self.currentIndex != NSNotFound)
        {
            [self setDropMenuHidden:YES animated:YES completion:^(BOOL finished) {
                action();
            }];
            
        }
        else
        {
            action();
        }
    }];
}

- (void)dismissDropMenuWithAnimated:(BOOL)animated
{
    self.currentIndex = NSNotFound;
    [self hideDropMenuWithAnimated:animated completion:NULL];
}

- (void)setDropMenuHidden:(BOOL)hidden animated:(BOOL)animated completion:(void(^)(BOOL finished))completion
{
    if (hidden)
    {
        [self hideDropMenuWithAnimated:animated completion:completion];
    }
    else
    {
        [self showDropMenuWithAnimated:animated completion:completion];
    }
}

- (void)showDropMenuWithAnimated:(BOOL)animated completion:(void(^)(BOOL finished))completion
{
    if (!self.window) {
        if (completion) {
            completion(NO);
            return;
        }
    }
    CGRect selfFrame = [self.window convertRect:self.bounds fromView:self];
    CGRect finalFrame;
    {
        finalFrame.origin.x = 0;
        finalFrame.origin.y = CGRectGetMaxY(selfFrame) - 1; //-1 for hides the tableView's separator
        finalFrame.size.width = self.window.zx_width;
        finalFrame.size.height = self.window.zx_height - finalFrame.origin.y;
    }
    {
        if (!self.maskView)
        {
            UIView *maskView = [[UIView alloc]initWithFrame:finalFrame];
            maskView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
            self.maskView = maskView;
        }
        
        self.maskView.frame = finalFrame;
        self.maskView.alpha = 0.f;
        if (!self.maskView.superview)
        {
            [self.window addSubview:self.maskView];
        }
    }
    {
        CGRect initialFrame = finalFrame;
        initialFrame.size.height = 0.f;
        if (!_tableView)
        {
            UITableView *tableView = [[UITableView alloc]initWithFrame:initialFrame style:UITableViewStyleGrouped];
            tableView.scrollsToTop = NO;
            tableView.alwaysBounceVertical = NO;
            UITapGestureRecognizer *tap = tableView.zx_tapGestureRecognizer;
            tap.delegate = self;
            [tap addTarget:self action:@selector(handleTap)];
            tableView.backgroundColor = [UIColor clearColor];
            tableView.delegate = self;
            tableView.dataSource = self;
            _tableView = tableView;
        }
        _tableView.frame = initialFrame;
        if (!_tableView.superview)
        {
            [self.window addSubview:_tableView];
        }
    }
    
    {
        CGRect initialFrame = finalFrame;
        initialFrame.size.height = 0.f;
        if (!_tableView)
        {
            UITableView *tableView = [[UITableView alloc] initWithFrame:initialFrame style:UITableViewStyleGrouped];
            tableView.bounces = NO;
            tableView.scrollsToTop = NO;
            tableView.alwaysBounceVertical = NO;
            UITapGestureRecognizer *tap = tableView.zx_tapGestureRecognizer;
            self.tableViewTapGestureRecognizer = tap;
            tap.delegate = self;
            [tap addTarget:self action:@selector(handleTap)];
            tableView.backgroundColor = [UIColor clearColor];
            tableView.delegate = self;
            tableView.dataSource = self;
            _tableView = tableView;
        }
        _tableView.frame = initialFrame;
        if (!_tableView.superview)
        {
            [self.window addSubview:_tableView];
        }
    }
    
    if (animated)
    {
        [UIView animateWithDuration:kAnimationDuration
                         animations:^{
                             self.tableView.frame = finalFrame;
                             self.maskView.alpha = 1.f;
                         } completion:^(BOOL finished) {
                             if (completion) completion(finished);
                         }];
    }
    else
    {
        self.tableView.frame = finalFrame;
        self.maskView.alpha = 1.f;
        if (completion) completion(YES);
    }
}

- (void)hideDropMenuWithAnimated:(BOOL)animated completion:(void(^)(BOOL finish))completion
{
    if (!_tableView || !_tableView.superview) {
        if (completion) {
            completion(YES);
        }
        return;
    }
    
    if (animated)
    {
        [UIView animateWithDuration:kAnimationDuration
                         animations:^{
                             self.tableView.zx_height = 0.f;
                             self.maskView.alpha = 0.f;
                             
                         } completion:^(BOOL finished) {
                             [self.tableView removeFromSuperview];
                             [self.maskView removeFromSuperview];
                             
                             if (completion)
                             {
                                 completion(finished);
                             }
                         }];
    }
    else
    {
        [self.tableView removeFromSuperview];
        [self.maskView removeFromSuperview];
        if (completion) {
            completion(YES);
        }
    }
}

- (void)handleTap
{
    [self dismissDropMenuWithAnimated:YES];
}

#pragma mark - gesture recognizer -
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    for (UIView *cell in self.tableView.visibleCells)
    {
        if ([cell pointInside:[touch locationInView:cell] withEvent:nil])
        {
            return NO;
        }
    }
    return YES;
}

#pragma mark - 生成属性文本 -
- (NSAttributedString *)createButtonTitleWithString:(NSString *)string
{
    return [[NSAttributedString alloc]initWithString:string attributes:
  @{
    NSForegroundColorAttributeName:[UIColor zx_colorWithHex:0x333333],
    NSFontAttributeName:[UIFont systemFontOfSize:14.f]
    }];
}

#pragma mark - layout -
- (void)layoutContentForButton:(UIButton *)button
{
    CGFloat offset = 3.f;
    
    button.contentEdgeInsets = UIEdgeInsetsMake(0, offset, 0, offset);
    
    CGFloat textWidth = button.titleLabel.intrinsicContentSize.width + offset;
    CGFloat imageWidth = button.imageView.intrinsicContentSize.width + offset;
    
    button.titleEdgeInsets = UIEdgeInsetsMake(0.f, - imageWidth, 0.f, imageWidth);
    button.imageEdgeInsets = UIEdgeInsetsMake(0.f, textWidth , 0.f, -textWidth);
}


#pragma mark - tableView -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentItem.options.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *const kReuse = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuse];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kReuse];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14.f];
        
        [RACObserve(cell, selected) subscribeNext:^(NSNumber *selected) {
            if (selected.boolValue) {
                cell.textLabel.textColor = [UIColor zx_colorWithHex:0Xee7059];
                cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nav_filter_back"]];
            }
            else {
                cell.textLabel.textColor = [UIColor zx_colorWithHex:0x333333];
                cell.accessoryView = nil;
            }
        }];
        
    }
    ZXDropMenuItem *item = self.currentItem;
    cell.textLabel.text = item.options[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXDropMenuItem *item = _items[_currentIndex];
    [item setValue:@(indexPath.row) forKey:@keypath(item, selectedOptionIndex)];
    [tableView cellForRowAtIndexPath:indexPath].selected = YES;
    
    [self dismissDropMenuWithAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
}


@end
