-- Pear 启动器 深色卡片体系（PCL2 风格深色重绘）—— v1.3.0
--
-- 设计语言（全部尺寸以窗口高 1H 为基准，vh 单位；横向用百分比）：
--   顶栏纯色玫红 #E84393；页面背景浅蓝灰 #C6D6DE；卡片深灰蓝 #3C4750
--   白色标题 / 灰次要文字 #9AA5AD；仅启动页有白色左栏(≈32%)，其余页无侧栏
--   启动页面每张卡片顶部有彩色细条（≈卡片高 1/20，颜色与卡内图标同色）
--   列表条目统一：深灰蓝圆角卡 = 左图标 + 中白粗体标题 + 灰小字副行 + 右端 ›
--
-- 结构约定（PLUIShellViewController.showLuaPage 依赖）：
--   内容区容器 id="content"，内挂 5 棵纯 Lua 页子树：
--     pageHome / pageDownload / pageMulti / pageSettings / pageMore
--   非启动页收起左栏（id="left"），内容区整幅铺开。

local C = {
  topbar       = "$color:topbar",
  pageBg       = "$color:pageBg",
  card         = "$color:card",
  cardText     = "$color:cardText",
  subText      = "$color:subText",
  sidebar      = "$color:sidebar",
  accent       = "$color:accent",
  accentBorder = "$color:accentBorder",
  orange       = "$color:orangePill",
  success      = "$color:success",
  dark         = "$color:textPrimary",
  mid          = "$color:textSecondary",
  white        = "$color:white",
  transparent  = "$color:transparent",
  barPurple    = "$color:barPurple",
  barBlue      = "$color:barBlue",
  barGreen     = "$color:barGreen",
  barRed       = "$color:barRed",
  barOrange    = "$color:barOrange",
  barPink      = "$color:barPink",
  barCyan      = "$color:barCyan",
  -- 设置页"灰蓝"线性图标统一用色
  gblue        = "#7E8F9E",
  -- 左栏头像占位浅灰底
  lightGray    = "#EEEEEE",
}

-- ===== 顶栏五个页签（启动/下载/联机/设置/更多）=====
local TABS = {
  { id = "tab.home",     label = "启动", icon = "sf:house.fill",                    action = "open:home",       page = "home" },
  { id = "tab.download", label = "下载", icon = "sf:arrow.down.circle.fill",        action = "open:download",   page = "download" },
  { id = "tab.multi",    label = "联机", icon = "sf:antenna.radiowaves.left.and.right", action = "open:multiplayer", page = "multi" },
  { id = "tab.setup",    label = "设置", icon = "sf:gearshape.fill",                action = "open:settings",   page = "settings" },
  { id = "tab.other",    label = "更多", icon = "sf:ellipsis.circle.fill",          action = "open:more",       page = "more" },
}

local PAGE_TAB = {
  home = "tab.home", download = "tab.download", multi = "tab.multi",
  settings = "tab.setup", more = "tab.other",
}

-- ===== 构建器（复用节点）=====

local function topTab(t)
  -- 顶栏页签：选中态白色全圆药丸 + 主题色文字/图标；未选中透明底白色。
  -- corner="pill" 布局期取高/2；选中态只切 background/tint，药丸形状自建时保留。
  return ui.button {
    id = t.id, label = t.label, icon = t.icon, action = t.action,
    height = "6vh", corner = "pill",
    padding = { left = "1.5vh", right = "1.5vh" },
    style = { background = C.transparent, tint = C.white, font = "2.4vh", weight = "bold" },
  }
end

-- 带彩色顶条的深色卡片：装饰条 ≈ 卡片高 1/20
local function bar(color, cardHeight)
  return ui.column { height = cardHeight / 20.0 .. "vh", background = color, crossAlign = "stretch" }
end

