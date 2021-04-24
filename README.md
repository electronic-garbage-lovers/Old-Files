# Old-Files
老王群老资料汇总（除了屏的）

  
### IPFS上的资料存档

IPNS地址: k51qzi5uqu5dh01e3d53rgy4gcov4217fvru7dnx502y35fdbehw1bllkukul6  
在魔法上网的条件下,可以试着访问 https://gateway.ipfs.io/ipns/k51qzi5uqu5dh01e3d53rgy4gcov4217fvru7dnx502y35fdbehw1bllkukul6 来看到所有文件。这个过程可能会非常慢(10分钟以上)

##### 这个资料存档怎么用?

1. 如果你可以访问上面的网址, 直接访问它, 之后找到上方的这里
  ![image](https://user-images.githubusercontent.com/20812356/115949641-001b2600-a509-11eb-9859-91cbe0b1fa3e.png)

2. 复制下方Qm开头的那一串数值.  
3. 下载一个ipfs客户端(IPFS Desktop), 点击文件-导入-ipfs路径, 把这个数值粘贴进去, 之后点导入.
4. 完成了, 你现在可以浏览所有的老王文件了. 由于分布式网络的原因, 加载速度可能很慢. IPFS会慢慢的把这些文件同步到本地, 如果你感觉浏览起来很慢, 可以睡个觉什么的, 等待同步完成. 你不需要干什么特别的事.

5. 如果你不能魔法上网...那么先装上IPFS Desktop, 之后找到安装目录中的ipfs.exe 例如`C:\Users\user\AppData\Local\Programs\IPFS Desktop\resources\app.asar.unpacked\node_modules\go-ipfs\go-ipfs\ipfs.exe`, 在包含ipfs.exe的那个文件夹按住shift右键选择打开命令提示符或者windows powershell, 输入 `./ipfs.exe  name  resolve k51qzi5uqu5dh01e3d53rgy4gcov4217fvru7dnx502y35fdbehw1bllkukul6` 之后等几分钟(分布式网络就这点不好, 真的太慢) 之后会弹出Qm开头的一串数值. 复制它之后返回第三步正常进行吧.
6. 就像BT下载一样, 建议有条件的人都同步一下, 这样将大大加速其它人的同步速度.
