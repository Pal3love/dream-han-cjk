# ![开源字体系列](image/png/title-black.png#gh-light-mode-only)![开源字体系列](image/png/title-white.png#gh-dark-mode-only)


## 下载与安装

请前往[**发布页面**](https://github.com/Pal3love/open-han-cjk/releases)下载最新版本的压缩包，解压后即可得到 ttf/ttc 字体文件。当前页面的“Code”按钮仅包含代码和源文件，不包含字体。

* [macOS](https://support.apple.com/en-us/HT201749)
* [Linux](https://github.com/adobe-fonts/source-code-pro/issues/17#issuecomment-8967116)
* [Windows](https://www.microsoft.com/en-us/Typography/TrueTypeInstall.aspx)
* **Windows 用户请注意：**从 Windows 10 1809 开始，Windows 会将字体文件默认安装到用户文件夹下，该行为可能会导致一部分软件找不到字体。建议在字体文件上单击右键，选择“为所有用户安装”，以全局安装。


## 特性

[可变版思源字体](https://blog.adobe.com/en/publish/2021/04/08/source-han-sans-goes-variable)使精细的字重调节成为了可能。然而，可变字体因轮廓重叠、渲染故障、软件兼容性等原因给实际使用造成了阻碍。本项目将可变版思源字体的大量中间字重**实例化**为传统单字重字体，并合并了重叠的曲线轮廓，在保证最大兼容性的前提下，为用户提供更加丰富的字重选择。本系列字体的其他功能（字形、竖排、kerning、多语言、异体字、曲线精度等）与思源系列完全一致，实际使用时可在两者之间无缝替换。

### 技术规格

* 样式：W25 - W90，14 字重
* 字符集：完整版为 6,5535 字符
* 异体字支持：简、台繁、港繁、日、韩
* OpenType 功能（竖排支持等）：完整收录，与思源系列相同
* 封装格式：完整版为 TrueType Collection (TTC)，子集版为 TrueType (TTF)
* Microsoft Office Style-Link：加粗按钮（B）链接 W40 与 W70 字重
* Microsoft Office 字体嵌入：完全兼容 Word、Excel、PowerPoint 等软件的字体嵌入功能
* 曲线格式：二次贝塞尔曲线
* 曲线精度（UPM, units per em）：2048，**即原版 OpenType/CFF 三次曲线的无损转换**
* 屏显渲染策略：全字号亚像素抗锯齿（Windows 10）

### 字重
本系列以可变版[思源黑体](https://github.com/adobe-fonts/source-han-sans)和[思源宋体](https://github.com/adobe-fonts/source-han-serif)为母版，以 50 `wght` 单位为步进，插值得到 14 个字重（W25 - W90）：

![字重展示](image/png/weights-black.png#gh-light-mode-only)![字重展示](image/png/weights-white.png#gh-dark-mode-only)

本系列字体的字重与思源黑体、思源宋体的对应关系如下，有对应字重则代表与思源系列完全相同：

| 开源系列 | 思源黑体   | 思源宋体   |
|----------|------------|------------|
| W25      | ExtraLight | ExtraLight |
| W30      | Light      | Light      |
| W35      | Normal     | 无对应     |
| W40      | Regular    | Regular    |
| W45      | 无对应     | 无对应     |
| W50      | Medium     | Medium     |
| W55      | 无对应     | 无对应     |
| W60      | 无对应     | SemiBold   |
| W65      | 无对应     | 无对应     |
| W70      | Bold       | Bold       |
| W75      | 无对应     | 无对应     |
| W80      | 无对应     | 无对应     |
| W85      | 无对应     | 无对应     |
| W90      | Heavy      | Heavy      |


## 编译

如需在本地编译该系列字体，请参考以下指南。

### 电脑配置

为加快编译速度，编译脚本会同时编译 14 个字体文件，并在过程中产生大量中间文件。推荐 4 核及以上处理器、> 10 GB 总内存和 > 12 GB 磁盘空间。

### 平台依赖

本项目支持 Windows Linux 子系统（WSL）平台与 macOS 平台。请先确保以下依赖已安装：

* Python 3 (>= 3.8)
* PyPI 包管理
* `pip install afdko`: [Adobe Font Development Kit for OpenType (AFDKO)](https://github.com/adobe-type-tools/afdko)
* `pip install skia-pathops`: [skia-pathops](https://github.com/fonttools/skia-pathops)
* `pip install fonttools`: [FontTools](https://github.com/fonttools/fonttools)
* `pip install toml`: [TOML](https://github.com/toml-lang/toml)
* `sudo apt install zip`（macOS 已自带）
* `sudo apt install rename`（macOS 已自带）

### 执行编译脚本

* WSL: `cd` 进 script 目录后，执行 `./build_fonts_wsl.sh`
* macOS: `cd` 进 script 目录后，执行 `./build_fonts_mac.sh`
* 运行完成后，最终的 ZIP 压缩包位于 open-han-cjk 根目录下新创建的 release 目录内。运行过程中产生的临时文件将会在结束时自动删除。


## 更多信息

如需获取 Adobe 思源系列字体的设计、编译、下载以及其他信息，请访问官方 GitHub 仓库。

* 思源黑体（Source Han Sans）：https://github.com/adobe-fonts/source-han-sans
* 思源宋体（Source Han Serif）：https://github.com/adobe-fonts/source-han-serif
* 思源等宽（Source Han Mono）：https://github.com/adobe-fonts/source-han-mono
