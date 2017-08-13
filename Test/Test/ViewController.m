//
//  ViewController.m
//  Test
//
//  Created by tangtianshuai on 2017/3/24.
//  Copyright © 2017年 tangtianshuai. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "NSString+MD5.h"

#include <dlfcn.h>
#import "lame.h"

#import  <CoreTelephony/CoreTelephonyDefines.h>



@interface ViewController ()

@property(nonatomic,strong)UIDocumentInteractionController *vc;

@property(nonatomic,strong)AFHTTPSessionManager *manager;


@property(nonatomic,weak)IBOutlet UITableView *table;

@property(nonatomic,assign)BOOL b;

@end

@implementation ViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}

- (IBAction)pressButton:(id)sender
{
    NSString *filePath=[[NSBundle mainBundle]pathForResource:@"1" ofType:@"wav"];
    
    NSString *resultPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"1.mp3"];
    
    NSString *result= [self toMap3FilePath:filePath resultPath:resultPath];
    
    NSLog(@"%@",result);
}


- (NSString *)toMap3FilePath:(NSString *)filePath resultPath:(NSString *)resultPath
{
    @try {
        int read, write;
        FILE *pcm = fopen([filePath cStringUsingEncoding:1], "rb");//被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);
        FILE *mp3 = fopen([resultPath cStringUsingEncoding:1], "wb");//生成的Mp3文件位置
        
        const int PCM_SIZE = 640;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE];
        unsigned char mp3_buffer[MP3_SIZE];
        
        // 初始化lame编码器
        lame_t lame = lame_init();
        lame_set_num_channels(lame,1);
        // 设置lame mp3编码的采样率 / 声道数 / 比特率
        lame_set_in_samplerate(lame, 8000);
        
        // MP3音频质量.0~9.其中0是最好,非常慢,9是最差.
        lame_set_quality(lame, 7);
        lame_set_mode(lame, MONO);
        
        // 设置mp3的编码方式
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            size_t size = (size_t)(sizeof(short int));
            read = fread(pcm_buffer, size, PCM_SIZE, pcm);
            if (read == 0) {
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            } else {
                write = lame_encode_buffer(lame,
                                                   pcm_buffer, NULL,
                                                   read,mp3_buffer,MP3_SIZE);
            }
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        // 转码完成
        return resultPath;
    }}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
