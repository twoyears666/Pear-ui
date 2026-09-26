-- Pear 启动器 · 仿 PCL 浅色 UI 包 —— v1.13.3
--
-- 契约（引擎通用，零特例）：
--   主题：仿 PCL 浅色——蓝顶栏 topbar #0A5FC4、内容区浅蓝灰对角渐变
--         background_start #E3EEF9 → background_end #D5E5F5、白卡 background_card #FFFFFF、
--         深色文字 cardText #333333。禁止任何黑色/深色/透明兜底（背景必须在 colors.json）。
--   尺寸：全部按窗口高 1H 比例（vh = 0.01H）；横向用 %。
--   布局：只通过容器组件表达，禁止绝对定位、禁止规格外元素、禁止大字号漂浮文字。
--         容器语义（引擎原生原语）：split_column ≈ row（横向分栏）、vertical_flow ≈
--         column（通栏纵向流，内容 94% 即左右留边 3%）、card ≈ 白底圆角卡片 column、
--         row_item ≈ 整行条目 row。所有子元素只在父容器内流式排布。
--   页面：内容区 content 内挂纯 Lua 页子树，页 token ∈ CONFIG.pages。
--
-- 结构约定（PLUIShellViewController.showLuaPage 依赖）：
--   pageHome / pageDownload / pageMulti / pageSettings / pageMore / pageVersionSettings

function describe()
  return { name = "PCL 浅色", version = "1.23.0-beta" }
end

local C = {
  topbar      = "$color:topbar",              -- 顶栏蓝 #0A5FC4
  topbarFrom  = "$color:topbarFrom",          -- 顶栏渐变起点（较亮的蓝）
  topbarTo    = "$color:topbarTo",            -- 顶栏渐变终点 = 主题蓝 #0A5FC4
  pageFrom    = "$color:pageFrom",            -- 渐变左上 #E3EEF9
  pageTo      = "$color:pageTo",              -- 渐变右下 #D5E5F5
  bg          = "$color:background_start",    -- 页面底色起点 #E3EEF9（渐变同 background_gradient）
  card        = "$color:card",                -- 卡片 #FFFFFF = background_card
  cardBorder  = "$color:cardBorder",          -- 卡片描边 #D9E4F0
  dark        = "$color:cardText",            -- 主文字 #333333
  mid         = "$color:subText",             -- 次要文字 #999999
  white       = "$color:white",
  transparent = "$color:transparent",
  accent      = "$color:accent",              -- 强调蓝 #0B84FF
  accentBorder = "$color:accentBorder",
  hover       = "$color:hover",               -- hover 浅蓝 #EAF3FC
  avatarBg    = "$color:avatarBg",
  avatarLine  = "$color:avatarLine",
  success     = "$color:success",
  danger      = "$color:danger",
  orange      = "$color:brandOrange",
  green       = "$color:brandGreen",
  purple      = "$color:brandPurple",
  cyan        = "$color:brandCyan",
  pink        = "$color:brandPink",
  hintBg      = "$color:faintBlue",           -- 提示条浅蓝底 #EAF3FC
  faintBlue   = "$color:faintBlue",           -- 浅蓝底（胶囊按钮/图标底）
  fieldBorder = "$color:fieldBorder",
}

local BORDER   = { width = "0.12vh", color = C.cardBorder }
local BORDER_A = { width = "0.18vh", color = C.accentBorder }
local BORDER_D = { width = "0.18vh", color = C.danger }
local SHADOW   = { blur = "0.3vh", opacity = 0.07, x = 0, y = "0.15vh" }

-- 当前设置分类选中项（文件顶部声明，避免 buildSettingsPage 前置引用读到 nil 全局）
local setSelCat = "launcher_settings"

local TABS = {
  { id = "tab.home",     label = "启动", icon = "sf:house.fill",                             action = "open:home",       page = "home" },
  { id = "tab.download", label = "下载", icon = "sf:arrow.down.circle.fill",                 action = "open:download",   page = "download" },
  { id = "tab.multi",    label = "联机", icon = "sf:antenna.radiowaves.left.and.right",      action = "open:multiplayer", page = "multi" },
  { id = "tab.setup",    label = "设置", icon = "sf:gearshape.fill",                         action = "open:settings",   page = "settings" },
  { id = "tab.other",    label = "更多", icon = "sf:ellipsis.circle.fill",                   action = "open:more",       page = "more" },
}

local PAGE_TAB = {
  home = "tab.home", download = "tab.download", multi = "tab.multi",
  settings = "tab.setup", more = "tab.other",
}

local CONFIG = {
  pages = {
    home = "pageHome", download = "pageDownload", multi = "pageMulti",
    settings = "pageSettings", more = "pageMore", version_settings = "pageVersionSettings",
    versionManager = "pageVersionManager", accountManager = "pageAccountManager",
    gameDirectory = "pageGameDirectory", versionDetail = "pageVersionDetail",
  },
  home = {
    secondaryLinks = { { label = "购买正版", action = "open:download" }, { label = "更换皮肤", action = "open:settings" } },
  },
  download = {
    segRows = {
      { "最新版本", "正式版", "快照" },
      { "Mods", "光影", "整合包" },
    },
    -- 下载页左侧分类目录（仿 PCL PageDownloadLeft）
    sidebarGroups = {
      { name = "原版游戏", items = {
        { id = "dlCat_1", label = "原版游戏" },
      } },
      { name = "社区资源", items = {
        { id = "dlCat_2", label = "Mod" },
        { id = "dlCat_3", label = "整合包" },
        { id = "dlCat_4", label = "数据包" },
        { id = "dlCat_5", label = "资源包" },
        { id = "dlCat_6", label = "光影包" },
      } },
    },
    titleByCat = { "原版游戏", "Mod", "整合包", "数据包", "资源包", "光影包" },
    latest = {
      { icon = "sf:cube.fill",          tint = C.green,  title = "最新 Java 版本", sub = "正式版 · 稳定 · 更新于 ···" },
      { icon = "sf:shippingbox.fill",   tint = C.orange, title = "光影整合包",     sub = "光影 · 热门 · 更新于 ···" },
      { icon = "sf:map.fill",           tint = C.cyan,   title = "地图资源",       sub = "地图 · 精选 · 更新于 ···" },
    },
    popular = {
      { icon = "sf:gamecontroller.fill", tint = C.orange, title = "[整合包 1.20] 生存 · 建筑 · 优化 · 光影",
        meta = "新手友好的一体化生存整合包", right = "更新 …   下载 …" },
      { icon = "sf:cube.fill",           tint = C.purple, title = "[Mod v1] 辅助 · 优化 · 冒险",
        meta = "提升帧率与游戏体验的核心模组", right = "更新 …   下载 …" },
    },
    searchLabels = { "搜索源", "搜索对象", "搜索关键词" },
    searchSources = { { id = "modrinth", name = "Modrinth" }, { id = "curseforge", name = "CurseForge" } },
    searchObjects = { "mod", "modpack", "datapack", "resourcepack", "shader" },
    communityResultSlots = 6, -- 社区资源搜索结果槽位数（下载页一次展示的最大结果数）
    keywordPlaceholder = "点击输入关键词…",
    searchStatusPreset = "点击「搜索」获取社区资源，点击结果条目可下载最新版本",
    vanillaTypes = { "最新版本", "正式版", "快照" },
    installHint = "安装后请留意版本与 Mod 兼容性；Fabric/Forge 需安装对应加载器。",
    defaultVersion = "1.20.1", -- 下载页「开始下载」默认安装的版本 id（可改；接版本清单后可动态选）
    -- 版本分组卡（引擎 download.versions 返回 key；name 为卡片标题；maxRows=卡片最多渲染行数）
    vanillaGroups = {
      { key = "release",      name = "正式版" },
      { key = "snapshot",     name = "快照" },
      { key = "april_fools",  name = "愚人节版本" },
      { key = "ancient",      name = "远古版" },
    },
    -- 下载页首屏「版本分组」列表（仿 PCL 下载→原版游戏）：点分组展开内联具体版本，
    -- 点具体版本进入安装面板。latest 由 download.versions 的 latest_release/snapshot 拼合。
    versionGroups = {
      { key = "latest",      name = "最新版本" },
      { key = "release",     name = "正式版" },
      { key = "snapshot",    name = "测试版" },
      { key = "april_fools", name = "愚人节版" },
      { key = "ancient",     name = "远古版" },
    },
    maxVersionRows = 12,     -- 每张版本卡最多渲染的版本行（真实列表很长，滚动超出部分截断）
    -- 版本详情页加载器组合（仿 PCL：默认「无」，可切换 Fabric/Forge 等后再下载）
    loaders = { "无", "Fabric", "Forge", "Quilt", "NeoForge" },
    -- PCL II 安装面板：Minecraft 卡标题 / 组件版本槽位数 / 加载器互斥（不可同装，选中其一则另一灰禁用）
    mcLabel = "Minecraft",
    compVersionSlots = 5,
    compConflictTip = "与 Forge 不兼容",
    conflicts = { { a = "Forge", b = "Fabric" }, { a = "Forge", b = "Quilt" }, { a = "Forge", b = "NeoForge" } },
    -- 分组 key → 版本类型显示名（详情页副标题用，仅结构，不写死具体版本）
    typeNames = { latest_snapshot = "最新快照", latest_release = "最新正式版",
      release = "正式版", snapshot = "快照", april_fools = "愚人节版本", ancient = "远古版" },
  },
  online = {
    branch = { "局域网", "在线" },
    rooms = {}, -- 房间列表由 MultiplayerManager 在运行时填充
  },
  moreGroups = {
    { name = "启动", rows = {
        { id = "moreLaunch",         icon = "sf:play.rectangle.fill",  label = "启动选项",   right = "chevron", action = "open:settings" },
    } },
    { name = "资源", rows = {
        { id = "moreDefaultVersion", icon = "sf:cube.fill",            label = "默认版本",   right = "version", action = "open:versionManager" },
        { id = "moreMods",           icon = "sf:hud",                  label = "资源中心",   right = "chevron", action = "open:mods" },
        { id = "moreVersions",       icon = "sf:square.grid.3x3.fill", label = "版本管理",   right = "chevron", action = "open:versionManager" },
    } },
    { name = "其他", rows = {
        { id = "moreAbout",          icon = "sf:info.circle.fill",     label = "关于加载器", right = "chevron", action = "open:settings" },
    } },
    { name = "帮助", rows = {
        { id = "moreFeedback",       icon = "sf:exclamationmark.bubble.fill", label = "问题反馈", right = "chevron", action = "open:more" },
        { id = "moreLogs",           icon = "sf:doc.text.fill",         label = "日志",       right = "chevron", action = "open:more" },
    } },
  },
  versionManager = {
    title = "版本管理",
    addAction = "open:download",
    emptyText = "尚未安装任何游戏版本，可前往下载页获取。",
  },
  accountManager = {
    title = "账号管理",
    addAction = "open:settings",
    emptyText = "暂无已登录账号，登录后即可联机同步。",
  },
  gameDirectory = {
    title = "游戏目录",
    emptyText = "尚未创建其他游戏目录，可在下方输入目录名新建。",
    addPlaceholder = "输入新目录名…",
  },
  -- 设置子页：token → { 标题, 分组: 组名 + 白卡多行条目 }。点击设置条目经
  -- open_subpage:token 进入；条目值用 "···" 占位结构（与版本信息一致，不写死内容）。
  settingsSubpages = {
    launcher_settings = { title = "启动器设置", groups = {
      { name = "常规", rows = {
        { label = "启动器主题",   value = "···" },
        { label = "界面语言",     value = "···" },
        { label = "检查更新",     value = "···" },
      } },
    } },
    download_mirror = { title = "下载镜像策略", groups = {
      { name = "镜像源", rows = {
        { label = "下载源",      value = "···" },
        { label = "自动检测延迟", value = "···" },
      } },
    } },
    video_settings = { title = "视频设置", groups = {
      { name = "渲染", rows = {
        { label = "最大分辨率", value = "···" },
        { label = "垂直同步",   value = "···" },
        { label = "渲染占比",   value = "···" },
      } },
    } },
    gl_renderer = { title = "MobileGlues 渲染器", groups = {
      { name = "兼容层", rows = {
        { label = "OpenGL 兼容层", value = "···" },
        { label = "开启调试日志",  value = "···" },
      } },
    } },
    control_keys = { title = "自定义控制键", groups = {
      { name = "控制", rows = {
        { label = "按键布局", value = "···" },
        { label = "摇杆模式", value = "···" },
      } },
    } },
    java_tuning = { title = "Java 调整", groups = {
      { name = "内存与参数", rows = {
        { label = "内存分配", value = "···" },
        { label = "JVM 参数", value = "···" },
      } },
    } },
    ui_theme = { title = "UI 设置", groups = {
      { name = "外观", rows = {
        { label = "界面缩放", value = "···" },
        { label = "主题材质包", value = "···" },
      } },
    } },
    ai_assistant = { title = "AI 助手", groups = {
      { name = "助手", rows = {
        { label = "服务商", value = "···" },
        { label = "对话模型", value = "···" },
      } },
    } },
  },
  -- 设置页数据源（数据驱动）：左侧目录 + 右侧单一大白卡分组条目。
  -- 每项 type：toggle=开关 / select=取值行 / button=描边蓝字按钮 / text=仅展示。
  -- settingsGroups 恒非常规非空渲染，侧栏与内容都不依赖引擎运行时（M1/M4 根治）。
  settingsGroups = {
    { id = "launcher_settings", label = "启动器设置", icon = "sf:slider.horizontal.3", rows = {
      { id = "st_theme",  label = "浅色主题",     type = "toggle", value = true  },
      { id = "st_lang",   label = "界面语言",     type = "select", value = "简体中文", options = { "简体中文", "English", "日本語" } },
      { id = "st_update", label = "自动检查更新", type = "toggle", value = true  },
      { id = "st_mirror", label = "下载镜像",     type = "select", value = "自动检测", options = { "自动检测", "Mojang 源", "BMCLAPI" } },
    } },
    { id = "download_mirror", label = "下载镜像", icon = "sf:arrow.down.circle.fill", rows = {
      { id = "sd_source", label = "下载源",       type = "select", value = "官源", options = { "官源", "镜像", "Modrinth", "CurseForge" } },
      { id = "sd_latency",label = "自动检测延迟", type = "toggle", value = false },
      { id = "sd_multi",  label = "多线程下载",   type = "toggle", value = true  },
    } },
    { id = "video_settings", label = "视频设置", icon = "sf:display", rows = {
      { id = "sv_res",   label = "最大分辨率",   type = "select", value = "自动", options = { "自动", "480p", "720p", "1080p", "2K" } },
      { id = "sv_vsync", label = "垂直同步",     type = "toggle", value = false },
      { id = "sv_ratio", label = "渲染占比",     type = "select", value = "100%", options = { "25%", "50%", "75%", "100%" } },
    } },
    { id = "gl_renderer", label = "GL 渲染器", icon = "sf:memorychip.fill", rows = {
      { id = "sg_layer", label = "OpenGL 兼容层", type = "select", value = "自动", options = { "自动", "OpenGL 2.1", "OpenGL 3.2", "Vulkan" } },
      { id = "sg_debug", label = "开启调试日志",  type = "toggle", value = false },
      { id = "sg_reset", label = "重置渲染器设置", type = "button" },
    } },
    { id = "control_keys", label = "控制键", icon = "sf:keyboard.fill", rows = {
      { id = "sk_layout", label = "按键布局",   type = "select", value = "默认", options = { "默认", "简洁", "紧凑" } },
      { id = "sk_joystick",label = "摇杆模式", type = "select", value = "跟随", options = { "跟随", "翻转", "关闭" } },
      { id = "sk_custom", label = "自定义按键", type = "button" },
    } },
    { id = "java_tuning", label = "Java 调整", icon = "sf:wrench.and.screwdriver.fill", rows = {
      { id = "sj_ram",   label = "内存分配",  type = "select", value = "2048 MB", options = { "1024 MB", "2048 MB", "4096 MB", "6144 MB" } },
      { id = "sj_jvm",   label = "JVM 参数",  type = "text",   value = "-Xmx2G" },
      { id = "sj_reset", label = "重置 JVM 参数", type = "button" },
    } },
    { id = "ui_theme", label = "UI 设置", icon = "sf:paintbrush.fill", rows = {
      { id = "su_scale",  label = "界面缩放",   type = "select", value = "自动", options = { "自动", "0.75x", "1x", "1.25x", "1.5x" } },
      { id = "su_pack",   label = "主题材质包", type = "select", value = "PCL 浅色", options = { "PCL 浅色", "深色" } },
    } },
    { id = "ai_assistant", label = "AI 助手", icon = "sf:sparkles", rows = {
      { id = "sa_provider", label = "服务商",   type = "select", value = "未配置", options = { "未配置", "OpenAI", "Anthropic", "本地" } },
      { id = "sa_model",    label = "对话模型", type = "select", value = "默认", options = { "默认", "快速", "专注" } },
    } },
  },
  settingsStatus = "设置项已按分组展示；点击开关或按钮可即时反馈（数据驱动配色，方便日后切换主题）。",
  settingsGroupNames = { "常规", "网络", "显示", "兼容", "控制", "性能", "外观", "助手" },
}

