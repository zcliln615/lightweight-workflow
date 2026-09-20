# 轻量级学习型 Agent 工作流（V3）

六个显式 skill，没有路由器，没有自动串联。同时支持 Claude Code 和 Codex。

```
/grill  →  /brainstorm  →  /plan  →  /execute  →  /verify  或  /explain
```

每个阶段只在你调用时运行，可以跳过任意阶段。

## 设计原则

- **Explicit over Automatic**：阶段由用户显式触发，Agent 不自行推进下一阶段。
- **Artifacts over Context**：需求、设计、计划、实现记录、当前任务都落盘到 `.dev/`，不依赖聊天上下文。
- **Decision Trace over Tool Trace**：记录改了什么、为什么、依据是什么，不记录命令和文件读取。
- **Complexity-Proportional Artifacts**：小任务只产出 `requirements.md` + `plan.md` + `implementation-trace.md`。
- **Evidence before Claims**：构建通过不等于需求满足，只说有证据的话。
- **No Silent Requirement Changes**：现实与需求冲突时停下来问，不静默改需求。

一套流程，两种思考深度：默认 **Bounded**，遇到接口变更、并发、外设、持久化或真实取舍时升级为 **Deep**（见 `AGENTS.md`）。
`requirements.md` 加可选的 `design.md` 构成 Spec；`plan.md` 只是执行地图，Spec 有阻塞性缺口时会返回 `PLAN NOT READY`。

## 目录布局

```
AGENTS.md                      全局规则和 Learner Profile（随成长修改 Profile）
CLAUDE.md                      一行引用 AGENTS.md，供 Claude Code 读取
.claude/skills/<name>/SKILL.md 规范版 skill，Claude Code 读取
.agents/skills/<name>/SKILL.md 生成副本，Codex 读取（不要手改）
scripts/sync-skills.*          从 .claude/skills 重新生成 .agents/skills
scripts/check-sync.*           检查两份是否一致，CI 也会跑
scripts/install.*              把工作流复制到目标项目
```

两个 Agent 都读 `AGENTS.md`：Codex 原生支持，Claude Code 通过 `CLAUDE.md` 引用。

## 安装到项目

```powershell
.\scripts\install.ps1 -Target C:\path\to\project
```

```sh
./scripts/install.sh /path/to/project
```

复制 `AGENTS.md`、`CLAUDE.md`、两份 skill 目录，创建 `.dev/tasks/`，并把 `.dev/active-task` 加入目标项目的 `.gitignore`。

目标项目已有 `AGENTS.md` 或 `CLAUDE.md` 时不会覆盖。此时需要手动把本仓库 `AGENTS.md` 中的 Task Directory、Active Task、Scope Guard、Adaptive Depth、Learner Profile 五段合并进去，否则 skill 找不到它们依赖的规则。

Cursor：在 `.cursor/rules` 引用 `AGENTS.md`，调用某阶段时粘贴对应 SKILL.md。

## 六个阶段

| 阶段 | 回答的问题 | 产出 | 不做的事 |
|---|---|---|---|
| `/grill` | 到底要做什么，怎么算完成 | `requirements.md` | 不讨论实现方案 |
| `/brainstorm` | 有哪些做法，哪个最好 | Deep 任务写 `design.md`，Bounded 任务只在聊天中给出推荐设计 | 不改代码，不写 plan |
| `/plan` | 具体改什么、在哪、什么顺序 | `plan.md` | 不修补需求，不发明架构，不开始实现 |
| `/execute` | 按计划实现并留下可读记录 | `implementation-trace.md` | 不做计划外重构，不声称需求已满足 |
| `/verify` | 实现是否真的满足每条验收标准 | 聊天中的 AC 矩阵，按需写 `verification.md` | 不修产品代码 |
| `/explain` | 作为学习者应该理解什么、按什么顺序 | 按需写 `learning.md` | 不逐行讲 diff |

每个阶段都有明确的完成门槛，达不到就报告缺什么，不会硬写文件。

## 任务与多任务

任务的持久状态只有一个文件加一个目录：

```
.dev/active-task               一行，当前未指名工作绑定的任务
.dev/tasks/<task-name>/
  requirements.md              /grill 写，/brainstorm 补充
  design.md                    /brainstorm 为 Deep 任务写
  plan.md                      /plan 写
  implementation-trace.md      /execute 维护
  verification.md              可选，/verify 按需写
  learning.md                  可选，/explain 按需写
```

`.dev/active-task` 是每个 checkout 的私有指针，不提交。同一 checkout 里并行开多个对话时，必须显式写任务名。

### 任务如何确定

不指名时的解析顺序，所有 skill 共用，永远不用聊天历史：

