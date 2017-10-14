//
//  EXPhotoViewer.h
//  EXPhotoViewerDemo
//
//  Created by Julio Carrettoni on 3/20/14.
//  Copyright (c) 2014 Julio Carrettoni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EXPhotoViewer : UIViewController <UIScrollViewDelegate>

+ (void) showImageFrom:(UIImageView*) image;

@end