-- 深色条目卡（下载/联机通用）：左图标 + 中标题/副行 + 右橙色胶囊 + ›
local function entryCard(id, icon, title, sub, pillText, pillColor, action)
  return ui.row {
    id = id, width = "97%", height = "9vh", corner = "1vh", background = C.card,
    action = action, crossAlign = "center",
    padding = { left = "2.5vh", right = "2vh" }, spacing = "1.2vh",
    children = {
      ui.image { icon = icon, size = "5vh", style = { tint = C.cardText } },
      ui.column {
        weight = 1, justify = "center", spacing = "0.4vh",
        children = {
          ui.text { id = id .. "Title", text = title, style = { font = "2.8vh", weight = "bold", color = C.cardText } },
          ui.text { id = id .. "Sub", text = sub, style = { font = "2.2vh", color = C.subText } },
        },
      },
      ui.button {
        id = id .. "Pill", label = pillText, height = "3vh", corner = "pill",
        padding = { left = "1.2vh", right = "1.2vh" },
        style = { background = pillColor, tint = C.dark, font = "2.2vh", weight = "bold" },
      },
      ui.text { id = id .. "Chev", text = "›", style = { font = "3vh", color = C.subText } },
    },
  }
end

-- 把数组 arr 的元素依次追加入列表 list（构建 children 时展平多返回值/嵌套数组）。
-- 直接放在表构造器末尾无法展开单值返回，统一用"先累加再引用"的方式规避。
local function pushAll(list, arr)
  for _, v in ipairs(arr) do list[#list + 1] = v end
end



-- 设置/更多页的整卡多行条目：左彩色图标 + 白色文字 + 右端 ›（或版本号）
local function rowItem(id, icon, tint, label, rightSpec, action)
  return ui.row {
    id = id, height = "7.5vh", corner = "1vh", action = action,
    crossAlign = "center", padding = { left = "3vh", right = "2.5vh" }, spacing = "1.5vh",
    children = {
      ui.image { icon = icon, size = "3.5vh", style = { tint = tint } },
      ui.text { text = label, weight = 1, style = { font = "2.8vh", color = C.cardText } },
      rightSpec,
    },
  }
end

local function chevron()
  return ui.text { text = "›", style = { font = "3vh", color = C.subText } }
end

local function versionLabel()
  -- 更多页版本行：右端灰色版本号（不占固定宽度，随内容收缩）
  return ui.text { text = "2.0.0", style = { font = "2.6vh", color = C.subText } }
end

-- 输入条（下载页搜索 / 联机页加入房间输入）：白底全圆，左灰图标+占位文字，右灰图标
local function inputBar(id, leftIcon, placeholder, rightIcon, action)
  return ui.row {
    id = id, height = "6vh", corner = "pill", background = C.white,
    action = action, crossAlign = "center",
    padding = { left = "2vh", right = "2vh" }, spacing = "1.2vh",
    children = {
      ui.image { icon = leftIcon, size = "2.6vh", style = { tint = C.mid } },
      ui.text { text = placeholder, weight = 1, style = { font = "2.4vh", color = C.mid } },
      ui.image { icon = rightIcon, size = "2.6vh", style = { tint = C.mid } },
    },
  }
end

function describe()
  return { name = "Pear 深色卡片", author = "Pear", version = "1.3.0" }
end

-- ===== 页面子树（content 容器内 5 棵，仅当前页可见）=====

-- 启动页 · 右区（68% 浅蓝灰底，深卡纵向堆叠，每卡顶部彩色细条）
local function buildHomePage()
  return ui.column {
    id = "pageHome", weight = 1, crossAlign = "center",
    padding = { top = "1vh", bottom = "1vh" }, spacing = "1.5vh",
    children = {
      -- 页头行：主页大标题 + 右端 自定义
      ui.row {
        id = "homeHeader", width = "95%", crossAlign = "center",
        children = {
          ui.text { text = "主页", style = { font = "4.5vh", weight = "bold", color = C.dark } },
          ui.spacer { weight = 1 },
          ui.image { icon = "sf:slider.horizontal.3", size = "2.6vh", style = { tint = C.mid } },
          ui.text { text = "自定义", style = { font = "2.2vh", color = C.mid } },
        },
      },
      -- 欢迎卡：紫色装饰条
      ui.column {
        id = "homeWelcomeCard", width = "95%", height = "17vh", corner = "1vh",
        background = C.card, crossAlign = "stretch", spacing = 0,
        children = {
          bar(C.barPurple, 17),
          ui.row {
            weight = 1, crossAlign = "center", padding = { left = "2vh", right = "2vh" }, spacing = "1.5vh",
            children = {
              ui.image { icon = "sf:person.fill", size = "8vh", style = { tint = C.barBlue } },
              ui.image { icon = "sf:person.crop.circle", size = "7vh", style = { tint = C.subText } },
              ui.column {
                weight = 1, justify = "center", spacing = "0.6vh",
                children = {
                  ui.text { id = "homeWelcomeTitle", text = "欢迎回来！", style = { font = "3.2vh", weight = "bold", color = C.cardText } },
                  ui.text { id = "homeWelcomeSub", text = "准备好了吗？开始你的冒险吧", style = { font = "2.4vh", color = C.subText } },
                },
              },
            },
          },
        },
      },
      -- 公告卡：蓝色装饰条
      ui.column {
        id = "homeAnnounceCard", width = "95%", height = "7.5vh", corner = "1vh",
        background = C.card, crossAlign = "stretch", spacing = 0, action = "open:home",
        children = {
          bar(C.barBlue, 7.5),
          ui.row {
            weight = 1, crossAlign = "center", padding = { left = "2vh", right = "2vh" }, spacing = "1.2vh",
            children = {
              ui.image { icon = "sf:bell.fill", size = "3vh", style = { tint = C.barBlue } },
              ui.text { text = "看看 Pear 启动器最近的动态与公告", style = { font = "2.4vh", color = C.cardText } },
            },
          },
        },
      },
      -- 双卡行：版本入口（绿 / 橙装饰条）
      ui.row {
        id = "homeVersionRow", width = "95%", height = "13vh", spacing = "2vh",
        children = {
          ui.column {
            id = "homeLatestCard", weight = 1, corner = "1vh", background = C.card,
            crossAlign = "stretch", spacing = 0, action = "open:download",
            children = {
              bar(C.barGreen, 13),
              ui.column {
                weight = 1, justify = "center", crossAlign = "center", spacing = "0.4vh",
                children = {
                  ui.image { icon = "sf:square.grid.3x3.fill", size = "5vh", style = { tint = C.barGreen } },
                  ui.text { text = "正式版", style = { font = "2.2vh", color = C.subText } },
                  ui.text { text = "进入下载", style = { font = "4vh", weight = "bold", color = C.cardText } },
                },
              },
            },
          },
          ui.column {
            id = "homeSnapshotCard", weight = 1, corner = "1vh", background = C.card,
            crossAlign = "stretch", spacing = 0, action = "open:download",
            children = {
              bar(C.barOrange, 13),
              ui.column {
                weight = 1, justify = "center", crossAlign = "center", spacing = "0.4vh",
                children = {
                  ui.image { icon = "sf:fish.fill", size = "5vh", style = { tint = C.barOrange } },
                  ui.text { text = "快照", style = { font = "2.2vh", color = C.subText } },
                  ui.text { text = "抢先体验", style = { font = "4vh", weight = "bold", color = C.cardText } },
                },
              },
            },
          },
        },
      },
      -- 资讯大卡：红色装饰条
      ui.column {
        id = "homeNewsCard", width = "95%", height = "16vh", corner = "1vh",
        background = C.card, crossAlign = "stretch", spacing = 0, action = "open:home",
        children = {
          bar(C.barRed, 16),
          ui.row {
            weight = 1, crossAlign = "center", padding = { left = "2vh", right = "2vh" }, spacing = "1.5vh",
            children = {
              ui.image { icon = "sf:photo.fill", size = "12vh", corner = "1vh", style = { tint = C.subText } },
              ui.column {
                weight = 1, justify = "center", spacing = "0.5vh",
                children = {
                  ui.text { text = "网站更新：新增多语言界面支持", style = { font = "2.8vh", weight = "bold", color = C.cardText } },
                  ui.text { text = "本次更新带来了全新的界面体验，并修复了大量历史问题。", style = { font = "2.1vh", color = C.subText } },
                  ui.row {
                    crossAlign = "center",
                    children = {
                      ui.spacer { weight = 1 },
                      ui.text { text = "2026-06-01", style = { font = "2vh", color = C.subText } },
                    },
                  },
                },
              },
            },
          },
        },
      },
      -- 导航双卡行 1：整合包（青）/ 光影（橙）
      ui.row {
        id = "homeNavRow1", width = "95%", height = "9vh", spacing = "2vh",
        children = {
          ui.row { id = "navPack", weight = 1, corner = "1vh", background = C.card, action = "open:modpackImport",
            crossAlign = "center", padding = { left = "2vh", right = "2vh" }, spacing = "1.2vh",
            children = {
              ui.image { icon = "sf:square.2.layers.3d.fill", size = "4.5vh", style = { tint = C.barCyan } },
              ui.text { text = "整合包", weight = 1, style = { font = "2.8vh", weight = "bold", color = C.cardText } },
              ui.text { text = "›", style = { font = "3vh", color = C.subText } },
            } },
          ui.row { id = "navShader", weight = 1, corner = "1vh", background = C.card, action = "open:shaders",
            crossAlign = "center", padding = { left = "2vh", right = "2vh" }, spacing = "1.2vh",
            children = {
              ui.image { icon = "sf:sun.max.fill", size = "4.5vh", style = { tint = C.barOrange } },
              ui.text { text = "光影", weight = 1, style = { font = "2.8vh", weight = "bold", color = C.cardText } },
              ui.text { text = "›", style = { font = "3vh", color = C.subText } },
            } },
        },
      },
      -- 导航双卡行 2：资源中心（紫）/ 壁纸（粉）
      ui.row {
        id = "homeNavRow2", width = "95%", height = "9vh", spacing = "2vh",
        children = {
          ui.row { id = "navMods", weight = 1, corner = "1vh", background = C.card, action = "open:mods",
            crossAlign = "center", padding = { left = "2vh", right = "2vh" }, spacing = "1.2vh",
            children = {
              ui.image { icon = "sf:cube.fill", size = "4.5vh", style = { tint = C.barPurple } },
              ui.text { text = "资源中心", weight = 1, style = { font = "2.8vh", weight = "bold", color = C.cardText } },
              ui.text { text = "›", style = { font = "3vh", color = C.subText } },
            } },
          ui.row { id = "navWall", weight = 1, corner = "1vh", background = C.card, action = "open:settings",
            crossAlign = "center", padding = { left = "2vh", right = "2vh" }, spacing = "1.2vh",
            children = {
              ui.image { icon = "sf:photo.on.rectangle.fill", size = "4.5vh", style = { tint = C.barPink } },
              ui.text { text = "壁纸设置", weight = 1, style = { font = "2.8vh", weight = "bold", color = C.cardText } },
              ui.text { text = "›", style = { font = "3vh", color = C.subText } },
            } },
        },
      },
    },
  }
end

-- 下载页：两行分段标签 + 搜索条 + 深色条目列
local DL1 = { "全部", "快照", "正式版", "Mods", "光影", "整合包", "地图" }
local DL2 = { "下载", "已购", "收藏", "历史" }
local function buildDownloadPage()
  -- 第一行分段标签（7 项等分），选中白底药丸 + 深色
  local seg1 = {}
  for i, name in ipairs(DL1) do
    seg1[#seg1 + 1] = ui.button {
      id = "dl1." .. i, label = name, weight = 1, height = "6vh", corner = "pill",
      style = { background = C.transparent, tint = C.mid, font = "2.4vh" },
    }
  end
  -- 第二行分段标签（4 项等分），选中白底圆角横条 + 深色
  local seg2 = {}
  for i, name in ipairs(DL2) do
    seg2[#seg2 + 1] = ui.button {
      id = "dl2." .. i, label = name, weight = 1, height = "5.5vh", corner = "1vh",
      style = { background = C.transparent, tint = C.mid, font = "2.4vh" },
    }
  end
  return ui.column {
    id = "pageDownload", weight = 1, crossAlign = "center",
    padding = { top = "1.5vh", bottom = "1.5vh" }, spacing = "2vh",
    children = {
      ui.row { id = "dlSeg1", width = "97%", spacing = "1vh", children = seg1 },
      ui.row { id = "dlSeg2", width = "97%", spacing = "1vh", children = seg2 },
      inputBar("dlSearch", "sf:magnifyingglass", "搜索内容…", "sf:slider.horizontal.3", "open:download"),
      entryCard("dlItem1", "sf:cube.fill", "Java 版本存档", "更新于 2026-06-01", "正式版", C.orange, "open:download"),
      entryCard("dlItem2", "sf:cube.fill", "光影整合包", "更新于 2026-05-28", "快照", C.orange, "open:download"),
      entryCard("dlItem3", "sf:cube.fill", "地图资源合集", "更新于 2026-05-20", "正式版", C.orange, "open:download"),
    },
  }
end

-- 联机页：分段切换「加入房间 / 创建房间」（此前完全遗漏，按同一设计语言补全）
local function buildMultiPage()
  local joinBranch = ui.column {
    id = "joinBranch", width = "97%", crossAlign = "stretch", spacing = "1.5vh",
    children = {
      inputBar("roomInput", "sf:person.2.fill", "输入房间连接码…", "sf:doc.on.clipboard", "open:multiplayer"),
      -- 提示条：浅蓝灰底
      ui.row {
        id = "roomHint", height = "5vh", corner = "1vh", background = C.pageBg,
        crossAlign = "center", padding = { left = "2vh", right = "2vh" }, spacing = "1.2vh",
        children = {
          ui.image { icon = "sf:info.circle.fill", size = "2.6vh", style = { tint = C.mid } },
          ui.text { text = "输入对方分享的房间连接码即可加入", style = { font = "2.2vh", color = C.mid } },
        },
      },
      entryCard("roomItem1", "sf:person.3.fill", "联机大厅 · 生存", "房主 · 24ms", "可加入", C.orange, "open:multiplayer"),
      entryCard("roomItem2", "sf:person.3.fill", "光影测试房间", "房主 · 68ms", "可加入", C.orange, "open:multiplayer"),
    },
  }
  -- 创建房间：纵向表单卡 + 底部实心蓝主按钮 + 绿色成功条
  local createBranch = ui.column {
    id = "createBranch", width = "97%", crossAlign = "stretch", spacing = "1.5vh",
    children = {
      ui.column {
        id = "createForm", corner = "1vh", background = C.card, padding = "3vh", spacing = "2vh",
        crossAlign = "stretch",
        children = {
          -- 房间名输入
          ui.column { crossAlign = "stretch", spacing = "0.8vh", children = {
            ui.text { text = "房间名称", style = { font = "2.2vh", color = C.subText } },
            ui.row { height = "6vh", corner = "pill", background = C.white, crossAlign = "center",
              padding = { left = "2vh", right = "2vh" },
              children = { ui.text { text = "我给房间起个名字", style = { font = "2.4vh", color = C.mid } } } },
          } },
          -- 人数上限步进器
          ui.column { crossAlign = "stretch", spacing = "0.8vh", children = {
            ui.text { text = "人数上限", style = { font = "2.2vh", color = C.subText } },
            ui.row { height = "6vh", corner = "pill", background = C.white, crossAlign = "center",
              padding = { left = "2vh", right = "2vh" }, spacing = "2vh",
              children = {
                ui.image { icon = "sf:minus.circle.fill", size = "3vh", style = { tint = C.mid } },
                ui.text { text = "8", weight = 1, style = { font = "2.6vh", weight = "bold", color = C.dark } },
                ui.image { icon = "sf:plus.circle.fill", size = "3vh", style = { tint = C.mid } },
              } },
          } },
          -- 游戏版本下拉条（结构与启动页账号下拉框一致：白底 + 右端箭头）
          ui.column { crossAlign = "stretch", spacing = "0.8vh", children = {
            ui.text { text = "游戏版本", style = { font = "2.2vh", color = C.subText } },
            ui.row { id = "createVersion", height = "6vh", corner = "pill", background = C.white,
              crossAlign = "center", padding = { left = "2vh", right = "2vh" }, spacing = "1.2vh",
              children = {
                ui.text { id = "createVersionLabel", text = "选择版本…", weight = 1, style = { font = "2.4vh", color = C.dark } },
                ui.image { icon = "sf:chevron.down", size = "2vh", style = { tint = C.mid } },
              } },
          } },
        },
      },
      ui.button { id = "createRoomBtn", label = "创建房间", height = "7vh", corner = "1.5vh",
        style = { background = C.accent, tint = C.white, font = "2.8vh", weight = "bold" } },
      -- 绿色成功状态条（创建成功后显示）
      ui.row { id = "createSuccess", height = "4vh", corner = "1vh", background = C.success,
        crossAlign = "center", justify = "center",
        children = { ui.text { text = "房间创建成功，连接码已复制", style = { font = "2.2vh", color = C.white } } } },
    },
  }
  return ui.column {
    id = "pageMulti", weight = 1, crossAlign = "center",
    padding = { top = "1.5vh", bottom = "1.5vh" }, spacing = "2vh",
    children = {
      ui.row { id = "multiSeg", width = "97%", height = "6vh", spacing = "1vh", crossAlign = "center", children = {
        ui.button { id = "multiJoin", label = "加入房间", weight = 1, height = "6vh", corner = "pill",
          style = { background = C.white, tint = C.dark, font = "2.4vh", weight = "bold" } },
        ui.button { id = "multiCreate", label = "创建房间", weight = 1, height = "6vh", corner = "pill",
          style = { background = C.transparent, tint = C.mid, font = "2.4vh" } },
      } },
      joinBranch,
      createBranch,
    },
  }
end

-- 设置页：版本信息卡 + 设置条目（带可选的灰色说明小字）
local function settingsEntry(id, icon, tint, label, desc)
  local nodes = {
    ui.row { id = id, height = "7vh", corner = "1vh", background = C.card, action = "open:settings",
      crossAlign = "center", padding = { left = "3vh", right = "2.5vh" }, spacing = "1.5vh",
      children = {
        ui.image { icon = icon, size = "3vh", style = { tint = tint } },
        ui.text { text = label, weight = 1, style = { font = "2.8vh", color = C.cardText } },
        chevron(),
      } },
  }
  if desc and desc ~= "" then
    nodes[#nodes + 1] = ui.text { text = desc, width = "95%", style = { font = "2.1vh", color = C.subText } }
  end
  return nodes
end

local function buildSettingsPage()
  local children = {
    -- 版本信息卡
    ui.row {
      id = "setAbout", width = "97%", height = "12vh", corner = "1vh", background = C.card, action = "open:settings",
      crossAlign = "center", padding = { left = "2.5vh", right = "2.5vh" }, spacing = "2vh",
      children = {
        ui.image { icon = "sf:shippingbox.fill", size = "7vh", corner = "1.5vh", background = C.barPurple, style = { tint = C.white } },
        ui.column {
          weight = 1, justify = "center", spacing = "0.4vh",
          children = {
            ui.text { text = "Pear 启动器", style = { font = "3vh", weight = "bold", color = C.cardText } },
            ui.text { text = "版本 2.0.0", style = { font = "2.2vh", color = C.subText } },
            ui.text { text = "Apple iPadOS 17.0  ·  arm64", style = { font = "2.2vh", color = C.subText } },
          },
        },
      },
    },
  }
  -- 设置条目（立方体紫 / 其余灰蓝）
  pushAll(children, settingsEntry("setLaunch", "sf:cube.fill", C.barPurple, "启动选项", "配置常用启动版本、内存与启动参数。"))
  pushAll(children, settingsEntry("setDownload", "sf:clock.fill", C.gblue, "下载设置", "选择下载源、并发数与下载目录。"))
  pushAll(children, settingsEntry("setDisplay", "sf:display", C.gblue, "界面显示", ""))
  pushAll(children, settingsEntry("setChip", "sf:memorychip.fill", C.gblue, "性能调优", ""))
  pushAll(children, settingsEntry("setGamepad", "sf:gamecontroller.fill", C.gblue, "手柄控制", ""))
  pushAll(children, settingsEntry("setWall", "sf:photo.on.rectangle.fill", C.gblue, "壁纸设置", ""))
  pushAll(children, settingsEntry("setTheme", "sf:star.fill", C.gblue, "主题材质包", ""))
  return ui.column {
    id = "pageSettings", weight = 1, crossAlign = "center",
    padding = { top = "1.5vh", bottom = "1.5vh" }, spacing = "2vh",
    children = children,
  }
end

-- 更多页：居中深色标题栏 + 纵向分组（组名 + 整卡多行）
local function group(name, rows)
  local nodes = {
    ui.text { text = name, width = "97%", style = { font = "2.2vh", color = C.subText } },
    ui.column { width = "97%", corner = "1vh", background = C.card, crossAlign = "stretch", children = rows },
  }
  return nodes
end

local function buildMorePage()
  local children = {
    -- 附加深色居中标题栏
    ui.row { id = "moreTitlebar", width = "97%", height = "6vh", corner = "1vh", background = C.card,
      crossAlign = "center", justify = "center",
      children = { ui.text { text = "更多", style = { font = "2.8vh", weight = "bold", color = C.cardText } } } },
  }
  pushAll(children, group("启动", {
    rowItem("moreLaunch", "sf:play.rectangle.fill", C.barBlue, "启动选项", chevron(), "open:settings"),
    rowItem("moreDefaultVersion", "sf:cube.fill", C.barPurple, "默认版本", versionLabel(), "open:versionManager"),
  }))
  pushAll(children, group("资源", {
    rowItem("moreMods", "sf:cube.fill", C.barCyan, "资源中心", chevron(), "open:mods"),
    rowItem("moreVersions", "sf:square.grid.3x3.fill", C.barGreen, "版本管理", chevron(), "open:versionManager"),
    rowItem("moreSaves", "sf:tray.full.fill", C.barOrange, "存档管理", chevron(), "open:gameDirectory"),
  }))
  pushAll(children, group("个性化", {
    rowItem("moreTheme", "sf:star.fill", C.barPink, "主题材质包", chevron(), "open:settings"),
    rowItem("moreWall", "sf:photo.on.rectangle.fill", C.barBlue, "壁纸设置", chevron(), "open:settings"),
  }))
  pushAll(children, group("关于", {
    rowItem("moreAbout", "sf:info.circle.fill", C.barBlue, "软件信息", chevron(), "open:settings"),
    rowItem("moreLicense", "sf:doc.text.fill", C.barGreen, "开源协议", chevron(), "open:settings"),
    rowItem("moreVersion", "sf:v.circle.fill", C.barPurple, "版本号", versionLabel(), "open:settings"),
  }))
  return ui.column {
    id = "pageMore", weight = 1, crossAlign = "center",
    padding = { top = "1.5vh", bottom = "1.5vh" }, spacing = "2vh",
    children = children,
  }
end

-- ===== build：整树（顶栏玫红 + 启动页白左栏，其余页无侧栏）=====

function build(ui)
  return ui.column {
    id = "shell",
    crossAlign = "stretch",
    spacing = 0,
    children = {
      -- 顶栏：纯色玫红，高 8.5vh
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
            background = C.sidebar,
            crossAlign = "center",
            padding = { left = "2vh", right = "2vh", top = "2.5vh", bottom = "2vh" },
            spacing = "0.6vh",
            children = {
              -- 两枚并排：实心蓝「正版登录」 + 白底蓝描边全圆胶囊「离线登录」
              ui.row {
                id = "capsules",
                spacing = "2vh",
                crossAlign = "center",
                children = {
                  ui.button {
                    id = "cap.genuine", label = "正版登录", action = "open:accountManager",
                    height = "4.5vh", corner = "1vh", padding = { left = "1.5vh", right = "1.5vh" },
                    style = { background = C.accent, tint = C.white, font = "2.4vh", weight = "bold" },
                  },
                  ui.button {
                    id = "cap.offline", label = "离线登录", action = "open:accountManager",
                    height = "4.5vh", corner = "pill", padding = { left = "1.5vh", right = "1.5vh" },
                    border = { width = 1.5, color = C.accentBorder },
                    style = { background = C.white, tint = C.accent, font = "2.4vh", weight = "bold" },
                  },
                },
              },
              ui.spacer { weight = 2 },
              -- 头像占位：浅灰底 + 灰人物轮廓
              ui.image { id = "avatar", icon = "sf:person.crop.square", size = "10vh", background = C.lightGray, style = { tint = "#C0C0C0" } },
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
                    background = C.white, corner = "0.8vh", crossAlign = "center",
                    padding = { left = "1.2vh", right = "1.2vh" }, spacing = "1vh",
                    children = {
                      ui.text { id = "accountPickerLabel", text = "未登录", weight = 1, style = { font = "2.3vh", color = C.dark } },
                      ui.image { icon = "sf:chevron.down", size = "1.8vh", style = { tint = C.mid } },
                    },
                  },
                  ui.button {
                    id = "login", label = "登录", action = "open:accountManager",
                    width = "28%", height = "4.5vh", corner = "0.8vh",
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
              -- 启动游戏大按钮：白底大圆角（全左栏最大），两行文字
              ui.column {
                id = "launchBtn",
                action = "launch",
                width = "85%",
                height = "10vh",
                corner = "1.5vh",
                background = C.white,
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
                    style = { background = C.white, tint = C.dark, font = "2.4vh", weight = "bold" },
                  },
                  ui.button {
                    id = "versionSetup", label = "版本设置", action = "open:profileEditor",
                    weight = 1, height = "5.5vh", corner = "1vh",
                    style = { background = C.white, tint = C.dark, font = "2.4vh", weight = "bold" },
                  },
                },
              },
            },
          },
          -- 内容区：浅蓝灰底，承载 5 棵 Lua 页子树
          ui.content {
            id = "content",
            weight = 1,
            initialPage = "home",
            background = C.pageBg,
            children = {
              buildHomePage(),
              buildDownloadPage(),
              buildMultiPage(),
              buildSettingsPage(),
              buildMorePage(),
            },
          },
        },
      },
    },
  }
