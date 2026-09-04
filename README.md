# My Hugo Blog

个人博客：**Hugo 静态网站 + GitHub Pages 免费托管**。

| 仓库 | 用途 | 可见性 |
|---|---|---|
| `xiaoxiaowei666/My_Hugo` | 博客源码（本仓库：hugo.toml、content、主题、脚本） | Private |
| `xiaoxiaowei666/xiaoxiaowei666.github.io` | 编译后的网页成品（也就是线上网站） | Public |

线上地址：<https://xiaoxiaowei666.github.io>

## 为什么是两个仓库？

GitHub Pages 只能托管**静态网页文件**（HTML/CSS/JS），而 Hugo 的源码（Markdown、配置）必须先用 `hugo` 命令“编译”成网页。

于是两个仓库分工——一个存原材料，一个存成品：

```
本仓库（My_Hugo 的工作副本）                xiaoxiaowei666.github.io 仓库
├── hugo.toml   ← 配置                        │
├── content/    ← 文章源码（Markdown）        │  hugo 编译后的文件
├── themes/     ← 主题                        │  （HTML、CSS…）
├── publish.sh  ← 一键发布脚本 ── sh publish.sh ──► public/  ← git clone 的成品仓库副本
└── public/     ← git 忽略，不入本仓库
```

关键点：`public/` 目录**内部是一个独立的 Git 仓库**（是 `xiaoxiaowei666.github.io` 克隆到本地的副本），它和本仓库是平行的两个仓库，不是同一个仓库的两个远程。

## 日常写文章

```bash
# 1. 新建文章（会在 content/blog/ 下生成模板）
hugo new blog/我的文章.md

# 2. 用编辑器写内容，注意 front matter 中 draft 要设为 false 才会发布

# 3. 一键发布（构建 + 提交 public + 推送到线上）
sh publish.sh "写完一篇文章"

# 4. 本地预览（可选，浏览器打开 http://localhost:1313）
hugo server -D
```

> Windows 下用 `sh publish.sh`，别用 `./publish.sh`（避免脚本权限坑）。
> `publish.sh` 不带参数也会发布，提交信息自动带时间戳。

## 从零恢复环境（换电脑 / 重装）

```bash
# 1. 克隆源码仓库（Private，需 SSH key 已配置）
git clone git@github.com:xiaoxiaowei666/My_Hugo.git
cd My_Hugo

# 2. 装 Hugo（https://gohugo.io/installation/）
hugo version

# 3. 重建 public/ —— 克隆成品仓库到这个目录（publish.sh 依赖它）
rm -rf public
git clone git@github.com:xiaoxiaowei666/xiaoxiaowei666.github.io.git public

# 4. 本地预览或直接发布
hugo server -D
# 或 sh publish.sh "欢迎回来"
```

## 几个常见坑

- **发布后线上 404**：检查 `xiaoxiaowei666.github.io` 仓库 Settings → Pages，Source 选 `Deploy from a branch` + `main` + `/ (root)`。
- **忘了 clone public/ 就运行脚本**：`sh publish.sh` 会因 `public` 里没有 `.git` 而报错，先做上面“恢复环境”第 3 步。
- **改了 `hugo.toml`（标题、菜单等）没生效**：改完要重新发布（`hugo` 会重新生成所有页面）。
- **`public/` 内容误入本仓库**：已被 `.gitignore` 排除；如需强制检查用 `git status`，正常不应出现 `public/`。
- **publish.sh 报 `\r` 相关错误**：`.gitattributes` 已强制脚本使用 LF 换行，若本地仍异常，用 `git add --renormalize .` 修正一次。

## 结构备忘

```
hugo.toml            网站总配置（baseURL、标题、菜单、permalinks…）
content/blog/        文章目录（Markdown）
themes/hugo-profile/ 主题（直接入库，非 submodule）
archetypes/          新建文章时的模板
publish.sh           一键构建 + 发布脚本
public/              构建产物目录 = github.io 仓库副本（git 忽略）
```
