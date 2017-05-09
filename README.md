# TPFDebugTool

[![CI Status](http://img.shields.io/travis/pzhtpf/TPFDebugTool.svg?style=flat)](https://travis-ci.org/pzhtpf/TPFDebugTool)
[![Version](https://img.shields.io/cocoapods/v/TPFDebugTool.svg?style=flat)](http://cocoapods.org/pods/TPFDebugTool)
[![License](https://img.shields.io/cocoapods/l/TPFDebugTool.svg?style=flat)](http://cocoapods.org/pods/TPFDebugTool)
[![Platform](https://img.shields.io/cocoapods/p/TPFDebugTool.svg?style=flat)](http://cocoapods.org/pods/TPFDebugTool)

## Description

一个iOS 端的网络抓包工具

TPFDebugTool is a debugging tool to monitor the network, view the log, collect crash log.

## Usage

 #import "JxbDebugTool.h"

 [[JxbDebugTool shareInstance] setMainColor:kColorWithRGB(0xff755a)]; //设置主色调
 [[JxbDebugTool shareInstance] enableDebugMode];//启用debug工具
 
 [JxbDebugTool shareInstance].arrOnlyHosts = @[@"www.baidu.com",@"www.qq.com"];  // 设置要监听的域名

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

TPFDebugTool is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "TPFDebugTool"
```

## Author

pzhtpf, pftian@yaduo.com

## License

TPFDebugTool is available under the MIT license. See the LICENSE file for more info.
