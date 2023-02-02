# PKGkeeper
一个OpenWRT自动脚本，以改善固件更新导致的软件包丢失及死灰复燃现象。

###### 但凡有成品软件包能装，绝不自行编译。低碳减排，人人有责 x(

A openwrt auto script, install &amp; remove packages after sysupgrade, keep the installed-list same as before.

![image](https://user-images.githubusercontent.com/20614068/216333739-af07aee7-05a5-4fc8-8637-f301a3c2a086.png)
```
root@OpenWRT:~# pkgkeep
*  用法:
*    run --- 手动运行（无参数状态下默认命令，如果开机没网导致脚本运行失败，可以使用）.
*    on  --- 启用脚本（默认状态下关闭，无法执行run命令）.
*    off --- 禁用脚本（但处于功能需要，并不禁用开机启动项）
*  force --- 强制运行（可能会用到？）

*  Usage:
*    run --- Run manually.
*    on  --- Enable the auto install & remove after sysupgrade.
*    off --- Disable the auto install & remove.
*  force --- Force run scripts although not the first boot after sysupgrade.
```

如果在你的软件源里没有你要装的软件，那么你可以使用本地安装，把每个软件包的绝对路径写到/etc/config/pkgkeep/local.list文件中即可，一行一个路径。
