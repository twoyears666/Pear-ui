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
  return { name = "PCL 浅色", version = "1.13.3" }
end

local C = {
  topbar      = "$color:topbar",              -- 顶栏蓝 #0A5FC4
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
  fieldBorder = "$color:fieldBorder",
}

local BORDER   = { width = "0.12vh", color = C.cardBorder }
local BORDER_A = { width = "0.18vh", color = C.accentBorder }
local BORDER_D = { width = "0.18vh", color = C.danger }
local SHADOW   = { blur = "0.3vh", opacity = 0.07, x = 0, y = "0.15vh" }

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
    maxVersionRows = 12,     -- 每张版本卡最多渲染的版本行（真实列表很长，滚动超出部分截断）
    -- 版本详情页加载器组合（仿 PCL：默认「无」，可切换 Fabric/Forge 等后再下载）
    loaders = { "无", "Fabric", "Forge", "Quilt", "NeoForge" },
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

-- 白底圆角卡片（vertical_flow 内的一行卡片；内容 94% = 左右留边 3%）
-- opts 可选：padding/spacing 覆盖默认留白（保证文字与圆角边框有足够间距），
--          crossAlign="center" 时子元素按自身宽度居中（用于版本行卡内左右留边）。
local function card(id, children, opts)
  opts = opts or {}
  return ui.column { id = id, width = "94%", background = C.card, border = BORDER,
    corner = "1.2vh", shadow = SHADOW, padding = opts.padding or "3vh",
    spacing = opts.spacing or "2vh", crossAlign = opts.crossAlign, visible = opts.visible, children = children }
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
  return ui.column { id = "pageHome", weight = 1, crossAlign = "center", padding = "2.5vh",
    spacing = "2.5vh",
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
  local latest = { latest_release = p.latestRelease, latest_snapshot = p.latestSnapshot }
  for cid, it in pairs(latest) do
    launcher.view("dlv_" .. cid .. "_1_name"):setText(it and it.id or "…")
    launcher.view("dlv_" .. cid .. "_1_date"):setText((it and it.date) or "")
    dlGroups[cid] = it and { it } or {}
  end
  for _, g in ipairs(CONFIG.download.vanillaGroups) do
    local items = {}
    for _, grp in ipairs(p.groups or {}) do
      if grp.key == g.key then items = grp.items or {} end
    end
    dlGroups[g.key] = items
    local count = #items
    local cntView = launcher.view("dlgCount_" .. g.key)
    if cntView then cntView:setText("(" .. count .. ")") end
    for i = 1, CONFIG.download.maxVersionRows do
      local it = items[i]
      launcher.view("dlv_" .. g.key .. "_" .. i .. "_name"):setText(it and it.id or "")
      launcher.view("dlv_" .. g.key .. "_" .. i .. "_date"):setText(it and ((it.date) or "") or "")
    end
  end
end

local function refreshDownloadGroupVisibility()
  for _, g in ipairs(CONFIG.download.vanillaGroups) do
    local v = launcher.view("dlgCard_" .. g.key)
    if v then v:setVisible(dlExpanded[g.key] == true) end
  end
end

-- ============ 下载页（无侧栏、通栏纵向流：分组卡片）============
local function buildDownloadPage()
  -- 右侧内容按分类：dlSec_1 原版(最新版本) / dlSec_2.. 社区资源(搜索+结果列表)
  local sec1 = ui.column { id = "dlvRoot", width = "100%", crossAlign = "center", spacing = "2vh",
    children = (function()
      local cards = {
        -- 卡片1：最新版本（最新快照 / 最新版本，可点进入详情）
        card("dlLatestCard", {
          ui.text { text = "最新版本", width = "100%", style = { font = "2.8vh", weight = "bold", color = C.dark } },
          versionSlot("latest_snapshot", 1), versionSlot("latest_release", 1),
        }, { crossAlign = "center" }),
      }
      -- 卡片2..5：可折叠分组标题 + 版本槽位卡片（仿 PCL2 下载页）
      for _, g in ipairs(CONFIG.download.vanillaGroups) do
        cards[#cards + 1] = ui.row {
          id = "dlgHeader_" .. g.key, width = "94%", height = "6.5vh", background = C.card,
          border = BORDER, corner = "1.2vh", shadow = SHADOW, hoverColor = C.hover,
          crossAlign = "center", padding = { left = "2vh", right = "2vh" }, spacing = "1.5vh",
          action = "dlgHeader:" .. g.key,
          children = {
            ui.text { text = g.name, weight = 1, style = { font = "2.8vh", weight = "bold", color = C.dark } },
            ui.text { id = "dlgCount_" .. g.key, text = "(0)", style = { font = "2.2vh", color = C.mid } },
            chevron(),
          } }
        local rows = {}
        for i = 1, CONFIG.download.maxVersionRows do rows[#rows + 1] = versionSlot(g.key, i) end
        cards[#cards + 1] = card("dlgCard_" .. g.key, rows,
          { crossAlign = "center", visible = (dlExpanded[g.key] == true) })
      end
      -- 兼容性提示 + 开始下载 + 下载进度区
      cards[#cards + 1] = ui.row { width = "100%", background = C.faintBlue, corner = "1vh",
        crossAlign = "center", spacing = "1vh", padding = "1.2vh",
        children = {
          ui.text { text = "ⓘ", style = { font = "2.6vh", color = C.accent } },
          ui.text { text = CONFIG.download.installHint, weight = 1, style = { font = "2vh", color = C.dark } },
        } }
      cards[#cards + 1] = ui.row { width = "100%", height = "5.5vh", spacing = "2vh",
        children = { ui.button { id = "dlInstall", label = "开始下载 / 安装", weight = 1, height = "5.5vh",
          background = C.card, border = BORDER_A, corner = "0.7vh", action = "dlStart",
          style = { font = "2.4vh", weight = "bold", tint = C.accent } } } }
      cards[#cards + 1] = ui.column { id = "dlProgress", width = "100%", visible = false, spacing = "1vh",
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
    ui.column { id = "dlSec_1", width = "100%", crossAlign = "center", spacing = "2vh", children = { sec1 } },
    -- 分类2..6：社区资源 → 搜索 + 结果列表（随 dlSelCat 切换分类）
    ui.column { id = "dlSecC", width = "100%", crossAlign = "center", spacing = "2vh", visible = false,
      children = { searchCard, card("dlResultCardC", resultCards) } },
  }
  return ui.column { id = "pageDownload", weight = 1, crossAlign = "center",
    padding = "2.5vh", spacing = "2vh", children = kids }
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
    padding = "2.5vh", spacing = "2.5vh",
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
        background = { from = C.accent, to = "#5AA0FF", angle = 30 }, style = { tint = C.white } },
      ui.text { text = "Pear 启动器", style = { font = "3vh", weight = "bold", color = C.dark } },
      ui.text { text = "版本 · · ·", style = { font = "2.2vh", color = C.mid } },
      ui.text { text = "系统信息 …  ·  设备架构 …", style = { font = "2.2vh", color = C.mid } },
    } }
  local order = { "launcher_settings", "download_mirror", "video_settings", "gl_renderer",
                  "control_keys", "java_tuning", "ui_theme", "ai_assistant" }
  for _, token in ipairs(order) do
    local spec = CONFIG.settingsSubpages[token]
    if spec then
      local rows = {}
      for gi, g in ipairs(spec.groups or {}) do
        if gi > 1 then
          rows[#rows + 1] = ui.divider { height = "0.2vh", background = C.cardBorder }
        end
        rows[#rows + 1] = ui.text { text = g.name or "", width = "100%",
          style = { font = "2.1vh", color = C.mid } }
        for ri, r in ipairs(g.rows or {}) do
          rows[#rows + 1] = settingsRow("setRow_" .. token .. "_" .. gi .. "_" .. ri,
            r.label, r.value, "open_subpage:" .. token)
        end
      end
      if #rows > 0 then
        kids[#kids + 1] = card("setCard_" .. token, rows, { spacing = "1.2vh" })
      end
    end
  end
  if #kids == 1 then
    kids[#kids + 1] = ui.text { text = "启动器暂未提供设置条目。", style = { font = "2.2vh", color = C.mid } }
  end
  return ui.column { id = "pageSettings", weight = 1, crossAlign = "center",
    padding = "2.5vh", spacing = "2.5vh", children = kids }
end

-- ============ 更多页（左侧分类 + 右侧分组卡片，仿 PCL 更多页）============
local function buildMorePage()
  local kids = {}
  for _, g in ipairs(CONFIG.moreGroups) do
    local rows = {}
    for _, rr in ipairs(g.rows) do
      local rightNode
      if rr.right == "version" then
        rightNode = ui.text { text = "· · ·", style = { font = "2.6vh", color = C.mid } }
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
    padding = "2.5vh", spacing = "2.5vh", children = kids }
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
    padding = "2.5vh", spacing = "2.5vh",
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
    padding = "2.5vh", spacing = "2.5vh",
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
    padding = "2.5vh", spacing = "2.5vh", children = kids }
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
    padding = "2.5vh", spacing = "2.5vh",
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
    padding = "2.5vh", spacing = "2.5vh", children = kids }
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
    padding = "2.5vh", spacing = "2.5vh", children = kids }
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
local function sidebarItem(id, icon, label, action, dotId)
  return ui.row {
    id = id, height = "6vh", width = "100%", background = C.card, corner = "0.9vh",
    hoverColor = C.hover, action = action, crossAlign = "center", spacing = "1vh",
    padding = { left = "1.4vh", right = "1.4vh" },
    children = {
      icon and ui.image { icon = icon, size = "3vh", corner = "pill",
        background = C.faintBlue, style = { tint = C.accent } } or nil,
      dotId and ui.image { id = dotId, icon = "sf:circle", size = "2.6vh", style = { tint = C.mid } } or nil,
      ui.text { text = label, weight = 1, style = { font = "2.3vh", color = C.dark } },
    } }
