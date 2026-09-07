-- Pear 启动器 · 仿 PCL 浅色 UI 包 —— v1.9.0
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
  return { name = "PCL 浅色", version = "1.11.2" }
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

local BORDER   = { width = 1, color = C.cardBorder }
local BORDER_A = { width = 1.5, color = C.accentBorder }
local BORDER_D = { width = 1.5, color = C.danger }
local SHADOW   = { blur = 4, opacity = 0.07, x = 0, y = 1 }

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
    gameDirectory = "pageGameDirectory",
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
  },
  online = {
    branch = { "局域网", "在线" },
    rooms = {
      { name = "联机大厅 · 生存", status = "房主 · 24ms" },
      { name = "光影测试房间",   status = "房主 · 68ms" },
      { name = "速通挑战房间",   status = "房主 · 96ms" },
    },
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
local function card(id, children)
  return ui.column { id = id, width = "94%", background = C.card, border = BORDER,
    corner = "1.2vh", shadow = SHADOW, padding = "2vh", spacing = "1vh", children = children }
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

local function bigItem(id, icon, tint, title, meta, rightText)
  return ui.row {
    id = id, height = "14vh", background = C.card, corner = "1.2vh",
    border = BORDER, shadow = SHADOW, hoverColor = C.hover, crossAlign = "center",
    padding = { left = "2vh", right = "2vh" }, spacing = "1.8vh",
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

local function pickerRow(id, label, valueText)
  return ui.row {
    id = id, height = "4.5vh", width = "100%", crossAlign = "center",
    children = {
      ui.text { text = label, style = { font = "2.4vh", color = C.dark } },
      ui.spacer { weight = 1 },
      ui.row { weight = 3, width = "70%", height = "4.5vh", background = C.card,
        border = { width = 1, color = C.fieldBorder }, corner = "0.8vh", crossAlign = "center",
        padding = { left = "1.2vh", right = "1.2vh" },
        children = {
          ui.text { text = valueText, weight = 1, style = { font = "2.2vh", color = C.dark } },
          ui.text { text = " ▾", style = { font = "2.2vh", color = C.mid } },
        } },
    },
  }
end

local function plainButton(id, label, accent)
  return ui.button { id = id, label = label, height = "5.5vh", weight = 1, background = C.card,
    corner = "0.7vh", border = (accent and BORDER_A or BORDER),
    style = { font = "2.4vh", tint = C.dark } }
end

-- ============ 启动页左栏（split_column 左 1/3）============
local function buildHomeSidebar()
  local kids = {}
  kids[#kids + 1] = ui.spacer { height = "2vh" }
  -- 胶囊在顶
  kids[#kids + 1] = ui.row { id = "capsules", width = "85%", height = "3.7vh", spacing = "2vh",
    children = {
      ui.button { id = "cap.offline", label = "离线", height = "3.7vh", weight = 1, corner = "pill",
        action = "cap.offline", hoverColor = C.hover,
        style = { background = C.accent, tint = C.white, font = "2.4vh", weight = "bold" } },
      ui.button { id = "cap.genuine", label = "正版", height = "3.7vh", weight = 1, corner = "pill",
        action = "cap.genuine", border = BORDER_A,
        style = { background = C.card, tint = C.accent, font = "2.4vh", weight = "bold" } },
    } }
  -- 头像在中
  kids[#kids + 1] = ui.spacer { height = "3vh" }
  kids[#kids + 1] = ui.image { id = "avatar", icon = "sf:person.crop.circle.fill", size = "11vh",
    corner = "10vh", background = C.avatarBg, style = { tint = C.avatarLine } }
  kids[#kids + 1] = ui.spacer { height = "2.5vh" }
  kids[#kids + 1] = ui.row { id = "accountRow", width = "85%", height = "3.5vh", spacing = "1vh",
    crossAlign = "center",
    children = {
      ui.row { id = "accountPicker", action = "open:accountManager", weight = 1, height = "3.5vh",
        background = C.card, border = BORDER, corner = "0.8vh", crossAlign = "center", hoverColor = C.hover,
        padding = { left = "1.2vh", right = "1.2vh" },
        children = {
          ui.text { id = "accountPickerLabel", text = "未登录", weight = 1, style = { font = "2.3vh", color = C.dark } },
          ui.image { icon = "sf:chevron.down", size = "1.8vh", style = { tint = C.mid } },
        } },
      ui.button { id = "login", label = "登录", width = "28%", height = "3.5vh", corner = "0.8vh",
        border = BORDER_A, style = { background = C.card, tint = C.accent, font = "2.4vh", weight = "bold" } },
    } }
  local lnKids = {}
  for _, ln in ipairs(CONFIG.home.secondaryLinks) do
    lnKids[#lnKids + 1] = ui.text { text = "» " .. ln.label, action = ln.action,
      style = { font = "2vh", color = C.mid } }
  end
  kids[#kids + 1] = ui.row { id = "links", spacing = "4vh", crossAlign = "center", children = lnKids }
  -- 按钮组贴底
  kids[#kids + 1] = ui.spacer { weight = 5 }
  kids[#kids + 1] = ui.column { id = "launchBtn", action = "launch", width = "85%", height = "9vh",
    corner = "1.5vh", background = C.card, border = BORDER_A, justify = "center", crossAlign = "center",
    spacing = "0.5vh",
    children = {
      ui.text { id = "launchTitle", text = "启动游戏", style = { font = "3vh", weight = "bold", color = C.dark } },
      ui.text { id = "launchSub", text = "尚未选择版本", style = { font = "2.2vh", color = C.mid } },
    } }
  kids[#kids + 1] = ui.spacer { height = "1vh" }
  kids[#kids + 1] = ui.row { id = "versionRow", width = "85%", height = "5.5vh", spacing = "1vh",
    children = {
      ui.button { id = "pickVersion", label = "选择版本", action = "open:versionManager", weight = 1,
        height = "5.5vh", corner = "1vh", border = BORDER, hoverColor = C.hover,
        style = { background = C.card, tint = C.dark, font = "2.4vh", weight = "bold" } },
      ui.button { id = "versionSetup", label = "版本设置", action = "open:version_settings", weight = 1,
        height = "5.5vh", corner = "1vh", border = BORDER, hoverColor = C.hover,
        style = { background = C.card, tint = C.dark, font = "2.4vh", weight = "bold" } },
    } }
  kids[#kids + 1] = ui.spacer { height = "2vh" }
  return kids
end

-- ============ 启动页右区（vertical_flow：白卡纵向堆叠）============
local function buildHomePage()
  return ui.column { id = "pageHome", weight = 1, crossAlign = "center", padding = "2.5vh",
    spacing = "2.5vh",
    children = {
      card("homeWelcome", {
        ui.row { width = "100%", height = "6vh", crossAlign = "center", spacing = "1.5vh",
          children = {
            ui.image { icon = "sf:sparkles", size = "5vh", corner = "1vh",
              background = { from = C.accent, to = C.cyan, angle = 30 }, style = { tint = C.white } },
            ui.column { weight = 1, justify = "center", spacing = "0.4vh", children = {
              ui.text { text = "欢迎使用 Pear 启动器", style = { font = "3vh", weight = "bold", color = C.dark } },
              ui.text { text = "在这里开始你的世界", style = { font = "2.1vh", color = C.mid } },
            } },
          } },
        ui.divider { height = "0.2vh", background = "#D9E4F0" },
        ui.text { text = "· 关注版本更新与社区动态 ·", style = { font = "2.1vh", color = C.mid } },
      }),
      card("homeQuick", {
        ui.text { text = "快速开始", style = { font = "2.8vh", weight = "bold", color = C.dark } },
        listEntry("homeQ1", "sf:cube.fill", C.green, "选择版本", "尚未选择游戏版本", "›", "open:versionManager"),
        listEntry("homeQ2", "sf:person.3.fill", C.orange, "登录账号", "未登录", "›", "open:accountManager"),
      }),
      card("homeNews", {
        ui.text { text = "近期动态", style = { font = "2.8vh", weight = "bold", color = C.dark } },
        listEntry("homeN1", "sf:newspaper.fill", C.cyan, "启动器更新日志", "查看最近更改与已知问题", "›", "open:more"),
        listEntry("homeN2", "sf:cloud.fill", C.purple, "版本镜像与资源", "下载源与资源中心入口", "›", "open:download"),
      }),
    } }
end

-- ============ 下载页（无侧栏、通栏纵向流：两行分段标签 + 卡片）============
local function buildDownloadPage()
  -- 右侧内容按分类：dlSec_1 原版(最新版本) / dlSec_2.. 社区资源(搜索+结果列表)
  local sec1 = card("dlSecCard1", (function()
    local k = { ui.text { text = "最新版本", style = { font = "2.8vh", weight = "bold", color = C.dark } } }
    for i, it in ipairs(CONFIG.download.latest) do
      k[#k + 1] = listEntry("dl11_" .. i, it.icon, it.tint, it.title, it.sub)
    end
    return k
  end)())
  local dlSearch = {}
  for i, lab in ipairs(CONFIG.download.searchLabels) do
    dlSearch[#dlSearch + 1] = pickerRow("dlSearchRow" .. i, lab, "…")
  end
  local dlRes = {}
  for i, it in ipairs(CONFIG.download.popular) do
    dlRes[#dlRes + 1] = bigItem("dl4_" .. i, it.icon, it.tint, it.title, it.meta, it.right)
  end
  local kids = {
    ui.text { id = "dlTitle", text = CONFIG.download.titleByCat[dlSelCat] or "原版游戏", width = "100%",
      style = { font = "3vh", weight = "bold", color = C.dark } },
    -- 分类1：原版游戏 → 最新版本
    ui.column { id = "dlSec_1", width = "100%", crossAlign = "center", spacing = "2vh", children = { sec1 } },
    -- 分类2..6：社区资源 → 搜索 + 结果列表（同一结构，标题区分）
    ui.column { id = "dlSec_2", width = "100%", crossAlign = "center", spacing = "2vh", visible = false, children = {
      card("dlSearchCard", (function()
        local s = { ui.text { text = "搜索", style = { font = "2.8vh", weight = "bold", color = C.dark } } }
        pushAll(s, dlSearch)
        s[#s + 1] = ui.row { width = "100%", height = "5.5vh", spacing = "3vh",
          children = { plainButton("dlBtnSearch", "搜索", false), plainButton("dlBtnReset", "重置", false) } }
        return s
      end)()),
      card("dlResultCard", (function()
        local s = { ui.text { text = "结果", style = { font = "2.8vh", weight = "bold", color = C.dark } } }
        pushAll(s, dlRes)
        return s
      end)()),
    } },
  }
  for c = 3, 6 do
    kids[#kids + 1] = ui.column { id = "dlSec_" .. c, width = "100%", crossAlign = "center",
      spacing = "2vh", visible = false,
      children = {
        card("dlSearchCard" .. c, (function()
          local s = { ui.text { text = "搜索", style = { font = "2.8vh", weight = "bold", color = C.dark } } }
          pushAll(s, dlSearch)
          s[#s + 1] = ui.row { width = "100%", height = "5.5vh", spacing = "3vh",
            children = { plainButton("dlBtnSearch", "搜索", false), plainButton("dlBtnReset", "重置", false) } }
          return s
        end)()),
        card("dlResultCard" .. c, (function()
          local s = { ui.text { text = "结果", style = { font = "2.8vh", weight = "bold", color = C.dark } } }
          pushAll(s, dlRes)
          return s
        end)()),
      } }
  end
  return ui.column { id = "pageDownload", weight = 1, crossAlign = "center",
    padding = "2.5vh", spacing = "2vh", children = kids }
end

-- ============ 联机页（两分支 + 输入条 + 提示行 + 房间条目卡）============
local function buildMultiPage()
  local rooms = {}
  for i, r in ipairs(CONFIG.online.rooms) do
    rooms[#rooms + 1] = ui.row { id = "mpRoom" .. i, height = "7vh", background = C.card,
      border = BORDER, corner = "1.2vh", hoverColor = C.hover, crossAlign = "center", spacing = "1.5vh",
      padding = "1.5vh",
      children = {
        ui.image { icon = "sf:square.3.layers.3d", size = "5vh", corner = "1vh", background = C.accent,
          style = { tint = C.white } },
        ui.column { weight = 1, justify = "center", spacing = "0.3vh", children = {
          ui.text { text = r.name, style = { font = "2.4vh", weight = "bold", color = C.dark } },
          ui.text { text = r.status, style = { font = "2vh", color = C.mid } },
        } },
        ui.text { text = "加入", style = { font = "2.2vh", color = C.accent } },
      } }
  end
  return ui.column { id = "pageMulti", weight = 1, crossAlign = "center",
    padding = "2.5vh", spacing = "2.5vh",
    children = {
      segmentRow("segM", CONFIG.online.branch, "1vh"),
      -- 输入条
      ui.row { width = "94%", height = "5.5vh", background = C.card, border = BORDER,
        corner = "1.2vh", crossAlign = "center", padding = "1.5vh", spacing = "1.2vh",
        children = {
          ui.image { icon = "sf:link", size = "2.6vh", style = { tint = C.mid } },
          ui.text { weight = 1, text = "输入房间连接码或地址…", style = { font = "2.2vh", color = C.mid } },
          ui.button { id = "mpJoin", label = "加入", height = "4vh", background = C.accent,
            corner = "pill", style = { font = "2.2vh", tint = C.white } },
        } },
      -- 提示行
      ui.row { width = "94%", background = C.hintBg, corner = "1vh", crossAlign = "center",
        spacing = "1.2vh", padding = "1.5vh",
        children = {
          ui.text { text = "ⓘ", style = { font = "2.8vh", color = C.accent } },
          ui.text { weight = 1, text = "联机需要双方都能访问服务器，房间连接码用于分享。",
            style = { font = "2.2vh", color = C.dark } },
        } },
      -- 房间条目卡
      card("mpRoomCard", (function()
        local k = { ui.text { text = "在线房间", style = { font = "2.8vh", weight = "bold", color = C.dark } } }
        pushAll(k, rooms)
        return k
      end)()),
    } }
end

-- ============ 设置页（1 版本信息卡 + N 白卡条目，说明文字紧跟卡片下方）============
local function buildSettingsPage()
  local kids = {}
  kids[#kids + 1] = ui.column { id = "setAbout", width = "94%", background = C.card, border = BORDER,
    corner = "1.2vh", shadow = SHADOW, padding = "3vh", crossAlign = "center", spacing = "1.2vh",
    children = {
      ui.image { icon = "sf:shippingbox.fill", size = "8vh", corner = "1.6vh",
        background = { from = C.accent, to = "#5AA0FF", angle = 30 }, style = { tint = C.white } },
      ui.text { text = "Pear 启动器", style = { font = "3vh", weight = "bold", color = C.dark } },
      ui.text { text = "版本 · · ·", style = { font = "2.2vh", color = C.mid } },
      ui.text { text = "系统信息 …  ·  设备架构 …", style = { font = "2.2vh", color = C.mid } },
    } }
  local list = launcher.state and launcher.state.settings
  if type(list) ~= "table" then list = {} end
  for i, s in ipairs(list) do
    local entry = {
      ui.row { id = "set" .. i, height = "7vh", background = C.card, border = BORDER,
        corner = "1.2vh", shadow = SHADOW, crossAlign = "center", spacing = "1.6vh",
        padding = "1.8vh", hoverColor = C.hover, action = (s.action or "open:settings"),
        children = {
          ui.image { icon = s.icon or "sf:gearshape.fill", size = "4.5vh", corner = "1vh",
            background = C.accent, style = { tint = C.white } },
          ui.text { text = s.label or "", weight = 1, style = { font = "2.7vh", color = C.dark } },
          chevron(),
        } },
    }
    -- 三条带说明的条目：说明文字紧跟卡片下方、左对齐
    if type(s.desc) == "string" and #s.desc > 0 then
      entry[#entry + 1] = ui.text { text = s.desc, width = "100%",
        style = { font = "2vh", color = C.mid } }
    end
    kids[#kids + 1] = ui.column { id = "setCol" .. i, width = "94%", spacing = "0.6vh",
      crossAlign = "stretch", children = entry }
  end
  if #kids == 1 then
    kids[#kids + 1] = ui.text { text = "启动器暂未提供设置条目。", style = { font = "2.2vh", color = C.mid } }
  end
  return ui.column { id = "pageSettings", weight = 1, crossAlign = "center",
    padding = "2.5vh", spacing = "2.5vh", children = kids }
end

-- ============ 更多页（居中标题 + 4 分组：灰字组名 + 白卡多行条目）============
local function buildMorePage()
  local kids = { ui.text { text = "更多", style = { font = "4vh", weight = "bold", color = C.dark } } }
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
            corner = "1vh", background = C.faintBlue, style = { tint = C.accent } },
          ui.text { text = rr.label, weight = 1, style = { font = "2.7vh", color = C.dark } },
          rightNode,
        } }
    end
    kids[#kids + 1] = ui.column { width = "94%", spacing = "1vh", crossAlign = "stretch",
      children = {
        ui.text { text = g.name, width = "100%", style = { font = "2.1vh", color = C.mid } },
        ui.column { background = C.card, border = BORDER, corner = "1.2vh", shadow = SHADOW,
          padding = "1vh", spacing = "0.5vh", children = rows },
      } }
  end
  return ui.column { id = "pageMore", weight = 1, crossAlign = "center",
    padding = "2.5vh", spacing = "2.5vh", children = kids }
end

-- ============ 版本设置二级页（回到一级页可返回；不规格外）============
local function buildVersionSettingsPage()
  return ui.column { id = "pageVersionSettings", weight = 1, crossAlign = "center",
    padding = "3vh", spacing = "3vh",
    children = {
      card("vsInfo", {
        ui.row { width = "100%", height = "11vh", crossAlign = "center", spacing = "2vh", padding = "1vh",
          children = {
            ui.image { icon = "sf:doc.text.fill", size = "6vh", background = C.accent,
              corner = "1.2vh", style = { tint = C.white } },
            ui.column { weight = 1, justify = "center", spacing = "0.4vh", children = {
              ui.text { text = "· · ·", style = { font = "2.8vh", weight = "bold", color = C.dark } },
              ui.text { text = "版本信息 · · ·", style = { font = "2.1vh", color = C.mid } },
            } },
          } },
      }),
      card("vsPick", {
        pickerRow("vsPick1", "启动方式", "· · ·"),
        pickerRow("vsPick2", "游戏目录", "· · ·"),
        ui.row { width = "100%", height = "5.5vh", spacing = "3vh",
          children = { plainButton("vsBtn1", "重选", false), plainButton("vsBtn2", "刷新", false) } },
      }),
      card("vsAdv", {
        ui.row { width = "100%", height = "5.5vh", spacing = "3vh",
          children = {
            plainButton("vsAdv1", "打开安装目录", false),
            plainButton("vsAdv2", "重置版本", false),
            ui.button { id = "vsAdvDanger", label = "删除本版本", weight = 1, height = "5.5vh",
              background = C.card, border = BORDER_D, corner = "0.7vh",
              style = { font = "2.4vh", tint = C.danger } },
          } },
      }),
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

-- ============ 通用设置子页（token → 标题 + 分组白卡；返回设置）============
local function buildSettingsSubpage(token, spec)
  local kids = {
    ui.row { id = "sub" .. token .. "Header", width = "94%", height = "6vh",
      crossAlign = "center", spacing = "1.5vh",
      children = {
        ui.button { id = "sub" .. token .. "Back", label = "‹ 返回", action = "open:settings",
          width = "22%", height = "5vh", background = C.card, border = BORDER, corner = "0.8vh",
          hoverColor = C.hover, style = { font = "2.4vh", weight = "bold", tint = C.dark } },
        ui.text { text = spec.title or "", weight = 1,
          style = { font = "3vh", weight = "bold", color = C.dark } },
      } },
  }
  for gi, g in ipairs(spec.groups or {}) do
    local rows = {}
    for ri, r in ipairs(g.rows or {}) do
      rows[#rows + 1] = ui.row { id = "sub" .. token .. "r" .. gi .. "_" .. ri, height = "6.5vh",
        crossAlign = "center", padding = "1.8vh", spacing = "1.6vh", hoverColor = C.hover,
        children = {
          ui.text { text = r.label or "", weight = 1, style = { font = "2.6vh", color = C.dark } },
          ui.text { text = r.value or "", style = { font = "2.4vh", color = C.accent } },
          chevron(),
        } }
    end
    kids[#kids + 1] = ui.column { width = "94%", spacing = "1vh", crossAlign = "stretch",
      children = {
        ui.text { text = g.name or "", width = "100%", style = { font = "2.1vh", color = C.mid } },
        ui.column { background = C.card, border = BORDER, corner = "1.2vh", shadow = SHADOW,
          padding = "1vh", spacing = "0.5vh", children = rows },
      } }
  end
  return ui.column { id = "sub_" .. token, weight = 1, crossAlign = "center",
    padding = "2.5vh", spacing = "2.5vh", children = kids }
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

-- 下载页左侧分类目录侧栏（仿 PCL PageDownloadLeft：原版游戏 / 社区资源各类）
local dlSelCat = 1
local function buildDownloadSidebar()
  local kids = {}
  local idx = 0
  for _, g in ipairs(CONFIG.download.sidebarGroups) do
    kids[#kids + 1] = ui.text { text = g.name, width = "100%", style = { font = "2.1vh", color = C.mid } }
    for _, it in ipairs(g.items) do
      idx = idx + 1
      kids[#kids + 1] = ui.row { id = it.id, height = "6vh", width = "100%",
        background = C.card, corner = "0.9vh", hoverColor = C.hover, action = "dlCat:" .. idx,
        crossAlign = "center", spacing = "1vh", padding = { left = "1.4vh", right = "1.4vh" },
        children = {
          ui.image { id = "dlCatDot_" .. idx, icon = "sf:circle", size = "2.6vh", style = { tint = C.mid } },
          ui.text { text = it.label, weight = 1, style = { font = "2.3vh", color = C.dark } },
        } }
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
              -- 启动页左栏；下载页=leftDownload 分类目录；其他页=leftDir 游戏目录
              ui.column { id = "leftHome", width = "100%", weight = 1, crossAlign = "center",
                spacing = "0.4vh", children = homeSidebar },
              ui.column { id = "leftDir", width = "100%", weight = 1, crossAlign = "center",
                spacing = "0.4vh", visible = false, children = buildDirectorySidebar() },
              ui.column { id = "leftDownload", width = "100%", weight = 1, crossAlign = "center",
                spacing = "0.4vh", visible = false, children = buildDownloadSidebar() },
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
local selectedCap = 1
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
  for i = 1, 2 do
    local sel = (i == idx)
    launcher.view("cap." .. (i == 1 and "offline" or "genuine")):setStyle(sel
      and { background = C.accent, tint = C.white, borderWidth = 1.5, borderColor = C.accent }
      or  { background = C.card, tint = C.accent, borderWidth = 1.5, borderColor = C.accent })
  end
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
  launcher.view("accountPickerLabel"):setText(name)
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
  launcher.view("accountPickerLabel"):setText(account.name or "未登录")
end

function onPageChange(page)
  currentPage = page
  -- 全幅无左栏页：版本设置 / 版本管理 / 账号管理 / 游戏目录 / 任意设置子页（顶栏仍显示，仅收左栏）
  local isFull = (page == "version_settings") or (page == "versionManager")
    or (page == "accountManager") or (page == "gameDirectory")
    or (CONFIG.settingsSubpages[page] ~= nil)
  launcher.view("titlebar"):setVisible(true)
  launcher.view("left"):setVisible(not isFull)
  launcher.view("leftHome"):setVisible(page == "home")
  launcher.view("leftDownload"):setVisible(page == "download" and not isFull)
  launcher.view("leftDir"):setVisible(page ~= "home" and page ~= "download" and not isFull)
  if page == "download" and not isFull then
    refreshDownloadSidebar()
    for i = 1, #CONFIG.download.titleByCat do launcher.view("dlSec_" .. i):setVisible(i == dlSelCat) end
  elseif page ~= "home" and page ~= "download" and not isFull then
    refreshDirectorySidebar()
  end
  if isFull and CONFIG.settingsSubpages[page] then
    selectTab("tab.setup") -- 设置子页仍高亮「设置」页签
  elseif not isFull then
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
  if id == "cap.offline" then selectCap(1) return end
  if id == "cap.genuine" then selectCap(2) return end
  local dlc = id:match("^dlCat:(%d+)$")
  if dlc then
    dlSelCat = tonumber(dlc) or 1
    refreshDownloadSidebar()
    for i = 1, #CONFIG.download.titleByCat do launcher.view("dlSec_" .. i):setVisible(i == dlSelCat) end
    launcher.view("dlTitle"):setText(CONFIG.download.titleByCat[dlSelCat] or "")
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
end