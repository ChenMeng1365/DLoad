# DLoad 示例工程

这是 DLoad（基于 DeepSeek Harness 的开源 IDE 环境）自带的体验工程，用于快速验证编辑、预览、终端、运行等能力。

## 目录

```
demo/
├── README.md          ← 本文件（Markdown 预览能力）
├── src/
│   ├── hello.js       ← JavaScript：体验语法高亮 / 转到定义 / ▶ 运行
│   └── util.py        ← Python：体验语法高亮 / 终端运行 python src/util.py
└── data.csv           ← 体验 CSV 表格预览
```

## 建议体验步骤

1. 在 DSH 右侧文件树中打开本工程目录。
2. 点击 `src/hello.js`，在编辑器中查看语法高亮，`Ctrl+S` 保存。
3. 打开终端（右侧栏 Terminal），执行 `node src/hello.js`。
4. 点击 `README.md` 预览 Markdown 渲染效果。
5. 对 AI 说「给 hello.js 加一个 shuffle 函数」，观察差异审查（红绿 diff / Keep / Undo）。
6. 打开 Git 面板，体验分支视图与变更提交。

> AI生成
