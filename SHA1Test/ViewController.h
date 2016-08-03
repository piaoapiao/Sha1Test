//
//  ViewController.h
//  SHA1Test
//
//  Created by guodong on 16/8/1.
//  Copyright © 2016年 nonobank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

- (NSString *) fileSha1:(NSData *)input;

- (NSString *) fileMd5:(NSData *)input;

- (NSString *) fileSha256:(NSData *)input;

- (NSString *) sha1:(NSString *)input;
@end

