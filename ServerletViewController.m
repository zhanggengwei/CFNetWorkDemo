//
//  ServerletViewController.m
//  CFNetWorkDemo
//
//  Created by Donald on 17/2/14.
//  Copyright © 2017年 Susu. All rights reserved.
//

#import "ServerletViewController.h"
#import <CFNetwork/CFNetwork.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>
@interface ServerletViewController ()
{
    CFSocketRef _socket;
    CFWriteStreamRef outputStream;
    CFReadStreamRef inputStream;
}
@end

static void TCPServer(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info)

{
    NSLog(@"%ld",type);
    
}

@implementation ServerletViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * strAddress = @"127.0.0.1";
    
    // CFSocketContext存放一些CFSocketRef的相关信息
    CFSocketContext CTX = {0,(__bridge void *)(self), NULL, NULL, NULL};
    
    
    _socket = CFSocketCreate(kCFAllocatorDefault, AF_INET, SOCK_STREAM,IPPROTO_TCP, kCFSocketDataCallBack, TCPServer, &CTX);
    if(_socket)
    {
        struct sockaddr_in addr4;   // IPV4
        memset(&addr4, 0, sizeof(addr4));
        addr4.sin_len = sizeof(addr4);
        addr4.sin_family = AF_INET;
        addr4.sin_port = htons(4444);
        addr4.sin_addr.s_addr = inet_addr([strAddress UTF8String]);
        
        
    }
    
    
    // Do any additional setup after loading the view.
}

// socket回调函数，同客户端

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
