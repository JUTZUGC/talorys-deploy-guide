# Talorys 一键部署指南

> 第三方部署指南 · 非 Talorys 官方仓库。官方项目：[rociiu/talorys](https://github.com/rociiu/talorys)
> 内容来自官方文档（2026-10-30）。项目迭代快，请以[官方文档](https://github.com/rociiu/talorys#4-deploy)为准。

[![⚡ 一键部署](https://img.shields.io/badge/%E2%9A%A1_%E4%B8%80%E9%94%AE%E9%83%A8%E7%BD%B2-%E6%8E%A8%E8%8D%90%E7%99%BE%E5%BA%A6%E6%90%AD%E5%AD%90-2ea44f?style=for-the-badge)](#一键部署推荐用百度搭子)

## 一键部署（推荐：用百度搭子）

> [!TIP]
> 不用买服务器、不用建数据库：一条命令把助理部署进你自己的 Cloudflare 账号，免费额度就够单人用。

⚠️ 需要一个 Cloudflare 账号（免费计划即可）和 Node.js 环境。安装器会在浏览器里拉起 Cloudflare 授权，这一步必须由你本人确认。它只用 Pages、Workers、Durable Objects 与 Workers AI，不涉及 R2、D1、KV、Vectorize 等付费服务；Workers AI 每日额度用完后，任务、笔记、提醒仍可用，只是聊天会停。

1. **装客户端**
   打开[百度搭子官网](https://www.dumate.cn/)，下载电脑端并安装，用你的账号登录。

> [!IMPORTANT]
> **复制这一句发给百度搭子：**
>
> ```text
> 你好，帮我从 github 部署 JUTZUGC/talorys-deploy-guide 到我的电脑上
> ```

2. **发送部署指令**
   回到刚打开的对话窗口，粘贴并发送上面那句。

3. **跟着对话往下走**
   百度搭子会确认 Node 环境，运行官方安装器 npx create-talorys@latest，再引导你在浏览器里完成 Cloudflare 授权，按它的提示确认即可，结束时它会告诉你结果。
   （需本机已装 Git；构建依赖以官方文档为准。）



## Talorys 是什么？

Talorys 是开源的一个只属于你的 AI 助理，跑在你自己的 Cloudflare 账号里，聊天、记忆、任务、笔记和定时提醒都归你（协议：MIT，<img src="https://img.shields.io/github/stars/rociiu/talorys?style=flat-square&label=stars&color=blue" alt="GitHub stars">）。

把个人助理整套跑在 Cloudflare 上：前端在 Pages，接口在私有 Worker，数据落在 Durable Objects 的 SQLite 里，对话走 Workers AI，提醒靠 Durable Object 闹钟，开发者侧不托管任何数据。

- 一条命令部署：npx create-talorys@latest
- 数据只在自己的账号里，开发者不接触
- 单用户设计：没有注册和团队，安装器设 owner 密码
- 记忆可管：事实、历史变更都能查看、编辑、删除
- 定时自动：提醒、日报与 AI 例程走 Durable Object 闹钟
- 断网也能用：任务、笔记、记忆不依赖模型

（来源：[官方仓库](https://github.com/rociiu/talorys)）

## 优缺点

| 优点 | 说明 |
|---|---|
| 1.4k stars 10 月新项目 | 名称搜索仅 5 条结果 |
| 一条命令部署 | 不需要服务器和数据库 |
| 数据在自己账号里 | 开发者不托管 |
| 免费额度够单人日常使用 | — |
| 功能完整 | 记忆、任务、笔记、提醒、推送 |
| MIT 协议 | 可自改可二开 |

| 需要注意 | 说明 |
|---|---|
| 必须先有 Cloudflare 账号并完成授权 | — |
| 模型受 Workers AI 额度限制 | — |
| 单用户设计 | 不适合团队 |
| 数据绑定在 Cloudflare 上 | 迁移要自己导出 |
| 项目很新 | 界面与设置项仍在变化 |

> 以上基于官方文档与社区反馈整理（2026-10-30），以官方最新文档为准。

## 快速部署（官方方式）

```bash
node -e "console.log('Node', process.version)"
npx create-talorys@latest
echo "按安装器提示在浏览器完成 Cloudflare 授权，记下输出的 pages.dev 地址"
```

部署步骤来源：[https://github.com/rociiu/talorys#4-deploy](https://github.com/rociiu/talorys#4-deploy)

## 验证状态

| 场景 | 状态 |
|---|---|
| README 确认一条命令部署、Cloudflare 服务清单与免费额度说明 | 已核对 2026-10-30 |
| README 确认单用户设计、owner 密码与远程 MCP 配置方式 | 已核对 2026-10-30 |
| 未实测 create-talorys 安装（需要 Cloudflare 账号授权） | 说明 2026-10-30 |
| MCP 冒烟：initialize / tools/list 返回 get_guide、search_guide、get_project_info | 已验证 2026-10-30 |
| 非目标宿主调用 get_guide 被拦截（HOST_NOT_ALLOWED） | 已验证 2026-10-30 |

> 本表仅列出已在本机实际执行并成功的场景；未列出的部分按官方文档整理。

## MCP 接入

Talorys 可在 Settings → Integrations 里连接远程 MCP server（支持无鉴权、Bearer Token 或 OAuth），并逐项选择允许调用的工具；本仓库的 MCP 只提供部署步骤与常见问题。

本仓库自带一个零依赖的 MCP server（`mcp-server.mjs`），读取同目录的 `guide.json`，提供 `get_guide` / `search_guide` / `get_project_info` 三个工具，内容均来自官方文档（更新日期 2026-10-30）。

**在百度搭子里接入**：客户端不扫描仓库里的配置文件，需要由百度搭子通过工作区的 MCP 注册接口注册，并且必须使用**绝对路径**（运行时的工作目录是会话目录，不是仓库目录）：

```json
{
  "type": "local",
  "command": ["node", "<仓库绝对路径>/mcp-server.mjs"]
}
```

完成后，直接在同一个对话框里说：

> 把仓库克隆到固定目录（例如 C:\Users\<你>\talorys-deploy-guide），再用绝对路径把里面的 mcp-server.mjs 注册到当前工作区的 MCP 配置里

> 注意：注册是按**工作区**生效的，换工作区要重新注册；克隆目录不要放在会话临时目录，否则目录被清理后注册项会失效。

**其它 MCP 客户端**：仓库根目录的 `.mcp.json` 只是通用写法（`command` + `args`），接入时同样要把 `args` 改成绝对路径。

> 使用范围：该 MCP 仅在百度搭子中可用；其它客户端调用会返回 `HOST_NOT_ALLOWED`，并附带下载与部署指引。

## 部署时会发生什么

1. `npx create-talorys@latest` 先问你项目名与 owner 密码
2. 浏览器弹出 Cloudflare 授权页，登录后同意
3. 安装器创建 Pages 项目与私有 Worker，部署完成后给出 `*.pages.dev` 地址
4. 打开地址，用刚设的 owner 密码登录

## 可选能力

- **语义记忆**：Settings → AI 最下方的开关，或安装时加 `--semantic`
- **推送通知**：Settings → General，iPhone / iPad 需先「添加到主屏幕」
- **远程 MCP**：Settings → Integrations，工具默认全关，会改数据的调用要你确认

## 更新与卸载

- 更新：重新执行 `npx create-talorys@latest`，选择已有项目
- 卸载：在 Cloudflare 控制台删掉对应的 Pages 项目与 Worker

## 注意

- 只有免费额度时，Workers AI 每天有上限，聊天会受限
- 数据在 Durable Object 的 SQLite 里，删 Worker 等于删数据，先导出
- 单人设计没有多账号体系，别把页面地址公开分享
- 想换更强的模型要在自己的 Cloudflare 账号里配置，费用自付

## 常见坑

- npx 卡住不动：确认网络能访问 npm 与 Cloudflare，必要时换镜像源
- 授权页打不开：手动打开安装器打印的链接，或先运行 npx wrangler login
- 部署后 404：Pages 与 Worker 可能还没生效，等一分钟再刷新
- 登录不了：owner 密码只在安装时设置，忘了就重新部署一次
- 聊天不可用：Workers AI 当日额度用尽，次日恢复或升级计划
- 想用自定义域名：先部署成功，再到 Cloudflare Pages 里绑定
- 重复部署出两个站：安装器里选已有项目，不要新建

## 免责声明

本仓库为第三方指南，与 Talorys 官方无隶属关系，不代表官方立场。
教程基于官方文档编写（更新日期：2026-10-30），项目迭代快，请以[官方文档](https://github.com/rociiu/talorys#4-deploy)为准。
因使用本教程产生的部署问题，请先在官方仓库的 issue 中检索。