end

-- ===== 交互 =====

local selectedTab = nil

local function selectTab(tabId)
  selectedTab = tabId
  for _, t in ipairs(TABS) do
    local sel = (t.id == tabId)
    launcher.view(t.id):setStyle(sel
      and { background = C.white, tint = C.accent }
      or  { background = C.transparent, tint = C.white })
  end
end

-- 下载页分段标签选中态
local function selectDlRow(prefix, ids, selId)
  for _, key in ipairs(ids) do
    local id = prefix .. "." .. key
    local sel = (id == selId)
    launcher.view(id):setStyle(sel
      and { background = C.white, tint = C.dark }
      or  { background = C.transparent, tint = C.mid })
  end
end

local selectedDl1 = "1"
local selectedDl2 = "1"
local function resetDownloadSegments()
  selectDlRow("dl1", { 1, 2, 3, 4, 5, 6, 7 }, selectedDl1)
  selectDlRow("dl2", { 1, 2, 3, 4 }, selectedDl2)
end

-- 联机页分支切换
local function showMultiBranch(join)
  launcher.view("joinBranch"):setVisible(join)
  launcher.view("createBranch"):setVisible(not join)
  launcher.view("multiJoin"):setStyle(join
    and { background = C.white, tint = C.dark }
    or  { background = C.transparent, tint = C.mid })
  launcher.view("multiCreate"):setStyle(join
    and { background = C.transparent, tint = C.mid }
    or  { background = C.white, tint = C.dark })
end

local function refreshAccount(account)
  local name = (account and account.name and account.name ~= "") and account.name or "未登录"
  launcher.view("accountPickerLabel"):setText(name)
end

local function refreshVersion(version)
  local name = (version and version.name and version.name ~= "") and version.name or nil
  launcher.view("launchSub"):setText(name or "尚未选择版本")
end

function onReady()
  local state = launcher.state or {}
  selectTab("tab.home")
  refreshAccount(state.account)
  refreshVersion(state.version)
  resetDownloadSegments()
  showMultiBranch(true)
  -- 房间创建成功条默认隐藏（创建成功后由 onClick 点亮）
  launcher.view("createSuccess"):setVisible(false)
end

function onAccountChange(account)
  refreshAccount(account)
end

function onPageChange(page)
  local tabId = PAGE_TAB[page]
  if tabId then selectTab(tabId) end
  -- 仅启动页显示白左栏；其余页左栏坍缩、内容整幅铺开
  launcher.view("left"):setVisible(page == "home")
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
  if id == "createRoomBtn" then showMultiBranch(false); launcher.view("createSuccess"):setVisible(true) end
end