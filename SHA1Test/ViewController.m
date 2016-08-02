//
//  ViewController.m
//  SHA1Test
//
//  Created by guodong on 16/8/1.
//  Copyright © 2016年 nonobank. All rights reserved.
//

#import "ViewController.h"
#include "sha1.h"

#import <CommonCrypto/CommonDigest.h>

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
    //不添加 空数据，计算值不对
    NSLog(@"System Api file imageData shal:%@",[self  fileSha1:imageData]);
    
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
    
    
    sha1(hashes, [imageMutableData bytes], [imageMutableData length]);
    
    NSData *data22 = [NSData dataWithBytes:hashes length:20];
    
    NSLog(@"O Api file sha1:%@",data22);
    
    
    
    //System Call
    NSLog(@"System Api file shal1:%@",[self  fileSha1:imageMutableData]);
    
    NSLog(@"System Api file shal2:%@",[self  fileSha1:imageData]);
    
    NSLog(@"System Api file sha256:%@",[self  fileSha256:imageMutableData]);
    
    NSLog(@"System Api file sha256:%@",[self  fileSha256:imageData]);
    
    

    // Do any additional setup after loading the view, typically from a nib.
}


- (NSString *) sha1:(NSString *)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}


- (NSString *) fileSha1:(NSData *)input
{
    NSData *data = [NSData dataWithBytes:input.bytes length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

- (NSString *) fileSha256:(NSData *)input
{
    NSData *data = [NSData dataWithBytes:input.bytes length:input.length];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(data.bytes, data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA256_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}
@end
