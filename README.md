# motion-prompt-lzcapp

[Motion Prompt](https://github.com/showheyohtaki/motion-prompt) 的 LazyCat LPK 打包 —— AI 创作提示词名称库（纯静态站）。

## 形态

- 纯静态：仓库本身就是站点，`tools/build.mjs` 生成派生文件（`api/v1/**`、`assets/catalog.js` 等）
- 版本策略：上游**没有 release tag、没有镜像**，只有 main 分支持续更新
  - 每日定时构建并递增 patch 版本，自动跟随上游 main
- 站点内容：120 个词条（动效 / 运镜 / UI / 落地页 / 摄影风格），每个带动态示例与可复制提示词
- 静态根包含：`index.html`、`found.html`、`api/`、`assets/`、`packs/`、`examples/`、`make-your-own/`、`skills/`

## 结构

- `package.yml` — LPK v2 包元数据（`community.lazycat.app.motion-prompt`）
- `lzc-manifest.yml` — 静态文件直出（`file:///lzcapp/pkg/content/`）
- `lzc-build.yml` — `build.sh` + `contentdir: ./dist`
- `build.sh` — 拉上游 main → `node tools/build.mjs` → 复制站点文件到 `dist/`
- `.github/workflows/lazycat.yml` — 每日构建 + 发布喵喵商店
