-- Pear 启动器 仿 PCL 浅色主题 —— v1.4.0
--
-- 设计语言（所有尺寸以窗口高 1H 为基准，vh 单位；横向用百分比；禁止写死像素）：
--   顶栏纯色蓝 #0A5FC4；页面背景浅蓝灰对角渐变 #E3EEF9→#D5E5F5
--   内容卡片 = 白底 #FFFFFF + 浅蓝灰描边 #D9E4F0 + 极浅投影 + 圆角 ≈ 1.2vh
--   仅启动页有白底左栏(≈32%)，其余四页通栏纵向流、无侧栏
--   几乎所有"按钮"都是整行可点击条目卡：白底圆角卡 = 左蓝图标 + 深色文字 + 右灰 ›
--   hover 时整行背景变浅蓝 #EAF3FC；页面切换淡入淡出
--
-- 结构约定（PLUIShellViewController.showLuaPage 依赖）：
--   内容区容器 id="content"，内挂 5 棵纯 Lua 页子树：
--     pageHome / pageDownload / pageMulti / pageSettings / pageMore
--   非启动页收起左栏（id="left"），内容区整幅铺开。

local C = {
  topbar       = "$color:topbar",
  pageFrom     = "$color:pageFrom",
  pageTo       = "$color:pageTo",
  card         = "$color:card",
  cardBorder   = "$color:cardBorder",
  dark         = "$color:cardText",      -- 主文字 #333333
  mid          = "$color:subText",       -- 次要文字 #999999
  white        = "$color:white",
  accent       = "$color:accent",        -- 强调蓝 #0B84FF
  accentBorder = "$color:accentBorder",
  transparent  = "$color:transparent",
  hover        = "$color:hover",         -- hover 浅蓝 #EAF3FC
  avatarBg     = "$color:avatarBg",      -- 头像灰底 #ECECEC
  green        = "$color:brandGreen",
  orange       = "$color:brandOrange",
  purple       = "$color:brandPurple",
  pink         = "$color:brandPink",
  cyan         = "$color:brandCyan",
  danger       = "$color:danger",
  avatarLine   = "#C0C0C0",
}

-- 卡片描边（白底 + 浅蓝灰细描边）；主按钮等个别元素用强调蓝描边。
local BORDER = { width = 1, color = C.cardBorder }
-- 极浅投影（浅色主题白卡片的立体感）
local SHADOW = { blur = 4, opacity = 0.07, x = 0, y = 1 }

-- ===== 顶栏五个页签（启动/下载/联机/设置/更多）=====
local TABS = {
  { id = "tab.home",     label = "启动", icon = "sf:house.fill",                    action = "open:home",            page = "home" },
  { id = "tab.download", label = "下载", icon = "sf:arrow.down.circle.fill",        action = "open:download",        page = "download" },
  { id = "tab.multi",    label = "联机", icon = "sf:antenna.radiowaves.left.and.right", action = "open:multiplayer", page = "multi" },
  { id = "tab.setup",    label = "设置", icon = "sf:gearshape.fill",                action = "open:settings",        page = "settings" },
  { id = "tab.other",    label = "更多", icon = "sf:ellipsis.circle.fill",          action = "open:more",            page = "more" },
}

local PAGE_TAB = {
  home = "tab.home", download = "tab.download", multi = "tab.multi",
  settings = "tab.setup", more = "tab.other",
}

-- ===== UI 包配置表（WS-E）：所有页面条目的单一数据源 ====
-- 新增页面/页签/下载项/房间/更多条目 = 只在此加一条，构建器与引擎零改动。
local CONFIG = {
  -- 页 token → Lua 页子树 id（content 节点据此解析 navigate/open）
  pages = {
    home = "pageHome", download = "pageDownload", multi = "pageMulti",
    settings = "pageSettings", more = "pageMore",
    version_settings = "pageVersionSettings",
  },
  -- 顶栏页签（即 TABS）
  tabs = TABS,
  -- 下载页：两行分段标签 + 条目列
  download = {
    segments = { "全部", "正式版", "快照", "Mods", "光影", "整合包" },
    subSegments = { "下载", "已购", "收藏", "历史" },
    items = {
      { icon = "sf:cube.fill",           color = C.green,  title = "最新 Java 版本", date = "更新于 ···", cat = "正式版", action = "open:download" },
      { icon = "sf:gamecontroller.fill", color = C.purple, title = "光影整合包",     date = "更新于 ···", cat = "光影",   action = "open:download" },
      { icon = "sf:map.fill",            color = C.cyan,   title = "地图资源合集",   date = "更新于 ···", cat = "地图",   action = "open:download" },
    },
  },
  -- 联机页 · 加入房间列表（右端状态文字 = 深色）
  online = {
    rooms = {
      { icon = "sf:person.3.fill", title = "联机大厅 · 生存", sub = "房主 · 24ms", status = "可加入", action = "open:multiplayer" },
      { icon = "sf:person.3.fill", title = "光影测试房间",     sub = "房主 · 68ms", status = "可加入", action = "open:multiplayer" },
    },
  },
  -- 更多页分组（right: "chevron" | "version"）
  moreGroups = {
    { name = "启动", rows = {
        { id = "moreLaunch", icon = "sf:play.rectangle.fill", label = "启动选项", right = "chevron", action = "open:settings" },
    } },
    { name = "资源", rows = {
        { id = "moreDefaultVersion", icon = "sf:cube.fill", label = "默认版本", right = "version", action = "open:versionManager" },
        { id = "moreMods", icon = "sf:hud", label = "资源中心", right = "chevron", action = "open:mods" },
        { id = "moreVersions", icon = "sf:square.grid.3x3.fill", label = "版本管理", right = "chevron", action = "open:versionManager" },
    } },
    { name = "个性化", rows = {
        { id = "moreSaves", icon = "sf:tray.full.fill", label = "存档管理", right = "chevron", action = "open:gameDirectory" },
        { id = "moreTheme", icon = "sf:paintbrush.fill", label = "主题材质包", right = "chevron", action = "open:settings" },
        { id = "moreWall", icon = "sf:photo.on.rectangle.fill", label = "壁纸设置", right = "chevron", action = "open:settings" },
    } },
    { name = "关于", rows = {
        { id = "moreAbout", icon = "sf:info.circle.fill", label = "软件信息", right = "chevron", action = "open:settings" },
        { id = "moreLicense", icon = "sf:doc.text.fill", label = "开源协议", right = "chevron", action = "open:settings" },
        { id = "moreFeedback", icon = "sf:exclamationmark.bubble.fill", label = "问题反馈", right = "chevron", action = "open:settings" },
        { id = "moreVersion", icon = "sf:v.circle.fill", label = "版本号", right = "version", action = "open:settings" },
    } },
  },
}

