# DLoad — 基于 DeepSeek Harness (DSH) 的开源 IDE 环境

DLoad 是一个用 **DeepSeek Harness**（DeepSeek 官方开源的"万物皆插件"智能体平台，GitHub `deepseek-ai/deepseek-harness`，MIT 协议）搭建起来的**开源 IDE 工作环境**：中央 AI 对话 + 右侧 Monaco 编辑器 + 终端 + Git 面板，同屏协作。

> 搭建日期：2026-11-04 · DSH 版本：0.2.1-rc.5（npm `@deepseek-ai/dsh`）· 运行于 Node.js 24

## 环境组成

| 组件 | 版本 | 来源 | 作用 |
| --- | --- | --- | --- |
| DeepSeek Harness (`@deepseek-ai/dsh`) | 0.2.1-rc.5 | npm（本地 node_modules） | 宿主平台：Web UI、会话/工作区管理、终端、插件系统、模型接入 |
| VSCodeMode (`dsh-vscode-mode`) | 0.26.0 | npm | 类 VSCode 体验：Monaco 文件编辑器（页签/差异审查/大纲）、命令面板 Ctrl+Shift+P、LSP 智能（跳转/补全/签名帮助）、断点调试（DAP）、代码片段（.code-snippets）、SVN、Markdown/Excel/PDF 编辑 |
| Git 面板 (`dsh-git-panel`) | 0.1.20 | npm | 分支管理、提交图谱、VS Code 风格并排 diff、冲突解决、文件树变更角标 |
| 智谱 GLM 免费模型 (`zhipu` 路由) | glm-5.3-flash / glm-5.3-flashx | open.bigmodel.cn | 免费 Flash 模型，用于日常轻量任务与子智能体分流，节省 DeepSeek 付费额度 |
| 官方内置（无需安装） | — | DSH 自带 | 右侧栏终端（真实 cmd.exe PTY）、工作区文件浏览器、插件市场、自动化任务、子智能体、智能体团队等 |

**目录结构**

```
DLoad/
├── start-dsh.cmd        # 一键启动（已占用 3080 端口时会提示并退出，防止重复启动）
├── stop-dsh.cmd         # 停止服务（结束监听 3080 端口的进程树）
├── package.json         # 本地依赖 + 常用脚本
├── node_modules/         # DSH 本体（npm 本地安装，不污染全局）
└── workspace/demo/      # 示例工程（js/py/csv/md），可添加为 DSH 工作区体验
```

## 启动 / 停止

```bat
:: 启动（在 DLoad 目录下双击或命令行运行）
start-dsh.cmd

:: 停止：在启动它的窗口按 Ctrl+C / 关闭窗口；任何情况下都可以用
stop-dsh.cmd

:: 重启 = 先 stop 再 start
```

说明：
- 每次启动会生成一次性访问 token（打印在启动窗口），`dsh web` 会自动带 token 打开默认浏览器，无需手动复制。
- **端口冲突提示**：若 3080 端口已有 DSH 实例在跑，`start-dsh.cmd` 会提示「已在运行」并退出（重复启动会报 `EADDRINUSE`，看起来像启动失败，其实服务一直在）。此时要么直接用已运行实例的地址（见它的启动窗口日志），要么先 `stop-dsh.cmd` 再启动。
- 启用/更新插件后需要重启一次 DSH 才生效。

## 首次使用

