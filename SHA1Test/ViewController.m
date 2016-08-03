//
//  ViewController.m
//  SHA1Test
//
//  Created by guodong on 16/8/1.
//  Copyright © 2016年 nonobank. All rights reserved.
//

#import "ViewController.h"
#include "sha1.h"

#include "crc32.h"
#include <stdio.h>

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "NSdata+Encryption.h"

#import "RSA.h"

#define  kNumber  64

@interface ViewController ()


@end



@implementation ViewController

void sha1(uint8_t *hash, uint8_t *data, size_t size) {
    SHA1Context context;
    SHA1Reset(&context);
    SHA1Input(&context, data,(unsigned)size);
    SHA1Result(&context, hash);
}

//- (NSString *) sha1:(NSString *)input
//{
//    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
//    NSData *data = [NSData dataWithBytes:cstr length:input.length];
//    
//    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
//    
//    CC_SHA1(data.bytes,(uint32_t)(data.length), digest);
//    
//    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
//    
//    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
//        [output appendFormat:@"%02x", digest[i]];
//    }
//    
//    return output;
//}


- (NSString *) fileSha1:(NSData *)input
{
    NSData *data = [NSData dataWithBytes:input.bytes length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (uint32_t)(data.length), digest);
    
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
    
    CC_SHA256(data.bytes,(uint32_t)(data.length), digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA256_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

- (NSString *) fileMd5:(NSData *)input
{
    NSData *data = [NSData dataWithBytes:input.bytes length:input.length];
    
    uint8_t digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(data.bytes, (uint32_t)(data.length), digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self  testAes];
    
    [self  testRsa];
    

    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
    //不添加 空数据，计算值不对
   // NSLog(@"System Api file imageData shal:%@",[self  fileSha1:imageData]);
    
    NSMutableData *imageMutableData = [NSMutableData dataWithData:imageData];
    
    FILE *crcFp = fopen([imagePath UTF8String], "r");
    
    unsigned long tmp;
    
    Crc32_ComputeFile(crcFp,&tmp);
    
    NSLog(@"crc32:%lx",tmp);
    
    
    //如果不够64个字节，就补充000
    if(imageData.length%64 != 0)
    {
        char appendBuf[64] = {0};
        int  appendLen = 64 - imageData.length%64;
        NSData *tmp= [NSData dataWithBytes:appendBuf length:appendLen];
        
        
        [imageMutableData appendBytes:[tmp bytes] length:tmp.length];
    }

    uint8_t (hashes)[20];
    
    
    sha1(hashes, (uint8_t *)[imageMutableData bytes], (size_t)[imageMutableData length]);
    
    NSData *data22 = [NSData dataWithBytes:hashes length:20];
    
    NSLog(@"O Api file sha1:%@",data22);
    
    
    
    //System Call
    NSLog(@"System Api file shal1:%@",[self  fileSha1:imageMutableData]);
    
    NSLog(@"System Api file shal2:%@",[self  fileSha1:imageData]);
    
    NSLog(@"System Api file sha256:%@",[self  fileSha256:imageMutableData]);
    
    NSLog(@"System Api file sha256:%@",[self  fileSha256:imageData]);
    
    
    NSLog(@"System Api file md5:%@",[self  fileMd5:imageData]);
    

    // Do any additional setup after loading the view, typically from a nib.
}



-(void)testAes
{
    NSString *aesKey = @"3243243243243243骨偶哦";

    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
    NSData *encryptedData = [imageData AES256EncryptWithKey:aesKey];
    
    
    //NSString *homePath =  [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSString *homePath =  [[NSBundle mainBundle] bundlePath];
    
    NSString *encryptDataPath = [homePath stringByAppendingString:@"/encrypted.data"];
    NSLog(@"encryptDataPath:%@",encryptDataPath);
    
    [encryptedData writeToFile:encryptDataPath atomically:YES];
    
    NSString *decryptedDataPath = [homePath stringByAppendingString:@"/decrypted.png"];
    
   // [encryptedData writeToFile:encryptDataPath atomically:YES];
   
   NSData *decryptData =  [encryptedData AES256DecryptWithKey:aesKey];
   
   [decryptData writeToFile:decryptedDataPath atomically:YES];
    
}



-(void)testRsa
{
    NSString *publicFilePath = [[NSBundle mainBundle] pathForResource:@"rsa_public_key" ofType:@"pem"];


    NSString *privateFilePath = [[NSBundle mainBundle] pathForResource:@"rsa_private_key" ofType:@"pem"];

    NSError *error;


    NSString *pubkey = [NSString stringWithContentsOfFile:publicFilePath encoding:NSUTF8StringEncoding error:&error];

    if(error)
    {
        NSLog(@"error:%@",error);
    }

    NSString *privkey = [NSString stringWithContentsOfFile:privateFilePath encoding:NSUTF8StringEncoding error:&error];

        if(error)
    {
        NSLog(@"error:%@",error);
    }

//    NSLog(@"pubkey:%@ len:%ld",pubkey,pubkey.length);
//
//    NSLog(@"privkey:%@ len:%ld",privkey,privkey.length);

	NSString *originString = @"0";

	NSString *encWithPubKey;
	NSString *decWithPrivKey;
	
	NSLog(@"Original string(%d): %@", (int)originString.length, originString);
	
	// Demo: encrypt with public key
	encWithPubKey = [RSA encryptString:originString publicKey:pubkey];
	NSLog(@"Enctypted with public key: %@", encWithPubKey);
	// Demo: decrypt with private key
	decWithPrivKey = [RSA decryptString:encWithPubKey privateKey:privkey];
	NSLog(@"Decrypted with private key: %@", decWithPrivKey);
    
    
    //还未

//    encWithPrivKey  = [RSA encryptData:originString privateKey:privkey];
//    NSLog(@"encWithPrivKey:%@",encWithPrivKey);
    
//    decWithPublicKey = [RSA decryptData:encWithPrivKey publicKey:privkey];
//    NSLog(@"decWithPublicKey:%@",decWithPublicKey);
    
	
	
}







@end