end

-- 设置页左侧分类目录侧栏（仿 PCL PageSetupLeft）
local setSelCat = "launcher_settings"
local function buildSettingsSidebar()
  local kids = { ui.text { text = "设置", width = "100%", style = { font = "2.1vh", color = C.mid } } }
  for i, s in ipairs(launcher.state and launcher.state.settings or {}) do
    local token = s.action and s.action:match("open_subpage:(.+)")
    if token then
      kids[#kids + 1] = sidebarItem("setCat_" .. token, s.icon, s.label, "setCat:" .. token)
    end
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
      -- 顶栏：蓝通栏，页签选中态套白底全圆药丸（不做绝对定位游标）
      ui.row { id = "titlebar", height = "8.5vh", background = C.topbar, crossAlign = "center",
        padding = { left = "2vh", right = "1.5vh" },
        children = {
          ui.text { id = "logo", text = "PCL", width = "10vh", style = { font = "3.2vh", weight = "bold", color = C.white } },
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
  for _, s in ipairs(launcher.state and launcher.state.settings or {}) do
    local token = s.action and s.action:match("open_subpage:(.+)")
    if token then
      local sel = (token == setSelCat)
      launcher.view("setCat_" .. token):setStyle(sel
        and { background = C.hover }
        or  { background = C.card })
    end
  end
end

local function refreshVersionSettingsSidebar()
  for _, c in ipairs(VS_CATS) do
    local sel = (c.token == vsSelCat)
    launcher.view("vsCat_" .. c.token):setStyle(sel
      and { background = C.hover }
      or  { background = C.card })
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
    launcher.view("moreCat_" .. g.name):setStyle(sel
      and { background = C.hover }
      or  { background = C.card })
  end
end

local function refreshMoreContent()
  for _, g in ipairs(CONFIG.moreGroups) do
    local v = launcher.view("moreSec_" .. g.name)
    if v then v:setVisible(g.name == moreSelCat) end
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
    refreshDownloadGroupVisibility()
    launcher.view("dlSec_1"):setVisible(dlSelCat == 1)
    launcher.view("dlSecC"):setVisible(dlSelCat > 1)
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
  for _, t in ipairs(TABS) do
    if t.id == id then selectTab(t.id) return end
  end
  if id == "cap.mojang" then selectCap(1) return end
  if id == "cap.microsoft" then selectCap(2) return end
  if id == "cap.offline" then selectCap(3) return end
  if id == "dlStart" then
    launcher.view("dlProgress"):setVisible(true)
    launcher.view("dlProgressLabel"):setText("准备中…")
    launcher.view("dlBarFill"):setStyle({ width = "0%" })
    launcher.service("download", "start", { versionId = CONFIG.download.defaultVersion })
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
  local dlg = id:match("^dlgHeader:(%w+)$")
  if dlg then
    dlExpanded[dlg] = not (dlExpanded[dlg] == true)
    refreshDownloadGroupVisibility()
    return
  end
  -- 社区资源：搜索源切换 / 关键词输入 / 搜索 / 重置 / 点击结果下载
  if id == "dlPick:source" then
    dlSource = (dlSource % #CONFIG.download.searchSources) + 1
    launcher.view("dlSrcVal"):setText(commSource().name or "…")
    clearCommunityResults()
    launcher.view("dlCommStatus"):setText(CONFIG.download.searchStatusPreset)
    return
  end
  if id == "dlPick:keyword" then
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
  local ci = id:match("^dlComm:(%d+)$")
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
  local sc = id:match("^setCat:(.+)$")
  if sc then
    setSelCat = sc
    refreshSettingsSidebar()
    launcher.action("open_subpage:" .. sc)
    return
  end
  local vsc = id:match("^vsCat:(.+)$")
  if vsc then
    vsSelCat = vsc
    refreshVersionSettingsSidebar()
    refreshVersionSettingsContent()
    return
  end
  local mc = id:match("^moreCat:(.+)$")
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
  local gd = id:match("^gdSelect:(.+)$")
  if gd then
    launcher.service("gameDir", "set", { name = gd })
    refreshGameDirectory()
    return
  end
  local ds = id:match("^dirSel:(%d+)$")
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
  -- 设置子页条目点击（占位：可扩展为弹窗或二级页）
  local subToken, subIdx = id:match("^subRow:([^:]+):(%d+_%d+)$")
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