1. 运行 `start-dsh.cmd`，浏览器自动打开 `http://127.0.0.1:3080`。
2. **登录模型**：左下角账号菜单 → 登录 → 跳转 DeepSeek 开放平台授权（本机已授权，账号 189******65；DSH 也支持 API Key 接入 DeepSeek 或其他模型）。
3. **选模型**：输入框左下角「请选择模型」→ 选择 DeepSeek 模型与推理等级（当前默认 DeepSeek-V4.1-Flash / High）。
4. **添加工作区**：左侧「添加工作区」→ 选择本目录下的 `workspace\demo`（或任意代码目录），即可在右侧边栏看到文件树。
5. 右上角「打开右侧边栏」后可使用：
   - **工作区文件**（Ctrl+Alt+P 快速打开）
   - **Git 版本控制与提交图谱**
   - **文件编辑**（Monaco，对话与编辑同屏，AI 改动有红绿差异审查 Keep/Undo）
   - **新建终端**（Ctrl+`，真实 cmd.exe，可在「选择 Shell」处切换 PowerShell 等）
   - **Ctrl+Shift+P** 命令面板（保存/跳转定义/查找引用/插入代码片段等 45 条指令）

## 插件管理

插件装在 DSH 的 web profile（`%USERPROFILE%\.dsh\profiles\web`），与本项目解耦：

```bat
:: 查看已装插件
npm run plugin:list
:: （等价）npx dsh plugin --profile web list

:: 安装/更新/卸载插件（以 VSCodeMode 为例）
npx dsh plugin --profile web add dsh-vscode-mode@0.26.0
npx dsh plugin --profile web update dsh-vscode-mode
npx dsh plugin --profile web remove dsh-vscode-mode

:: 也可以直接在 Web UI 左侧「插件」面板里可视化安装（内置插件市场）
```

在**其他机器**复现本环境：

```bat
npm install                 # 安装 DSH 本体（Node ≥ 22；原生依赖需允许构建脚本）
npm run setup               # 安装两个 IDE 插件（dsh-vscode-mode + dsh-git-panel）
npm start
```

## 免费模型与多模型协作（MOE）

### 已接入的免费模型：智谱 GLM（2026-11-04 实测）

通过 DSH 的多提供商接入层（`dsh-llm-pi-ai`）接入智谱开放平台的免费 Flash 模型：

| 项 | 值 |
| --- | --- |
| 提供商路由 ID | `zhipu`（界面显示「智谱 GLM」） |
| API 地址 | `https://open.bigmodel.cn/api/paas/v4` |
| 协议 | OpenAI Chat Completions（兼容） |
| 模型 | `glm-5.3-flash`、`glm-5.3-flashx`（免费档，带思考链；`-flash` 后缀为智谱免费系列，其余如 glm-4.5/glm-5 均为付费，请勿误选） |
| 密钥存放 | `~/.dsh/.env` 的 `ZHIPU_API_KEY`（凭据 seam 官方通道，密钥不进任何配置文件） |
| 配置存放 | `~/.dsh/profiles/web/cordis.patch.yml`（`llm-pi-ai` 行 + `subagent-model-selection-settings` 行） |

**三种用法**：

1. **会话内手动切换**：输入框左下角模型选择器 → 智谱 GLM → 选 glm-5.3-flash，轻量任务全程零成本。
2. **子智能体分流（已配置）**：主会话用 DeepSeek（付费）做规划，把执行类杂活派给子智能体跑免费模型。已开启「子智能体模型选择」并允许 zhipu 两个模型；对主模型说「这件事派子智能体用 zhipu/glm-5.3-flash 完成」即可。设置入口：插件面板 → 子智能体 → 模型选择。
3. **智能体团队（已启用）**：插件面板 → 实验性插件「智能体团队」，主对话中让 Lead 创建带名字的队友（如 reviewer）协同干活，配合共享任务看板。

**升级/改配**：改 `cordis.patch.yml` 中 llm-pi-ai 行（模型清单、显示名等）后需重启 DSH；轮换密钥只需改 `~/.dsh/.env`，下次请求即生效（凭据 seam 热加载）。也可全程在 设置 → 模型 → 添加模型提供商 → 自定义模型 API 里可视化操作（Provider ID 填 `zhipu`，其余字段同上表）。

### 关于社区多模型插件

dsh-agent-team-gui（287★）、dsh-model-router 等多模型协作插件目前仅兼容 DSH 0.1.x，在 0.2.1-rc.5 上会被官方版本门槛拦截（实测确认）；内置的子智能体分流 + 智能体团队是当前 0.2.x 上可用的 MOE 方案。

