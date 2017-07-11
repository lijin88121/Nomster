//
//  AOTag.m
//  AOTagDemo
//
//  Created by Loïc GRIFFIE on 16/09/13.
//  Copyright (c) 2013 Appsido. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AOTag.h"
#import <QuartzCore/QuartzCore.h>

#define tagFontSize         12.0f
#define tagFontType         @"Helvetica-Light"
#define tagMargin           5.0f
#define tagHeight           25.0f
#define tagCornerRadius     6.0f
#define tagCloseButton      6.0f

@implementation AOTagList

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
        
        self.tags = [NSMutableArray array];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        self.tags = [NSMutableArray array];
    }
    
    return self;
}

- (void)adjustLayout
{
    int n = 0;
    float x = 0.0;
    float y = 0.0f;
    
    for (id v in [self subviews])
        if ([v isKindOfClass:[AOTag class]])
            [v removeFromSuperview];
    
    for (AOTag *tag in self.tags)
    {
        if (x + [tag getTagSize].width + tagMargin > self.frame.size.width) { n = 0; x = 0.0; y += [tag getTagSize].height + tagMargin; }
        else x += (n ? tagMargin : 0.0f);
        
        x += [tag getTagSize].width;
        
        n++;
    }
    
    CGRect r = [self frame];
    r.size.height = y + tagHeight;
    [self setFrame:r];
}

- (void)drawRect:(CGRect)rect
{
    int n = 0;
    float x = 0.0;
    float y = 0.0f;
    
    for (id v in [self subviews])
        if ([v isKindOfClass:[AOTag class]])
            [v removeFromSuperview];
    
    for (AOTag *tag in self.tags)
    {
        if (x + [tag getTagSize].width + tagMargin > self.frame.size.width) { n = 0; x = 0.0; y += [tag getTagSize].height + tagMargin; }
        else x += (n ? tagMargin : 0.0f);
        
        [tag setFrame:CGRectMake(x, y, [tag getTagSize].width, [tag getTagSize].height)];
        [self addSubview:tag];
        
        x += [tag getTagSize].width;
        
        n++;
    }
    
    CGRect r = [self frame];
    r.size.height = y + tagHeight;
    [self setFrame:r];
}

- (AOTag *)generateTagWithLabel:(NSString *)tTitle
{
    AOTag *tag = [[AOTag alloc] initWithFrame:CGRectZero];
    
    [tag setDelegate:self.delegate];
    [tag setTTitle:tTitle];
    
    [self.tags addObject:tag];
    
    return tag;
}

- (AOTag*)addTag:(NSString *)tTitle
{
    AOTag* tag = [self generateTagWithLabel:(tTitle ? tTitle : @"")];
    
    [self setNeedsDisplay];
    [self adjustLayout];
    return tag;
}

- (void)addTag:(NSString *)tTitle
withLabelColor:(UIColor *)labelColor
withBackgroundColor:(UIColor *)backgroundColor
withCloseButtonColor:(UIColor *)closeColor
{
    AOTag *tag = [self generateTagWithLabel:(tTitle ? tTitle : @"")];
    
    if (labelColor) [tag setTLabelColor:labelColor];
    if (backgroundColor) [tag setTBackgroundColor:backgroundColor];
    if (closeColor) [tag setTCloseButtonColor:closeColor];
    
    [self setNeedsDisplay];
    [self adjustLayout];
}


- (void)addTags:(NSArray *)tags
{
    for (NSDictionary *tag in tags)
        [self addTag:[tag objectForKey:@"title"]];
}

- (void)removeTag:(AOTag *)tag
{
    [self.tags removeObject:tag];
    
    [self setNeedsDisplay];
    [self adjustLayout];
}

- (void)removeAllTag
{
    for (id t in [NSArray arrayWithArray:[self tags]])
        [self removeTag:t];
}

@end

@implementation AOTag

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.tBackgroundColor = NR_COLOR;
        self.tLabelColor = [UIColor whiteColor];
        self.tCloseButtonColor = [UIColor whiteColor];
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
        
        [[self layer] setCornerRadius:tagCornerRadius];
        [[self layer] setMasksToBounds:YES];
        
    }
    return self;
}

- (CGSize)getTagSize
{
    CGSize tSize = [self.tTitle sizeWithFont:[UIFont fontWithName:tagFontType size:tagFontSize]];
    
    return CGSizeMake(tagMargin + tSize.width + tagMargin + tagCloseButton + tagMargin, tagHeight);
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    self.layer.backgroundColor = [self.tBackgroundColor CGColor];
        
    CGSize tSize = [self.tTitle sizeWithFont:[UIFont fontWithName:tagFontType size:tagFontSize]];
    

    AOTagCloseButton *close = [[AOTagCloseButton alloc] initWithFrame:CGRectMake(tagMargin / 2 + (tagCloseButton - tagHeight) / 2.0, 0.0, tagHeight, tagHeight)
                                                            withColor:self.tCloseButtonColor];
    
    
    [self addSubview:close];
    
    [self.tLabelColor setFill];
    [self.tTitle drawInRect:CGRectMake(tagMargin + tagCloseButton + tagMargin , ([self getTagSize].height / 2.0f) - (tSize.height / 2.0f), tSize.width, tSize.height)
                   withFont:[UIFont fontWithName:tagFontType size:tagFontSize]];
    
    
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagSelected:)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self addGestureRecognizer:recognizer];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tagDidAddTag:)])
        [self.delegate performSelector:@selector(tagDidAddTag:) withObject:self];
}

- (void)tagSelected:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tagDidSelectTag:)])
        [self.delegate performSelector:@selector(tagDidSelectTag:) withObject:self];
}

- (void)tagClose:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tagDidRemoveTag:)])
        [self.delegate performSelector:@selector(tagDidRemoveTag:) withObject:self];
    
    [(AOTagList *)[self superview] removeTag:self];
}

@end

@implementation AOTagCloseButton

- (id)initWithFrame:(CGRect)frame withColor:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
        
        [self setCColor:color];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(rect.size.width - tagCloseButton + 1.0, (rect.size.height - tagCloseButton) / 2.0)];
    [bezierPath addLineToPoint:CGPointMake(rect.size.width - (tagCloseButton * 2.0) + 1.0, ((rect.size.height - tagCloseButton) / 2.0) + tagCloseButton)];
    [self.cColor setStroke];
    bezierPath.lineWidth = 1.0;
    [bezierPath stroke];
    
    UIBezierPath *bezier2Path = [UIBezierPath bezierPath];
    [bezier2Path moveToPoint:CGPointMake(rect.size.width - tagCloseButton + 1.0, ((rect.size.height - tagCloseButton) / 2.0) + tagCloseButton)];
    [bezier2Path addLineToPoint:CGPointMake(rect.size.width - (tagCloseButton * 2.0) + 1.0, (rect.size.height - tagCloseButton) / 2.0)];
    [self.cColor setStroke];
    bezier2Path.lineWidth = 1.0;
    [bezier2Path stroke];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagClose:)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self addGestureRecognizer:recognizer];
}

- (void)tagClose:(id)sender
{
    if ([[self superview] respondsToSelector:@selector(tagClose:)])
        [[self superview] performSelector:@selector(tagClose:) withObject:self];
}

@end