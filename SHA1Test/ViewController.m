//
//  ViewController.m
//  SHA1Test
//
//  Created by guodong on 16/8/1.
//  Copyright © 2016年 nonobank. All rights reserved.
//

#import "ViewController.h"
#include "sha1.h"

#define  kNumber  64

@interface ViewController ()

@end

void sha1(uint8_t *hash, uint8_t *data, size_t size) {
    SHA1Context context;
    SHA1Reset(&context);
    SHA1Input(&context, data, size);
    SHA1Result(&context, hash);
}

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
    
    NSMutableData *imageMutableData = [NSMutableData dataWithData:imageData];
    
    
    //如果不够64个字节，就补充000
    if(imageData.length%64 != 0)
    {
        char appendBuf[64] = {0};
        int  appendLen = 64 - imageData.length%64;
        NSData *tmp= [NSData dataWithBytes:appendBuf length:appendLen];
        
        
        [imageMutableData appendBytes:[tmp bytes] length:tmp.length];
    }

    uint8_t (hashes)[20];
    
    NSData *data22 = [NSData dataWithBytes:hashes length:20];
    
    NSLog(@"data:%@",data22);
    
    
    //int page = 0;
    
    char *fpoint = (char *)[imageMutableData bytes];
    
    
    sha1(hashes, fpoint, imageData.length);
    
//    
//    int  result = imageData.length%kNumber;
//    
//    if(imageData.length%kNumber == 0)
//    {
//       page = imageData.length/kNumber;
//    }
//    else
//    {
//       page  = imageData.length/kNumber + 1;
//    }
//    
//    for(int i = 0;i< page;i++)
//    {
//        if(i == page - 1)
//        {
//            if(result == 0)
//            {
//                sha1(hashes, fpoint + i*kNumber, kNumber);
//               // NSData *data22 = [NSData dataWithBytes:hashes length:20];
//
//               // NSLog(@"tmpHashed:%@",data22);
//            }
//            else
//            {
//                char tailBuffer[64] = {0};
//                memset(tailBuffer, 0, 64);
//                strncpy(tailBuffer, fpoint + i*kNumber,result);
//            
//               // NSData *tailData = [NSData dataWithBytes:<#(nullable const void *)#> length:<#(NSUInteger)#>]
//                
//               // sha1(hashes, tailBuffer, 64);
//                
//                sha1(hashes, fpoint + i*kNumber, result);
//            }
//        }
//        else
//        {
//            sha1(hashes, fpoint + i*kNumber, kNumber);
//            NSData *data22 = [NSData dataWithBytes:hashes length:20];
//
//           // NSLog(@"tmpHashed:%@",data22);
//        }
//        
//       // NSData *data22 = [NSData dataWithBytes:*hashes length:20];
//
//        //NSLog(@"tmpHashed:%@",data22);
//    
//    }

    
    


    // Do any additional setup after loading the view, typically from a nib.
}
@end
