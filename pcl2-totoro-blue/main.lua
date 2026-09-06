-- Pear 启动器 仿 PCL II 浅色主题 —— v1.7.0
--
-- 复刻规格（结构版 · 比例适配）：
--   设窗口高 1H、宽 ≈ 2H；所有尺寸用 vh（H 的百分比），横向用 %，禁止写死像素。
--   顶栏 0.085H 通栏蓝 #0A5FC4；内容区浅蓝对角渐变 #E3EEF9→#D5E5F5。
--   卡片 = 白底 #FFFFFF + 描边 #D9E4F0 + 极浅投影；卡片圆角 ≈ 0.012H，按钮圆角 ≈ 0.007H。
--   顶栏页签选中套白色全圆药丸；hover 浅蓝 #EAF3FC；页面淡入淡出。
--   仅启动页有 32% 白侧栏；下载/联机各有页内左导航；版本设置是二级页。
--
-- 结构约定（PLUIShellViewController.showLuaPage 依赖）：
--   内容区容器 id="content"，内挂纯 Lua 页子树：
--     pageHome / pageDownload / pageMulti / pageSettings / pageMore / pageVersionSettings

local C = {
  topbar      = "$color:topbar",      -- 顶栏蓝 #0A5FC4
  pageFrom    = "$color:pageFrom",    -- 渐变左上 #E3EEF9
  pageTo      = "$color:pageTo",      -- 渐变右下 #D5E5F5
  card        = "$color:card",        -- 卡片 #FFFFFF
  cardBorder  = "$color:cardBorder",  -- 描边 #D9E4F0
  dark        = "$color:cardText",    -- 主文字 #333333
  mid         = "$color:subText",     -- 次要文字 #999999
  white       = "$color:white",
  accent      = "$color:accent",      -- 强调蓝 #0B84FF
  accentBorder = "$color:accentBorder",
  transparent = "$color:transparent",
  hover       = "$color:hover",       -- hover 浅蓝 #EAF3FC
  avatarBg    = "$color:avatarBg",    -- 头像灰底 #ECECEC
  success     = "$color:success",     -- 绿 #3FB950
  danger      = "$color:danger",      -- 红 #E5484D
  orange      = "$color:orangePill",  -- 橙 #F0883E
  green       = "$color:brandGreen",
  purple      = "$color:brandPurple",
  cyan        = "$color:brandCyan",
  pink        = "$color:brandPink",
  warnBg      = "#FDECEC",            -- 浅红底（警告框）
  faintBlue   = "#EAF3FC",            -- 提示条浅蓝底
  avatarLine  = "#C0C0C0",
}

-- 描边：卡片用浅蓝灰细描边；强调控件（胶囊/主按钮）用蓝描边；危险用红描边。
local BORDER   = { width = 1, color = C.cardBorder }
local BORDER_A = { width = 1.5, color = C.accentBorder }
local BORDER_D = { width = 1.5, color = C.danger }
-- 极浅投影（白卡片立体感）
local SHADOW = { blur = 4, opacity = 0.07, x = 0, y = 1 }

-- ===== 顶栏五个页签 =====
local TABS = {
  { id = "tab.home",     label = "启动", icon = "sf:house.fill",                                        action = "open:home",       page = "home" },
  { id = "tab.download", label = "下载", icon = "sf:arrow.down.circle.fill",                            action = "open:download",   page = "download" },
  { id = "tab.multi",    label = "联机", icon = "sf:antenna.radiowaves.left.and.right",                 action = "open:multiplayer", page = "multi" },
  { id = "tab.setup",    label = "设置", icon = "sf:gearshape.fill",                                    action = "open:settings",   page = "settings" },
  { id = "tab.other",    label = "更多", icon = "sf:ellipsis.circle.fill",                              action = "open:more",       page = "more" },
}

local PAGE_TAB = {
  home = "tab.home", download = "tab.download", multi = "tab.multi",
  settings = "tab.setup", more = "tab.other",
}

