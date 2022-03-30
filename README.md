# ![梦源字体系列](image/png/title_black.png#gh-light-mode-only)![梦源字体系列](image/png/title_white.png#gh-dark-mode-only)


## 下载与安装

请前往[**发布页面**](https://github.com/Pal3love/dream-han-cjk/releases)下载最新版本的压缩包，解压后即可得到 TTF/TTC 字体文件。当前页面的“Code”按钮仅包含代码和源文件，不包含字体。

* [macOS](https://support.apple.com/en-us/HT201749)
* [Linux](https://github.com/adobe-fonts/source-code-pro/issues/17#issuecomment-8967116)
* [Windows](https://www.microsoft.com/en-us/Typography/TrueTypeInstall.aspx)
* **Windows 用户请注意**：从 Windows 10 1809 开始，Windows 会将字体文件默认安装到用户文件夹下，该行为可能会导致一部分软件找不到字体。建议在字体文件上单击右键，选择“为所有用户安装”，以全局安装。


## 协议

本字体以 [SIL Open Font License](http://scripts.sil.org/OFL) 发布，可免费用于商业用途。字体文件可二次修改。转载请注明原作者。


## 特性

[可变版思源字体](https://blog.adobe.com/en/publish/2021/04/08/source-han-sans-goes-variable)使精细的字重调节成为了可能。然而，可变字体因轮廓重叠、渲染故障、软件兼容性等原因给实际使用造成了阻碍。本项目将可变版思源字体的大量中间字重**实例化**为传统单字重字体，并合并了重叠的曲线轮廓，在保证最大兼容性的前提下，为用户提供更加丰富的字重选择。本系列字体的其他功能（如字形、竖排、kerning、多语言、异体字、曲线精度等）与思源系列保持完全一致，未做任何修改。在实际使用中，可将本系列与思源系列的对应字重无缝替换。

### 技术规格

* **样式**：线性版（L）含 14 字重，等比版（E）含 15 字重
* **字符集**：完整版含 6,5535 字符
* **异体字支持**：简、台繁、港繁、日、韩
* **OpenType 功能（竖排支持等）**：完整收录，与思源系列相同
* **Adobe 行高**：标准行高，已修复思源系列存在的行高过大问题
* **Microsoft Office Style-Link**：加粗按钮（B）链接线性版（L）的 L40 与 L70 字重，以及等比版（E）的 E6 与 E12 字重
* **Microsoft Office 字体嵌入**：支持 Word、Excel、PowerPoint 等软件的字体嵌入功能
* **封装格式**：完整版为 TrueType Collection (TTC)，子集版为 TrueType (TTF)
* **曲线格式**：二次贝塞尔曲线
* **曲线精度（UPM, units per em）**：2048，即原版 OpenType/CFF 三次曲线的无损转换
* **屏显渲染策略**：全字号亚像素抗锯齿（Windows 10 及更新版本）

### 字重
本项目以可变版[思源黑体](https://github.com/adobe-fonts/source-han-sans)和[思源宋体](https://github.com/adobe-fonts/source-han-serif)为母版，对其 `wght` 轴（字重轴）做线性（linear，也称等差）和等比（exponential）两种插值运算，共得到 14 + 15 = 29 字重。在线性版（L）中，每个字重的 `wght` 值比前一个恒定增加 50，从最细的 250 开始逐步累加，得到 L25 - L90 共计 14 字重；而在等比版（E）中，每个字重的 `wght` 值始终比前一个增加 10%，即 1.1 倍，从 250 开始逐步累乘，得到 E1 - E15 共计 15 字重。

两种插值算法带来了不同的粗度分布和迥异的视觉观感。请仔细比较下图中的左右两列文字，感受哪一边的粗度变化更加均匀：

![黑体字重展示](image/png/weight_sans_black.png#gh-light-mode-only)![黑体字重展示](image/png/weight_sans_white.png#gh-dark-mode-only)

![宋体字重展示](image/png/weight_serif_black.png#gh-light-mode-only)![宋体字重展示](image/png/weight_serif_white.png#gh-dark-mode-only)

可以看到，从粗度变化的均匀程度来看，**等比版黑体**和**线性版宋体**看起来更加均匀，而线性版黑体的字重分布挤到了粗体那一侧（粗体过多、细体过少），等比版宋体则挤到了细体那一侧（细体过多、粗体过少）。究其原因，在加粗时，黑体的横竖笔画都在变粗，而宋体只有竖笔画变粗，因此在人眼看来，黑体的加粗速度要高于宋体。在实际使用中，不妨结合设计项目的具体使用案例，挑选出最合适的字重。

梦源系列的字重与思源黑体、思源宋体的对应关系如下。有对应则表示与思源系列的字重完全相同：

| 字重轴 `wght` 取值 | 梦源线性版 L | 梦源等比版 E | 思源黑体   | 思源宋体   |
|--------------------|--------------|--------------|------------|------------|
| 250                | L25          | E1           | ExtraLight | ExtraLight |
| 275                | -            | E2           | -          | -          |
| 300                | L30          | -            | Light      | Light      |
| 302.5              | -            | E3           | -          | -          |
| 332.75             | -            | E4           | -          | -          |
| 350                | L35          | -            | Normal     | -          |
| 366.025            | -            | E5           | -          | -          |
| 400                | L40          | -            | Regular    | Regular    |
| 402.6275           | -            | E6           | -          | -          |
| 442.89025          | -            | E7           | -          | -          |
| 450                | L45          | -            | -          | -          |
| 487.179275         | -            | E8           | -          | -          |
| 500                | L50          | -            | Medium     | Medium     |
| 535.8972025        | -            | E9           | -          | -          |
| 550                | L55          | -            | _          | -          |
| 589.4869228        | -            | E10          | _          | _          |
| 600                | L60          | -            | _          | SemiBold   |
| 648.435615         | -            | E11          | _          | _          |
| 650                | L65          | -            | _          | _          |
| 700                | L70          | -            | Bold       | Bold       |
| 713.2791765        | -            | E12          | _          | _          |
| 750                | L75          | -            | _          | _          |
| 784.6070942        | -            | E13          | _          | _          |
| 800                | L80          | -            | _          | _          |
| 850                | L85          | -            | _          | _          |
| 863.0678036        | -            | E14          | _          | _          |
| 900                | L90          | E15          | Heavy      | Heavy      |


## 编译

如需在本地编译该系列字体，请参考以下指南。

### 硬盘空间

脚本将在运行过程中生成大量临时文件。所有临时文件加最终的 ZIP 压缩包共计约 30 GB 总硬盘空间。临时文件将在运行结束时自动删除。

### 平台依赖

本项目支持 Windows Linux 子系统（WSL）与 macOS 平台。请先确保以下依赖已安装：

* Python 3.8 及以上
* PyPI 包管理（`pip`）
* `pip install afdko`: [Adobe Font Development Kit for OpenType (AFDKO)](https://github.com/adobe-type-tools/afdko)
* `pip install skia-pathops`: [skia-pathops](https://github.com/fonttools/skia-pathops)
* `pip install fonttools`: [FontTools](https://github.com/fonttools/fonttools)
* `pip install toml`: [TOML](https://github.com/toml-lang/toml)
* `sudo apt install zip`（仅供 WSL，macOS 已自带）
* `sudo apt install rename`（仅供 WSL，macOS 已自带）

### 执行脚本

* WSL: `cd` 进 script 目录后，执行 `./build_fonts.sh wsl <最大并行数>`
* macOS: `cd` 进 script 目录后，执行 `./build_fonts.sh mac <最大并行数>`
* 其中，**最大并行数**决定最多并行处理的字体数量。每个字体占用约 1.5 CPU 线程和最多 1.5 GB 内存，请根据自己的电脑配置酌情选择。譬如，AMD Ryzen 9 3950X 可将此参数设为 28，在内存足够的情况下，可达 97% CPU 使用率。
* 脚本运行完成后，最终字体的 ZIP 压缩包将位于根目录下新创建的 release 目录内。运行过程中产生的临时文件将会在结束时自动删除。


## 更多信息

如需获取 Adobe 思源系列字体的设计、使用以及其他信息，请访问以下官方 GitHub 仓库：

* [思源黑体（Source Han Sans）](https://github.com/adobe-fonts/source-han-sans)
* [思源宋体（Source Han Serif）](https://github.com/adobe-fonts/source-han-serif)
* [思源等宽（Source Han Mono）](https://github.com/adobe-fonts/source-han-mono)
