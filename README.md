# 肉鸽扫雷demo ·  RogueMinesweeperdemo

> 一款把**经典扫雷**与**肉鸽**融合的 2D 单机游戏。

基于 **Godot 4.2** 独立开发（玩法设计 + 系统设计 + 全部程序）。

---

## 🎮 玩法简介

传统扫雷加上 Roguelike 的构筑与成长循环：

```
主菜单 → 商店（金钱购买饰品）→ 诅咒抉择（用诅咒点换取 Debuff）
      → 扫雷关卡 → 通关结算 → 回到商店 → 循环，难度递增
```

- **双货币构筑**：金钱买正向 Buff，诅咒点换负向 Debuff（必须凑够每轮最低诅咒点才能进阶）

### 核心机制

| 机制 | 说明 |
|---|---|
| **9 种特殊地块** | 黑色格 / 毒格 / 宝藏格 / 迷惑格 / 食腐草 + 红雷 / 毒雷 + 问号线索 |
| **连击循环** | 每 10 连击触发吸血回血 / 挖宝加钱，插旗命中雷同样计入连击 |
| **中毒 DoT** | 层数 × 抗性 × 步数计数 |
| **护甲** | 每轮开始自动回复 |
| **15 种 Buff** | 4 个生效时机钩子（购买瞬间 / 建图前 / 开局 / 过关结算） |

---

## ⚙️ 技术亮点

**规模**：16 个脚本 · 3153 行 GDScript · 20 个场景

### 1. 四层架构 + 事件解耦
```
Autoload 单例层（Playerdata / LoadSource / SceneChanger）
      ↓
逻辑层 MinesGrid(TileMap)  ── 17 个自定义信号 ──→  中介者 GameStateManager
                                                        ↓
视图层 UI（20+ setter，零反向依赖）
```
逻辑层不持有任何 UI 引用，只发信号；中介者集中订阅并转发。替换 UI 无需改动逻辑。

### 2. 双层存档架构
- **运行时层** `Playerdata`（Node 单例）：唯一数据源 + 业务方法
- **序列化层** `SaveData`（`extends Resource`）：约 80 个字段，按用途分为 **7 组声明式管理**
- 支持**断点续玩**：4 状态流程机 `game_run_flag` + 主菜单按状态路由到不同场景

### 3. 地图数据重建
地图**只存纯数据**（雷区坐标、已揭示格、特殊地块二维矩阵），读档时反向重建 TileMap —— 存档与表现层彻底解耦，地图结构变更不影响老存档。

### 4. 不重复随机落点算法
「**全格坐标池洗牌 + 顺序 pop_back**」，保证同类特殊地块绝不重叠；特殊雷强制从已有雷集合中抽取。另实现**防死局保护**：线索密度不足时自动扩容地图。

### 5. 数据驱动配置
CSV 配置表启动时自动解析（首行作 Key 映射为字典），新增 Buff / Debuff / 商品**零代码改动**；接入 CSV 本地化方案，17 个翻译文件支持多语言。

---

## 📁 项目结构

```
├── Main/                   # 20 个场景
│   ├── start_interface.tscn    # 主菜单（游戏入口）
│   ├── shop_ui.tscn            # 饰品商店
│   ├── choose_debuff_ui.tscn   # 诅咒抉择
│   ├── main.tscn               # 关卡主体
│   └── Small Components/       # UI 组件（商品卡 / 属性行等）
├── scripts/                # 16 个 GDScript
│   ├── mines_grid.gd           # 核心逻辑层（904 行）
│   ├── playerdata.gd           # 运行时数据单例
│   ├── achieve_process.gd      # SaveData 序列化 schema
│   ├── load_source.gd          # CSV 配置加载
│   ├── game_state_manager.gd   # 信号中介者
│   └── ui.gd                   # 关卡 UI 视图
├── data/                   # 配置表 + 多语言
│   ├── BuffList.csv            # 15 种 Buff 配置
│   ├── DebuffList.csv          # 6 种 Debuff 配置
│   └── *.translation           # 17 个翻译文件
└── picture/                # 像素美术资源
```

---

## 🚀 如何运行

1. 安装 [Godot 4.2](https://godotengine.org/download)（Standard 版即可，无需 .NET）
2. 克隆本仓库
3. 用 Godot 打开 `project.godot`
4. 按 `F5` 运行

**操作方式**：鼠标左键揭示格子 · 鼠标右键插旗

---
部分画面展示
<img width="1920" height="1028" alt="image" src="https://github.com/user-attachments/assets/2d6332bc-efcb-44dd-a7d6-b9f8d298757b" />


## 📄 License

本项目仅用于学习与作品展示。
