# wfb-ng-termux
wfb-ng run in termux,driven by libusb without root 

## 使用方式
### 依赖
需要安装zerotermux和termux-api,从而启用termux访问usb设备的功能;
安装以及换源完成后运行如下脚本安装依赖环境。
```
apt install termux-usb libusb build-essential cmake libpcap libsodium libspdlog
```

### 编译
```
cmake .
make
```

### 运行
1. 插入网卡后，不要让别的app访问，在termux中执行termux-usb -l ，获取到usb设备列表；
2. 执行termux -r '上一步的设备',允许termux访问
3. 执行`termux-usb -e ./wfb_tx.sh 上一步的设备` 即可运行。wfb_tx.sh中的c参数即为信道，E参数为txpower功率级别,其它参数和wfb_tx的参数一致。
4. nc -u 连接5600端口，即可测试发送udp数据。

## TODO
- [*] txpower修改后的测试 
- [ ] libusb调用方式修改为使用submit_transfer
- [ ] submit_transfer是否需要建立一个池子防止爆内存等场景?
- [ ] 内存优化：是否需要减少拷贝场景?