1. 命令里的任务名。
2. `.dev/active-task` 指向的目录存在。
3. `.dev/tasks/` 下恰好一个目录，采用并写入 active-task。
4. 否则列出任务并询问。不按修改时间猜。

`active-task` 只在两种情况下被写入：用户显式选择或创建任务；只有一个任务且没有 active-task 时的自举。语义推断、聊天历史、顺口提到某个任务、读它的文件，都不会改它。

每个 skill 回复和每次修改代码或 artifact 的回复，第一行固定是 `Task: <name>`，切换时写 `Task: <name> (switched from <old>)`。你一眼就能发现判断错了。

### 创建、切换、扩展

```
/grill new 两路相机帧时间戳要对齐到 5ms 内     创建：Agent 提名字和边界，你确认后才落盘
/grill                                         打磨当前任务
/grill camera-sync 还要支持四路相机             扩展指定任务，并切换到它
/brainstorm  /plan  /execute                   不指名，绑定 active-task
/verify camera-sync                            指名即切换，回复会标注 switched from
/explain udp-protocol                          首个词精确匹配任务目录时视为任务，否则视为解释范围
```

`/grill new` 之后 Agent 先做 Boundary Round：检查是否落在现有任务的需求内、现有任务 Non-goals 里有没有预留过这个名字、是否该拆成多个任务。然后给出：

```
Task: camera-sync (proposed)
Goal: 两路相机帧时间戳对齐到 5 ms 内
In: 时间戳采集点、帧配对、偏差统计
Out: UDP 传输格式、落盘格式
Questions:
1. 5 ms 是最大值还是 p99？ (default: 最大值)
```

回复 `ok` 或改任意一行。确认前不创建目录，边界由你定，Agent 只摆证据。名字规则：kebab-case 纯 ASCII，两到四个词，命名变化的对象而不是症状，`plan.md` 出现后冻结。

### Scope Guard

读代码、读任何任务的文件、纯讨论都不需要任务，也不触发检查。要写代码或 artifact 时，Agent 把请求对照当前任务分为三类：

| 分类 | 判定 | 处理 |
|---|---|---|
| IN | 在 `requirements.md` 范围内 | 直接做；计划外的改动在 trace 里记一条 `Unplanned` |
| EXTENSION | 需要新增或修改需求、AC | 停下，输出 SCOPE CHECK |
| BOUNDARY | 属于另一个已有任务，或命中 Non-goals / Out of Scope | 停下，输出 SCOPE CHECK |

```
SCOPE CHECK
Task: camera-sync
Request: 重新设计 UDP 包格式
Why: Non-goals 写明 "UDP packet format (separate task: udp-protocol)"
Options: 1. 扩展当前任务（先更新 requirements.md）
         2. 新任务：/grill new <描述>
         3. 只讨论，不写任何文件
```

Guard 只提议，永远不写 `active-task`，也不创建任务。切换只由你敲的命令完成。

### 一段典型对话

```
/grill new 两路相机帧时间戳对齐到 5ms 内
    → Task: camera-sync (proposed) ... 你回复 ok
    → Task: camera-sync (created)，写 requirements.md

/brainstorm
    → Task: camera-sync，Deep 任务，逐个决策，写 design.md

/plan
    → Task: camera-sync，写 plan.md，4 步

/execute
    → Task: camera-sync，按步实现，维护 implementation-trace.md

"这个地方顺便优化一下"
    → Task: camera-sync，IN，做完加一条 Unplanned

"我想重新设计一下 UDP 包格式"
    → SCOPE CHECK，三个选项

/grill new UDP 包格式重新设计
    → Task: udp-protocol (proposed) ...

/verify camera-sync
    → Task: camera-sync (switched from udp-protocol)，AC 矩阵

--- 第二天新会话 ---
"继续"
    → Task: camera-sync，从 trace 看到停在 Step 3，问你是否 /execute
```

最后一步体现分层：文件解决“在哪个任务”，artifact 推导“到了哪一步”，进入哪个阶段仍由你决定。

## 编辑 skill

只改 `.claude/skills/<name>/SKILL.md`，然后运行 `scripts/sync-skills.ps1`（或 `.sh`）保持 Codex 副本一致。`scripts/check-sync.*` 在两份不一致时失败，GitHub Actions 每次 push 都会跑。

## 明确不做的事

没有 skill 路由器、自动串联、强制 TDD、worktree、subagent、code review。没有任务栈、session id、任务状态字段、阶段指针、自动关闭任务。`.dev/active-task` 永远只有一行，阶段进度从 artifact 推导。这些如果将来需要，只作为可选能力加入，不作为基础设施。