-- 兼容旧引用：resetDownloadSegments 仍读 DL1/DL2；直接指向配置表保证单一数据源。
local DL1 = CONFIG.download.segments
local DL2 = CONFIG.download.subSegments

-- ===== 构建器（复用节点）=====

local function topTab(t)
  -- 顶栏页签：选中态白色全圆药丸 + 蓝 #0B84FF 图标文字；未选中透明底白色。
  return ui.button {
    id = t.id, label = t.label, icon = t.icon, action = t.action,
    height = "6vh", corner = "pill",
    padding = { left = "1.5vh", right = "1.5vh" },
    style = { background = C.transparent, tint = C.white, font = "2.4vh", weight = "bold" },
  }
end

-- 把数组 arr 的元素依次追加入列表 list（构建 children 时展平多返回值/嵌套数组）。
local function pushAll(list, arr)
  for _, v in ipairs(arr) do list[#list + 1] = v end
end

-- 整行可点击条目卡（下载/联机房间等）：白底卡 = 左彩色图标 + 中标题/副行 + 右文字 + ›
-- 整行可点，hover 变浅蓝 #EAF3FC。
local function listEntry(id, icon, iconTint, title, sub, rightText, rightColor, action)
  return ui.row {
    id = id, width = "94%", height = "9vh", corner = "1.2vh",
    background = C.card, border = BORDER, shadow = SHADOW,
    hoverColor = C.hover, action = action, crossAlign = "center",
    padding = { left = "2.5vh", right = "2vh" }, spacing = "1.5vh",
    children = {
      ui.image { icon = icon, size = "5vh", corner = "0.8vh", style = { tint = iconTint } },
      ui.column {
        weight = 1, justify = "center", spacing = "0.4vh",
        children = {
          ui.text { id = id .. "Title", text = title, style = { font = "2.8vh", weight = "bold", color = C.dark } },
          ui.text { id = id .. "Sub", text = sub, style = { font = "2.2vh", color = C.mid } },
        },
      },
      ui.text { id = id .. "Right", text = rightText, style = { font = "2.6vh", color = rightColor } },
      ui.text { text = "›", style = { font = "3vh", color = C.mid } },
    },
  }
end

-- 设置/更多页的整卡多行条目：左蓝色小图标 + 深色文字 + 右端 ›（或版本号）
local function rowItem(id, icon, tint, label, rightSpec, action)
  return ui.row {
    id = id, height = "7.5vh", corner = "1.2vh", action = action,
    border = BORDER, hoverColor = C.hover, crossAlign = "center",
    padding = { left = "3vh", right = "2.5vh" }, spacing = "1.5vh",
    children = {
      ui.image { icon = icon, size = "3.5vh", style = { tint = tint } },
      ui.text { text = label, weight = 1, style = { font = "2.8vh", color = C.dark } },
      rightSpec,
    },
  }
end

local function chevron()
  return ui.text { text = "›", style = { font = "3vh", color = C.mid } }
end

local function versionLabel()
  -- 更多页版本行：右端灰色版本号（不占固定宽度，随内容收缩）
  return ui.text { text = "…", style = { font = "2.6vh", color = C.mid } }
end

-- 输入条（下载页搜索 / 联机页加入房间输入）：白底全圆 + 细描边，左蓝图标 + 灰占位 + 右蓝图标
local function inputBar(id, leftIcon, placeholder, rightIcon, action)
  return ui.row {
    id = id, width = "94%", height = "6vh", corner = "pill", background = C.white,
    border = BORDER, shadow = SHADOW, action = action, crossAlign = "center",
    padding = { left = "2vh", right = "2vh" }, spacing = "1.2vh",
    children = {
      ui.image { icon = leftIcon, size = "2.6vh", style = { tint = C.accent } },
      ui.text { text = placeholder, weight = 1, style = { font = "2.4vh", color = C.mid } },
      ui.image { icon = rightIcon, size = "2.6vh", style = { tint = C.accent } },
    },
  }
end

function describe()
  return { name = "Pear PCL 浅色", author = "Pear", version = "1.4.0" }
end

-- ===== 页面子树（content 容器内 5 棵，仅当前页可见）=====

-- 启动页 · 右区（68% 浅蓝灰渐变底，白卡纵向堆叠，左右留边 ≈3%）
local function buildHomePage()
  return ui.column {
    id = "pageHome", weight = 1, crossAlign = "center",
    padding = { top = "1vh", bottom = "1vh" }, spacing = "2vh",
    children = {
      -- 页头行：主页大标题 + 右端 自定义
      ui.row {
        id = "homeHeader", width = "94%", crossAlign = "center",
        children = {
          ui.text { text = "主页", style = { font = "4.5vh", weight = "bold", color = C.dark } },
          ui.spacer { weight = 1 },
          ui.image { icon = "sf:slider.horizontal.3", size = "2.6vh", style = { tint = C.mid } },
          ui.text { text = "自定义", style = { font = "2.2vh", color = C.mid } },
        },
      },
      -- 欢迎卡
      ui.row {
        id = "homeWelcomeCard", width = "94%", height = "14vh", corner = "1.2vh",
        background = C.card, border = BORDER, shadow = SHADOW,
        crossAlign = "center", padding = { left = "2vh", right = "2vh" }, spacing = "1.5vh",
        children = {
          ui.image { icon = "sf:person.fill", size = "8vh", style = { tint = C.accent } },
          ui.image { icon = "sf:person.crop.circle", size = "7vh", background = C.avatarBg, corner = "pill", style = { tint = C.mid } },
          ui.column {
            weight = 1, justify = "center", spacing = "0.6vh",
            children = {
              ui.text { id = "homeWelcomeTitle", text = "欢迎回来！", style = { font = "3.2vh", weight = "bold", color = C.dark } },
              ui.text { id = "homeWelcomeSub", text = "准备好开始你的冒险了吗？", style = { font = "2.4vh", color = C.mid } },
            },
          },
        },
      },
      -- 公告卡
      ui.row {
        id = "homeAnnounceCard", width = "94%", height = "7.5vh", corner = "1.2vh",
        background = C.card, border = BORDER, shadow = SHADOW,
        action = "open:home", hoverColor = C.hover,
        crossAlign = "center", padding = { left = "2vh", right = "2vh" }, spacing = "1.2vh",
        children = {
          ui.image { icon = "sf:bell.fill", size = "3vh", style = { tint = C.accent } },
          ui.text { text = "看看 Pear 启动器最近的动态与公告", style = { font = "2.8vh", color = C.dark } },
        },
      },
      -- 双卡行：版本入口（绿 / 橙）
      ui.row {
        id = "homeVersionRow", width = "94%", height = "13vh", spacing = "2vh",
        children = {
          ui.column {
            id = "homeLatestCard", weight = 1, corner = "1.2vh", background = C.card,
            border = BORDER, shadow = SHADOW, action = "open:download", hoverColor = C.hover,
            justify = "center", crossAlign = "center", spacing = "0.4vh",
            children = {
              ui.image { icon = "sf:square.grid.3x3.fill", size = "5vh", style = { tint = C.green } },
              ui.text { text = "正式版", style = { font = "2.2vh", color = C.mid } },
              ui.text { id = "homeLatestVer", text = "…", style = { font = "4vh", weight = "bold", color = C.dark } },
            },
          },
          ui.column {
            id = "homeSnapshotCard", weight = 1, corner = "1.2vh", background = C.card,
            border = BORDER, shadow = SHADOW, action = "open:download", hoverColor = C.hover,
            justify = "center", crossAlign = "center", spacing = "0.4vh",
            children = {
              ui.image { icon = "sf:fish.fill", size = "5vh", style = { tint = C.orange } },
              ui.text { text = "快照", style = { font = "2.2vh", color = C.mid } },
              ui.text { id = "homeSnapshotVer", text = "…", style = { font = "4vh", weight = "bold", color = C.dark } },
            },
          },
        },
      },
      -- 资讯大卡
      ui.row {
        id = "homeNewsCard", width = "94%", height = "16vh", corner = "1.2vh",
        background = C.card, border = BORDER, shadow = SHADOW,
        action = "open:home", hoverColor = C.hover,
        crossAlign = "center", padding = { left = "2vh", right = "2vh" }, spacing = "1.5vh",
        children = {
          ui.image { icon = "sf:photo.fill", size = "12vh", corner = "1vh", background = C.avatarBg, style = { tint = C.mid } },
          ui.column {
            weight = 1, justify = "center", spacing = "0.5vh",
            children = {
              ui.text { text = "官网头条：最新动态标题", style = { font = "2.8vh", weight = "bold", color = C.dark } },
              ui.text { text = "这里显示资讯的一句话简介与标题说明，超出部分自动省略。", style = { font = "2.1vh", color = C.mid } },
              ui.text { text = "第二行灰色描述，补充资讯详情。", style = { font = "2.1vh", color = C.mid } },
              ui.row {
                crossAlign = "center",
                children = {
                  ui.spacer { weight = 1 },
                  ui.text { text = "2026-06-01", style = { font = "2vh", color = C.mid } },
                },
              },
            },
          },
        },
      },
      -- 导航双卡行 1：整合包（紫）/ 光影（橙）
      ui.row {
        id = "homeNavRow1", width = "94%", height = "9vh", spacing = "2vh",
        children = {
          ui.row { id = "navPack", weight = 1, corner = "1.2vh", background = C.card, border = BORDER, shadow = SHADOW,
            action = "open:modpackImport", hoverColor = C.hover,
            crossAlign = "center", padding = { left = "2vh", right = "2vh" }, spacing = "1.2vh",
            children = {
              ui.image { icon = "sf:square.2.layers.3d.fill", size = "4.5vh", style = { tint = C.purple } },
              ui.text { text = "整合包", weight = 1, style = { font = "2.8vh", weight = "bold", color = C.dark } },
              ui.text { text = "›", style = { font = "3vh", color = C.mid } },
            } },
          ui.row { id = "navShader", weight = 1, corner = "1.2vh", background = C.card, border = BORDER, shadow = SHADOW,
            action = "open:shaders", hoverColor = C.hover,
            crossAlign = "center", padding = { left = "2vh", right = "2vh" }, spacing = "1.2vh",
            children = {
              ui.image { icon = "sf:sun.max.fill", size = "4.5vh", style = { tint = C.orange } },
              ui.text { text = "光影", weight = 1, style = { font = "2.8vh", weight = "bold", color = C.dark } },
              ui.text { text = "›", style = { font = "3vh", color = C.mid } },
            } },
        },
      },
      -- 导航双卡行 2：资源中心（青）/ 壁纸（粉）
      ui.row {
        id = "homeNavRow2", width = "94%", height = "9vh", spacing = "2vh",
        children = {
          ui.row { id = "navMods", weight = 1, corner = "1.2vh", background = C.card, border = BORDER, shadow = SHADOW,
            action = "open:mods", hoverColor = C.hover,
            crossAlign = "center", padding = { left = "2vh", right = "2vh" }, spacing = "1.2vh",
            children = {
              ui.image { icon = "sf:cube.fill", size = "4.5vh", style = { tint = C.cyan } },
              ui.text { text = "资源中心", weight = 1, style = { font = "2.8vh", weight = "bold", color = C.dark } },
              ui.text { text = "›", style = { font = "3vh", color = C.mid } },
            } },
          ui.row { id = "navWall", weight = 1, corner = "1.2vh", background = C.card, border = BORDER, shadow = SHADOW,
            action = "open:settings", hoverColor = C.hover,
            crossAlign = "center", padding = { left = "2vh", right = "2vh" }, spacing = "1.2vh",
            children = {
              ui.image { icon = "sf:photo.on.rectangle.fill", size = "4.5vh", style = { tint = C.pink } },
              ui.text { text = "壁纸设置", weight = 1, style = { font = "2.8vh", weight = "bold", color = C.dark } },
              ui.text { text = "›", style = { font = "3vh", color = C.mid } },
            } },
        },
      },
    },
  }
end

-- 下载页：两行分段标签（文字式白底选中态）+ 搜索条 + 条目列（清单来自 CONFIG.download）
local function buildDownloadPage()
  -- 第一行分段标签（6 项等分），选中白底全圆药丸 + 深色文字
  local seg1 = {}
  for i, name in ipairs(CONFIG.download.segments) do
    seg1[#seg1 + 1] = ui.button {
      id = "dl1." .. i, label = name, weight = 1, height = "5vh", corner = "pill",
      style = { background = C.transparent, tint = C.mid, font = "2.4vh" },
    }
  end
  -- 第二行分段标签（4 项等分），选中白底圆角横条 + 深色文字
  local seg2 = {}
  for i, name in ipairs(CONFIG.download.subSegments) do
    seg2[#seg2 + 1] = ui.button {
      id = "dl2." .. i, label = name, weight = 1, height = "5.5vh", corner = "1vh",
      style = { background = C.transparent, tint = C.mid, font = "2.4vh" },
    }
  end
  -- 条目列：一条一卡，全部整行可点击
  local items = { inputBar("dlSearch", "sf:magnifyingglass", "搜索内容…", "sf:slider.horizontal.3", "open:download") }
  for i, it in ipairs(CONFIG.download.items) do
    pushAll(items, { listEntry("dlItem" .. i, it.icon, it.color, it.title, it.date, it.cat, C.mid, it.action) })
  end
  return ui.column {
    id = "pageDownload", weight = 1, crossAlign = "center",
    padding = { top = "1.5vh", bottom = "1.5vh" }, spacing = "2vh",
    children = {
      ui.row { id = "dlSeg1", width = "94%", spacing = "1vh", children = seg1 },
      ui.row { id = "dlSeg2", width = "94%", spacing = "1vh", children = seg2 },
      unpack(items),
    },
  }
end

-- 联机页：文字式分段「加入房间 / 创建房间」（选中深色 + 蓝下划线）
local function multiTextTab(id, label, action)
  -- 整列可点：文字 + 底部选中下划线
  return ui.column {
    id = id, weight = 1, action = action, crossAlign = "stretch", spacing = "0.6vh",
    justify = "center",
    children = {
      ui.text { id = id .. "Label", text = label, style = { font = "2.8vh", weight = "bold", color = C.dark }, justify = "center" },
      ui.row { id = id .. "Bar", height = "0.5vh", background = C.accent },
    },
  }
end

local function buildMultiPage()
  -- 加入房间：房间列表来自 CONFIG.online.rooms
  local rooms = {}
  for i, r in ipairs(CONFIG.online.rooms) do
    pushAll(rooms, { listEntry("roomItem" .. i, r.icon, C.accent, r.title, r.sub, r.status, C.dark, r.action) })
  end
  local joinBranch = ui.column {
    id = "joinBranch", width = "94%", crossAlign = "stretch", spacing = "1.5vh",
    children = {
      inputBar("roomInput", "sf:person.2.fill", "输入房间连接码…", "sf:doc.on.clipboard", "open:multiplayer"),
      -- 提示行：蓝色圆圈 i 图标 + 一行灰色说明
      ui.row {
        id = "roomHint", height = "5vh", crossAlign = "center", spacing = "1.2vh",
        padding = { left = "2vh", right = "2vh" },
        children = {
          ui.image { icon = "sf:info.circle.fill", size = "2.6vh", style = { tint = C.accent } },
          ui.text { text = "输入对方分享的房间连接码即可加入", style = { font = "2.4vh", color = C.mid } },
        },
      },
      unpack(rooms),
    },
  }
  -- 创建房间：白底表单卡 + 底部实心蓝主按钮
  local createBranch = ui.column {
    id = "createBranch", width = "94%", crossAlign = "stretch", spacing = "1.5vh",
    children = {
      ui.column {
        id = "createForm", corner = "1.2vh", background = C.card, border = BORDER, shadow = SHADOW,
        padding = "3vh", spacing = "2vh", crossAlign = "stretch",
        children = {
          -- 房间名
          ui.column { crossAlign = "stretch", spacing = "0.8vh", children = {
            ui.text { text = "房间名称", style = { font = "2.2vh", color = C.mid } },
            ui.row { height = "6vh", corner = "pill", background = C.white, border = BORDER, crossAlign = "center",
              padding = { left = "2vh", right = "2vh" },
              children = { ui.text { text = "为房间起个名字", style = { font = "2.4vh", color = C.mid } } } },
          } },
          -- 人数上限（步进器）
          ui.column { crossAlign = "stretch", spacing = "0.8vh", children = {
            ui.text { text = "人数上限", style = { font = "2.2vh", color = C.mid } },
            ui.row { height = "6vh", corner = "pill", background = C.white, border = BORDER, crossAlign = "center",
              padding = { left = "2vh", right = "2vh" }, spacing = "2vh",
              children = {
                ui.image { icon = "sf:minus.circle.fill", size = "3vh", style = { tint = C.accent } },
                ui.text { text = "8", weight = 1, justify = "center", style = { font = "2.6vh", weight = "bold", color = C.dark } },
                ui.image { icon = "sf:plus.circle.fill", size = "3vh", style = { tint = C.accent } },
              } },
          } },
          -- 游戏版本下拉条
          ui.column { crossAlign = "stretch", spacing = "0.8vh", children = {
            ui.text { text = "游戏版本", style = { font = "2.2vh", color = C.mid } },
            ui.row { id = "createVersion", height = "6vh", corner = "pill", background = C.white, border = BORDER,
              crossAlign = "center", padding = { left = "2vh", right = "2vh" }, spacing = "1.2vh",
              children = {
                ui.text { id = "createVersionLabel", text = "选择版本…", weight = 1, style = { font = "2.4vh", color = C.dark } },
                ui.image { icon = "sf:chevron.down", size = "2vh", style = { tint = C.accent } },
              } },
          } },
        },
      },
      -- 本页唯一实心主按钮：蓝底白字
      ui.button { id = "createRoomBtn", label = "创建房间", height = "7vh", corner = "1.5vh",
        style = { background = C.accent, tint = C.white, font = "2.8vh", weight = "bold" } },
    },
  }
  return ui.column {
    id = "pageMulti", weight = 1, crossAlign = "center",
    padding = { top = "1.5vh", bottom = "1.5vh" }, spacing = "2vh",
    children = {
      ui.row { id = "multiTabs", width = "94%", height = "6vh", spacing = "2vh", crossAlign = "center",
        children = {
          multiTextTab("multiJoin", "加入房间", "multiJoin"),
          multiTextTab("multiCreate", "创建房间", "multiCreate"),
        } },
      joinBranch,
      createBranch,
    },
  }
end

-- 设置页：版本信息卡 + 设置条目（带可选的灰色说明小字）
local function settingsEntry(id, icon, label, desc, action)
  local nodes = {
    ui.row { id = id, height = "7vh", corner = "1.2vh", background = C.card, border = BORDER, shadow = SHADOW,
      action = action or "open:settings", hoverColor = C.hover,
      crossAlign = "center", padding = { left = "3vh", right = "2.5vh" }, spacing = "1.5vh",
      children = {
        ui.image { icon = icon, size = "3vh", style = { tint = C.accent } },
        ui.text { text = label, weight = 1, style = { font = "2.8vh", color = C.dark } },
        chevron(),
      } },
  }
  if desc and desc ~= "" then
    nodes[#nodes + 1] = ui.text { text = desc, width = "95%", style = { font = "2.1vh", color = C.mid } }
  end
  return nodes
end

-- 设置页：条目清单由启动器经 launcher.state.settings 提供（启动器新增设置无需改包）。
-- build() 期间 launcher.state 已在 buildTree 前注入，故此处可安全读取。
local function buildSettingsPage()
  local list = launcher.state and launcher.state.settings
  if type(list) ~= "table" then list = {} end
  local children = {
    -- 版本信息卡
    ui.row {
      id = "setAbout", width = "94%", height = "12vh", corner = "1.2vh", background = C.card,
      border = BORDER, shadow = SHADOW, action = "open:settings", hoverColor = C.hover,
      crossAlign = "center", padding = { left = "2.5vh", right = "2.5vh" }, spacing = "2vh",
      children = {
        -- 渐变蓝底 + 白色盒子图标
        ui.image { icon = "sf:shippingbox.fill", size = "7vh", corner = "1.5vh",
          background = { from = C.accent, to = "#5AA0FF", angle = 30 }, style = { tint = C.white } },
        ui.column {
          weight = 1, justify = "center", spacing = "0.4vh",
          children = {
            ui.text { text = "Pear 启动器", style = { font = "3vh", weight = "bold", color = C.dark } },
            ui.text { text = "版本 …", style = { font = "2.2vh", color = C.mid } },
            ui.text { text = "系统信息 …  · 设备架构 …", style = { font = "2.2vh", color = C.mid } },
          },
        },
      },
    },
  }
  -- 由启动器数据驱动；每一条都调用同一 settingsEntry 组件（引擎零页面特例）。
  if #list > 0 then
    for i, s in ipairs(list) do
      pushAll(children, settingsEntry(
        "set" .. i,
        s.icon or "sf:gearshape.fill",
        s.label ~= nil and s.label or "",
        s.desc or "",
        s.action
      ))
    end
  else
    -- 引擎未提供列表时的结构占位（仅描述结构，不写死条目）
    pushAll(children, settingsEntry("setEmpty", "sf:gearshape.fill", "设置", "启动器暂未提供设置条目。", "open:settings"))
  end
  return ui.column {
    id = "pageSettings", weight = 1, crossAlign = "center",
    padding = { top = "1.5vh", bottom = "1.5vh" }, spacing = "3vh",
    children = children,
  }
end

-- 更多页：居中深色标题 + 纵向分组（组名 + 整卡多行）
local function group(name, rows)
  local nodes = {
    ui.text { text = name, width = "94%", style = { font = "2.4vh", color = C.mid } },
    ui.column { width = "94%", corner = "1.2vh", background = C.card, border = BORDER, shadow = SHADOW,
      crossAlign = "stretch", children = rows },
  }
  return nodes
end

local function buildMorePage()
  local children = {
    ui.text { id = "moreTitle", text = "更多", style = { font = "4vh", weight = "bold", color = C.dark } },
  }
  -- 分组清单来自 CONFIG.moreGroups；右端 right 决定即时 rightSpec（chevron / versionLabel）
  for _, g in ipairs(CONFIG.moreGroups) do
    local rows = {}
    for _, r in ipairs(g.rows) do
      local rightSpec = (r.right == "version") and versionLabel() or chevron()
      pushAll(rows, { rowItem(r.id, r.icon, C.accent, r.label, rightSpec, r.action) })
    end
    pushAll(children, group(g.name, rows))
  end
  return ui.column {
    id = "pageMore", weight = 1, crossAlign = "center",
    padding = { top = "1.5vh", bottom = "1.5vh" }, spacing = "3vh",
    children = children,
  }
end

-- ===== 二级页：版本设置（由 open:version_settings 进入）=====
-- 顶部蓝栏（同顶栏色，自带返回 + 「— ✕」）+ 左导航 18% 白底（概览/设置/Mod管理/导出）
-- + 右区渐变底纵向白卡片。
local SUB_NAV = {
  { id = "vs_nav_overview",  label = "概览" },
  { id = "vs_nav_settings",  label = "设置" },
  { id = "vs_nav_mods",      label = "Mod 管理" },
  { id = "vs_nav_export",    label = "导出" },
}

-- 个性化卡 / 快捷方式卡 / 高级管理卡共用的普通白按钮
local function plainButton(id, label)
  return ui.button {
    id = id, label = label, height = "5.5vh", corner = "1vh",
    border = BORDER, style = { background = C.white, tint = C.dark, font = "2.4vh", weight = "bold" },
  }
end

-- 下拉行：灰色标签 + 白底输入条（占行宽约 70%）
local function pickerRow(id, label, valueText)
  return ui.row {
    id = id, crossAlign = "center", spacing = "2vh",
    children = {
      ui.text { text = label, style = { font = "2.4vh", color = C.mid } },
      ui.spacer { weight = 1 },
      ui.row {
        id = id .. "Picker", width = "70%", height = "5.5vh", corner = "1vh",
        background = C.white, border = BORDER, crossAlign = "center",
        padding = { left = "2vh", right = "2vh" }, spacing = "1vh",
        children = {
          ui.text { text = valueText, weight = 1, style = { font = "2.4vh", color = C.dark } },
          ui.image { icon = "sf:chevron.down", size = "2vh", style = { tint = C.accent } },
        },
      },
    },
  }
end

local function buildVersionSettingsPage()
  -- 左导航四项（选中 = 蓝色加粗 + 左缘蓝色竖条）
  local navItems = {}
  for _, n in ipairs(SUB_NAV) do
    navItems[#navItems + 1] = ui.row {
      id = n.id, height = "7vh", action = n.id, crossAlign = "center",
      padding = { left = "1.5vh", right = "1vh" }, spacing = "1.2vh",
      children = {
        ui.row { id = n.id .. "Bar", width = "0.6vh", height = "70%", background = C.accent },
        ui.text { id = n.id .. "Label", text = n.label, weight = 1, style = { font = "2.6vh", color = C.mid, weight = "bold" } },
      },
    }
  end
  return ui.column {
    id = "pageVersionSettings", weight = 1, crossAlign = "stretch", spacing = 0,
    children = {
      -- 顶部蓝栏（自带返回 + 页面标题 + 「— ✕」）
      ui.row {
        id = "vsTitlebar", height = "8.5vh", background = C.topbar, crossAlign = "center",
        padding = { left = "2vh", right = "1.5vh" }, spacing = "1.5vh",
        children = {
          ui.row { id = "vsBack", action = "open:home", crossAlign = "center", spacing = "0.8vh",
            children = {
              ui.image { icon = "sf:chevron.left", size = "2.6vh", style = { tint = C.white } },
              ui.text { text = "版本设置", style = { font = "3.2vh", weight = "bold", color = C.white } },
            } },
          ui.spacer { weight = 1 },
          ui.image { id = "vsMin", icon = "sf:minus", size = "2.5vh", style = { tint = C.white } },
          ui.image { id = "vsClose", icon = "sf:xmark", size = "2.5vh", style = { tint = C.white } },
        },
      },
      -- 主体：左导航 18% + 右区卡片
      ui.row {
        id = "vsBody", weight = 1, crossAlign = "stretch", spacing = 0,
        children = {
          ui.column {
            id = "vsNav", width = "18%", background = C.white, crossAlign = "stretch",
            padding = { top = "2vh", bottom = "2vh" }, children = navItems,
          },
          ui.column {
            id = "vsRight", weight = 1,
            background = { from = C.pageFrom, to = C.pageTo, angle = 45 },
            padding = "3vh", spacing = "3vh", crossAlign = "stretch",
            children = {
              -- 1. 信息卡
              ui.row {
                id = "vsInfo", height = "12vh", corner = "1.2vh", background = C.card,
                border = BORDER, shadow = SHADOW, crossAlign = "center",
                padding = { left = "3vh", right = "3vh" }, spacing = "2vh",
                children = {
                  ui.image { icon = "sf:doc.text.fill", size = "6vh", style = { tint = C.accent } },
                  ui.column {
                    weight = 1, justify = "center", spacing = "0.4vh",
                    children = {
                      ui.text { text = "PCL 浅色 · 游戏版本", style = { font = "2.8vh", weight = "bold", color = C.dark } },
                      ui.text { text = "当前所选版本与启动配置信息", style = { font = "2.2vh", color = C.mid } },
                    },
                  },
                },
              },
              -- 2. 个性化卡
              ui.column {
                id = "vsPersonalize", corner = "1.2vh", background = C.card,
                border = BORDER, shadow = SHADOW, padding = "3vh", spacing = "2vh", crossAlign = "stretch",
                children = {
                  pickerRow("vsVer", "游戏版本", "选择版本…"),
                  pickerRow("vsJava", "Java 版本", "选择 Java…"),
                  ui.row { spacing = "2vh", children = {
                    plainButton("vsMode1", "软渲染"),
                    plainButton("vsMode2", "硬件加速"),
                    plainButton("vsMode3", "高清修复"),
                  } },
                },
              },
              -- 3. 快捷方式卡
              ui.row {
                id = "vsShortcut", corner = "1.2vh", background = C.card,
                border = BORDER, shadow = SHADOW, padding = "3vh", spacing = "2vh",
                children = {
                  plainButton("vsShort1", "创建桌面快捷方式"),
                  plainButton("vsShort2", "创建菜单快捷方式"),
                  plainButton("vsShort3", "管理启动参数"),
                },
              },
              -- 4. 高级管理卡（两白按钮 + 一红字红边危险按钮）
              ui.row {
                id = "vsAdvanced", corner = "1.2vh", background = C.card,
                border = BORDER, shadow = SHADOW, padding = "3vh", spacing = "2vh",
                children = {
                  plainButton("vsAdv1", "清理冗余文件"),
                  plainButton("vsAdv2", "重置配置"),
                  -- 危险操作：红字红边 #E5484D
                  ui.button {
                    id = "vsDanger", label = "删除版本", height = "5.5vh", corner = "1vh",
                    border = { width = 1.5, color = C.danger },
                    style = { background = C.white, tint = C.danger, font = "2.4vh", weight = "bold" },
                  },
                },
              },
            },
          },
        },
      },
    },
  }
end

-- ===== build：整树（顶栏蓝 + 启动页白左栏，其余页无侧栏）=====

function build(ui)
  return ui.column {
    id = "shell",
    crossAlign = "stretch",
    spacing = 0,
    children = {
      -- 顶栏：纯色蓝 #0A5FC4，高 8.5vh
      ui.row {
        id = "titlebar",
        height = "8.5vh",
        background = C.topbar,
        crossAlign = "center",
        padding = { left = "2vh", right = "1.5vh" },
        children = {
          ui.text { id = "logo", text = "Pear", style = { font = "3.2vh", weight = "bold", color = C.white } },
          ui.spacer { weight = 1 },
          ui.row {
            id = "tabs",
            spacing = "6vh",
            crossAlign = "center",
            children = (function()
              local nodes = {}
              -- 滑动高亮游标：白色全圆药丸，绝对定位铺在选中页签之下，随选中平滑滑动
              nodes[#nodes + 1] = ui.row {
                id = "tabCursor", absolute = true, background = C.white, corner = "pill",
              }
              for _, t in ipairs(TABS) do nodes[#nodes + 1] = topTab(t) end
              return nodes
            end)(),
          },
          ui.spacer { weight = 1 },
          ui.image { id = "winMin", icon = "sf:minus", size = "2.5vh", style = { tint = C.white } },
          ui.image { id = "winClose", icon = "sf:xmark", size = "2.5vh", style = { tint = C.white } },
        },
      },
      -- 内容行：启动页才有的白左栏 + 内容区（非启动页左栏坍缩，内容整幅铺开）
      ui.row {
        id = "page",
        weight = 1,
        crossAlign = "stretch",
        spacing = 0,
        children = {
          -- 启动页白左栏（仅启动页显示）
          ui.column {
            id = "left",
            width = "32%",
            background = C.white,
            crossAlign = "center",
            padding = { left = "2vh", right = "2vh", top = "3.5vh", bottom = "3vh" },
            spacing = "0.6vh",
            children = {
              -- 两枚并排胶囊：实心蓝「正版登录」 + 白底蓝描边「离线登录」
              ui.row {
                id = "capsules",
                spacing = "2vh",
                crossAlign = "center",
                children = {
                  ui.button {
                    id = "cap.genuine", label = "正版登录", action = "open:accountManager",
                    height = "3.7vh", corner = "pill", padding = { left = "1.5vh", right = "1.5vh" },
                    style = { background = C.accent, tint = C.white, font = "2.4vh", weight = "bold" },
                  },
                  ui.button {
                    id = "cap.offline", label = "离线登录", action = "open:accountManager",
                    height = "3.7vh", corner = "pill", padding = { left = "1.5vh", right = "1.5vh" },
                    border = { width = 1.5, color = C.accentBorder },
                    style = { background = C.white, tint = C.accent, font = "2.4vh", weight = "bold" },
                  },
                },
              },
              ui.spacer { weight = 2 },
              -- 头像占位：浅灰底 + 灰人物轮廓
              ui.image { id = "avatar", icon = "sf:person.fill", size = "11vh", corner = "1.5vh",
                background = C.avatarBg, style = { tint = C.avatarLine } },
              ui.spacer { weight = 1 },
              -- 账号行：下拉框 + 登录按钮（总宽 85%）
              ui.row {
                id = "accountRow",
                width = "85%",
                height = "4.5vh",
                spacing = "1vh",
                crossAlign = "center",
                children = {
                  ui.row {
                    id = "accountPicker", action = "open:accountManager", weight = 1, height = "4.5vh",
                    background = C.white, border = BORDER, corner = "0.8vh", crossAlign = "center",
                    padding = { left = "1.2vh", right = "1.2vh" }, spacing = "1vh",
                    children = {
                      ui.text { id = "accountPickerLabel", text = "未登录", weight = 1, style = { font = "2.3vh", color = C.dark } },
                      ui.image { icon = "sf:chevron.down", size = "1.8vh", style = { tint = C.mid } },
                    },
                  },
                  ui.button {
                    id = "login", label = "登录", action = "open:accountManager",
                    width = "28%", height = "4.5vh", corner = "0.8vh",
                    border = { width = 1.5, color = C.accentBorder },
                    style = { background = C.white, tint = C.accent, font = "2.4vh", weight = "bold" },
                  },
                },
              },
              -- 次要链接：灰色小字（» 前缀）
              ui.row {
                id = "links",
                spacing = "4vh",
                children = {
                  ui.text { text = "» 购买正版", action = "open:download", style = { font = "2vh", color = C.mid } },
                  ui.text { text = "» 更换皮肤", action = "open:settings", style = { font = "2vh", color = C.mid } },
                },
              },
              ui.spacer { weight = 3 },
              -- 启动游戏大按钮：白底蓝描边（全左栏最大圆角），两行文字
              ui.column {
                id = "launchBtn",
                action = "launch",
                width = "85%",
                height = "10vh",
                corner = "1.5vh",
                background = C.white,
                border = { width = 1.5, color = C.accentBorder },
                justify = "center",
                crossAlign = "center",
                spacing = "0.5vh",
                children = {
                  ui.text { id = "launchTitle", text = "启动游戏", style = { font = "3vh", weight = "bold", color = C.dark } },
                  ui.text { id = "launchSub", text = "尚未选择版本", style = { font = "2.2vh", color = C.mid } },
                },
              },
              -- 版本选择 / 版本设置（贴底，各占一半）
              ui.row {
                id = "versionRow",
                width = "85%",
                height = "5.5vh",
                spacing = "1vh",
                children = {
                  ui.button {
                    id = "pickVersion", label = "选择版本", action = "open:versionManager",
                    weight = 1, height = "5.5vh", corner = "1vh",
                    border = BORDER,
                    style = { background = C.white, tint = C.dark, font = "2.4vh", weight = "bold" },
                  },
                  ui.button {
                    id = "versionSetup", label = "版本设置", action = "open:version_settings",
                    weight = 1, height = "5.5vh", corner = "1vh",
                    border = BORDER,
                    style = { background = C.white, tint = C.dark, font = "2.4vh", weight = "bold" },
                  },
                },
              },
            },
          },
          -- 内容区：浅蓝灰对角渐变底，承载 Lua 页子树（含二级页）
          ui.content {
            id = "content",
            weight = 1,
            initialPage = "home",
            background = { from = C.pageFrom, to = C.pageTo, angle = 45 },
            -- 页 token → Lua 页子树 id（引擎据此解析 navigate/open，零硬编码页面名）
            pages = CONFIG.pages,
            children = {
              buildHomePage(),
              buildDownloadPage(),
              buildMultiPage(),
              buildSettingsPage(),
              buildMorePage(),
              buildVersionSettingsPage(),
            },
          },
        },
      },
    },
  }
end

-- ===== 交互 =====

local selectedTab = nil

-- 让白色游标药丸平滑滑动到选中页签之下。
-- 游标与页签同为 topbar 内 tabs 行的直接子节点，getFrame 返回同一坐标系。
-- 药丸高取页签高的 5/6（≈0.05H），垂直居中；frame 未就绪时静默跳过。
local function moveCursorTo(tabId)
  local f = launcher.view(tabId):getFrame()
  if not f or not f.w or f.w == 0 or not f.h or f.h == 0 then return end
  local pillH = f.h * (5 / 6)
  launcher.view("tabCursor"):setFrame(
    { x = f.x, y = f.y + (f.h - pillH) / 2, w = f.w, h = pillH }, true)
end

local function selectTab(tabId)
  selectedTab = tabId
  for _, t in ipairs(TABS) do
    local sel = (t.id == tabId)
    launcher.view(t.id):setStyle(sel
      and { background = C.white, tint = C.accent }
      or  { background = C.transparent, tint = C.white })
  end
  moveCursorTo(tabId)
end

-- 下载页分段标签选中态
local function selectDlRow(prefix, count, selId)
  for i = 1, count do
    local id = prefix .. "." .. i
    local sel = (id == selId)
    launcher.view(id):setStyle(sel
      and { background = C.white, tint = C.dark }
      or  { background = C.transparent, tint = C.mid })
  end
end

local selectedDl1 = "1"
local selectedDl2 = "1"
local function resetDownloadSegments()
  selectDlRow("dl1", #DL1, selectedDl1)
  selectDlRow("dl2", #DL2, selectedDl2)
end

-- 联机页分支切换（文字式标签：选中深色文字 + 蓝下划线）
local function showMultiBranch(join)
  launcher.view("joinBranch"):setVisible(join)
  launcher.view("createBranch"):setVisible(not join)
  launcher.view("multiJoinLabel"):setStyle(join and { tint = C.dark } or { tint = C.mid })
  launcher.view("multiCreateLabel"):setStyle(join and { tint = C.mid } or { tint = C.dark })
  launcher.view("multiJoinBar"):setVisible(join)
  launcher.view("multiCreateBar"):setVisible(not join)
end

local function refreshAccount(account)
  local name = (account and account.name and account.name ~= "") and account.name or "未登录"
  launcher.view("accountPickerLabel"):setText(name)
end

local function refreshVersion(version)
  local name = (version and version.name and version.name ~= "") and version.name or nil
  launcher.view("launchSub"):setText(name or "尚未选择版本")
  launcher.view("homeLatestVer"):setText(name or "…")
  launcher.view("homeSnapshotVer"):setText(name or "…")
end

function onReady()
  local state = launcher.state or {}
  selectTab("tab.home")
  refreshAccount(state.account)
  refreshVersion(state.version)
  resetDownloadSegments()
  showMultiBranch(true)
end

function onAccountChange(account)
  refreshAccount(account)
end

-- 二级页左导航选中态（蓝色加粗 + 左缘蓝色竖条）
local selectedSubNav = nil
local function selectedSubNavId()
  return selectedSubNav or SUB_NAV[1].id
end

function onPageChange(page)
  local isSub = (page == "version_settings")
  -- 二级页隐藏主顶栏（自带返回蓝栏）；其余页恢复主顶栏
  launcher.view("titlebar"):setVisible(not isSub)
  if isSub then
    if not selectedSubNav then selectSubNav(selectedSubNavId()) end
  else
    local tabId = PAGE_TAB[page]
    if tabId then selectTab(tabId) end
  end
  -- 仅启动页显示白左栏；其余页左栏坍缩、内容整幅铺开
  launcher.view("left"):setVisible(page == "home")
end

function selectSubNav(id)
  selectedSubNav = id
  for _, n in ipairs(SUB_NAV) do
    local sel = (n.id == id)
    launcher.view(n.id .. "Bar"):setVisible(sel)
    launcher.view(n.id .. "Label"):setStyle(sel and { tint = C.accent } or { tint = C.mid })
  end
end

-- 首个布局完成后被引擎调用：游标等依赖真实 frame 的定位此时才有坐标可读。
-- 幂等：只是把游标再对准当前选中页签。
function onLayout()
  if selectedTab then selectTab(selectedTab) end
end

function onClick(id)
  -- 顶栏页签：即时高亮（onPageChange 随后做最终同步）
  for _, t in ipairs(TABS) do
    if t.id == id then selectTab(t.id); return end
  end
  -- 下载页分段标签
  if id and id:sub(1, 4) == "dl1." then
    selectedDl1 = id:sub(5)
    resetDownloadSegments()
    return
  end
  if id and id:sub(1, 4) == "dl2." then
    selectedDl2 = id:sub(5)
    resetDownloadSegments()
    return
  end
  -- 联机页分支
  if id == "multiJoin" then showMultiBranch(true) end
  if id == "multiCreate" then showMultiBranch(false) end
  if id == "createRoomBtn" then showMultiBranch(false) end
  -- 二级页左导航
  for _, n in ipairs(SUB_NAV) do
    if n.id == id then selectSubNav(n.id); return end
  end
end