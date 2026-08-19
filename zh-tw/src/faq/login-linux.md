# 登入 Linux 系統


--------------------
### 登入

使用 Type-C 傳輸線連結 BN-B3A 的 Type-C (OTG) 接口到電腦的 USB port，再以 ssh 登入，

    ssh debian@192.168.7.2

密碼為 temppwd

下列命令會取得不受限制的 root shell，必須由獲授權管理員執行。程序若提供明確的
`sudo <命令>`，應優先只執行該命令；只有核准的維修工作才可使用 root shell，完成後
應立即退出：

    sudo su