-- ===== 配置表：页面条目的单一数据源 =====
local CONFIG = {
  pages = {
    home = "pageHome", download = "pageDownload", multi = "pageMulti",
    settings = "pageSettings", more = "pageMore",
    version_settings = "pageVersionSettings",
  },
  tabs = TABS,
  home = {
    secondaryLinks = { { label = "购买正版", action = "open:download" }, { label = "更换皮肤", action = "open:settings" } },
  },
  download = {
    nav = {
      { icon = "sf:clock.arrow.circlepath", label = "最新版本" },
      { icon = "sf:cube.fill",               label = "正式版" },
      { icon = "sf:bolt.fill",               label = "快照" },
      { icon = "sf:hud",                     label = "Mods" },
      { icon = "sf:sparkles",                label = "光影" },
      { icon = "sf:shippingbox.fill",        label = "整合包" },
    },
    latest = {
      { icon = "sf:cube.fill",          tint = C.green,  title = "最新 Java 版本", sub = "正式版 · 稳定 · 更新于 ···" },
      { icon = "sf:shippingbox.fill",   tint = C.orange, title = "光影整合包",     sub = "光影 · 热门 · 更新于 ···" },
      { icon = "sf:map.fill",           tint = C.cyan,   title = "地图资源",       sub = "地图 · 精选 · 更新于 ···" },
    },
    groups = { "版本列表", "Mod 列表", "光影列表" },
    popular = {
      { icon = "sf:gamecontroller.fill", tint = C.orange, title = "[整合包 1.20] 生存 · 建筑 · 优化 · 光影",
        meta = "新手友好的一体化生存整合包", right = "更新 …   下载 …" },
      { icon = "sf:cube.fill",            tint = C.purple, title = "[Mod v1] 辅助 · 优化 · 冒险",
        meta = "提升帧率与游戏体验的核心模组", right = "更新 …   下载 …" },
    },
    searchLabels = { "搜索源", "搜索对象", "搜索关键词" },
  },
  online = {
    rooms = {
      { name = "联机大厅 · 生存", status = "房主 · 24ms" },
      { name = "光影测试房间",   status = "房主 · 68ms" },
      { name = "速通挑战房间",   status = "房主 · 96ms" },
    },
    bottomLinks = { "协议说明", "常见问题", "更新日志" },
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
  },
  subnav = { "概览", "设置", "Mod 管理", "导出" },
}

