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

[可变版思源字体](https://blog.adobe.com/en/publish/2021/04/08/source-han-sans-goes-variable)使精细的字重调节成为了可能。然而，可变字体因轮廓重叠、渲染故障、软件兼容性等原因给实际使用造成了阻碍。本项目将可变版思源字体的大量中间字重**实例化**为传统单字重字体，合并了重叠的曲线轮廓，在保证最大兼容性的前提下，提供更加细腻、丰富的字重选择。此外，本项目修复了思源系列广泛存在的 Adobe 行高过大问题。本系列字体的其他功能（如字形、竖排、kerning、多语言、异体字、曲线精度等）与思源系列保持完全一致，未做任何修改。

### 技术规格

* **样式**：W1 - W27 共计 27 字重
* **字符集**：完整版含 6,5535 字符
* **异体字支持**：简、台繁、港繁、日、韩
* **OpenType 功能（竖排支持等）**：完整收录，与思源系列相同
* **Adobe 行高**：标准行高，已修复思源系列存在的行高过大问题
* **Microsoft Office Style-Link**：加粗按钮 B 链接黑体的 W12 与 W22 字重，以及宋体的 W7 与 W20 字重
* **Microsoft Office 字体嵌入**：支持 Word、Excel、PowerPoint 等软件的字体嵌入功能
* **封装格式**：完整版为 TrueType Collection (TTC)，子集版为 TrueType (TTF)
* **曲线格式**：二次贝塞尔曲线
* **曲线精度（UPM, units per em）**：2048，即原版 OpenType/CFF 三次曲线的无损转换
* **屏显渲染策略**：全字号亚像素抗锯齿（Windows 10 及更新版本）

### 字重

本项目以可变版[思源黑体](https://github.com/adobe-fonts/source-han-sans)和[思源宋体](https://github.com/adobe-fonts/source-han-serif)为母版，对其字重轴 `wght` 进行插值运算，提取中间字重。插值算法经过了如下考量：

1. 暴露给最终用户的 `wght` 轴经 Adobe 添加的 `avar` 表人工干预，导致字重随 `wght` 非线性增大（参见 [issue #6](https://github.com/Pal3love/dream-han-cjk/issues/6)）。插值算法需排除 `avar` 表的干扰；
2. 加粗时，黑体和宋体的黑度变化不同：黑体的横竖笔画同时变粗，而宋体只有竖笔画变粗，因此在人眼看来，黑体的加粗速度要高于宋体，且其细体字重比粗体对粗度的变化更为敏感。简单的线性插值适用于宋体，但如果直接用在黑体上，就会导致细体字重被粗体“挤压”。

### 插值算法

1. 绕开思源可变源文件中的 `avar` 表，确保插值算法不受人工预设值干扰；
2. 梦源宋体采用线性插值（linear interpolation）：从最细端 250 开始，粗度每步增加常数 25 ，直到最粗端 900，得到 250-275-300-...900 共计 27 字重；
3. 梦源黑体采用二次多项式插值（quadratic interpolation）：从最细端 250 开始，粗度每步增加 19.4 + *f* ^ 2；其中，系数 *f* 的起始值为 1，每一步增大 0.1；以此类推，直到最粗端 900，得到 250-270.4-291.01-...-900 共计 27 字重。

因为插值算法绕过了思源可变内置的 `avar` 表，所以本项目采用的 `wght` 值与思源可变字体没有任何关联，也没有与思源在数值上完美对应的字重。在实际使用中，可对比思源字体找出梦源字体最接近的字重。

![字重展示](image/png/weight_black.png#gh-light-mode-only)![字重展示](image/png/weight_white.png#gh-dark-mode-only)


## 编译

如需在本地编译该系列字体，请参考以下指南。

### 硬盘空间

脚本将在运行过程中产生大量临时文件。临时文件加最终的 ZIP 压缩包共计约 30 GB 总硬盘空间。临时文件将在运行结束时自动删除。

### 平台依赖

本项目支持 Windows Linux 子系统（WSL）、Linux x86-64（带有 Wine）与 macOS 平台。请先确保以下依赖已安装：

* Python 3.8 及以上
* PyPI 包管理（`pip`）
* `pip install afdko`: [Adobe Font Development Kit for OpenType (AFDKO)](https://github.com/adobe-type-tools/afdko)
* `pip install skia-pathops`: [skia-pathops](https://github.com/fonttools/skia-pathops)
* `pip install fonttools`: [FontTools](https://github.com/fonttools/fonttools)
* `pip install toml`: [TOML](https://github.com/toml-lang/toml)
* 使用包管理器安装 `zip`，如 `sudo apt install zip`（仅供 WSL 和 Linux；macOS 已自带）

### 执行脚本

* WSL: `cd` 进 script 目录后，执行 `./build_fonts.sh wsl <最大并行数>`
* Linux: `cd` 进 script 目录后，执行 `./build_fonts.sh linux <最大并行数>`
* macOS: `cd` 进 script 目录后，执行 `./build_fonts.sh mac <最大并行数>`
* 其中，**最大并行数**决定最多并行处理的字体数量。每个字体占用约 1.5 CPU 线程和最多 1.5 GB 内存，请根据自己的电脑配置酌情选择。譬如，AMD Ryzen 9 3950X 可将此参数设为 28，在内存足够的情况下，可达 97% CPU 使用率。
* 脚本运行完成后，最终字体的 ZIP 压缩包将位于根目录下新创建的 release 目录内。运行过程中产生的临时文件将会在结束时自动删除。


## 更多信息

如需获取 Adobe 思源系列字体的设计、使用以及其他信息，请访问以下官方 GitHub 仓库：

* [思源黑体（Source Han Sans）](https://github.com/adobe-fonts/source-han-sans)
* [思源宋体（Source Han Serif）](https://github.com/adobe-fonts/source-han-serif)
* [思源等宽（Source Han Mono）](https://github.com/adobe-fonts/source-han-mono)
