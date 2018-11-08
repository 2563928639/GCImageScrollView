//
//  GCImageScrollView.h
//  GCImageScrollView
//
//  Created by sunflower on 2018/11/8.
//  Copyright © 2018 sunflower. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol GCImageScrollViewDelegate <NSObject>

@required

- (void)gc_imageLoadWithImageView:(UIImageView *)imageView withImageUrl:(NSURL *)url;

- (void)gc_imageDidClickWithIndex:(NSInteger)index;

@end


@interface GCImageScrollView : UIView

@property(nonatomic, weak)id<GCImageScrollViewDelegate> delegate;

@property (nonatomic, copy) void (^gc_imageViewLoad) (UIImageView *imageView, NSURL *url);
@property (nonatomic, copy) void (^gc_imageDidClick) (NSInteger curIndex);

@property (nonatomic, copy) NSArray *imageURLStringArray;

- (instancetype)initWithFrame:(CGRect)frame scrollDuration:(NSTimeInterval)duration;

@end

NS_ASSUME_NONNULL_END