-- ===== 通用构件 =====
local function pushAll(dst, src) for _, v in ipairs(src) do dst[#dst + 1] = v end end

local function chevron()
  return ui.text { text = "›", style = { font = "3vh", color = C.mid } }
end

local function topTab(t)
  return ui.button {
    id = t.id, label = t.label, icon = t.icon, action = t.action,
    height = "6vh", corner = "pill",
    padding = { left = "1.5vh", right = "1.5vh" },
    style = { background = C.transparent, tint = C.white, font = "2.4vh", weight = "bold" },
  }
end

local function listEntry(id, icon, tint, title, sub, rightText)
  return ui.row {
    id = id, width = "100%", height = "8vh", corner = "1.2vh", background = C.card,
    border = BORDER, shadow = SHADOW, hoverColor = C.hover, crossAlign = "center",
    padding = { left = "2vh", right = "2vh" }, spacing = "1.6vh",
    children = {
      ui.image { icon = icon, size = "5vh", corner = "0.8vh",
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
    id = id, width = "100%", height = "14vh", corner = "1.2vh", background = C.card,
    border = BORDER, shadow = SHADOW, hoverColor = C.hover, crossAlign = "center",
    padding = { left = "2vh", right = "2vh" }, spacing = "1.8vh",
    children = {
      ui.image { icon = icon, size = "10vh", corner = "0.8vh",
        background = { from = tint, to = C.accent, angle = 30 }, style = { tint = C.white } },
      ui.column { weight = 1, justify = "center", spacing = "0.5vh", children = {
        ui.text { text = title, style = { font = "2.5vh", weight = "bold", color = C.dark } },
        ui.text { text = meta, style = { font = "2.1vh", color = C.mid } },
        rightText and ui.text { text = rightText, style = { font = "2vh", color = C.mid } } or nil,
      } },
    },
  }
end

local function navItem(id, icon, label)
  return ui.row {
    id = id, height = "7vh", width = "100%", crossAlign = "center", spacing = "1.4vh",
    padding = { left = "2vh", right = "1.5vh" }, hoverColor = C.hover, action = id,
    children = {
      ui.row { id = id .. "Bar", width = "0.6vh", height = "3.4vh", corner = "0.6vh", background = C.transparent },
      ui.image { id = id .. "Icon", icon = icon, size = "3.4vh", style = { tint = C.mid } },
      ui.text { id = id .. "Label", text = label, weight = 1, style = { font = "2.6vh", color = C.mid } },
    },
  }
end

local function groupBar(id, label, chevId)
  return ui.row {
    id = id, height = "7vh", width = "100%", crossAlign = "center",
    padding = { left = "1.8vh", right = "1.8vh" }, hoverColor = C.hover, action = id,
    children = {
      ui.text { text = label, weight = 1, style = { font = "2.7vh", weight = "bold", color = C.dark } },
      ui.text { id = chevId, text = "›", style = { font = "3vh", color = C.mid } },
    },
  }
end

local function pickerRow(id, label, valueText)
  return ui.row {
    id = id, height = "4.5vh", width = "100%", crossAlign = "center",
    children = {
      ui.text { text = label, style = { font = "2.4vh", color = C.dark } },
      ui.spacer { weight = 1 },
      ui.row { weight = 3, width = "70%", height = "4.5vh", background = C.white,
        border = { width = 1, color = "#C9D8E8" }, corner = "0.8vh", crossAlign = "center",
        padding = { left = "1.2vh", right = "1.2vh" },
        children = {
          ui.text { text = valueText, weight = 1, style = { font = "2.2vh", color = C.dark } },
          ui.text { text = " ▾", style = { font = "2.2vh", color = C.mid } },
        } },
    },
  }
end

local function plainButton(id, label, accent)
  return ui.button { id = id, text = label, height = "5.5vh", weight = 1, background = C.white,
    corner = "0.7vh", border = (accent and BORDER_A or BORDER),
    style = { font = "2.4vh", tint = C.dark } }
end

-- ============ 启动页左栏 ============
local function buildHomeSidebar()
  local kids = {}
  kids[#kids + 1] = ui.row { id = "capsules", width = "85%", height = "3.7vh", spacing = "2vh",
    children = {
      ui.button { id = "homeCap1", label = "离线", height = "3.7vh", weight = 1, corner = "pill",
        action = "homeCap1",
        style = { background = C.accent, tint = C.white, font = "2.4vh", weight = "bold" } },
      ui.button { id = "homeCap2", label = "正版", height = "3.7vh", weight = 1, corner = "pill",
        action = "homeCap2", border = BORDER_A,
        style = { background = C.white, tint = C.accent, font = "2.4vh", weight = "bold" } },
    } }
  kids[#kids + 1] = ui.spacer { weight = 3 }
  kids[#kids + 1] = ui.image { id = "avatar", icon = "sf:person.crop.circle.fill", size = "11vh",
    corner = "10vh", background = C.avatarBg, style = { tint = C.avatarLine } }
  kids[#kids + 1] = ui.spacer { weight = 2 }
  kids[#kids + 1] = ui.row { id = "accountRow", width = "85%", height = "3.5vh", spacing = "1vh",
    crossAlign = "center",
    children = {
      ui.row { id = "accountPicker", action = "open:accountManager", weight = 1, height = "3.5vh",
        background = C.white, border = BORDER, corner = "0.8vh", crossAlign = "center",
        padding = { left = "1.2vh", right = "1.2vh" },
        children = {
          ui.text { id = "accountPickerLabel", text = "未登录", weight = 1, style = { font = "2.3vh", color = C.dark } },
          ui.image { icon = "sf:chevron.down", size = "1.8vh", style = { tint = C.mid } },
        } },
      ui.button { id = "login", label = "登录", width = "28%", height = "3.5vh", corner = "0.8vh",
        border = BORDER_A, style = { background = C.white, tint = C.accent, font = "2.4vh", weight = "bold" } },
    } }
  kids[#kids + 1] = ui.spacer { weight = 1.5 }
  local lnKids = {}
  for _, ln in ipairs(CONFIG.home.secondaryLinks) do
    lnKids[#lnKids + 1] = ui.text { text = "» " .. ln.label, action = ln.action,
      style = { font = "2vh", color = C.mid } }
  end
  kids[#kids + 1] = ui.row { id = "links", spacing = "4vh", children = lnKids }
  kids[#kids + 1] = ui.spacer { weight = 4 }
  kids[#kids + 1] = ui.column { id = "launchBtn", action = "launch", width = "85%", height = "10vh",
    corner = "1.5vh", background = C.white, border = BORDER_A, justify = "center", crossAlign = "center",
    spacing = "0.5vh",
    children = {
      ui.text { id = "launchTitle", text = "启动游戏", style = { font = "3vh", weight = "bold", color = C.dark } },
      ui.text { id = "launchSub", text = "尚未选择版本", style = { font = "2.2vh", color = C.mid } },
    } }
  kids[#kids + 1] = ui.spacer { weight = 1 }
  kids[#kids + 1] = ui.row { id = "versionRow", width = "85%", height = "5.5vh", spacing = "1vh",
    children = {
      ui.button { id = "pickVersion", label = "选择版本", action = "open:versionManager", weight = 1,
        height = "5.5vh", corner = "1vh", border = BORDER,
        style = { background = C.white, tint = C.dark, font = "2.4vh", weight = "bold" } },
      ui.button { id = "versionSetup", label = "版本设置", action = "open:version_settings", weight = 1,
        height = "5.5vh", corner = "1vh", border = BORDER,
        style = { background = C.white, tint = C.dark, font = "2.4vh", weight = "bold" } },
    } }
  return kids
end

-- ============ 下载页 ============
local function buildDownloadPage()
  local navKids = {}
  for i, n in ipairs(CONFIG.download.nav) do
    navKids[#navKids + 1] = navItem("dlNav" .. i, n.icon, n.label)
  end
  local dlLatest = {}
  for i, it in ipairs(CONFIG.download.latest) do
    dlLatest[#dlLatest + 1] = listEntry("dl1_" .. i, it.icon, it.tint, it.title, it.sub)
  end
  local groupKids = {}
  for i, g in ipairs(CONFIG.download.groups) do
    groupKids[#groupKids + 1] = groupBar("dlGroup" .. i, g, "dlGroup" .. i .. "Chev")
    groupKids[#groupKids + 1] = ui.column { id = "dlGroup" .. i .. "List", width = "100%",
      hidden = true, padding = { left = "2vh", right = "2vh", bottom = "1vh" },
      children = { ui.text { text = "· · ·", style = { font = "2.2vh", color = C.mid } } } }
  end
  local searchRows = {}
  for i, lab in ipairs(CONFIG.download.searchLabels) do
    searchRows[#searchRows + 1] = pickerRow("dlSearchRow" .. i, lab, "…")
  end
  local popular = {}
  for i, it in ipairs(CONFIG.download.popular) do
    popular[#popular + 1] = bigItem("dl4_" .. i, it.icon, it.tint, it.title, it.meta, it.right)
  end
  return ui.row { id = "pageDownload", weight = 1,
    children = {
      ui.column { id = "dlNavCol", width = "18%", weight = 1, background = C.white,
        padding = { top = "1.5vh" }, spacing = "0.5vh", children = navKids },
      ui.column { weight = 1, crossAlign = "center", spacing = "2.5vh", padding = "2.5vh",
        children = {
          ui.column { id = "dlCard1", width = "92%", background = C.card, border = BORDER,
            corner = "1.2vh", shadow = SHADOW, padding = "2vh", spacing = "1vh",
            children = (function()
              local k = { ui.text { text = "最新版本", style = { font = "2.8vh", weight = "bold", color = C.dark } } }
              pushAll(k, dlLatest)
              return k
            end)() },
          ui.column { id = "dlCard2", width = "92%", background = C.card, border = BORDER,
            corner = "1.2vh", shadow = SHADOW, padding = "1vh", spacing = "0", children = groupKids },
          ui.column { id = "dlCard3", width = "92%", background = C.card, border = BORDER,
            corner = "1.2vh", shadow = SHADOW, padding = "2vh", spacing = "1.5vh",
            children = (function()
              local k = { ui.text { text = "搜索", style = { font = "2.8vh", weight = "bold", color = C.dark } } }
              pushAll(k, searchRows)
              k[#k + 1] = ui.row { width = "100%", height = "5.5vh", spacing = "3vh",
                children = {
                  plainButton("dlBtnSearch", "搜索", false),
                  plainButton("dlBtnReset", "重置", false),
                  plainButton("dlBtnInstall", "安装", true),
                } }
              return k
            end)() },
          ui.column { id = "dlCard4", width = "92%", background = C.card, border = BORDER,
            corner = "1.2vh", shadow = SHADOW, padding = "2vh", spacing = "1.5vh",
            children = (function()
              local k = { ui.text { text = "热门", style = { font = "2.8vh", weight = "bold", color = C.dark } } }
              pushAll(k, popular)
              return k
            end)() },
        } },
    } }
end

-- ============ 联机页 ============
local function buildMultiPage()
  local rooms = {}
  for i, r in ipairs(CONFIG.online.rooms) do
    rooms[#rooms + 1] = ui.row { id = "mpRoom" .. i, width = "100%", height = "7vh", crossAlign = "center",
      spacing = "1.5vh", background = C.white, border = BORDER, corner = "1.2vh", hoverColor = C.hover,
      padding = "1.5vh",
      children = {
        ui.image { icon = "sf:square.3.layers.3d", size = "5vh", corner = "1vh", background = C.accent,
          style = { tint = C.white } },
        ui.column { weight = 1, justify = "center", spacing = "0.3vh", children = {
          ui.text { text = r.name, style = { font = "2.4vh", weight = "bold", color = C.dark } },
          ui.text { text = r.status, style = { font = "2vh", color = C.mid } },
        } },
      } }
  end
  local joinRooms = {}
  for i, r in ipairs(CONFIG.online.rooms) do
    joinRooms[#joinRooms + 1] = ui.row { id = "mpR2_" .. i, width = "100%", height = "7vh", crossAlign = "center",
      spacing = "1.5vh", padding = "1vh", hoverColor = C.hover,
      children = {
        ui.image { icon = "sf:person.3.fill", size = "5vh", style = { tint = C.mid } },
        ui.column { weight = 1, justify = "center", spacing = "0.3vh", children = {
          ui.text { text = r.name, style = { font = "2.4vh", weight = "bold", color = C.dark } },
          ui.text { text = r.status, style = { font = "2.1vh", color = C.mid } },
        } },
        ui.text { text = "加入", style = { font = "2.2vh", tint = C.accent } },
      } }
  end
  local downLinks = {}
  for _, ln in ipairs(CONFIG.online.bottomLinks) do
    downLinks[#downLinks + 1] = ui.text { text = ln, action = "open:more", style = { font = "2vh", color = C.mid } }
    downLinks[#downLinks + 1] = ui.text { text = "|", style = { font = "2vh", color = "#C9D8E8" } }
  end
  local mpLeftKids = { ui.text { width = "100%", text = "快速加入", style = { font = "2.1vh", color = C.mid } } }
  pushAll(mpLeftKids, rooms)
  mpLeftKids[#mpLeftKids + 1] = ui.spacer { weight = 1 }
  mpLeftKids[#mpLeftKids + 1] = ui.button { text = "建立连接", height = "5.5vh", width = "85%",
    background = C.white, border = BORDER_A, corner = "0.7vh", style = { font = "2.4vh", tint = C.accent } }
  mpLeftKids[#mpLeftKids + 1] = ui.button { text = "复制连接码", height = "5.5vh", width = "85%",
    background = C.white, border = BORDER, corner = "0.7vh", style = { font = "2.4vh", tint = C.dark } }
  mpLeftKids[#mpLeftKids + 1] = ui.spacer { height = "1vh" }
  mpLeftKids[#mpLeftKids + 1] = ui.row { width = "100%", height = "5vh", background = C.success,
    corner = "1.2vh", crossAlign = "center",
    children = {
      ui.text { text = "未连接", weight = 1, justify = "center", style = { font = "2.4vh", color = C.white } },
    } }
  return ui.row { id = "pageMulti", weight = 1,
    children = {
      ui.column { id = "mpLeft", width = "30%", weight = 1, background = C.white, crossAlign = "center",
        padding = "2vh", spacing = "1.5vh", children = mpLeftKids },
      ui.column { weight = 1, crossAlign = "center", spacing = "2.5vh", padding = "2.5vh",
        children = {
          ui.row { width = "92%", height = "5vh", crossAlign = "center", background = C.faintBlue,
            corner = "1.2vh", spacing = "1.2vh", padding = "1.5vh",
            children = {
              ui.text { text = "ⓘ", style = { font = "2.8vh", tint = C.accent } },
              ui.text { weight = 1, text = "联机需要双方都能访问服务器，房间连接码用于分享。",
                style = { font = "2.2vh", color = C.dark } },
            } },
          ui.column { id = "mpRoomCard", width = "92%", background = C.card, border = BORDER,
            corner = "1.2vh", shadow = SHADOW, padding = "2.5vh", spacing = "1vh",
            children = (function()
              local k = { ui.row { width = "100%", height = "5vh", crossAlign = "center",
                children = {
                  ui.text { text = "加入房间", weight = 1, style = { font = "2.8vh", weight = "bold", color = C.dark } },
                  ui.button { text = "⊕ 创建房间", height = "4.5vh", background = C.white,
                    border = BORDER_A, corner = "pill", style = { font = "2.2vh", tint = C.accent } },
                } } }
              pushAll(k, joinRooms)
              return k
            end)() },
          ui.column { width = "92%", background = C.card, border = BORDER, corner = "1.2vh",
            shadow = SHADOW, padding = "2.5vh", spacing = "1.5vh",
            children = {
              ui.row { width = "100%", background = C.warnBg, corner = "1vh", crossAlign = "center",
                spacing = "1.2vh", padding = "1.5vh",
                children = {
                  ui.text { text = "⚠", style = { font = "3vh", tint = C.danger } },
                  ui.column { weight = 1, justify = "center", spacing = "0.2vh", children = {
                    ui.text { text = "请确保所使用的 Mod 与在线版本兼容。", style = { font = "2.1vh", color = C.dark } },
                    ui.text { text = "非兼容内容可能导致联机失败。", style = { font = "2.1vh", color = C.mid } },
                  } },
                } },
              pickerRow("mpSetRow", "端口号", "· · ·"),
              ui.row { height = "4vh", crossAlign = "center", spacing = "1.2vh", width = "100%",
                children = {
                  ui.button { id = "mpAllow", text = "☐", height = "3.5vh", width = "14%",
                    background = C.white, border = BORDER, corner = "0.8vh",
                    style = { font = "2.6vh", tint = C.dark } },
                  ui.text { weight = 1, text = "允许他人直接通过地址连接",
                    style = { font = "2.1vh", color = C.dark } },
                } },
            } },
          ui.row { width = "92%", height = "4vh", crossAlign = "center", spacing = "1.5vh",
            children = downLinks },
        } },
    } }
end

-- ============ 设置页 ============
local function buildSettingsPage()
  local kids = {}
  kids[#kids + 1] = ui.column { id = "setAbout", width = "92%", background = C.card, border = BORDER,
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
    kids[#kids + 1] = ui.row { id = "set" .. i, width = "92%", height = "7vh", background = C.card,
      border = BORDER, corner = "1.2vh", shadow = SHADOW, crossAlign = "center", spacing = "1.6vh",
      padding = "1.8vh", hoverColor = C.hover, action = (s.action or "open:settings"),
      children = {
        ui.image { icon = s.icon or "sf:gearshape.fill", size = "4.5vh", corner = "1vh",
          background = C.accent, style = { tint = C.white } },
        ui.column { weight = 1, justify = "center", spacing = "0.3vh", children = {
          ui.text { text = s.label or "", style = { font = "2.7vh", color = C.dark } },
          s.desc and ui.text { text = s.desc, style = { font = "2.1vh", color = C.mid } } or nil,
        } },
        chevron(),
      } }
  end
  if #kids == 1 then
    kids[#kids + 1] = ui.text { text = "启动器暂未提供设置条目。", style = { font = "2.2vh", color = C.mid } }
  end
  return ui.column { id = "pageSettings", weight = 1, crossAlign = "center",
    padding = "2vh", spacing = "2.5vh", children = kids }
end

-- ============ 更多页 ============
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
      rows[#rows + 1] = ui.row { id = rr.id, width = "100%", height = "7vh", crossAlign = "center",
        spacing = "1.6vh", padding = "1.8vh", hoverColor = C.hover, action = (rr.action or "open:more"),
        children = {
          ui.image { icon = rr.icon or "sf:gearshape.fill", size = "4.5vh", style = { tint = C.mid } },
          ui.text { text = rr.label, weight = 1, style = { font = "2.7vh", color = C.dark } },
          rightNode,
        } }
    end
    kids[#kids + 1] = ui.column { width = "92%", background = C.card, border = BORDER,
      corner = "1.2vh", shadow = SHADOW, padding = "1vh", spacing = "0.5vh", children = rows }
  end
  return ui.column { id = "pageMore", weight = 1, crossAlign = "center",
    padding = "2vh", spacing = "2.5vh", children = kids }
end

-- ============ 版本设置二级页 ============
local function buildVersionSettingsPage()
  local navKids = {}
  for i, n in ipairs(CONFIG.subnav) do
    navKids[#navKids + 1] = navItem("vsNav" .. i, "sf:doc.text.fill", n)
  end
  return ui.column { id = "pageVersionSettings", weight = 1,
    children = {
      ui.row { id = "vsBar", height = "8.5vh", width = "100%", background = C.topbar, crossAlign = "center",
        padding = { left = "2vh", right = "2vh" }, spacing = "1.2vh",
        children = {
          ui.text { text = "←", action = "navigate:settings", style = { font = "3vh", color = C.white } },
          ui.text { text = "版本设置", weight = 1, style = { font = "2.8vh", weight = "bold", color = C.white } },
          ui.text { text = "—", style = { font = "2.5vh", color = C.white } },
          ui.text { text = "✕", style = { font = "2.5vh", color = C.white } },
        } },
      ui.row { weight = 1, width = "100%",
        children = {
          ui.column { id = "vsNavCol", width = "18%", weight = 1, background = C.white,
            padding = { top = "1.5vh" }, spacing = "0.5vh", children = navKids },
          ui.column { weight = 1, crossAlign = "center", spacing = "3vh", padding = "3vh",
            children = {
              ui.row { width = "92%", height = "11vh", background = C.card, border = BORDER,
                corner = "1.2vh", shadow = SHADOW, crossAlign = "center", spacing = "2vh", padding = "2vh",
                children = {
                  ui.image { icon = "sf:doc.text.fill", size = "6vh", background = C.accent,
                    corner = "1.2vh", style = { tint = C.white } },
                  ui.column { weight = 1, justify = "center", spacing = "0.4vh", children = {
                    ui.text { text = "· · ·", style = { font = "2.8vh", weight = "bold", color = C.dark } },
                    ui.text { text = "版本信息 · · ·", style = { font = "2.1vh", color = C.mid } },
                  } },
                } },
              ui.column { width = "92%", background = C.card, border = BORDER, corner = "1.2vh",
                shadow = SHADOW, padding = "3vh", spacing = "1.5vh",
                children = {
                  pickerRow("vsPick1", "启动方式", "· · ·"),
                  pickerRow("vsPick2", "游戏目录", "· · ·"),
                  ui.row { width = "100%", height = "5.5vh", spacing = "3vh",
                    children = {
                      plainButton("vsBtn1", "重选", false),
                      plainButton("vsBtn2", "刷新", false),
                      plainButton("vsBtn3", "重置", false),
                    } },
                } },
              ui.column { width = "92%", background = C.card, border = BORDER, corner = "1.2vh",
                shadow = SHADOW, padding = "3vh",
                children = {
                  ui.row { width = "100%", height = "5.5vh", spacing = "2vh",
                    children = {
                      plainButton("vsShort1", "创建桌面快捷方式", false),
                      plainButton("vsShort2", "创建开始菜单项", false),
                      plainButton("vsShort3", "创建应用图标", false),
                    } },
                } },
              ui.column { width = "92%", background = C.card, border = BORDER, corner = "1.2vh",
                shadow = SHADOW, padding = "3vh",
                children = {
                  ui.row { width = "100%", height = "5.5vh", spacing = "2vh",
                    children = {
                      plainButton("vsAdv1", "打开安装目录", false),
                      plainButton("vsAdv2", "删除版本文件夹", false),
                      ui.button { id = "vsAdvDanger", text = "删除本版本", weight = 1, height = "5.5vh",
                        background = C.white, border = BORDER_D, corner = "0.7vh",
                        style = { font = "2.4vh", tint = C.danger } },
                    } },
                } },
            } },
        } },
    } }
end

-- ============ 根构建 ============
function build(ui)
  local homeSidebar = buildHomeSidebar()

  -- 启动页右区：仅装饰（浅蓝渐变上放一枚水印，无功能内容）
  local pageHome = ui.column { id = "pageHome", weight = 1, justify = "center", crossAlign = "center",
    children = {
      ui.text { text = "P C L", style = { font = "12vh", weight = "bold", color = C.card } },
    } }

  return ui.column {
    id = "shell", crossAlign = "stretch", spacing = 0,
    children = {
      -- 顶栏
      ui.row { id = "titlebar", height = "8.5vh", background = C.topbar, crossAlign = "center",
        padding = { left = "2vh", right = "1.5vh" },
        children = {
          ui.text { id = "logo", text = "PCL", width = "10vh", style = { font = "3.2vh", weight = "bold", color = C.white } },
          ui.spacer { weight = 1 },
          ui.row { id = "tabs", spacing = "6vh", crossAlign = "center",
            children = (function()
              local nodes = {}
              -- 滑动高亮游标：白色全圆药丸，绝对定位铺在选中页签之下
              nodes[#nodes + 1] = ui.row { id = "tabCursor", absolute = true, background = C.white, corner = "pill" }
              for _, t in ipairs(TABS) do nodes[#nodes + 1] = topTab(t) end
              return nodes
            end)() },
          ui.spacer { weight = 1 },
          ui.image { id = "winMin", icon = "sf:minus", size = "2.5vh", style = { tint = C.white } },
          ui.image { id = "winClose", icon = "sf:xmark", size = "2.5vh", style = { tint = C.white } },
        } },
      -- 内容行
      ui.row { id = "page", weight = 1, crossAlign = "stretch", spacing = 0,
        children = {
          ui.column { id = "left", width = "32%", background = C.white, crossAlign = "center",
            spacing = "0.6vh", padding = { left = "2vh", right = "2vh", top = "3.5vh", bottom = "3vh" },
            children = homeSidebar },
          ui.content {
            id = "content", weight = 1, initialPage = "home",
            background = { from = C.pageFrom, to = C.pageTo, angle = 45 },
            pages = CONFIG.pages,
            children = {
              pageHome,
              buildDownloadPage(),
              buildMultiPage(),
              buildSettingsPage(),
              buildMorePage(),
              buildVersionSettingsPage(),
            },
          },
        } },
    },
  }
end

-- ===== 交互 =====

local selectedTab = "tab.home"

-- 白色游标药丸平滑滑动：getFrame 返回 {x,y,w,h}，药丸高取页签高的 5/6，垂直居中
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

-- 下载页左导航选中态
local function selectDlNav(idx)
  for i = 1, #CONFIG.download.nav do
    local sel = (i == idx)
    launcher.view("dlNav" .. i .. "Bar"):setVisible(sel)
    launcher.view("dlNav" .. i .. "Icon"):setStyle({ tint = sel and C.accent or C.mid })
    launcher.view("dlNav" .. i .. "Label"):setStyle({ tint = sel and C.accent or C.mid })
  end
end

-- 版本设置二级页左导航选中态
local function selectVsNav(idx)
  for i = 1, #CONFIG.subnav do
    local sel = (i == idx)
    launcher.view("vsNav" .. i .. "Bar"):setVisible(sel)
    launcher.view("vsNav" .. i .. "Label"):setStyle({ tint = sel and C.accent or C.mid })
  end
end

-- 启动页登录胶囊选中态（选中蓝底白字，未选白底蓝描边）
local function selectCap(idx)
  for i = 1, 2 do
    local sel = (i == idx)
    launcher.view("homeCap" .. i):setStyle(sel
      and { background = C.accent, tint = C.white }
      or  { background = C.white, tint = C.accent })
  end
end

-- 下载页折叠分组：展开/收起其下列表
local dlGroupOpen = {}
local function toggleGroup(i)
  dlGroupOpen[i] = not dlGroupOpen[i]
  launcher.view("dlGroup" .. i .. "List"):setVisible(dlGroupOpen[i])
  launcher.view("dlGroup" .. i .. "Chev"):setText(dlGroupOpen[i] and "⌄" or "›")
end

function onReady()
  selectTab(selectedTab)
  selectDlNav(1)
  selectVsNav(1)
  selectCap(1)
  onPageChange("home")
end

function onPageChange(page)
  local isSub = (page == "version_settings")
  launcher.view("titlebar"):setVisible(not isSub)
  if isSub then
    selectVsNav(1)
  else
    local tabId = PAGE_TAB[page]
    if tabId then selectTab(tabId) end
  end
  launcher.view("left"):setVisible(page == "home")
end

function onLayout()
  selectTab(selectedTab)
end

function onClick(id)
  -- 顶栏页签
  for _, t in ipairs(TABS) do
    if t.id == id then selectTab(t.id); return end
  end
  -- 下载页左导航
  for i = 1, #CONFIG.download.nav do
    if id == "dlNav" .. i then selectDlNav(i); return end
  end
  -- 版本设置二级页左导航
  for i = 1, #CONFIG.subnav do
    if id == "vsNav" .. i then selectVsNav(i); return end
  end
  -- 启动页登录胶囊
  if id == "homeCap1" then selectCap(1); return end
  if id == "homeCap2" then selectCap(2); return end
  -- 下载页折叠分组
  local gi = id:match("^dlGroup(%d+)$")
  if gi then toggleGroup(tonumber(gi)); return end
end