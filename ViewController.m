//
//  ViewController.m
//  CFNetWorkDemo
//
//  Created by Donald on 17/2/13.
//  Copyright © 2017年 Susu. All rights reserved.
//

#import "ViewController.h"
#import <CFNetwork/CFNetwork.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>

@interface ViewController ()


@end

static void TCPServerConnectCallBack(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info)
{
    NSLog(@"%d",type);
    
}

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * strAddress = @"127.0.0.1";
    
    // CFSocketContext存放一些CFSocketRef的相关信息
    CFSocketContext CTX = {0,(__bridge void *)(self), NULL, NULL, NULL};
    
    CFSocketRef socket = CFSocketCreate(kCFAllocatorDefault, AF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketDataCallBack, TCPServerConnectCallBack, &CTX);
    if (socket != nil) {
        struct sockaddr_in addr4;   // IPV4
        memset(&addr4, 0, sizeof(addr4));
        addr4.sin_len = sizeof(addr4);
        addr4.sin_family = AF_INET;
        addr4.sin_port = htons(8888);
        addr4.sin_addr.s_addr = inet_addr([strAddress UTF8String]);  // 把字符串的地址转换为机器可识别的网络地址
        
        // 把sockaddr_in结构体中的地址转换为Data
        CFDataRef address = CFDataCreate(kCFAllocatorDefault, (UInt8 *)&addr4, sizeof(addr4));
        CFSocketConnectToAddress(socket, // 连接的socket
                                 address, // CFDataRef类型的包含上面socket的远程地址的对象
                                 20  // 连接超时时间，如果为负，则不尝试连接，而是把连接放在后台进行，如果_socket消息类型为kCFSocketConnectCallBack，将会在连接成功或失败的时候在后台触发回调函数
                                 );
    }
    CFRunLoopRef cRunRef = CFRunLoopGetCurrent();    // 获取当前线程的循环
    // 创建一个循环，但并没有真正加如到循环中，需要调用CFRunLoopAddSource
    CFRunLoopSourceRef sourceRef = CFSocketCreateRunLoopSource(kCFAllocatorDefault, socket, 0);
    CFRunLoopAddSource(cRunRef, // 运行循环
                       sourceRef,  // 增加的运行循环源, 它会被retain一次
                       kCFRunLoopCommonModes  // 增加的运行循环源的模式
                       );
    CFRelease(sourceRef);
    
    
    


    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
