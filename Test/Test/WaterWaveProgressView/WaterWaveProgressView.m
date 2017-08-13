//
//  WaterWaveProgressView.m
//  Test
//
//  Created by tangtianshuai on 2017/7/27.
//  Copyright © 2017年 tangtianshuai. All rights reserved.
//

#import "WaterWaveProgressView.h"

@interface WaterWaveProgressView ()
{
    CGFloat _wave_offsety;//根据进度计算(波峰所在位置的y坐标)
    
    CGFloat _offsety_scale;//上升的速度
    
    CGFloat _wave_move_width;//移动的距离，配合速率设置
    
    CGFloat _wave_offsetx;//偏移,animation
    
    CADisplayLink *_waveDisplaylink;
}

//边界path，水波的容器
@property (nonatomic, strong) UIBezierPath *borderPath;

//振幅，a
@property (nonatomic, assign) CGFloat wave_Amplitude;
//周期，w
@property (nonatomic, assign) CGFloat wave_Cycle;

//两个波水平之间偏移
@property (nonatomic, assign) CGFloat wave_h_distance;

//两个波竖直之间偏移
@property (nonatomic, assign) CGFloat wave_v_distance;

//水波速率
@property (nonatomic, assign) CGFloat wave_scale;

//进度
@property (nonatomic, assign) CGFloat progress;


@end

@implementation WaterWaveProgressView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        
        [self initView];
    }
    
    return self;
}

#pragma mark - initView
- (void)initView {
    
    _wave_Amplitude = self.frame.size.height/20;
    
    _wave_Cycle = 2*M_PI/(self.frame.size.width * .9);
    
    _wave_h_distance = 2*M_PI/_wave_Cycle * .65;
    
    _wave_v_distance = _wave_Amplitude * .2;
    
    _wave_move_width = 0.5;
    
    _wave_scale = 0.5;
    
    _offsety_scale = 0.03;
    
    _topColor = [UIColor colorWithRed:79/255.0 green:240/255.0 blue:255/255.0 alpha:1];
    
    _bottomColor = [UIColor colorWithRed:79/255.0 green:240/255.0 blue:255/255.0 alpha:.3];
    
    //iOSy轴是向下的，刚开始的时候_wave_offsety是最大值
    _wave_offsety = (1-_progress) * (self.frame.size.height + 2* _wave_Amplitude);
    
    CGRect rect = self.frame;
    
    rect.size.height = rect.size.width;
    
    self.borderPath = [self circlePathRect:rect lineWidth:0];
    
    self.border_fillColor = [UIColor groupTableViewBackgroundColor];
    
    [self startWave];
    
}

- (void)setProgress:(float)progress animation:(BOOL)animation
{
    self.progress=progress;
    
    if (animation)
    {
        //波浪动画，进度的实际操作范围是，多加上两个振幅的高度,到达设置进度的位置y坐标
        CGFloat end_offY = (1-_progress) * (self.frame.size.height + 2* _wave_Amplitude);
        
        _wave_offsety=end_offY;
    }
}


#pragma mark - drawRect
- (void)drawRect:(CGRect)rect
{
    if (_borderPath)
    {
        if (_border_fillColor)
        {
            [_border_fillColor setFill];
            
            [_borderPath fill];
        }
        
        if (_border_strokeColor)
        {
            [_border_strokeColor setStroke];
            
            [_borderPath stroke];
        }
        
        [_borderPath addClip];
    }
    //同时绘制两个波形图
    [self drawWaveColor:_topColor offsetx:0 offsety:0];
    
    [self drawWaveColor:_bottomColor offsetx:_wave_h_distance offsety:_wave_v_distance];
    
}

#pragma mark - draw wave
- (void)drawWaveColor:(UIColor *)color offsetx:(CGFloat)offsetx offsety:(CGFloat)offsety
{
    //波浪动画，进度的实际操作范围是，多加上两个振幅的高度,到达设置进度的位置y坐标
    CGFloat end_offY = (1-_progress) * (self.frame.size.height + 2* _wave_Amplitude);
    
    if (_wave_offsety != end_offY)
    {
        if (end_offY < _wave_offsety)
        {//上升
            _wave_offsety = MAX(_wave_offsety-=(_wave_offsety - end_offY)*_offsety_scale, end_offY);
        }
        else
        {
            _wave_offsety = MIN(_wave_offsety+=(end_offY-_wave_offsety)*_offsety_scale, end_offY);
        }
    }
    
    
    
    UIBezierPath *wave = [UIBezierPath bezierPath];
    
    for (float next_x= 0.f; next_x <= self.frame.size.width; next_x ++)
    {
        //正弦函数，绘制波形
        CGFloat next_y = _wave_Amplitude * sin(_wave_Cycle*next_x + _wave_offsetx + offsetx/self.bounds.size.width*2*M_PI) + _wave_offsety + offsety;
        
        if (next_x == 0)
        {
            [wave moveToPoint:CGPointMake(next_x, next_y - _wave_Amplitude)];
            
        }
        else
        {
            [wave addLineToPoint:CGPointMake(next_x, next_y - _wave_Amplitude)];
        }
    }
    [wave addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    
    [wave addLineToPoint:CGPointMake(0, self.bounds.size.height)];
    
    [color set];
    
    [wave fill];
}

#pragma mark - animation
- (void)changeoff
{
    _wave_offsetx += _wave_move_width*_wave_scale;
    
    [self setNeedsDisplay];
    
    //偏移较小的时候加速，节省时间
    if (_wave_offsety < 5.0)
    {
        _offsety_scale += 1.0;
    }
    
}

#pragma mark - start
- (void)startWave
{
    if (!_waveDisplaylink)
    {
        //启动同步渲染绘制波纹
        _waveDisplaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeoff)];
        
        _waveDisplaylink.preferredFramesPerSecond=30;
        
        [_waveDisplaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

#pragma mark - stop
- (void)stopWave
{
    [_waveDisplaylink invalidate];
    
    _waveDisplaylink = nil;
}


///圆形区域的path
- (UIBezierPath *)circlePathRect:(CGRect)rect
                       lineWidth:(CGFloat)width {
    //没有直接使用rect防止传入的是frame而不是试图的bounds
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [path setLineWidth:width];
    
    return path;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
