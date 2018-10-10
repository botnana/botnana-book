## WINDOWS 10 透過 MicroUSB 與 Botnana A2 連線時需先安裝 RNDIS 驅動程式

#### 0. 將 Botnana-A2 microUSB埠 與 電腦 連接。
註解︰若已嘗試過安裝 RNDIS 驅動程式，請從步驟 1 開始；否則，請直接從步驟 3 開始。


#### 1. 裝置管理員 出現如下裝置
![](./win10_1_com_port.png)

#### 2. 解除安裝裝置
![](./win10_2_remove_com_device.png)


#### 3. 修改 C:\Windows\INF\usbser.inf （[關於 usbser.inf 權限問題](#permission)）
將底下這個 
![](./win10_3_modify_usbser_inf.png)
改成如下
![](./win10_4_mark_usbser_inf_com_port.png)

#### 4. 選裝置管理員中的  Botnana-A2，並更新驅動程式
![](./win10_5_upgrade_drive.png)


#### 5. 選 瀏覽電腦上的驅動程式軟體
![](./win10_6_browse_drive.png)

#### 6. 選 讓我從電腦上的可用驅動程式清單中挑選
![](./win10_7_choose_drive.png)

#### 7. 硬體類型選 網路介面卡
![](./win10_8_select_network_interface.png)

#### 8. 製造商 / 型號︰Microsoft / USB RNDIS介面卡
![](./win10_9_select_rndis_drive.png)

#### 9. 忽略警告訊息
![](./win10_10_ignore_warning.png)

#### 10. 驅動程式更新成功
![](./win10_11_install_rndis_ok.png)

#### 11. 檢查是否出現這個裝置︰裝置管理員/網路介面卡/USB RNDIS介面卡
![](./win10_12_got_usb_rndis_interface.png)

#### 12. 連線測試（假設用 PuTTY 連線軟體）
![](./win10_13_connect_by_ssh.png)

#### 13. username / password: debian / temppwd
![](./win10_14_login.png)


### 修改權限的步驟<a id="permission"></a> ###
1. 以 C:\Windows\INF\usbstor.inf 檔案為範例
2. 假設登入 Windows 10 的使用者帳號為 felix

#### step 1. 將滑鼠移到 usbstor.inf 上，並按滑鼠右鍵，選 內容 。
#### step 2. 選 安全性 -〉 進階 。
![](./win10_15_mod_permission_0.png)

#### step 3. 按 變更 擁有者，輸入使用者帳號，按 檢查名稱，此時會顯示完整的帳號資訊，按 確定 離開。
![](./win10_15_mod_permission_1.png)
![](./win10_15_mod_permission_2.png)

#### step 4. 回到上一層後，按 套用 ，顯示警告訊息，按 確定。
![](./win10_15_mod_permission_3.png)
![](./win10_15_mod_permission_4.png)

#### step 5. 將顯示 usbstor.inf 內容的視窗全部關閉後，再重開 內容 視窗。

#### step 6. 新增 一個主體。
![](./win10_15_mod_permission_5.png)

#### step 7. 選取一個主體。
![](./win10_15_mod_permission_6.png)

#### step 8. 輸入帳號並檢查名稱，再按確定。
![](./win10_15_mod_permission_7.png)
![](./win10_15_mod_permission_8.png)

#### step 9. 修改基本權限後，按確定。
![](./win10_15_mod_permission_9.png)

#### step 10. 確認帳號已正確加入，並擁有完全控制的權限。
![](./win10_15_mod_permission_10.png)

#### step 11. 按 套用及確定，顯示安全警告的訊息，按 是。
![](./win10_15_mod_permission_11.png)