### 本地决策模型工具（MCP，2026-11-05 接入）

DSH 内置的 `dsh-mcp-client` 以 **stdio** 方式接入 SC-TyPhon 决策服务（`..\SC-TyPhon\mcp\server.py`），在工具列表中以 `mcp__decide__*` 出现：

| 工具 | 用途 |
| --- | --- |
| `mcp__decide__decide` | 通用结构化决策：state + questions（choice/noul/score）→ 全选项概率与置信度 |
| `mcp__decide__triage` | 告警/流量研判：处置动作 + 风险档位 + 升级上报，一次前向三问 |

- 配置位置：`~/.dsh/profiles/web/cordis.patch.yml` 的 `- insert:` 条目 `mcp-decide`（注意 patch 层新增条目必须用 `insert` 包装）。
- **前置条件**：SC-TyPhon 决策服务需在运行（`..\SC-TyPhon\scripts\start-server.ps1`），否则工具调用返回"决策服务不可达"。
- 决策模型**不**接入 llm-pi-ai 模型列表：它是决策模型（`/v1/systemone` 协议、零文本生成），不是对话模型。
- DSH 运行中改 `cordis.patch.yml` 会经 HMR 自动重载（实测 mcp 子进程即时拉起）；MCP 进程随 DSH 启停。

## 已知注意事项（本机实测）

- **代理**：本机环境变量 `HTTP_PROXY/HTTPS_PROXY=127.0.0.1:7890`。`dsh plugin`（走 pnpm）经代理并发拉包会 `EADDRINUSE` 失败，而 npmmirror 镜像可直连——装插件前先清掉这两个环境变量即可。已在本 README 与实践中验证。
- **pnpm**：`dsh plugin` 依赖 pnpm，已作为本项目 devDependency（`node_modules\.bin` 内），启动脚本已自动加 PATH，不污染全局。
- **npm 11 构建脚本许可**：首次 `npm install` 后需 `npm approve-scripts @deepseek-ai/dsh-subprocess-local koffi node-pty @google/genai protobufjs` 并 `npm rebuild ...`，否则终端/子进程等原生模块不可用（本项目已完成）。
- **版本兼容门槛**：DSH 会拒绝与当前运行时不兼容的插件（例如 `dsh-terminal@0.1.1` 要求旧版 `dsh-typert-protocol`，被拦截属正常保护）；官方 0.2.x 已内置终端侧栏，无需该插件。
- DSH 处于开发者预览阶段，0.2 → 0.3 可能存在破坏性变更；升级 DSH 后插件请同步 `update`。

## 验证记录（2026-11-04）

- 服务启动：`http://127.0.0.1:3080` 正常响应（401 未带 token / 200 带 token）。
- 插件面板显示 **dsh-git-panel**、**VSCodeMode** 均已安装且启用。
- DeepSeek 账号授权完成，模型 DeepSeek-V4-Pro（推理等级 High）可选。
- 右侧边栏四个 IDE 组件（工作区文件 / Git / Monaco 文件编辑 / 终端）全部渲染。
- 终端实测：右侧栏成功拉起真实 cmd.exe（PTY，node-pty），工作目录为默认工作区。
- 免费模型链路实测：智谱 API 直连成功（glm-5.3-flash 真实推理输出）；DSH 重启后 `/api/session/modelCatalog` 返回 `zhipu` 提供商与 glm-5.3-flash / glm-5.3-flashx 两个模型。
- 子智能体模型选择已启用并允许 zhipu 免费模型（配置经 `--dump-config` 校验）。

## 开源许可

- 本项目（脚本与配置）：MIT（见 [LICENSE](LICENSE)）
- DeepSeek Harness：MIT（`github.com/deepseek-ai/deepseek-harness`）
- dsh-vscode-mode：MIT（`github.com/Lenonss/DSH_VsCodeMode`）
- dsh-git-panel：见其仓库（npm 发布版）

> AI生成