-- 设置子页注册：token → 内容区 Lua 页子树 id（引擎经 open_subpage:token 切页）。
for _subKey in pairs(CONFIG.settingsSubpages) do
  CONFIG.pages[_subKey] = "sub_" .. _subKey
end

-- ===== 通用构件 =====
local function pushAll(dst, src) for _, v in ipairs(src) do dst[#dst + 1] = v end end

local function chevron()
  return ui.text { text = "›", style = { font = "3vh", color = C.mid } }
end

-- 顶栏页签（选中态由 setStyle 套白底全圆药丸，不做绝对定位游标）
local function topTab(t)
  return ui.button {
    id = t.id, label = t.label, icon = t.icon, action = t.action,
    height = "6vh", corner = "pill",
    padding = { left = "1.5vh", right = "1.5vh" },
    style = { background = C.transparent, tint = C.white, font = "2.4vh", weight = "bold" },
  }
end

-- 白底圆角卡片（通用卡片规范，apply to all 界面）：
--   外边距：水平居中、两侧各留白 15% —— 卡宽 70%；垂直：首卡距顶 4%、卡距 2%。
--   内边距：内容距卡缘水平 3%(用 vh 近似)、垂直 1.5%。
--   圆角：= 屏高 1%（1vh）。
-- opts 可覆盖 width/padding/spacing/crossAlign/visible/height。
local function card(id, children, opts)
  opts = opts or {}
  return ui.column { id = id, width = opts.width or "70%", background = C.card, border = BORDER,
    corner = opts.corner or "1vh", shadow = SHADOW,
    padding = opts.padding or { left = "2.4vh", right = "2.4vh", top = "1.5vh", bottom = "1.5vh" },
    spacing = opts.spacing or "2vh", crossAlign = opts.crossAlign,
    height = opts.height, visible = opts.visible, children = children }
end

-- 整行条目卡（row_item）：左图标 + 中列(标题/副题) + 右文本；整行可点、hover 浅蓝，图标圆角
local function listEntry(id, icon, tint, title, sub, rightText, action)
  return ui.row {
    id = id, height = "8vh", background = C.card, corner = "1.2vh",
    border = BORDER, shadow = SHADOW, hoverColor = C.hover, crossAlign = "center",
    padding = { left = "2vh", right = "2vh" }, spacing = "1.6vh", action = action,
    children = {
      ui.image { icon = icon, size = "5vh", corner = "pill",
        background = { from = C.accent, to = tint, angle = 30 }, style = { tint = C.white } },
      ui.column { weight = 1, justify = "center", spacing = "0.4vh", children = {
        ui.text { id = id .. "Title", text = title, style = { font = "2.8vh", weight = "bold", color = C.dark } },
        ui.text { id = id .. "Sub", text = sub, style = { font = "2.1vh", color = C.mid } },
      } },
      rightText and ui.text { text = rightText, style = { font = "2vh", color = C.mid } } or nil,
    },
  }
end

local function bigItem(id, icon, tint, title, meta, rightText, action)
  return ui.row {
    id = id, height = "14vh", background = C.card, corner = "1.2vh",
    border = BORDER, shadow = SHADOW, hoverColor = C.hover, crossAlign = "center",
    padding = { left = "2vh", right = "2vh" }, spacing = "1.8vh", action = action,
    children = {
      ui.image { icon = icon, size = "10vh", corner = "pill",
        background = { from = tint, to = C.accent, angle = 30 }, style = { tint = C.white } },
      ui.column { weight = 1, justify = "center", spacing = "0.5vh", children = {
        ui.text { text = title, style = { font = "2.5vh", weight = "bold", color = C.dark } },
        ui.text { text = meta, style = { font = "2.1vh", color = C.mid } },
        rightText and ui.text { text = rightText, style = { font = "2vh", color = C.mid } } or nil,
      } },
    },
  }
end

-- 分段选择：等分横排的 n 个按钮，选中项白底全圆药丸
local function segmentRow(id, labels, spacing)
  local kids = {}
  for i, lab in ipairs(labels) do
    kids[#kids + 1] = ui.button { id = id .. "_" .. i, label = lab, weight = 1,
      height = "4.5vh", corner = "pill", action = id .. "_" .. i, hoverColor = C.hover,
      style = { background = C.transparent, tint = C.dark, font = "2.3vh", weight = "bold" } }
  end
  return ui.row { width = "94%", height = "5.5vh", crossAlign = "center", spacing = spacing, children = kids }
end

local function pickerRow(id, label, valueText, valueId)
  return ui.row {
    id = id, height = "4.5vh", width = "100%", crossAlign = "center",
    children = {
      ui.text { text = label, style = { font = "2.4vh", color = C.dark } },
      ui.spacer { weight = 1 },
      ui.row { weight = 3, width = "70%", height = "4.5vh", background = C.card,
        border = { width = "0.12vh", color = C.fieldBorder }, corner = "0.8vh", crossAlign = "center",
        padding = { left = "1.2vh", right = "1.2vh" },
        children = {
          ui.text { id = valueId, text = valueText, weight = 1, style = { font = "2.2vh", color = C.dark } },
          ui.text { text = " ▾", style = { font = "2.2vh", color = C.mid } },
        } },
    },
  }
end

local function plainButton(id, label, accent, action)
  return ui.button { id = id, label = label, height = "5.5vh", weight = 1, background = C.card,
    corner = "0.7vh", border = (accent and BORDER_A or BORDER), action = action,
    style = { font = "2.4vh", tint = C.dark } }
end

-- 设置页分组行：标签 + 当前值 + ›
local function settingsRow(id, label, value, action)
  return ui.row {
    id = id, height = "6.5vh", width = "100%", crossAlign = "center",
    spacing = "1.5vh", hoverColor = C.hover, action = action,
    children = {
      ui.text { text = label, weight = 1, style = { font = "2.5vh", color = C.dark } },
      ui.text { text = value or "···", style = { font = "2.3vh", color = C.mid } },
      chevron(),
    } }
end

-- 开关状态表（id → bool），默认取 CONFIG 定义（M5：点击真正切换）。
local setToggles = {}
local function toggleOn(id)
  if setToggles[id] ~= nil then return setToggles[id] end
  for _, g in ipairs(CONFIG.settingsGroups) do
    for _, s in ipairs(g.rows or {}) do
      if s.id == id then setToggles[id] = (s.value == true); return setToggles[id] end
    end
  end
  return false
end

-- 设置项（数据驱动，type 字段决定控件形态；所有颜色走 C 变量）
local function settingsItemRow(s)
  local id = "setit_" .. s.id
  if s.type == "toggle" then
    local on = toggleOn(s.id)
    return ui.row {
      id = id, action = id, height = "6.5vh", width = "100%", crossAlign = "center",
      spacing = "1.5vh", hoverColor = C.hover, padding = { left = "1.2vh", right = "1.2vh" },
      children = {
        ui.text { text = s.label, weight = 1, style = { font = "2.5vh", color = C.dark } },
        ui.button { id = id .. "_sw", label = (on and "开" or "关"), width = "13vh", height = "4.4vh",
          corner = "pill", action = id, hoverColor = C.hover,
          style = { background = on and C.accent or C.cardBorder, tint = C.white,
                    font = "2.2vh", weight = "bold" } },
      } }
  elseif s.type == "button" then
    return ui.button { id = id, label = s.label, height = "5.6vh", width = "100%",
      background = C.card, border = BORDER_A, corner = "0.7vh", action = id, hoverColor = C.hover,
      style = { font = "2.4vh", tint = C.accent, weight = "bold" } }
  elseif s.type == "text" then
    return ui.row { id = id, height = "6.5vh", width = "100%", crossAlign = "center",
      spacing = "1.5vh", padding = { left = "1.2vh", right = "1.2vh" },
      children = {
        ui.text { text = s.label, weight = 1, style = { font = "2.5vh", color = C.dark } },
        ui.text { id = id .. "_v", text = s.value or "", style = { font = "2.3vh", color = C.mid } },
      } }
  else -- select
    return ui.row { id = id, action = id, height = "6.5vh", width = "100%", crossAlign = "center",
      spacing = "1.5vh", hoverColor = C.hover, padding = { left = "1.2vh", right = "1.2vh" },
      children = {
        ui.text { text = s.label, weight = 1, style = { font = "2.5vh", color = C.dark } },
        ui.text { id = id .. "_v", text = s.value or "", style = { font = "2.3vh", color = C.mid } },
        ui.text { text = " ▾", style = { font = "2.3vh", color = C.mid } },
      } }
  end
end

-- ============ 启动页左栏（split_column 左 1/3，仿 PCL2 主页左侧）============
local function buildHomeSidebar()
  local kids = {}
  kids[#kids + 1] = ui.spacer { height = "2.5vh" }
  -- 账号类型胶囊：Mojang / 微软 / 离线（PCL2 为三态 pill）
  kids[#kids + 1] = ui.row { id = "capsules", width = "90%", height = "4vh", spacing = "1vh",
    children = {
      ui.button { id = "cap.mojang", label = "Mojang", height = "4vh", weight = 1, corner = "pill",
        action = "cap.mojang", hoverColor = C.hover,
        style = { background = C.card, tint = C.accent, font = "2.2vh", weight = "bold" } },
      ui.button { id = "cap.microsoft", label = "微软", height = "4vh", weight = 1, corner = "pill",
        action = "cap.microsoft", hoverColor = C.hover,
        style = { background = C.card, tint = C.accent, font = "2.2vh", weight = "bold" } },
      ui.button { id = "cap.offline", label = "离线", height = "4vh", weight = 1, corner = "pill",
        action = "cap.offline", hoverColor = C.hover,
        style = { background = C.card, tint = C.accent, font = "2.2vh", weight = "bold" } },
    } }
  -- 头像在中（PCL2 皮肤预览较大，用像素风格占位）
  kids[#kids + 1] = ui.spacer { height = "2.5vh" }
  kids[#kids + 1] = ui.column { id = "avatarBox", width = "15vh", height = "15vh", corner = "1.2vh",
    background = C.avatarBg, border = BORDER, justify = "center", crossAlign = "center",
    children = {
      ui.image { id = "avatar", icon = "sf:person.crop.square.fill", size = "10vh",
        background = C.transparent, style = { tint = C.avatarLine } },
    } }
  kids[#kids + 1] = ui.spacer { height = "1.5vh" }
  kids[#kids + 1] = ui.text { id = "accountName", text = "未登录", width = "90%",
    style = { font = "2.4vh", weight = "bold", color = C.dark, align = "center" } }
  kids[#kids + 1] = ui.text { id = "accountType", text = "点击登录账号", width = "90%",
    style = { font = "2vh", color = C.mid, align = "center" } }
  kids[#kids + 1] = ui.spacer { height = "1.8vh" }
  -- 登录 / 管理账号
  kids[#kids + 1] = ui.button { id = "loginBtn", label = "登录 / 管理账号", width = "90%", height = "5vh",
    background = C.accent, corner = "0.8vh", action = "open:accountManager",
    style = { font = "2.3vh", weight = "bold", tint = C.white } }
  kids[#kids + 1] = ui.row { id = "homeLinks", width = "90%", height = "4vh", crossAlign = "center", spacing = "1vh",
    children = {
      ui.button { id = "linkBuy", label = "购买正版", weight = 1, height = "4vh", corner = "pill",
        action = "open:download", hoverColor = C.hover,
        style = { background = C.transparent, tint = C.mid, font = "1.9vh" } },
      ui.button { id = "linkSkin", label = "更换皮肤", weight = 1, height = "4vh", corner = "pill",
        action = "open:settings", hoverColor = C.hover,
        style = { background = C.transparent, tint = C.mid, font = "1.9vh" } },
    } }
  kids[#kids + 1] = ui.spacer { height = "2vh" }
  -- 启动游戏大按钮：白底 + 蓝色边框（PCL2 风格）
  kids[#kids + 1] = ui.column { id = "launchBtn", action = "launch", width = "90%", height = "10vh",
    corner = "1.2vh", background = C.card, border = BORDER_A, justify = "center", crossAlign = "center",
    spacing = "0.6vh", hoverColor = C.hover,
    children = {
      ui.text { id = "launchTitle", text = "启动游戏", style = { font = "3.2vh", weight = "bold", color = C.accent } },
      ui.text { id = "launchSub", text = "尚未选择版本", style = { font = "2.2vh", color = C.mid } },
    } }
  kids[#kids + 1] = ui.spacer { weight = 1 }
  -- 版本选择 / 版本设置（PCL2 底部并排按钮）
  kids[#kids + 1] = ui.row { id = "versionRow", width = "90%", height = "5.5vh", spacing = "1.2vh",
    children = {
      ui.button { id = "pickVersion", label = "版本选择", action = "open:versionManager", weight = 1,
        height = "5.5vh", corner = "0.8vh", border = BORDER, hoverColor = C.hover,
        style = { background = C.card, tint = C.dark, font = "2.4vh", weight = "bold" } },
      ui.button { id = "versionSetup", label = "版本设置", action = "open:version_settings", weight = 1,
        height = "5.5vh", corner = "0.8vh", border = BORDER, hoverColor = C.hover,
        style = { background = C.card, tint = C.dark, font = "2.4vh", weight = "bold" } },
    } }
  kids[#kids + 1] = ui.spacer { height = "2vh" }
  return kids
end

-- ============ 启动页右区（仿 PCL2 主页右侧大公告卡片）============
local function buildHomePage()
  return ui.column { id = "pageHome", weight = 1, crossAlign = "center", padding = "1.6vh",
    spacing = "1.6vh",
    children = {
      card("homeNotice", {
        ui.row { width = "100%", height = "5vh", crossAlign = "center", spacing = "1.5vh",
          children = {
            ui.image { icon = "sf:info.circle.fill", size = "4vh", corner = "pill",
              background = C.faintBlue, style = { tint = C.accent } },
            ui.text { text = "公告", style = { font = "2.8vh", weight = "bold", color = C.dark } },
          } },
        ui.divider { height = "0.2vh", background = C.cardBorder },
        ui.text { text = "欢迎使用 Pear 启动器。", style = { font = "2.4vh", color = C.dark } },
        ui.text { text = "· 在左侧选择账号类型并登录。\n· 点击「版本选择」安装或切换游戏版本。\n· 点击「启动游戏」即可开始游玩。",
          style = { font = "2.2vh", color = C.mid, lineSpacing = "1.6vh" } },
        ui.button { id = "homeNoticeBtn", label = "了解更多", width = "28vh", height = "5vh",
          background = C.accent, corner = "0.8vh", action = "open:more",
          style = { font = "2.3vh", weight = "bold", tint = C.white } },
      }, { spacing = "2vh" }),
    } }
end

-- 下载页版本行槽位（icon + 两行小字：版本号 / 发布时间）。
-- width 96% + 卡 crossAlign=center → 与卡片上下、左右均留出间距。
local function versionSlot(cid, idx)
  return ui.row { id = "dlv_" .. cid .. "_" .. idx, width = "96%", height = "6.5vh",
    background = C.card, border = BORDER, corner = "0.8vh", hoverColor = C.hover,
    crossAlign = "center", spacing = "1.2vh", padding = { left = "1.6vh", right = "1.6vh" },
    children = {
      ui.image { icon = "sf:cube.fill", size = "2.6vh", style = { tint = C.accent } },
      ui.column { weight = 1, crossAlign = "stretch", spacing = "0.5vh",
        children = {
          ui.text { id = "dlv_" .. cid .. "_" .. idx .. "_name", text = "…", width = "100%",
            style = { font = "2.2vh", color = C.dark } },
          ui.text { id = "dlv_" .. cid .. "_" .. idx .. "_date", text = "", width = "100%",
            style = { font = "1.8vh", color = C.mid } },
        } },
      chevron(),
    } }
end

local dlGroups = {} -- download.versions 分组缓存（onClick 按 cid/idx 取版本 id）
local dlExpanded = {} -- 下载页版本分组折叠状态
-- 版本详情页状态：dlCurrent=当前查看版本{id,date,cid}；dlLoader=加载器选择索引
local dlCurrent = nil
local dlLoader = 1

-- ===== PCL II 下载安装面板状态（行内选择，不再跳详情页）=====
local PLC = {}       -- 选中 Minecraft 版本 id（默认取 CONFIG 默认版本）
PLC.mc = CONFIG.download.defaultVersion or ""
PLC.mcOpen = false   -- Minecraft 版本选择列表展开
local compSel = {}   -- 组件卡（加载器）当前选中版本：index → string/nil
local compOpen = {}  -- 组件卡展开状态：index → bool

-- 由 download.versions 平铺填充 Minecraft 行内版本列表
local flatVersions = {}

-- 下载页版本选择层级：groups(分组列表，首屏) / install(安装面板，点具体版本后进入)
dlLevel = "groups"
-- 分组展开状态：groupkey → bool（下载页首屏分组列表内联展开）
dlOpenGroup = {}
-- 已把该组全部版本行追加进列表容器的分组：groupkey → true（只追加一次，折叠/展开复用；
-- 原版版本走引擎滚动完整列表，无数量上限，无需分页）
dlGroupAppended = {}

-- 版本行点击后打开详情页：填入所选版本信息并保持当前页高亮为「下载」。
local function openDetailFor(cid, idx)
  local it = (dlGroups[cid] or {})[idx]
  if not it or not it.id then return end
  dlCurrent = { id = it.id, date = it.date or "", cid = cid }
  dlLoader = 1
  launcher.view("vdVersion"):setText(dlCurrent.id)
  local tname = (CONFIG.download.typeNames or {})[cid] or "版本"
  launcher.view("vdType"):setText(tname .. " · " .. dlCurrent.date .. " 发布")
  local loaders = CONFIG.download.loaders or {}
  for li = 1, #loaders do
    local sel = (li == dlLoader)
    launcher.view("vdL_" .. li):setStyle(sel
      and { background = C.accent, tint = C.white, corner = "pill" }
      or  { background = C.transparent, tint = C.dark, corner = "pill" })
  end
  launcher.action("open_subpage:versionDetail")
end
local function refreshDownloadVersions()
  local p = launcher.service("download", "versions") or {}
  if type(p) ~= "table" or not p.ok then return end
  dlGroups = {}
  flatVersions = {}
  local latest = { latest_release = p.latestRelease, latest_snapshot = p.latestSnapshot }
  local latestItems = {}
  for cid, it in pairs(latest) do
    if it and it.id then
      dlGroups[cid] = { it }
      latestItems[#latestItems + 1] = it
      flatVersions[#flatVersions + 1] = it
    end
  end
  dlGroups["latest"] = latestItems -- 首屏「最新版本」分组 = 最新正式版 + 最新快照
  for _, g in ipairs(CONFIG.download.vanillaGroups) do
    local items = {}
    for _, grp in ipairs(p.groups or {}) do
      if grp.key == g.key then items = grp.items or {} end
    end
    dlGroups[g.key] = items
    for _, it in ipairs(items) do flatVersions[#flatVersions + 1] = it end
  end
end

-- PCL II 安装面板运行态刷新：Minecraft 行内列表 + 组件行 + 高亮/按钮可见性
local function refreshInstallPanel()
  local D = CONFIG.download
  local maxR = D.maxVersionRows or 12
  -- Minecraft 行内列表
  for i = 1, maxR do
    local it = flatVersions[i]
    local nameV = launcher.view("dlIv_" .. i .. "_name")
    local dateV = launcher.view("dlIv_" .. i .. "_date")
    if nameV then nameV:setText(it and it.id or "") end
    if dateV then dateV:setText(it and (it.date or "") or "") end
    local icoV = launcher.view("dlIv_" .. i .. "_ico")
    if icoV then icoV:setStyle({ tint = (it and it.id == PLC.mc) and C.accent or C.mid }) end
    local rowV = launcher.view("dlIv_" .. i)
    if rowV then rowV:setVisible(PLC.mcOpen and it ~= nil) end
  end
  -- 预览卡 + Minecraft 卡文本
  launcher.view("insVersion"):setText(PLC.mc ~= "" and PLC.mc or "未选择版本")
  launcher.view("insMcVer"):setText(PLC.mc ~= "" and PLC.mc or "未选择版本")
  -- 组件卡：✓按钮/×可见性/冲突禁用（与已选加载器互斥则灰禁用整卡）
  local selected = {}
  for i, nm in ipairs(D.loaders or {}) do if compSel[i] then selected[nm] = true end end
  for i, nm in ipairs(D.loaders or {}) do
    local bad = false
    for _, c in ipairs(D.conflicts or {}) do
      local other = (c.a == nm) and c.b or ((c.b == nm) and c.a or nil)
      if other and selected[other] then bad = true break end
    end
    local sel = compSel[i]
    local hV = launcher.view("dlCompH_" .. i)
    local btnV = launcher.view("dlCompBtn_" .. i)
    if hV then hV:setEnabled(not bad) end
    if btnV then btnV:setVisible(not bad) end
    launcher.view("dlCompVer_" .. i):setText(bad and (D.compConflictTip or "与加载器不兼容") or (sel or "未选择"))
    local xV = launcher.view("dlCompX_" .. i)
    if xV then xV:setVisible(sel ~= nil) end
    -- 组件行内列表折叠状态
    local open = compOpen[i] == true
    for j = 1, (D.compVersionSlots or 5) do
      local rv = launcher.view("dlCompV_" .. i .. "_" .. j)
      if rv then rv:setVisible(open) end
    end
  end
end

-- 下载页版本分组内单个版本行（原版版本完整列表，由 append 动态挂入滚动容器）
local function dlGrpVersionRow(gkey, j, it)
  return ui.row { id = "dlGrpVer_" .. gkey .. "_" .. j, width = "100%", height = "6.5vh",
    background = C.card, corner = "0", border = { width = "0", color = C.cardBorder },
    hoverColor = C.hover, crossAlign = "center", spacing = "1.2vh",
    padding = { left = "1.6vh", right = "1.6vh" }, action = "dlGrpVer:" .. gkey .. ":" .. j,
    children = {
      ui.image { icon = "sf:cube.fill", size = "2.6vh", style = { tint = C.accent } },
      ui.column { weight = 1, crossAlign = "stretch", spacing = "0.5vh", children = {
        ui.text { id = "dlGrpVer_" .. gkey .. "_" .. j .. "_name", text = it and it.id or "",
          width = "100%", style = { font = "2.3vh", color = C.dark } },
        ui.text { id = "dlGrpVer_" .. gkey .. "_" .. j .. "_date",
          text = it and (it.date or "") or "", width = "100%",
          style = { font = "1.9vh", color = C.mid } },
      } },
      chevron(),
    } }
end

-- 下载页首屏版本分组列表刷新：按 dlOpenGroup 展开分组。
-- 首次展开时把该组的全部版本行一次性追加进列表容器（dlGrpVersionRow × N，引擎滚动完整列表），
-- 此后折叠/展开只切换列表容器可见性；版本数量无上限（mod 等其它下载内容不走此路径）。
local function refreshDownloadGroups()
  for _, g in ipairs(CONFIG.download.versionGroups or {}) do
    local key = g.key
    local open = dlOpenGroup[key] == true
    if open and not dlGroupAppended[key] then
      local rows = dlGroups[key] or {}
      local nodes = {}
      for j = 1, #rows do nodes[#nodes + 1] = dlGrpVersionRow(key, j, rows[j]) end
      local listV = launcher.view("dlGrpList_" .. key)
      if listV and #nodes > 0 then
        listV:append(nodes)
        dlGroupAppended[key] = true
      end
    end
    local listV = launcher.view("dlGrpList_" .. key)
    if listV then listV:setVisible(open) end
    local hV = launcher.view("dlGh_" .. key)
    if hV then hV:setStyle({ background = open and C.hover or C.card }) end
  end
end

-- 下载页层级切换：groups=版本分组列表 / install=安装面板
local function refreshDownloadState()
  launcher.view("dlGroupsCard"):setVisible(dlLevel == "groups")
  launcher.view("dlvRoot"):setVisible(dlLevel == "install")
  if dlLevel == "groups" then
    refreshDownloadGroups()
  else
    refreshInstallPanel()
  end
end

-- ============ 下载页（无侧栏、通栏纵向流：分组卡片）============
-- PCL II 安装面板：预览卡 + Minecraft 卡 + 组件卡×N（行内下拉，贴合连成一体）
local function buildDownloadPage()
  local D = CONFIG.download
  local maxR = D.maxVersionRows or 12
  local compN = #(D.loaders or {})

  -- 首屏「版本分组」列表：分组行（dlGh_<key>）+ 内联版本列表容器（dlGrpList_<key>）。
  -- 列表容器初始为空；展开时由 refreshDownloadGroups 用 listV:append(dlGrpVersionRow × N)
  -- 一次性注入该组全部版本（版本行构建见模块级 dlGrpVersionRow），整个页面随内容滚动。
  local function grpCard()
    local rows = {}
    for _, g in ipairs(D.versionGroups or {}) do
      rows[#rows + 1] = ui.row { id = "dlGh_" .. g.key, height = "7vh", width = "100%",
        background = C.card, corner = "0", border = { width = "0", color = C.cardBorder },
        hoverColor = C.hover, crossAlign = "center", spacing = "1.4vh",
        padding = { left = "1.6vh", right = "1.6vh" }, action = "dlGh:" .. g.key,
        children = {
          ui.image { icon = "sf:shippingbox.fill", size = "3vh", corner = "pill",
            background = C.faintBlue, style = { tint = C.accent } },
          ui.text { text = g.name, weight = 1, style = { font = "2.6vh", color = C.dark } },
          ui.text { text = "›", style = { font = "3vh", color = C.mid } },
        } }
      rows[#rows + 1] = ui.column { id = "dlGrpList_" .. g.key, width = "100%",
        crossAlign = "stretch", spacing = "0", children = {} }
    end
    return ui.column { id = "dlGroupsCard", width = "70%", background = C.card, border = BORDER,
      corner = "1vh", shadow = SHADOW, padding = "0", overflow = "hidden",
      children = rows }
  end

  -- Minecraft 卡内版本行（贴合：无外边距，顶部细分割线）
  local function mcRow(i)
    return ui.row { id = "dlIv_" .. i, width = "100%", height = "7vh", background = C.card,
      corner = "0", border = { width = "0", color = C.cardBorder }, hoverColor = C.hover,
      crossAlign = "center", spacing = "1.2vh", padding = { left = "1.2vh", right = "1.2vh" },
      action = "dlIv:" .. i, visible = false,
      children = {
        ui.image { id = "dlIv_" .. i .. "_ico", icon = "sf:cube.fill", size = "2.6vh",
          style = { tint = C.mid } },
        ui.column { weight = 1, crossAlign = "stretch", spacing = "0.4vh", children = {
          ui.text { id = "dlIv_" .. i .. "_name", text = "", width = "100%",
            style = { font = "2.3vh", color = C.dark } },
          ui.text { id = "dlIv_" .. i .. "_date", text = "", width = "100%",
            style = { font = "1.9vh", color = C.mid } },
        } },
        chevron(),
      } }
  end

  -- 组件卡内版本行（结构占位；加载器版本服务未接入，仅描述结构）
  local function compRow(i, j)
    return ui.row { id = "dlCompV_" .. i .. "_" .. j, width = "100%", height = "7vh",
      background = C.card, corner = "0", border = { width = "0", color = C.cardBorder },
      hoverColor = C.hover, crossAlign = "center", spacing = "1.2vh",
      padding = { left = "1.2vh", right = "1.2vh" }, action = "dlCompV:" .. i .. ":" .. j,
      visible = false,
      children = {
        ui.image { icon = "sf:cube.fill", size = "2.6vh", style = { tint = C.mid } },
        ui.text { id = "dlCompV_" .. i .. "_" .. j .. "_name", weight = 1, text = "· · ·",
          style = { font = "2.3vh", color = C.dark } },
        chevron(),
      } }
  end

  -- 组件卡头部：左名称 / 中 图标+当前版本 / 右 按钮区（未选只有>，选中 >+×）
  local function compHeader(i)
    local nm = D.loaders[i]
    local btnKids = {
      ui.button { id = "dlCompX_" .. i, label = "✕", width = "3.5vh", height = "3.5vh",
        corner = "pill", background = C.cardBorder, action = "dlCompX:" .. i,
        style = { font = "2.6vh", tint = C.dark }, visible = false },
      ui.button { id = "dlCompC_" .. i, label = "›", width = "3.5vh", height = "3.5vh",
        corner = "pill", background = C.faintBlue, action = "dlCompC:" .. i,
        style = { font = "3vh", tint = C.accent } },
    }
    return {
      ui.text { text = nm, weight = 1, style = { font = "2.6vh", weight = "bold", color = C.dark } },
      ui.row { weight = 1, height = "7vh", crossAlign = "center", spacing = "0.8vh", children = {
        ui.image { icon = "sf:wrench.and.screwdriver.fill", size = "3vh",
          style = { tint = C.mid } },
        ui.text { id = "dlCompVer_" .. i, text = "未选择", style = { font = "2.3vh", color = C.mid } },
      } },
      ui.row { id = "dlCompBtn_" .. i, width = "9vh", crossAlign = "center",
        spacing = "0.7vh", children = btnKids },
    }
  end

  local sec1 = ui.column { id = "dlvRoot", width = "100%", crossAlign = "center", spacing = "2vh",
    children = (function()
      local cards = {}

      -- 卡1 安装预览卡：左图标 + (版本号/摘要) + 开始安装 + 版本名称输入
      cards[#cards + 1] = ui.column { id = "dlPrevCard", width = "70%", height = "14vh",
        background = C.card, border = BORDER, corner = "1vh", shadow = SHADOW,
        padding = { left = "1.5vh", right = "1.5vh", top = "1.4vh", bottom = "1.4vh" },
        spacing = "0.8vh", crossAlign = "stretch",
        children = {
          ui.row { width = "100%", height = "6vh", crossAlign = "center", spacing = "1.5vh",
            children = {
              ui.image { icon = "sf:shippingbox.fill", size = "6vh", corner = "1.2vh",
                background = { from = C.accent, to = C.cyan, angle = 30 }, style = { tint = C.white } },
              ui.column { weight = 1, justify = "center", spacing = "0.5vh", children = {
                ui.text { id = "insVersion", text = PLC.mc, width = "100%",
                  style = { font = "2.9vh", weight = "bold", color = C.dark } },
                ui.text { id = "insSummary", text = D.installHint, width = "100%",
                  style = { font = "2.1vh", color = C.mid } },
              } },
              ui.button { id = "dlBackGrp", label = "‹ 版本列表", width = "18vh", height = "6vh",
                background = C.faintBlue, corner = "0.9vh", action = "dlBackGrp",
                style = { font = "2.2vh", tint = C.accent, weight = "bold" } },
              ui.button { id = "insStart", label = "开始安装", width = "24vh", height = "6vh",
                background = C.accent, corner = "0.9vh", action = "insStart",
                style = { font = "2.4vh", weight = "bold", tint = C.white } },
            } },
          ui.divider { height = "0.16vh", background = C.cardBorder },
          ui.row { width = "100%", height = "4.5vh", crossAlign = "center", spacing = "1.2vh",
            children = {
              ui.text { text = "版本名称", width = "12vh", style = { font = "2.3vh", color = C.dark } },
              ui.input { id = "insNameIn", text = "", placeholder = PLC.mc, weight = 1,
                height = "4.5vh", style = { font = "2.3vh", color = C.dark } },
            } },
        } }

      -- 卡2 Minecraft 版本卡 + 行内下拉（贴合一体）
      local mcRows = {}
      for i = 1, maxR do mcRows[#mcRows + 1] = mcRow(i) end
      cards[#cards + 1] = ui.column { id = "dlMcW", width = "70%", background = C.card,
        border = BORDER_A, corner = "1vh", shadow = SHADOW, padding = "0", overflow = "hidden",
        children = {
          ui.row { id = "dlMcH", width = "100%", height = "7vh", background = C.card,
            hoverColor = C.hover, crossAlign = "center", spacing = "1vh",
            padding = { left = "1.5vh", right = "1.5vh" }, action = "dlMcH",
            children = {
              ui.text { text = D.mcLabel or "Minecraft", weight = 1,
                style = { font = "2.6vh", weight = "bold", color = C.accent } },
              ui.row { weight = 1, height = "7vh", crossAlign = "center", spacing = "0.8vh",
                children = {
                  ui.image { icon = "sf:cube.fill", size = "3vh", style = { tint = C.mid } },
                  ui.text { id = "insMcVer", text = PLC.mc, style = { font = "2.4vh", color = C.dark } },
                } },
              ui.button { id = "dlMcBack", label = "返回", width = "12vh", height = "4vh",
                corner = "pill", background = C.faintBlue, action = "dlMcBack",
                style = { font = "2.2vh", tint = C.accent } },
            } },
          -- 展开列表（与卡片零间距贴合，宽同 70%）
          ui.column { id = "dlMcList", width = "100%", crossAlign = "stretch",
            spacing = "0", children = mcRows },
        } }

      -- 组件卡片×N：行内下拉（贴合）；冲突组件灰禁用
      for i = 1, compN do
        local crows = {}
        for j = 1, (D.compVersionSlots or 5) do crows[#crows + 1] = compRow(i, j) end
        cards[#cards + 1] = ui.column { id = "dlCompW_" .. i, width = "70%", background = C.card,
          border = BORDER, corner = "1vh", shadow = SHADOW, padding = "0", overflow = "hidden",
          children = {
            ui.row { id = "dlCompH_" .. i, width = "100%", height = "7vh", background = C.card,
              hoverColor = C.hover, crossAlign = "center", spacing = "1vh",
              padding = { left = "1.5vh", right = "1.5vh" }, action = "dlCompH:" .. i,
              children = compHeader(i) },
            ui.column { id = "dlCompList_" .. i, width = "100%", crossAlign = "stretch",
              spacing = "0", children = crows },
          } }
      end

      -- 兼容性提示 + 下载进度区
      cards[#cards + 1] = ui.row { width = "70%", background = C.faintBlue, corner = "1vh",
        crossAlign = "center", spacing = "1vh", padding = "1.2vh",
        children = {
          ui.text { text = "ⓘ", style = { font = "2.6vh", color = C.accent } },
          ui.text { text = D.installHint, weight = 1, style = { font = "2vh", color = C.dark } },
        } }
      cards[#cards + 1] = ui.column { id = "dlProgress", width = "70%", visible = false, spacing = "1vh",
        crossAlign = "stretch",
        children = {
          ui.row { height = "1.6vh", background = C.faintBlue, corner = "pill", overflow = "hidden",
            children = { ui.column { id = "dlBarFill", width = "0%", height = "100%",
              background = { from = C.accent, to = C.cyan, angle = 0 } } } },
          ui.text { id = "dlProgressLabel", text = "准备中…", width = "100%",
            style = { font = "2.2vh", color = C.dark } },
        } }
      return cards
    end)() }
  -- 社区资源：搜索 + 结果列表（随 dlSelCat 切换分类，单一结构避免节点 id 冲突）
  local function commPickerRow(id, label, valueId, action)
    return ui.row {
      id = id, height = "4.5vh", width = "100%", crossAlign = "center", hoverColor = C.hover, action = action,
      children = {
        ui.text { text = label, style = { font = "2.4vh", color = C.dark } },
        ui.spacer { weight = 1 },
        ui.row { weight = 3, width = "70%", height = "4.5vh", background = C.card,
          border = { width = "0.12vh", color = C.fieldBorder }, corner = "0.8vh", crossAlign = "center",
          padding = { left = "1.2vh", right = "1.2vh" },
          children = {
            ui.text { id = valueId, text = "…", weight = 1, style = { font = "2.2vh", color = C.dark } },
            ui.text { text = " ▾", style = { font = "2.2vh", color = C.mid } },
          } },
      } }
  end
  local commSlots = {}
  for i = 1, CONFIG.download.communityResultSlots do
    commSlots[#commSlots + 1] = ui.row {
      id = "dlComm_" .. i, height = "9vh", background = C.card, corner = "1.1vh",
      border = BORDER, hoverColor = C.hover, crossAlign = "center", spacing = "1.5vh",
      padding = "1.5vh", visible = false, action = "dlComm:" .. i,
      children = {
        ui.image { icon = "sf:cube.fill", size = "6vh", corner = "pill", background = C.accent,
          style = { tint = C.white } },
        ui.column { weight = 1, justify = "center", spacing = "0.5vh", children = {
          ui.text { id = "dlComm_" .. i .. "_title", text = "", style = { font = "2.4vh", weight = "bold", color = C.dark } },
          ui.text { id = "dlComm_" .. i .. "_meta", text = "", style = { font = "2vh", color = C.mid } },
        } },
        ui.text { id = "dlComm_" .. i .. "_btn", text = "下载", style = { font = "2.2vh", color = C.accent } },
      } }
  end
  local searchCard = card("dlSearchCard", { ui.text { text = "搜索", style = { font = "2.8vh", weight = "bold", color = C.dark } },
    commPickerRow("dlSrcRow", "搜索源", "dlSrcVal", "dlPick:source"),
    commPickerRow("dlObjRow", "搜索对象", "dlObjVal", nil),
    commPickerRow("dlKwRow", "搜索关键词", "dlKwVal", "dlPick:keyword"),
    ui.row { width = "100%", height = "5.5vh", spacing = "3vh",
      children = { plainButton("dlBtnSearch", "搜索", false), plainButton("dlBtnReset", "重置", false) } } })
  local resultCards = { ui.text { text = "结果", style = { font = "2.8vh", weight = "bold", color = C.dark } } }
  pushAll(resultCards, commSlots)
  resultCards[#resultCards + 1] = ui.text { id = "dlCommStatus", text = CONFIG.download.searchStatusPreset, width = "100%",
    style = { font = "2.2vh", color = C.mid } }
  resultCards[#resultCards + 1] = ui.column { id = "dlCommBarBox", width = "100%", visible = false,
    spacing = "1vh", crossAlign = "stretch",
    children = {
      ui.row { height = "1.6vh", background = C.faintBlue, corner = "pill", overflow = "hidden",
        children = { ui.column { id = "dlCommBarFill", width = "0%", height = "100%",
          background = { from = C.accent, to = C.cyan, angle = 0 } } } },
      ui.text { id = "dlCommBarLabel", text = "", width = "100%", style = { font = "2.2vh", color = C.dark } },
    } }
  local kids = {
    ui.text { id = "dlTitle", text = CONFIG.download.titleByCat[dlSelCat] or "原版游戏", width = "100%",
      style = { font = "3vh", weight = "bold", color = C.dark } },
    -- 分类1：原版游戏 → 最新版本
    ui.column { id = "dlSec_1", width = "100%", crossAlign = "center", spacing = "2vh",
      children = { grpCard(), sec1 } },
    -- 分类2..6：社区资源 → 搜索 + 结果列表（随 dlSelCat 切换分类）
    ui.column { id = "dlSecC", width = "100%", crossAlign = "center", spacing = "2vh", visible = false,
      children = { searchCard, card("dlResultCardC", resultCards) } },
  }
  return ui.column { id = "pageDownload", weight = 1, crossAlign = "center",
    padding = "1.6vh", spacing = "1.6vh", children = kids }
end

-- ============ 联机页（两分支 + 加入/创建行 + 状态行 + 房间条目卡）============
local MP_MAX_ROOMS = 6

local function mpRoomSlot(i)
  return ui.row { id = "mpRoom_" .. i, height = "7vh", background = C.card,
    border = BORDER, corner = "1.2vh", hoverColor = C.hover, crossAlign = "center", spacing = "1.5vh",
    padding = "1.5vh", visible = false,
    children = {
      ui.image { icon = "sf:square.3.layers.3d", size = "5vh", corner = "1vh", background = C.accent,
        style = { tint = C.white } },
      ui.column { weight = 1, justify = "center", spacing = "0.3vh", children = {
        ui.text { id = "mpRoom_" .. i .. "_name", text = "", style = { font = "2.4vh", weight = "bold", color = C.dark } },
        ui.text { id = "mpRoom_" .. i .. "_status", text = "", style = { font = "2vh", color = C.mid } },
      } },
      ui.text { id = "mpRoom_" .. i .. "_action", text = "连接", style = { font = "2.2vh", color = C.accent } },
    } }
end

local function buildMultiPage()
  local slots = {}
  for i = 1, MP_MAX_ROOMS do slots[#slots + 1] = mpRoomSlot(i) end
  return ui.column { id = "pageMulti", weight = 1, crossAlign = "center",
    padding = "1.6vh", spacing = "1.6vh",
    children = {
      segmentRow("segM", CONFIG.online.branch, "1vh"),
      -- 加入行
      ui.row { id = "mpJoinRow", width = "94%", height = "5.5vh", background = C.card, border = BORDER,
        corner = "1.2vh", crossAlign = "center", padding = "1.5vh", spacing = "1.2vh", hoverColor = C.hover,
        children = {
          ui.image { icon = "sf:link", size = "2.6vh", style = { tint = C.mid } },
          ui.text { weight = 1, text = "输入房间连接码加入房间…", style = { font = "2.2vh", color = C.mid } },
          ui.button { id = "mpJoin", label = "加入", height = "4vh", background = C.accent,
            corner = "pill", style = { font = "2.2vh", tint = C.white } },
        } },
      -- 创建行
      ui.row { id = "mpCreateRow", width = "94%", height = "5.5vh", background = C.card, border = BORDER,
        corner = "1.2vh", crossAlign = "center", padding = "1.5vh", spacing = "1.2vh", hoverColor = C.hover,
        children = {
          ui.image { icon = "sf:plus.circle", size = "2.6vh", style = { tint = C.mid } },
          ui.text { weight = 1, text = "输入 Network ID 创建房间…", style = { font = "2.2vh", color = C.mid } },
          ui.button { id = "mpCreate", label = "创建", height = "4vh", background = C.accent,
            corner = "pill", style = { font = "2.2vh", tint = C.white } },
        } },
      -- 状态行
      ui.row { id = "mpStatusRow", width = "94%", background = C.hintBg, corner = "1vh", crossAlign = "center",
        spacing = "1.2vh", padding = "1.5vh",
        children = {
          ui.text { id = "mpStatusIcon", text = "ⓘ", style = { font = "2.8vh", color = C.accent } },
          ui.text { id = "mpStatus", weight = 1, text = "联机需要双方都能访问服务器，房间连接码用于分享。",
            style = { font = "2.2vh", color = C.dark } },
        } },
      -- 房间条目卡
      card("mpRoomCard", (function()
        local k = { ui.text { text = "在线房间", style = { font = "2.8vh", weight = "bold", color = C.dark } } }
        pushAll(k, slots)
        return k
      end)()),
    } }
end

-- ============ 设置页（PCL2 风格：关于卡 + 分组白卡，每组标题 + 行）============
local function buildSettingsPage()
  local kids = {}
  -- 关于卡
  kids[#kids + 1] = ui.column { id = "setAbout", width = "94%", background = C.card, border = BORDER,
    corner = "1.2vh", shadow = SHADOW, padding = "3vh", crossAlign = "center", spacing = "1.2vh",
    children = {
      ui.image { icon = "sf:shippingbox.fill", size = "8vh", corner = "1.6vh",
        background = { from = C.accent, to = C.cyan, angle = 30 }, style = { tint = C.white } },
      ui.text { text = "Pear 启动器", style = { font = "3vh", weight = "bold", color = C.dark } },
      ui.text { text = "版本 · · ·", style = { font = "2.2vh", color = C.mid } },
      ui.text { text = "系统信息 …  ·  设备架构 …", style = { font = "2.2vh", color = C.mid } },
    } }
  -- 分类内容：每分类一个 section（id=setSec_<id>），随左侧目录选中切换可见（行内展开，非跳子页）
  for gi, g in ipairs(CONFIG.settingsGroups) do
    local rows = {}
    rows[#rows + 1] = ui.text { text = (CONFIG.settingsGroupNames[gi] or g.label) .. " · " .. g.label,
      width = "100%", style = { font = "2.4vh", weight = "bold", color = C.dark } }
    for _, s in ipairs(g.rows or {}) do
      rows[#rows + 1] = settingsItemRow(s)
    end
    kids[#kids + 1] = ui.column { id = "setSec_" .. g.id, width = "94%", crossAlign = "center",
      spacing = "2vh", visible = (g.id == setSelCat),
      children = { card("setCard_" .. g.id, rows, { spacing = "1.5vh" }) } }
  end
  -- 状态提示条（开关/按钮的即时反馈落点；浅蓝底 H）
  kids[#kids + 1] = ui.row { id = "setStatusBar", width = "94%", background = C.hintBg,
    corner = "1vh", crossAlign = "center", spacing = "1.2vh", padding = "1.5vh",
    children = {
      ui.text { id = "setStatusIcon", text = "ⓘ", style = { font = "2.8vh", color = C.accent } },
      ui.text { id = "setStatus", weight = 1, text = CONFIG.settingsStatus,
        style = { font = "2.2vh", color = C.dark } },
    } }
  return ui.column { id = "pageSettings", weight = 1, crossAlign = "center",
    padding = "1.6vh", spacing = "1.6vh", children = kids }
end

-- ============ 更多页（左侧分类 + 右侧分组卡片，仿 PCL 更多页）============
local function buildMorePage()
  local kids = {}
  -- 主题包（Material Pack）信息卡：名称 + 当前加载版本（版本动态填充，不硬编码）
  kids[#kids + 1] = ui.column { id = "moreSec_theme", width = "94%", spacing = "1.2vh",
    crossAlign = "stretch",
    children = {
      ui.text { text = "主题包", width = "100%", style = { font = "2.4vh", weight = "bold", color = C.dark } },
      ui.column { background = C.card, border = BORDER, corner = "1.2vh", shadow = SHADOW,
        padding = "1vh", spacing = "0.5vh",
        children = {
          ui.row { id = "moreThemeName", height = "6.5vh", crossAlign = "center",
            spacing = "1.6vh", padding = "1.8vh",
            children = {
              ui.image { icon = "sf:paintbrush.fill", size = "4.5vh", corner = "pill",
                background = C.faintBlue, style = { tint = C.accent } },
              ui.text { text = "主题包名称", weight = 1, style = { font = "2.6vh", color = C.dark } },
              ui.text { id = "moreThemeName_text", text = "PCL 浅色", style = { font = "2.5vh", color = C.mid } },
            } },
          ui.row { id = "moreThemeVer", height = "6.5vh", crossAlign = "center",
            spacing = "1.6vh", padding = "1.8vh",
            children = {
              ui.image { icon = "sf:tag.fill", size = "4.5vh", corner = "pill",
                background = C.faintBlue, style = { tint = C.accent } },
              ui.text { text = "主题包版本", weight = 1, style = { font = "2.6vh", color = C.dark } },
              ui.text { id = "moreThemeVersion", text = "· · ·", style = { font = "2.5vh", color = C.mid } },
            } },
        } } } }
  for _, g in ipairs(CONFIG.moreGroups) do
    local rows = {}
    for _, rr in ipairs(g.rows) do
      local rightNode
      if rr.right == "version" then
        rightNode = ui.text { id = rr.id .. "_val", text = "· · ·", style = { font = "2.6vh", color = C.mid } }
      else
        rightNode = chevron()
      end
      rows[#rows + 1] = ui.row { id = rr.id, height = "7vh", crossAlign = "center",
        spacing = "1.6vh", padding = "1.8vh", hoverColor = C.hover, action = (rr.action or "open:more"),
        children = {
          ui.image { icon = rr.icon or "sf:gearshape.fill", size = "4.5vh",
            corner = "pill", background = C.faintBlue, style = { tint = C.accent } },
          ui.text { text = rr.label, weight = 1, style = { font = "2.7vh", color = C.dark } },
          rightNode,
        } }
    end
    kids[#kids + 1] = ui.column { id = "moreSec_" .. g.name, width = "94%", spacing = "1.2vh",
      crossAlign = "stretch",
      children = {
        ui.text { text = g.name, width = "100%", style = { font = "2.4vh", weight = "bold", color = C.dark } },
        ui.column { background = C.card, border = BORDER, corner = "1.2vh", shadow = SHADOW,
          padding = "1vh", spacing = "0.5vh", children = rows },
      } }
  end
  if #kids == 0 then
    kids[#kids + 1] = ui.text { text = "暂无更多选项。", style = { font = "2.2vh", color = C.mid } }
  end
  return ui.column { id = "pageMore", weight = 1, crossAlign = "center",
    padding = "1.6vh", spacing = "1.6vh", children = kids }
end

-- ============ 版本设置页（PCL2 风格：概览 / 设置 / Mod 管理 / 资源 / 高级）============
local VS_SETTING_LABELS = {
  versionIsolation = "默认版本隔离",
  windowTitle      = "游戏窗口标题",
  windowInfo       = "自定义信息",
  javaVersion      = "游戏 Java",
  ramType          = "内存分配",
  ram              = "内存大小",
  ramOptimize      = "启动前内存优化",
  serverIp         = "服务器地址",
  loginMode        = "登录模式",
}
local function buildVersionSettingsPage()
  local section = function(token, title, children)
    return ui.column { id = "vsSec_" .. token, width = "100%", crossAlign = "center",
      spacing = "2.5vh", visible = (token == vsSelCat), children = children }
  end
  -- 概览：版本信息 + 个性化 + 快捷方式 + 高级管理
  local overviewRows = {
    card("vsOverviewCard", {
      ui.row { width = "100%", height = "11vh", crossAlign = "center", spacing = "2vh", padding = "1vh",
        children = {
          ui.image { icon = "sf:doc.text.fill", size = "6vh", background = C.accent,
            corner = "1.2vh", style = { tint = C.white } },
          ui.column { weight = 1, justify = "center", spacing = "0.4vh", children = {
            ui.text { id = "vsName", text = "· · ·", style = { font = "2.8vh", weight = "bold", color = C.dark } },
            ui.text { id = "vsMeta", text = "版本信息 · · ·", style = { font = "2.1vh", color = C.mid } },
          } },
        } },
    }, { spacing = "1.2vh" }),
    card("vsPersonalize", {
      ui.text { text = "个性化", width = "100%", style = { font = "2.4vh", weight = "bold", color = C.dark } },
      pickerRow("vsIcon",     "图标", "自动", "vsIconVal"),
      pickerRow("vsCategory", "分类", "自动", "vsCategoryVal"),
      ui.row { width = "100%", height = "5.5vh", spacing = "2vh",
        children = {
          plainButton("vsRename", "修改版本名", false),
          plainButton("vsDesc",   "修改描述",   false),
          plainButton("vsFav",    "加入收藏夹", false),
        } },
    }, { spacing = "1.8vh" }),
    card("vsShortcuts", {
      ui.text { text = "快捷方式", width = "100%", style = { font = "2.4vh", weight = "bold", color = C.dark } },
      ui.row { width = "100%", height = "5.5vh", spacing = "2vh",
        children = {
          plainButton("vsOpenDir",   "版本文件夹", false, "vsOpenDir"),
          plainButton("vsOpenSaves", "存档文件夹", false, "vsOpenSaves"),
          plainButton("vsOpenMods",  "Mod 文件夹", false, "vsOpenMods"),
        } },
    }, { spacing = "1.8vh" }),
    card("vsAdvOverview", {
      ui.text { text = "高级管理", width = "100%", style = { font = "2.4vh", weight = "bold", color = C.dark } },
      ui.row { width = "100%", height = "5.5vh", spacing = "2vh",
        children = {
          plainButton("vsExport",   "导出启动脚本", false),
          plainButton("vsComplete", "补全文件",     false, "vsComplete"),
        } },
      ui.button { id = "vsDeleteTop", label = "删除本版本", width = "100%", height = "5.5vh",
        background = C.card, border = BORDER_D, corner = "0.7vh", action = "vsDelete",
        style = { font = "2.4vh", tint = C.danger } },
    }, { spacing = "1.8vh" }),
  }
  -- 设置：从 engine versionSettings.list 动态取值
  local settingsRows = {}
  for _, k in ipairs({"versionIsolation","windowTitle","windowInfo","javaVersion","ramType","ram","ramOptimize","serverIp","loginMode"}) do
    settingsRows[#settingsRows + 1] = pickerRow("vsSet_" .. k, VS_SETTING_LABELS[k] or k, "···", "vsSet_" .. k .. "Val")
  end
  settingsRows[#settingsRows + 1] = ui.row { width = "100%", height = "5.5vh", spacing = "3vh",
    children = { plainButton("vsReset", "重置版本设置", false, "vsReset") } }

  -- Mod 管理
  local modRows = {
    ui.row { width = "100%", height = "5.5vh", background = C.card, border = BORDER,
      corner = "0.8vh", crossAlign = "center", padding = { left = "1.5vh", right = "1.5vh" }, spacing = "1.2vh",
      children = {
        ui.image { icon = "sf:magnifyingglass", size = "2.6vh", style = { tint = C.mid } },
        ui.text { text = "搜索 Mod 名称 / 描述 / 标签", weight = 1, style = { font = "2.2vh", color = C.mid } },
      } },
    ui.row { width = "100%", height = "5.5vh", spacing = "1.5vh",
      children = {
        plainButton("vsModOpenDir",    "打开文件夹",   false, "vsOpenMods"),
        plainButton("vsModInstallFile","从文件安装",   false),
        plainButton("vsModDownload",   "下载新 Mod",   false),
        plainButton("vsModSelectAll",  "全选",         false),
      } },
    ui.text { id = "vsModEmpty", text = "当前版本未安装 Mod 加载器或暂无 Mod。",
      width = "100%", style = { font = "2.4vh", color = C.mid } },
    ui.button { id = "vsModInstallLoader", label = "安装 Forge/Fabric", width = "100%", height = "5.5vh",
      background = C.accent, corner = "0.8vh", action = "vsModInstall",
      style = { font = "2.4vh", weight = "bold", tint = C.white } },
  }

  return ui.column { id = "pageVersionSettings", weight = 1, crossAlign = "center",
    padding = "1.6vh", spacing = "1.6vh",
    children = {
      section("info",     "概览",       overviewRows),
      section("launch",   "设置",       { card("vsSettingsCard", settingsRows, { spacing = "1.8vh" }) }),
      section("mod",      "Mod 管理",   { card("vsModCard", modRows, { spacing = "1.8vh" }) }),
      section("resource", "资源包 / 光影", {
        card("vsResource", {
          listEntry("vsResPack", "sf:sun.max.fill", C.orange, "资源包", "管理当前版本资源包", "›", "vsResPack"),
          listEntry("vsShader",  "sf:sparkles",     C.cyan,   "光影包", "管理当前版本光影包", "›", "vsShader"),
        }),
      }),
      section("advanced", "高级管理", {
        card("vsAdv", {
          ui.row { width = "100%", height = "5.5vh", spacing = "3vh",
            children = {
              plainButton("vsAdv1", "打开安装目录", false, "vsOpenDir"),
              plainButton("vsAdv2", "重置版本",     false, "vsReset"),
            } },
          ui.button { id = "vsAdvDanger", label = "删除本版本", width = "100%", height = "5.5vh",
            background = C.card, border = BORDER_D, corner = "0.7vh", action = "vsDelete",
            style = { font = "2.4vh", tint = C.danger } },
        }),
      }),
    } }
end

-- ============ 版本下载详情页（版本信息 + 加载器选择 + 下载；仿 PCL 安装面板）============
local function buildVersionDetailPage()
  local loaderRow = {}
  for i, lab in ipairs(CONFIG.download.loaders or {}) do
    loaderRow[#loaderRow + 1] = ui.button { id = "vdL_" .. i, label = lab, weight = 1,
      height = "4.5vh", corner = "pill", action = "vdL_" .. i, hoverColor = C.hover,
      style = { background = C.transparent, tint = C.dark, font = "2.3vh" } }
  end
  return ui.column { id = "pageVersionDetail", weight = 1, crossAlign = "center",
    padding = "1.6vh", spacing = "1.6vh",
    children = {
      -- 页眉：返回下载页 + 标题
      ui.row { id = "vdHeader", width = "94%", height = "6vh", crossAlign = "center", spacing = "1.5vh",
        children = {
          ui.button { id = "vdBack", label = "‹ 返回", action = "open:download", width = "22%", height = "5vh",
            background = C.card, border = BORDER, corner = "0.8vh", hoverColor = C.hover,
            style = { font = "2.4vh", weight = "bold", tint = C.dark } },
          ui.text { text = "版本详情", weight = 1,
            style = { font = "3vh", weight = "bold", color = C.dark } },
        } },
      -- 版本信息卡
      card("vdInfoCard", {
        ui.row { width = "100%", crossAlign = "center", spacing = "2vh", padding = "1vh",
          children = {
            ui.image { icon = "sf:cube.fill", size = "7vh", corner = "1.3vh",
              background = { from = C.accent, to = C.cyan, angle = 30 }, style = { tint = C.white } },
            ui.column { weight = 1, justify = "center", spacing = "0.5vh", children = {
              ui.text { id = "vdVersion", text = dlCurrent and dlCurrent.id or "· · ·",
                style = { font = "3vh", weight = "bold", color = C.dark } },
              ui.text { id = "vdType", text = "请先选择一个版本",
                style = { font = "2.1vh", color = C.mid } },
            } },
          } },
      }),
      -- 加载器选择卡
      card("vdLoaderCard", {
        ui.text { text = "加载器", width = "100%", style = { font = "2.8vh", weight = "bold", color = C.dark } },
        ui.row { width = "100%", crossAlign = "center", spacing = "1vh", children = loaderRow },
      }),
      -- 下载按钮
      ui.button { id = "vdInstall", label = "下载并安装", width = "94%", height = "6vh",
        background = C.accent, corner = "0.9vh", action = "vdInstall",
        style = { font = "2.6vh", weight = "bold", tint = C.white } },
    } }
end

-- ============ 版本管理二级页（列表 + 选中 + 返回可回首页）============
local function buildVersionManagerPage()
  local resp = launcher.service and launcher.service("version", "list", {}) or nil
  local items = (type(resp) == "table" and resp.ok and type(resp.items) == "table") and resp.items or {}
  local kids = {
    -- 页眉：返回首页 + 标题
    ui.row { id = "vmHeader", width = "94%", height = "6vh", crossAlign = "center", spacing = "1.5vh",
      children = {
        ui.button { id = "vmBack", label = "‹ 返回", action = "open:home", width = "22%", height = "5vh",
          background = C.card, border = BORDER, corner = "0.8vh", hoverColor = C.hover,
          style = { font = "2.4vh", weight = "bold", tint = C.dark } },
        ui.text { text = CONFIG.versionManager.title, weight = 1,
          style = { font = "3vh", weight = "bold", color = C.dark } },
      } },
  }
  for i, v in ipairs(items) do
    local sel = v.selected
    kids[#kids + 1] = ui.row { id = "vm" .. i, height = "8vh", background = C.card, border = BORDER,
      corner = "1.2vh", shadow = SHADOW, crossAlign = "center", spacing = "1.6vh", padding = "1.8vh",
      action = "open:version_settings",
      children = {
        ui.image { icon = (v.type == "release" and "sf:checkmark.seal.fill" or "sf:cube.fill"),
          size = "4.5vh", corner = "1vh", background = C.accent, style = { tint = C.white } },
        ui.column { weight = 1, justify = "center", spacing = "0.3vh", children = {
          ui.text { id = "vm" .. i .. "Name", text = v.id or "", style = { font = "2.7vh", weight = "bold", color = C.dark } },
          ui.text { text = (sel and "当前使用" or "本地版本"), style = { font = "2vh", color = C.mid } },
        } },
        chevron(),
      } }
  end
  if #items == 0 then
    kids[#kids + 1] = ui.text { text = CONFIG.versionManager.emptyText, width = "94%",
      style = { font = "2.2vh", color = C.mid } }
  end
  kids[#kids + 1] = plainButton("vmAdd", "前往下载新版本", false)
  return ui.column { id = "pageVersionManager", weight = 1, crossAlign = "center",
    padding = "1.6vh", spacing = "1.6vh", children = kids }
end

-- ============ 通用设置子页（token → 标题 + 单一大白卡分组条目；返回设置）============
local function buildSettingsSubpage(token, spec)
  local cardRows = {}
  for gi, g in ipairs(spec.groups or {}) do
    if gi > 1 then
      cardRows[#cardRows + 1] = ui.divider { height = "0.2vh", background = C.cardBorder }
    end
    cardRows[#cardRows + 1] = ui.text { text = g.name or "", width = "100%",
      style = { font = "2.1vh", color = C.mid } }
    for ri, r in ipairs(g.rows or {}) do
      cardRows[#cardRows + 1] = ui.row { id = "sub" .. token .. "r" .. gi .. "_" .. ri,
        height = "6.5vh", crossAlign = "center", padding = "1.8vh", spacing = "1.6vh",
        hoverColor = C.hover, action = "subRow:" .. token .. ":" .. gi .. "_" .. ri,
        children = {
          ui.text { text = r.label or "", weight = 1, style = { font = "2.6vh", color = C.dark } },
          ui.text { text = r.value or "", style = { font = "2.4vh", color = C.accent } },
          chevron(),
        } }
    end
  end
  return ui.column { id = "sub_" .. token, weight = 1, crossAlign = "center",
    padding = "1.6vh", spacing = "1.6vh",
    children = {
      ui.row { id = "sub" .. token .. "Header", width = "94%", height = "6vh",
        crossAlign = "center", spacing = "1.5vh",
        children = {
          ui.button { id = "sub" .. token .. "Back", label = "‹ 返回", action = "open:settings",
            width = "22%", height = "5vh", background = C.card, border = BORDER, corner = "0.8vh",
            hoverColor = C.hover, style = { font = "2.4vh", weight = "bold", tint = C.dark } },
          ui.text { text = spec.title or "", weight = 1,
            style = { font = "3vh", weight = "bold", color = C.dark } },
        } },
      card("sub" .. token .. "Card", cardRows, { spacing = "1vh" }),
    } }
end

-- ============ 账号管理二级页（已登录账号列表 + 返回首页）============
local function buildAccountManagerPage()
  local resp = launcher.service and launcher.service("account", "list", {}) or nil
  local items = (type(resp) == "table" and resp.ok and type(resp.items) == "table") and resp.items or {}
  local kids = {
    ui.row { id = "amHeader", width = "94%", height = "6vh", crossAlign = "center", spacing = "1.5vh",
      children = {
        ui.button { id = "amBack", label = "‹ 返回", action = "open:home", width = "22%", height = "5vh",
          background = C.card, border = BORDER, corner = "0.8vh", hoverColor = C.hover,
          style = { font = "2.4vh", weight = "bold", tint = C.dark } },
        ui.text { text = CONFIG.accountManager.title, weight = 1,
          style = { font = "3vh", weight = "bold", color = C.dark } },
      } },
  }
  for i, a in ipairs(items) do
    local sel = a.selected
    kids[#kids + 1] = ui.row { id = "am" .. i, height = "8vh", background = C.card, border = BORDER,
      corner = "1.2vh", shadow = SHADOW, crossAlign = "center", spacing = "1.6vh", padding = "1.8vh",
      action = "open:settings",
      children = {
        ui.image { icon = "sf:person.crop.circle.fill", size = "4.5vh", corner = "1vh",
          background = C.avatarBg, style = { tint = C.avatarLine } },
        ui.column { weight = 1, justify = "center", spacing = "0.3vh", children = {
          ui.text { id = "am" .. i .. "Name", text = a.username or "", style = { font = "2.7vh", weight = "bold", color = C.dark } },
          ui.text { text = (sel and "当前登录" or a.type or ""), style = { font = "2vh", color = C.mid } },
        } },
        chevron(),
      } }
  end
  if #items == 0 then
    kids[#kids + 1] = ui.text { text = CONFIG.accountManager.emptyText, width = "94%",
      style = { font = "2.2vh", color = C.mid } }
  end
  kids[#kids + 1] = plainButton("amAdd", "登录 / 添加账号", true)
  return ui.column { id = "pageAccountManager", weight = 1, crossAlign = "center",
    padding = "1.6vh", spacing = "1.6vh", children = kids }
end

-- ============ 游戏目录二级页（默认 + instances 子目录列表，新建目录）============
local function buildGameDirectoryPage()
  local resp = launcher.service and launcher.service("gameDir", "list", {}) or nil
  local items = (type(resp) == "table" and resp.ok and type(resp.items) == "table") and resp.items or {}
  local kids = {
    ui.row { id = "gdHeader", width = "94%", height = "6vh", crossAlign = "center", spacing = "1.5vh",
      children = {
        ui.button { id = "gdBack", label = "‹ 返回", action = "open:home", width = "22%", height = "5vh",
          background = C.card, border = BORDER, corner = "0.8vh", hoverColor = C.hover,
          style = { font = "2.4vh", weight = "bold", tint = C.dark } },
        ui.text { text = CONFIG.gameDirectory.title, weight = 1,
          style = { font = "3vh", weight = "bold", color = C.dark } },
      } },
  }
  for i, d in ipairs(items) do
    local sel = d.selected
    kids[#kids + 1] = ui.row { id = "gd" .. i, height = "8vh", background = C.card, border = BORDER,
      corner = "1.2vh", shadow = SHADOW, crossAlign = "center", spacing = "1.6vh", padding = "1.8vh",
      hoverColor = C.hover,
      children = {
        ui.image { icon = "sf:folder.fill", size = "4.5vh", corner = "1vh",
          background = (sel and C.accent or C.faintBlue), style = { tint = (sel and C.white or C.accent) } },
        ui.column { weight = 1, justify = "center", spacing = "0.3vh", children = {
          ui.text { id = "gd" .. i .. "Name", text = d.name or "", style = { font = "2.7vh", weight = "bold", color = C.dark } },
          ui.text { text = (sel and "当前使用" or "游戏目录"), style = { font = "2vh", color = C.mid } },
        } },
        ui.button { id = "gdPick" .. i, label = (sel and "使用中" or "使用"), width = "26%", height = "5vh",
          action = "gdSelect:" .. (d.id or ""), corner = "pill",
          background = (sel and C.accent or C.card), border = (sel and BORDER_A or BORDER),
          style = { font = "2.3vh", tint = (sel and C.white or C.accent), weight = "bold" } },
      } }
  end
  if #items <= 1 then
    kids[#kids + 1] = ui.text { text = CONFIG.gameDirectory.emptyText, width = "94%",
      style = { font = "2.2vh", color = C.mid } }
  end
  -- 新建目录输入行
  kids[#kids + 1] = ui.row { width = "94%", height = "6vh", background = C.card, border = BORDER,
    corner = "1.2vh", crossAlign = "center", padding = "1.2vh", spacing = "1.2vh",
    children = {
      ui.text { id = "gdNewName", text = CONFIG.gameDirectory.addPlaceholder, weight = 1,
        style = { font = "2.3vh", color = C.mid } },
      ui.button { id = "gdCreate", label = "新建", width = "26%", height = "5vh",
        action = "gdCreate", corner = "pill", hoverColor = C.hover,
        background = C.card, border = BORDER_A,
        style = { font = "2.3vh", tint = C.accent, weight = "bold" } },
    } }
  return ui.column { id = "pageGameDirectory", weight = 1, crossAlign = "center",
    padding = "1.6vh", spacing = "1.6vh", children = kids }
end

-- ============ 根构建 ============
-- 非首页目录侧栏：游戏目录(instances) 文件夹列表 + 添加/导入（数据驱动，克隆 gameDir 服务）
local function buildDirectorySidebar()
  local kids = {
    ui.text { text = "文件夹列表", width = "100%", style = { font = "2.1vh", color = C.mid } },
  }
  for i = 1, 5 do
    kids[#kids + 1] = ui.row { id = "dirSlot_" .. i, height = "6vh", width = "100%",
      background = C.card, corner = "0.9vh", hoverColor = C.hover, visible = false,
      crossAlign = "center", spacing = "1vh", padding = { left = "1.4vh", right = "1.4vh" },
      action = "dirSel:" .. i,
      children = {
        ui.image { icon = "sf:folder.fill", size = "3.6vh", corner = "pill",
          background = C.faintBlue, style = { tint = C.accent } },
        ui.column { weight = 1, justify = "center", spacing = "0.2vh",
          children = {
            ui.text { id = "dirSlot_" .. i .. "_Name", text = "", style = { font = "2.3vh", weight = "bold", color = C.dark } },
            ui.text { id = "dirSlot_" .. i .. "_Meta", text = "", style = { font = "1.8vh", color = C.mid } },
          } },
      } }
  end
  kids[#kids + 1] = ui.text { id = "dirEmpty", text = "暂无游戏目录", width = "100%", visible = true,
    style = { font = "2vh", color = C.mid } }
  kids[#kids + 1] = ui.text { text = "添加或导入", width = "100%", style = { font = "2.1vh", color = C.mid } }
  for _, r in ipairs({ { id = "dirAdd", icon = "sf:plus.circle.fill", label = "添加已有文件夹" },
                       { id = "dirNew", icon = "sf:folder.badge.plus.fill", label = "新建文件夹" } }) do
    kids[#kids + 1] = ui.row { id = r.id, width = "100%", height = "5.5vh", action = "open:gameDirectory",
      background = C.card, border = BORDER, corner = "0.9vh", hoverColor = C.hover,
      crossAlign = "center", spacing = "1vh", padding = { left = "1.2vh", right = "1.2vh" },
      children = {
        ui.image { icon = r.icon, size = "3.2vh", corner = "pill", background = C.faintBlue,
          style = { tint = C.accent } },
        ui.text { text = r.label, weight = 1, style = { font = "2.2vh", color = C.dark } },
      } }
  end
  return kids
end

local function refreshDirectorySidebar()
  local resp = launcher.service and launcher.service("gameDir", "list", {}) or nil
  local items = (type(resp) == "table" and resp.ok and type(resp.items) == "table") and resp.items or {}
  local count = #items
  for i = 1, 5 do
    local m = items[i]
    if not m then
      launcher.view("dirSlot_" .. i):setVisible(false)
      goto continue
    end
    launcher.view("dirSlot_" .. i):setVisible(true)
    launcher.view("dirSlot_" .. i .. "_Name"):setText(m.name or "")
    launcher.view("dirSlot_" .. i .. "_Meta"):setText(m.selected and "当前使用" or "游戏目录")
    ::continue::
  end
  launcher.view("dirEmpty"):setVisible(count == 0)
end

local function refreshMultiRooms()
  local resp = launcher.service and launcher.service("multiplayer", "list", {}) or nil
  local items = (type(resp) == "table" and resp.ok and type(resp.items) == "table") and resp.items or {}
  for i = 1, MP_MAX_ROOMS do
    local it = items[i]
    local row = launcher.view("mpRoom_" .. i)
    if row then
      if it then
        row:setVisible(true)
        local name = it.name or ("房间 " .. i)
        local status = it.status or "未连接"
        if it.hostIP and it.hostIP ~= "" then
          status = status .. " · " .. it.hostIP .. ":" .. (it.hostPort or "25565")
        end
        launcher.view("mpRoom_" .. i .. "_name"):setText(name)
        launcher.view("mpRoom_" .. i .. "_status"):setText(status)
        local actionText = (it.isCurrent == true) and "断开" or "连接"
        launcher.view("mpRoom_" .. i .. "_action"):setText(actionText)
      else
        row:setVisible(false)
      end
    end
  end
end

-- 通用侧边栏条目：左图标 + 标题，可选选中指示（圆点）
-- 文本包一层 weight=1 的列（与该启用的版本行结构一致），确保标签始终可见。
local function sidebarItem(id, icon, label, action, dotId)
  local kids = {}
  if icon then
    kids[#kids + 1] = ui.image { id = id .. "Icon", icon = icon, size = "3vh", corner = "pill",
      background = C.faintBlue, style = { tint = C.accent } }
  end
  if dotId then
    kids[#kids + 1] = ui.image { id = dotId, icon = "sf:circle", size = "2.6vh",
      style = { tint = C.mid } }
  end
  kids[#kids + 1] = ui.column { weight = 1, crossAlign = "stretch", children = {
    ui.text { id = id .. "Txt", text = label, width = "100%", style = { font = "2.3vh", color = C.dark } },
  } }
  return ui.row {
    id = id, height = "6vh", width = "100%", background = C.card, corner = "0.9vh",
    hoverColor = C.hover, action = action, crossAlign = "center", spacing = "1vh",
    padding = { left = "1.4vh", right = "1.4vh" },
    children = kids,
  }
end

-- 侧栏项选中态：PCL2 左侧目录选中项为「主题蓝实底 + 白字」，未选中为白底深字。
-- 依赖 sidebarItem 为图标/文字生成的 `<id>Icon` / `<id>Txt` 子节点 id。
local function applySidebarSel(id, sel)
  local row = launcher.view(id)
  if row then
    row:setStyle(sel
      and { background = C.accent, borderColor = C.accentBorder }
      or  { background = C.card, borderColor = C.cardBorder })
  end
  local txt = launcher.view(id .. "Txt")
  if txt then txt:setTextColor(sel and C.white or C.dark) end
  local ic = launcher.view(id .. "Icon")
  if ic then
    ic:setStyle(sel
      and { background = C.white, tint = C.accent }
      or  { background = C.faintBlue, tint = C.accent })
  end
end

-- 设置页左侧分类目录侧栏（仿 PCL PageSetupLeft；数据驱动 CONFIG.settingsGroups，恒非空）
-- 注意：setSelCat 需在文件前面声明（见顶部），此处不可再 local，否则 buildSettingsPage 前置引用读到 nil。
local function buildSettingsSidebar()
  local kids = { ui.text { text = "设置", width = "100%", style = { font = "2.1vh", color = C.mid } } }
  for _, g in ipairs(CONFIG.settingsGroups) do
    kids[#kids + 1] = sidebarItem("setCat_" .. g.id, g.icon, g.label, "setCat:" .. g.id)
  end
  return kids
end

-- 版本设置页左侧分类目录侧栏（仿 PCL PageVersionSetupLeft）
local vsSelCat = "info"
local VS_CATS = {
  { token = "info",     label = "概览",       icon = "sf:info.circle.fill" },
  { token = "launch",   label = "设置",       icon = "sf:play.fill" },
  { token = "mod",      label = "Mod 管理",   icon = "sf:hud" },
  { token = "resource", label = "资源包 / 光影", icon = "sf:sun.max.fill" },
  { token = "advanced", label = "高级管理",   icon = "sf:gearshape.2.fill" },
}
local function buildVersionSettingsSidebar()
  local kids = { ui.text { text = "版本设置", width = "100%", style = { font = "2.1vh", color = C.mid } } }
  for _, c in ipairs(VS_CATS) do
    kids[#kids + 1] = sidebarItem("vsCat_" .. c.token, c.icon, c.label, "vsCat:" .. c.token)
  end
  return kids
end

-- 更多页左侧分类目录侧栏
local moreSelCat = "launch"
local function buildMoreSidebar()
  local kids = { ui.text { text = "更多", width = "100%", style = { font = "2.1vh", color = C.mid } } }
  for _, g in ipairs(CONFIG.moreGroups) do
    kids[#kids + 1] = sidebarItem("moreCat_" .. g.name, nil, g.name, "moreCat:" .. g.name)
  end
  return kids
end

-- 下载页左侧分类目录侧栏（仿 PCL PageDownloadLeft：原版游戏 / 社区资源各类）
local dlSelCat = 1
local function buildDownloadSidebar()
  local kids = {}
  local idx = 0
  for _, g in ipairs(CONFIG.download.sidebarGroups) do
    kids[#kids + 1] = ui.text { text = g.name, width = "100%", style = { font = "2.1vh", color = C.mid } }
    for _, it in ipairs(g.items) do
      idx = idx + 1
      kids[#kids + 1] = sidebarItem(it.id, nil, it.label, "dlCat:" .. idx, "dlCatDot_" .. idx)
    end
  end
  return kids
end

local dlSecVisible = { [1] = true }
local function refreshDownloadSidebar()
  for i = 1, #CONFIG.download.titleByCat do
    local sel = (i == dlSelCat)
    launcher.view("dlCatDot_" .. i):setImage(sel and "sf:circle.inset.filled" or "sf:circle")
    launcher.view("dlCatDot_" .. i):setStyle(sel and { tint = C.accent } or { tint = C.mid })
  end
end

-- ============ 社区资源（下载页）搜索与下载 ============
local dlSource = 1        -- 搜索源索引（CONFIG.download.searchSources）
local dlKeyword = ""      -- 当前搜索关键词
local dlCommItems = {}    -- 最近一次结果缓存（槽位索引 → 条目）供点击下载使用
local commDownloading = false

local function commCategory()
  return CONFIG.download.searchObjects[dlSelCat - 1] or "mod"
end

local function commSource()
  return CONFIG.download.searchSources[dlSource] or CONFIG.download.searchSources[1]
end

local function clearCommunityResults()
  for i = 1, CONFIG.download.communityResultSlots do
    launcher.view("dlComm_" .. i):setVisible(false)
  end
  dlCommItems = {}
end

local function refreshCommunitySearch()
  launcher.view("dlSrcVal"):setText(commSource().name or "…")
  launcher.view("dlObjVal"):setText(CONFIG.download.titleByCat[dlSelCat] or "…")
  launcher.view("dlKwVal"):setText((dlKeyword ~= "" and dlKeyword) or CONFIG.download.keywordPlaceholder)
  clearCommunityResults()
  launcher.view("dlCommStatus"):setText(CONFIG.download.searchStatusPreset)
  launcher.view("dlCommBarBox"):setVisible(false)
  commDownloading = false
end

local function doCommunitySearch()
  if dlSelCat <= 1 then return end
  local kw = tostring(dlKeyword):gsub("^%s+", ""):gsub("%s+$", "")
  if kw == "" then
    launcher.view("dlCommStatus"):setText("请先点击「搜索关键词」输入要搜索的内容")
    return
  end
  launcher.service("community", "search", {
    source = commSource().id, category = commCategory(),
    keyword = kw, limit = CONFIG.download.communityResultSlots,
  })
  launcher.view("dlCommStatus"):setText("正在搜索「" .. kw .. "」…")
end

-- 事件：搜索完成，填充结果槽位
function onCommunityResults(payload)
  local items = (type(payload) == "table" and type(payload.items) == "table") and payload.items or {}
  for i = 1, CONFIG.download.communityResultSlots do
    local it = items[i]
    local row = launcher.view("dlComm_" .. i)
    if row then
      row:setVisible(it ~= nil)
      if it then
        launcher.view("dlComm_" .. i .. "_title"):setText(it.title or "未知资源")
        local author = it.author or ""
        launcher.view("dlComm_" .. i .. "_meta"):setText((author ~= "") and (author .. " · 下载 " .. tostring(it.downloads or 0)) or ("下载 " .. tostring(it.downloads or 0)))
      end
    end
  end
  dlCommItems = items
  launcher.view("dlCommStatus"):setText(#items == 0
    and "未找到结果，换个关键词试试"
    or ("共 " .. #items .. " 条结果，点击条目下载最新版本"))
end

-- 事件：下载/搜索进度或状态提示
function onCommunityStatus(payload)
  local msg = (type(payload) == "table" and payload.message) or ""
  if msg == "" then return end
  if launcher.view("dlCommStatus") then launcher.view("dlCommStatus"):setText(msg) end
  if msg:find("已下载", 1, true) or msg:find("完成", 1, true) then
    launcher.view("dlCommBarBox"):setVisible(false)
    commDownloading = false
  end
end

-- 事件：下载进度推流，更新进度条与文本
function onCommunityProgress(payload)
  local p = (type(payload) == "table" and payload.items and payload.items[1]) or {}
  local done = p.downloaded or 0
  local total = p.total or 100
  local pct = (total > 0) and math.floor(done / total * 100) or 0
  launcher.view("dlCommBarBox"):setVisible(true)
  launcher.view("dlCommBarFill"):setStyle({ width = pct .. "%" })
  launcher.view("dlCommBarLabel"):setText(p.finished and "下载完成" or ("下载中 " .. pct .. "%…"))
end

-- 事件：关键词输入弹窗返回
function onCommunityKeyword(payload)
  local items = (type(payload) == "table" and type(payload.items) == "table") and payload.items or {}
  dlKeyword = (items[1] ~= nil) and items[1] or ""
  launcher.view("dlKwVal"):setText((dlKeyword ~= "" and dlKeyword) or CONFIG.download.keywordPlaceholder)
end

function build(ui)
  local homeSidebar = buildHomeSidebar()
  local pageHome = buildHomePage()
  -- 内容区页子树：显式页 + 全部设置子页（数据驱动，引擎仅按 CONFIG.pages 切页）
  local contentChildren = {
    pageHome,
    buildDownloadPage(),
    buildMultiPage(),
    buildSettingsPage(),
    buildMorePage(),
    buildVersionSettingsPage(),
    buildVersionManagerPage(),
    buildAccountManagerPage(),
    buildGameDirectoryPage(),
    buildVersionDetailPage(),
  }
  for _tok, _spec in pairs(CONFIG.settingsSubpages) do
    contentChildren[#contentChildren + 1] = buildSettingsSubpage(_tok, _spec)
  end

  return ui.column {
    id = "shell", crossAlign = "stretch", spacing = 0,
    children = {
      -- 顶栏：蓝色渐变通栏（PCL2 顶栏为渐变而非纯色），页签选中态套白底全圆药丸
      ui.row { id = "titlebar", height = "8.5vh",
        background = { from = C.topbarFrom, to = C.topbarTo, angle = 90 }, crossAlign = "center",
        padding = { left = "1.4vh", right = "1.5vh" },
        children = {
          -- PCL II 徽标：白底圆角方块 + 主题蓝字，右侧「II」
          ui.row { id = "logoBadge", corner = "0.7vh", background = C.white, crossAlign = "center",
            padding = { left = "0.9vh", right = "0.9vh", top = "0.35vh", bottom = "0.35vh" },
            children = {
              ui.text { id = "logo", text = "PCL", style = { font = "2.7vh", weight = "bold", color = C.topbarTo } },
            } },
          ui.text { id = "logoII", text = "II", style = { font = "2.3vh", weight = "bold", color = C.white } },
          ui.spacer { weight = 1 },
          ui.row { id = "tabs", spacing = "5vh", crossAlign = "center",
            children = (function()
              local nodes = {}
              for _, t in ipairs(TABS) do nodes[#nodes + 1] = topTab(t) end
              return nodes
            end)() },
          ui.spacer { weight = 1 },
          ui.image { id = "winMin", icon = "sf:minus", size = "2.5vh", style = { tint = C.white } },
          ui.image { id = "winClose", icon = "sf:xmark", size = "2.5vh", style = { tint = C.white } },
        } },
      -- 内容区（split_column：左 32% 白侧栏 + 右 68%）
      ui.row { id = "page", weight = 1, crossAlign = "stretch", spacing = 0,
        children = {
          ui.column { id = "left", width = "32%", background = C.card, crossAlign = "center",
            spacing = "0.4vh", padding = { left = "2vh", right = "2vh", top = "1vh", bottom = "1vh" },
            children = {
              -- 启动页左栏；下载页=leftDownload 分类目录；设置/版本设置/更多页使用独立侧栏；其他页=leftDir 游戏目录
              ui.column { id = "leftHome", width = "100%", weight = 1, crossAlign = "center",
                spacing = "0.4vh", children = homeSidebar },
              ui.column { id = "leftDir", width = "100%", weight = 1, crossAlign = "center",
                spacing = "0.4vh", visible = false, children = buildDirectorySidebar() },
              ui.column { id = "leftDownload", width = "100%", weight = 1, crossAlign = "center",
                spacing = "0.4vh", visible = false, children = buildDownloadSidebar() },
              ui.column { id = "leftSettings", width = "100%", weight = 1, crossAlign = "center",
                spacing = "0.4vh", visible = false, children = buildSettingsSidebar() },
              ui.column { id = "leftVersionSettings", width = "100%", weight = 1, crossAlign = "center",
                spacing = "0.4vh", visible = false, children = buildVersionSettingsSidebar() },
              ui.column { id = "leftMore", width = "100%", weight = 1, crossAlign = "center",
                spacing = "0.4vh", visible = false, children = buildMoreSidebar() },
            } },
          ui.content {
            id = "content", weight = 1, initialPage = "home",
            background = { from = C.pageFrom, to = C.pageTo, angle = 45 },
            pages = CONFIG.pages,
            children = contentChildren,
          },
        } },
    },
  }
end

-- ===== 交互 =====

local currentPage = "home"
local selectedCap = 3
local CAPS = { "mojang", "microsoft", "offline" }
local CAPS_LABEL = { "Mojang", "微软", "离线" }
local segSel = { [1] = 1, [2] = 1, [3] = 1, [4] = 1 }

local function selectTab(tabId)
  for _, t in ipairs(TABS) do
    local sel = (t.id == tabId)
    launcher.view(t.id):setStyle(sel
      and { background = C.card, tint = C.accent, corner = "pill" }
      or  { background = C.transparent, tint = C.white, corner = "pill" })
  end
end

local function selectCap(idx)
  selectedCap = idx
  for i, key in ipairs(CAPS) do
    local sel = (i == idx)
    launcher.view("cap." .. key):setStyle(sel
      and { background = C.accent, tint = C.white, borderWidth = 1.5, borderColor = C.accent }
      or  { background = C.card, tint = C.accent, borderWidth = 1.5, borderColor = C.accent })
  end
  local acc = launcher.state and launcher.state.account
  local name = (type(acc) == "table" and acc.name) and acc.name or "未登录"
  launcher.view("accountName"):setText(name)
  launcher.view("accountType"):setText(CAPS_LABEL[idx])
end

-- 分段标签选中：白底全圆药丸
local function selectSegment(prefix, row, idx)
  local labels
  if prefix == "segM" then
    labels = CONFIG.online.branch
  else
    labels = CONFIG.download.segRows[row]
  end
  segSel[row] = idx
  for i = 1, #labels do
    local sel = (i == idx)
    launcher.view(prefix .. "_" .. i):setStyle(sel
      and { background = C.card, tint = C.accent, corner = "pill" }
      or  { background = C.transparent, tint = C.dark, corner = "pill" })
  end
end

local function refreshAccount()
  local acc = launcher.state and launcher.state.account
  local name = (type(acc) == "table" and acc.name) and acc.name or "未登录"
  launcher.view("accountName"):setText(name)
end

local function refreshVersion()
  local ver = launcher.state and launcher.state.version
  launcher.view("launchSub"):setText((ver and ver.name) or "尚未选择版本")
end

function onReady()
  refreshAccount()
  refreshVersion()
  selectCap(selectedCap)
  for r = 1, 2 do selectSegment("segR", r, segSel[r] or 1) end
  selectSegment("segM", 3, segSel[3] or 1)
  onPageChange(currentPage)
end

function onLayout()
  -- 无绝对定位游标，无需在布局后补定位；保留钩子供引擎调用
end

function onAccountChange(account)
  if type(account) ~= "table" then return end
  launcher.view("accountName"):setText(account.name or "未登录")
end

-- 联机房间列表/状态刷新
function onMultiplayerRooms(payload)
  refreshMultiRooms()
end

function onMultiplayerStatus(payload)
  local msg = (type(payload) == "table" and payload.message) or "联机状态已更新"
  if launcher.view("mpStatus") then launcher.view("mpStatus"):setText(msg) end
  refreshMultiRooms()
end

function onMultiplayerProgress(payload)
  local msg = (type(payload) == "table" and payload.message) or "连接中…"
  if launcher.view("mpStatus") then launcher.view("mpStatus"):setText(msg) end
end

-- 真下载进度推流（download.start 后由引擎每 0.3s 上报）：更新进度条与文本。
function onDownloadUpdate(payload)
  local p = payload or {}
  local done = p.downloaded or 0
  local total = p.total or 100
  local pct = (total > 0) and math.floor(done / total * 100) or 0
  launcher.view("dlBarFill"):setStyle({ width = pct .. "%" })
  launcher.view("dlProgressLabel"):setText(p.finished and ("安装完成（" .. pct .. "%）") or ("下载中 " .. pct .. "%…"))
end

-- 版本清单异步拉取完成：刷新下载页原版版本分组卡。
function onRemoteVersions(payload)
  refreshDownloadVersions()
end

local function refreshSettingsSidebar()
  for _, g in ipairs(CONFIG.settingsGroups) do
    local sel = (g.id == setSelCat)
    applySidebarSel("setCat_" .. g.id, sel)
    local sec = launcher.view("setSec_" .. g.id)
    if sec then sec:setVisible(sel) end
  end
end

local function refreshVersionSettingsSidebar()
  for _, c in ipairs(VS_CATS) do
    local sel = (c.token == vsSelCat)
    applySidebarSel("vsCat_" .. c.token, sel)
  end
end

local function refreshVersionSettingsContent()
  for _, c in ipairs(VS_CATS) do
    local v = launcher.view("vsSec_" .. c.token)
    if v then v:setVisible(c.token == vsSelCat) end
  end
end

local function refreshVersionSettingsValues()
  local ver = launcher.state and launcher.state.version
  local name = (ver and ver.name) or "未选择版本"
  if launcher.view("vsName") then launcher.view("vsName"):setText(name) end
  if launcher.view("vsMeta") then
    launcher.view("vsMeta"):setText("版本信息 · " ..
      (name == "未选择版本" and "请先在版本选择中指定" or "本地版本"))
  end
  local resp = launcher.service and launcher.service("versionSettings", "list", {}) or nil
  if type(resp) == "table" and resp.ok and type(resp.items) == "table" then
    for _, it in ipairs(resp.items) do
      local k = it.key
      local v = launcher.view("vsSet_" .. k .. "Val")
      if v then v:setText(tostring(it.value or "···")) end
    end
  end
end

local function refreshMoreSidebar()
  for _, g in ipairs(CONFIG.moreGroups) do
    local sel = (g.name == moreSelCat)
    applySidebarSel("moreCat_" .. g.name, sel)
  end
end

local function refreshMoreContent()
  for _, g in ipairs(CONFIG.moreGroups) do
    local v = launcher.view("moreSec_" .. g.name)
    if v then v:setVisible(g.name == moreSelCat) end
  end
  -- 动态填充更多页版本类条目：主题信息卡 + 标注 right="version" 的行。
  -- 数据来自 launcher.getState() 快照（引擎 source of truth），不在此硬编码。
  local st = launcher.getState and launcher.getState() or {}
  local ui = (type(st.ui) == "table") and st.ui or nil
  local themeName = launcher.view("moreThemeName_text")
  local themeVersion = launcher.view("moreThemeVersion")
  if themeName and ui and ui.name and ui.name ~= "" then themeName:setText(ui.name) end
  if themeVersion and ui and ui.version and ui.version ~= "" then
    themeVersion:setText(ui.version)
  else
    -- 引擎未提供包版本时退回「本地已安装默认版本」，避免显示"···"旧占位。
    local defVer = launcher.view("moreDefaultVersion_val")
    if themeVersion and defVer then themeVersion:setText(defVer:getText() or "") end
  end
  for _, g in ipairs(CONFIG.moreGroups) do
    for _, rr in ipairs(g.rows or {}) do
      if rr.right == "version" and rr.id then
        local val = launcher.view(rr.id .. "_val")
        if val then
          local text
          if rr.id == "moreDefaultVersion" then
            local acc = (type(st.version) == "table" and st.version.name) or ""
            text = (acc ~= "" and acc) or "未选择"
          else
            text = "· · ·" -- 其他 future 版本行暂保结构占位
          end
          val:setText(text)
        end
      end
    end
  end
end

function onPageChange(page)
  currentPage = page
  -- 全幅无左栏页：版本管理 / 账号管理 / 游戏目录 / 版本详情（二级页，使用目录侧栏）
  local isDirFull = (page == "versionManager") or (page == "accountManager")
    or (page == "gameDirectory") or (page == "versionDetail")
  local isSettingsSub = (CONFIG.settingsSubpages[page] ~= nil)
  local isSettings = (page == "settings") or isSettingsSub
  local isVersionSettings = (page == "version_settings")
  local isMore = (page == "more")
  local isMulti = (page == "multi")

  launcher.view("titlebar"):setVisible(true)
  launcher.view("left"):setVisible(true)
  launcher.view("leftHome"):setVisible(page == "home")
  launcher.view("leftDownload"):setVisible(page == "download")
  launcher.view("leftDir"):setVisible(isDirFull or isMulti)
  launcher.view("leftSettings"):setVisible(isSettings)
  launcher.view("leftVersionSettings"):setVisible(isVersionSettings)
  launcher.view("leftMore"):setVisible(isMore)

  if page == "download" then
    refreshDownloadSidebar()
    refreshDownloadVersions()
    dlLevel = "groups" -- 每次进入下载页都从版本分组列表开始
    launcher.view("dlSec_1"):setVisible(dlSelCat == 1)
    launcher.view("dlSecC"):setVisible(dlSelCat > 1)
    refreshDownloadState()
    if dlSelCat > 1 then refreshCommunitySearch() end
  elseif isSettings then
    refreshSettingsSidebar()
    -- 若进入设置子页，同步左侧高亮
    if isSettingsSub then setSelCat = page end
    refreshSettingsSidebar()
  elseif isVersionSettings then
    refreshVersionSettingsSidebar()
    refreshVersionSettingsContent()
    refreshVersionSettingsValues()
  elseif isMore then
    refreshMoreSidebar()
    refreshMoreContent()
  elseif isDirFull or isMulti then
    refreshDirectorySidebar()
    if isMulti then refreshMultiRooms() end
  end

  if isSettingsSub then
    selectTab("tab.setup")
  elseif page == "versionDetail" then
    selectTab("tab.download")
  else
    local tabId = PAGE_TAB[page]
    if tabId then selectTab(tabId) end
  end
end

local function refreshGameDirectory()
  local resp = launcher.service and launcher.service("gameDir", "list", {}) or nil
  local items = (type(resp) == "table" and resp.ok and type(resp.items) == "table") and resp.items or {}
  for i, d in ipairs(items) do
    local sel = d and d.selected
    launcher.view("gd" .. i .. "Name"):setText((d and d.name) or "")
    if launcher.view("gdPick" .. i) then
      launcher.view("gdPick" .. i):setText(sel and "使用中" or "使用")
    end
  end
end

function onClick(id)
  launcher.log("[Lua.onClick] id=" .. tostring(id))
  for _, t in ipairs(TABS) do
    if t.id == id then selectTab(t.id) return end
  end
  if id == "cap.mojang" then selectCap(1) return end
  if id == "cap.microsoft" then selectCap(2) return end
  if id == "cap.offline" then selectCap(3) return end
  local compSlots = CONFIG.download.compVersionSlots or 5
  local function refreshCompRows(i)
    local open = compOpen[i] == true
    for j = 1, compSlots do
      local rv = launcher.view("dlCompV_" .. i .. "_" .. j)
      if rv then rv:setVisible(open) end
    end
  end
  local function setMcList(open)
    PLC.mcOpen = open
    local D = CONFIG.download
    for i = 1, (D.maxVersionRows or 12) do
      local it = flatVersions[i]
      local rowV = launcher.view("dlIv_" .. i)
      if rowV then rowV:setVisible(open and it ~= nil) end
    end
  end
  -- 「开始安装」：读输入框版本名 + 选中 Minecraft 版本 → 发起下载
  if id == "insStart" then
    local name = (launcher.view("insNameIn") and launcher.view("insNameIn"):getText()) or ""
    name = tostring(name):gsub("^%s+", ""):gsub("%s+$", "")
    if PLC.mc == "" or PLC.mc == nil then
      local st = launcher.view("dlProgressLabel")
      if st then st:setText("请先选择 Minecraft 版本") end
      launcher.view("dlProgress"):setVisible(true)
      return
    end
    launcher.view("dlProgress"):setVisible(true)
    launcher.view("dlProgressLabel"):setText("准备下载 " .. PLC.mc .. (name ~= "" and ("（" .. name .. "）") or "") .. " …")
    launcher.view("dlBarFill"):setStyle({ width = "0%" })
    launcher.service("download", "start", { versionId = PLC.mc, name = name })
    return
  end
  -- Minecraft 卡：整卡点击 / 返回 切换行内版本列表
  if id == "dlMcH" or id == "dlMcBack" then setMcList(not PLC.mcOpen) return end
  local mcv = id:match("^dlIv_(%d+)$")
  if mcv then
    local it = flatVersions[tonumber(mcv)]
    if it and it.id then
      PLC.mc = it.id
      setMcList(false)
      refreshInstallPanel()
      launcher.view("insVersion"):setText(PLC.mc)
      launcher.view("insMcVer"):setText(PLC.mc)
    end
    return
  end
  -- 组件卡：整卡 / › 切换行内列表；× 清除选择；版本行选择
  local cph = id:match("^dlCompH:(%d+)$")
  if cph then
    local i = tonumber(cph)
    if launcher.view("dlCompH_" .. i) then
      compOpen[i] = not (compOpen[i] == true)
      refreshCompRows(i)
    end
    return
  end
  local cpc = id:match("^dlCompC:(%d+)$")
  if cpc then
    local i = tonumber(cpc)
    compOpen[i] = not (compOpen[i] == true)
    refreshCompRows(i)
    return
  end
  local cpx = id:match("^dlCompX:(%d+)$")
  if cpx then
    local i = tonumber(cpx)
    compSel[i] = nil
    compOpen[i] = false
    refreshCompRows(i)
    refreshInstallPanel()
    return
  end
  local cpv = id:match("^dlCompV:(%d+):(%d+)$")
  if cpv then
    local i, j = tonumber(cpv[1]), tonumber(cpv[2])
    compSel[i] = "已选择"
    compOpen[i] = false
    refreshCompRows(i)
    refreshInstallPanel()
    return
  end
  -- 首屏版本分组：点分组展开内联版本；点具体版本进入安装面板；返回按钮回到分组列表
  local dgh = id:match("^dlGh_(.+)$")
  if dgh then
    dlOpenGroup[dgh] = not (dlOpenGroup[dgh] == true)
    refreshDownloadGroups()
    return
  end
  -- 引擎派发的版本行节点 id 为下划线形式：dlGrpVer_<key>_<j>（key 可能含下划线，如 april_fools）
  local dgv = id:match("^dlGrpVer_(.+)_(%d+)$")
  if dgv then
    local it = (dlGroups[dgv[1]] or {})[tonumber(dgv[2])]
    if it and it.id then
      PLC.mc = it.id
      dlLevel = "install"
      refreshDownloadState()
    end
    return
  end
  if id == "dlBackGrp" then
    dlLevel = "groups"
    refreshDownloadState()
    return
  end
  -- 版本行点击：进入该版本的详情页（信息 + 加载器选择），由详情页发起下载
  local dlv = id:match("^dlv_(%w+)_(%d+)$")
  if dlv then
    openDetailFor(dlv[1], tonumber(dlv[2]))
    return
  end
  -- 详情页加载器选择
  local vl = id:match("^vdL_(%d+)$")
  if vl then
    dlLoader = tonumber(vl) or 1
    local loaders = CONFIG.download.loaders or {}
    for li = 1, #loaders do
      local sel = (li == dlLoader)
      launcher.view("vdL_" .. li):setStyle(sel
        and { background = C.accent, tint = C.white, corner = "pill" }
        or  { background = C.transparent, tint = C.dark, corner = "pill" })
    end
    return
  end
  -- 详情页「下载并安装」：启动下载后返回下载页展示进度
  if id == "vdInstall" then
    if dlCurrent and dlCurrent.id then
      -- loader = CONFIG.download.loaders[dlLoader]，当前真实下载逻辑沿用 versionId
      launcher.view("dlProgress"):setVisible(true)
      launcher.view("dlProgressLabel"):setText("准备下载 " .. dlCurrent.id .. " …")
      launcher.view("dlBarFill"):setStyle({ width = "0%" })
      launcher.service("download", "start", { versionId = dlCurrent.id })
      launcher.action("open:download")
    end
    return
  end
  local dlc = id:match("^dlCat_(%d+)$")
  if dlc then
    dlSelCat = tonumber(dlc) or 1
    refreshDownloadSidebar()
    launcher.view("dlSec_1"):setVisible(dlSelCat == 1)
    launcher.view("dlSecC"):setVisible(dlSelCat > 1)
    if dlSelCat > 1 then refreshCommunitySearch() end
    launcher.view("dlTitle"):setText(CONFIG.download.titleByCat[dlSelCat] or "")
    return
  end
  -- 社区资源：搜索源切换 / 关键词输入 / 搜索 / 重置 / 点击结果下载
  if id == "dlSrcRow" then
    dlSource = (dlSource % #CONFIG.download.searchSources) + 1
    launcher.view("dlSrcVal"):setText(commSource().name or "…")
    clearCommunityResults()
    launcher.view("dlCommStatus"):setText(CONFIG.download.searchStatusPreset)
    return
  end
  if id == "dlKwRow" then
    launcher.service("community", "promptKeyword", { category = commCategory() })
    return
  end
  if id == "dlBtnSearch" then doCommunitySearch() return end
  if id == "dlBtnReset" then
    dlKeyword = ""
    if launcher.view("dlKwVal") then launcher.view("dlKwVal"):setText(CONFIG.download.keywordPlaceholder) end
    clearCommunityResults()
    launcher.view("dlCommStatus"):setText(CONFIG.download.searchStatusPreset)
    launcher.view("dlCommBarBox"):setVisible(false)
    return
  end
  local ci = id:match("^dlComm_(%d+)$")
  if ci then
    local it = dlCommItems[tonumber(ci)]
    if it and not commDownloading then
      commDownloading = true
      launcher.view("dlCommBarBox"):setVisible(true)
      launcher.view("dlCommBarFill"):setStyle({ width = "0%" })
      launcher.view("dlCommBarLabel"):setText("准备下载…")
      launcher.view("dlCommStatus"):setText("准备下载「" .. (it.title or "") .. "」最新版本…")
      launcher.service("community", "download", {
        source = commSource().id, category = commCategory(),
        projectId = it.id, title = it.title,
      })
    end
    return
  end
  local sc = id:match("^setCat_(.+)$")
  if sc then
    setSelCat = sc
    refreshSettingsSidebar()
    -- 行内展开当前分类（数据驱动内容已在 pageSettings 预渲染），不再跳转到子页
    launcher.view("dlProgress"):setVisible(false)
    return
  end
  -- 设置项：开关切换 / 选择器 / 描边按钮（M5：点击真正产生反馈）
  local se = id:match("^setit_(.+)$")
  if se then
    -- 派发节点可能是行(id)、开关按钮(id_sw)或取值文本(id_v)：剥掉后缀得到设置项 id
    local base = se:gsub("_(sw|v)$", "")
    local def
    for _, g in ipairs(CONFIG.settingsGroups) do
      for _, s in ipairs(g.rows or {}) do
        if s.id == base then def = s; break end
      end
      if def then break end
    end
    if def then
      local statusView = launcher.view("setStatus")
      local label = "「" .. def.label .. "」"
      if def.type == "toggle" then
        local on = not toggleOn(base)
        setToggles[base] = on
        local sw = launcher.view("setit_" .. base .. "_sw")
        if sw then
          sw:setText(on and "开" or "关")
          sw:setStyle(on
            and { background = C.accent, tint = C.white }
            or  { background = C.cardBorder, tint = C.white })
        end
        if statusView then statusView:setText(label .. "已" .. (on and "开启" or "关闭")) end
      elseif def.type == "select" then
        local opts = def.options or {}
        if #opts > 0 then
          local cur = nil
          for i, o in ipairs(opts) do
            if tostring(o) == tostring(def.value) then cur = i break end
          end
          local nxt = opts[(cur or 0) % #opts + 1]
          def.value = nxt
          local vv = launcher.view("setit_" .. base .. "_v")
          if vv then vv:setText(tostring(nxt)) end
          if statusView then statusView:setText(label .. "已切换为：" .. tostring(nxt)) end
        else
          if statusView then statusView:setText(label .. "当前为：" .. tostring(def.value or "")) end
        end
      elseif def.type == "button" then
        local bv = launcher.view("setit_" .. base)
        if bv then
          bv:setStyle({ background = C.accent, tint = C.white,
            border = { width = "0.12vh", color = C.accent } })
        end
        if statusView then statusView:setText("已执行：" .. label .. "（引擎预留能力，后续接入真实实现）") end
      else -- text
        local vv = launcher.view("setit_" .. base .. "_v")
        if vv then vv:setText(tostring(def.value or "")) end
        if statusView then statusView:setText(label .. "：" .. tostring(def.value or "")) end
      end
    end
    return
  end
  local vsc = id:match("^vsCat_(.+)$")
  if vsc then
    vsSelCat = vsc
    refreshVersionSettingsSidebar()
    refreshVersionSettingsContent()
    return
  end
  local mc = id:match("^moreCat_(.+)$")
  if mc then
    moreSelCat = mc
    refreshMoreSidebar()
    refreshMoreContent()
    return
  end
  local r, i = id:match("^segR(%d+)_(%d+)$")
  if r then selectSegment("segR", tonumber(r), tonumber(i)) return end
  local m = id:match("^segM_(%d+)$")
  if m then selectSegment("segM", 3, tonumber(m)) return end
  local gd = id:match("^gdPick(%d+)$")
  if gd then
    local r = launcher.service and launcher.service("gameDir", "list", {}) or nil
    local its = (type(r) == "table" and r.ok and type(r.items) == "table") and r.items or {}
    local m = its[tonumber(gd)]
    if m and type(m.name) == "string" and m.name ~= "" then
      launcher.service("gameDir", "set", { name = m.name })
    end
    refreshGameDirectory()
    return
  end
  local ds = id:match("^dirSlot_(%d+)$")
  if ds then
    local r = launcher.service and launcher.service("gameDir", "list", {}) or nil
    local its = (type(r) == "table" and r.ok and type(r.items) == "table") and r.items or {}
    local m = its[tonumber(ds)]
    if m and type(m.name) == "string" and m.name ~= "" then
      launcher.service("gameDir", "set", { name = m.name })
    end
    refreshDirectorySidebar()
    return
  end
  if id == "gdCreate" then
    local name = (launcher.view("gdNewName") and launcher.view("gdNewName"):getText()) or ""
    name = tostring(name):gsub("^%s+", ""):gsub("%s+$", "")
    if name ~= "" and name ~= CONFIG.gameDirectory.addPlaceholder then
      launcher.service("gameDir", "new", { name = name })
      refreshGameDirectory()
    end
    return
  end
  -- 联机页：加入 / 创建 / 连接房间槽位
  if id == "mpJoin" or id == "mpJoinRow" then
    launcher.service("multiplayer", "promptJoin", {})
    return
  end
  if id == "mpCreate" or id == "mpCreateRow" then
    launcher.service("multiplayer", "promptCreate", {})
    return
  end
  local mpIdx = id:match("^mpRoom_(%d+)$")
  if mpIdx then
    launcher.service("multiplayer", "connect", { index = tonumber(mpIdx) })
    return
  end
  -- 设置子页条目点击（占位：可扩展为弹窗或二级页）。节点 id = sub{token}r{gi}_{ri}
  local subToken, subIdx = id:match("^sub([^%d]+)r(%d+_%d+)$")
  if subToken then
    launcher.view("dlProgress"):setVisible(true)
    launcher.view("dlProgressLabel"):setText("设置项 " .. subToken .. "/" .. subIdx .. " 待实现…")
    return
  end
  -- 版本设置页动作
  if id == "vsModInstall" then
    launcher.view("dlProgress"):setVisible(true)
    launcher.view("dlProgressLabel"):setText("Mod 加载器安装功能开发中…")
    return
  end
  if id == "vsOpenDir" then
    launcher.service("versionSettings", "openDir", {})
    return
  end
  if id == "vsReset" then
    launcher.service("versionSettings", "reset", {})
    return
  end
  if id == "vsDelete" then
    launcher.service("versionSettings", "delete", {})
    return
  end
  if id == "vsResPack" or id == "vsShader" then
    launcher.view("dlProgress"):setVisible(true)
    launcher.view("dlProgressLabel"):setText((id == "vsResPack" and "资源包" or "光影包") .. " 管理功能开发中…")
    return
  end
  -- 概览页快捷按钮（开发中占位）
  if id == "vsRename" or id == "vsDesc" or id == "vsFav" or id == "vsExport" then
    launcher.view("dlProgress"):setVisible(true)
    launcher.view("dlProgressLabel"):setText("功能开发中：" .. id)
    return
  end
  if id == "vsOpenSaves" or id == "vsOpenMods" or id == "vsModInstallFile" or id == "vsModDownload" or id == "vsModSelectAll" then
    launcher.view("dlProgress"):setVisible(true)
    launcher.view("dlProgressLabel"):setText("功能开发中：" .. id)
    return
  end
  if id == "vsComplete" then
    launcher.view("dlProgress"):setVisible(true)
    launcher.view("dlProgressLabel"):setText("补全文件功能开发中…")
    return
  end
end