-- PCL II 复刻 —— 按用户提供的《PCL II 启动器 UI 复刻规格说明（结构版 · 比例适配）》1:1 还原
--
-- 基准：窗口高 1H、宽 ≈ 2H，所有尺寸按 H 比例；尺寸基准取 12.9" iPad 横屏（H≈1024），
-- phone 尺寸类走 responsive.phone 覆盖。配色与结构全部取自规格说明：
--   顶栏 #0A5FC4 通栏；侧栏 #FFFFFF；内容区浅蓝对角渐变 #E3EEF9 → #D5E5F5
--   强调蓝 #0B84FF；主文字 #333333；次要文字 #999999；卡片描边 #D9E4F0
--   左栏宽 32%；启动按钮两行文字（主行 + 灰色副行）；顶栏选中页签白色全圆药丸
--
-- v1.2.0（黑边/页面导航/背景三修复）：
--   1. shell/page 行 spacing=0 —— 缺省 8pt 间距是透明缝，透出黑色窗口底形成"黑边"
--   2. 大面积底色改 8 位半透明 hex —— 壁纸可透过顶栏/侧栏/内容渐变显示（PCL2 带背景图行为）
--   3. 更多页签 → open:more（聚合页）；非启动页收起左栏，内容区全幅铺开（PCL2 导航行为）

local C = {
  topbar      = "#E60A5FC4", -- 顶栏蓝（90%：透出壁纸，无壁纸时叠浅色底不变样）
  accent      = "#0B84FF",   -- 强调蓝（药丸选中文字/描边）
  text        = "#333333",   -- 主文字
  textSub     = "#999999",   -- 次要文字
  sidebar     = "#E6FFFFFF", -- 侧栏白（90%）
  cardWhite   = "#E6FFFFFF", -- 卡片/按钮白（90%）
  cardBorder  = "#D9E4F0",   -- 卡片/控件描边
  gradFrom    = "#B3E3EEF9", -- 内容区渐变起点（70%：半透明遮罩叠壁纸）
  gradTo      = "#B3D5E5F5", -- 内容区渐变终点（70%）
  btnBorder   = "#C9D6E8",   -- 普通按钮细蓝灰描边
  white       = "#FFFFFF",
  transparent = "#00000000",
}

-- 顶栏五个页签（PCL2：启动/下载/联机/设置/更多）
local TABS = {
  { id = "tab.home",       label = "启动", icon = "sf:house.fill",                        action = "open:home",       page = "home" },
  { id = "tab.download",   label = "下载", icon = "sf:arrow.down.circle.fill",            action = "open:download",   page = "download" },
  { id = "tab.multi",      label = "联机", icon = "sf:antenna.radiowaves.left.and.right", action = "open:multiplayer" },
  { id = "tab.setup",      label = "设置", icon = "sf:gearshape.fill",                    action = "open:settings",   page = "settings" },
  { id = "tab.other",      label = "更多", icon = "sf:ellipsis.circle.fill",              action = "open:more",       page = "more" },
}

local function tabNode(t)
  return ui.button {
    id = t.id,
    label = t.label,
    icon = t.icon,
    action = t.action,
    height = ui.dimen({ phone = 30, pad = 44 }),   -- 药丸高 ≈ 0.05H
    corner = "pill",
    padding = { left = 18, right = 18 },
    style = { tint = C.white, font = 15 },
  }
end

-- 胶囊（账号方式：正版登录 / 离线登录）
local function capsule(id, label, selected)
  return ui.button {
    id = id,
    label = label,
    height = ui.dimen({ phone = 26, pad = 34 }),   -- 胶囊高 ≈ 0.037H
    corner = "pill",
    padding = { left = 16, right = 16 },
    style = selected
      and { background = C.accent, tint = C.white, font = 13 }
      or  { background = C.cardWhite, tint = C.accent, font = 13 },
    border = selected and nil or { width = 1, color = C.accent },
  }
end

function describe()
  return { name = "PCL II 复刻", author = "Pear", version = "1.2.0" }
end

function build(ui)
  return ui.column {
    id = "shell",
    -- stretch：顶栏/页面行宽度铺满（缺省按内容测量会导致整链坍缩成窄条）
    crossAlign = "stretch",
    spacing = 0,   -- 缺省 8pt 间距是透明缝：透出窗口底色形成黑边，必须显式归零
    children = {
      -- ===== 一、顶栏（通栏蓝 #0A5FC4，高 ≈ 0.085H）=====
      ui.row {
        id = "titlebar",
        height = ui.dimen({ phone = 48, pad = 80 }),
        background = C.topbar,
        padding = { left = 20, right = 16 },
        spacing = 18,
        crossAlign = "center",
        children = {
          ui.text { id = "logo", text = "Pear", style = { font = 26, weight = "bold", color = C.white } },
          ui.spacer { weight = 1 },
          -- 五个页签居中（加权空隙对称）
          ui.row {
            id = "tabs",
            spacing = 14,
            crossAlign = "center",
            children = (function()
              local nodes = {}
              for _, t in ipairs(TABS) do nodes[#nodes + 1] = tabNode(t) end
              return nodes
            end)(),
          },
          ui.spacer { weight = 1 },
          -- 右侧「—」「✕」白线图标（视觉还原；iOS 无窗口控制语义）
          ui.image { id = "winMin", icon = "sf:minus", size = ui.dimen({ phone = 13, pad = 18 }), style = { tint = C.white } },
          ui.image { id = "winClose", icon = "sf:xmark", size = ui.dimen({ phone = 13, pad = 18 }), style = { tint = C.white } },
        },
      },
      -- ===== 二、启动页：左栏 32% 白底 + 右区 68% 浅蓝对角渐变 =====
      ui.row {
        id = "page",
        weight = 1,
        crossAlign = "stretch",   -- 左栏/内容区高度铺满（否则内容区高 0 黑屏）
        spacing = 0,              -- 左栏与内容区之间不留透明缝（黑边根治）
        children = {
          ui.column {
            id = "left",
            width = "32%",
            background = C.sidebar,
            crossAlign = "center",
            padding = { left = 20, right = 20, top = 24, bottom = 22 },
            spacing = 8,
            children = {
              -- 账号方式胶囊（两枚并排，间距 ≈ 0.02H）
              ui.row {
                id = "capsules",
                spacing = 18,
                children = { capsule("cap.genuine", "正版登录", true), capsule("cap.offline", "离线登录", false) },
              },
              ui.spacer { weight = 1 },
              -- 头像（未登录：灰色线条人物轮廓）
              ui.image {
                id = "avatar",
                icon = "sf:person.crop.square",
                size = ui.dimen({ phone = 64, pad = 104 }),   -- ≈ 0.11H 见方
                style = { tint = "#C7C7C7" },
              },
              -- 账号行：下拉框（72%）+ 登录按钮（28%），高 ≈ 0.035H
              ui.row {
                id = "accountRow",
                width = "85%",
                height = ui.dimen({ phone = 32, pad = 38 }),
                spacing = 10,
                children = {
                  ui.button {
                    id = "accountPicker",
                    label = "未登录",
                    icon = "sf:chevron.down",
                    action = "open:accountManager",
                    weight = 1,
                    corner = 4,
                    padding = { left = 12, right = 12 },
                    border = { width = 1, color = C.cardBorder },
                    style = { background = C.cardWhite, tint = C.text, font = 13 },
                  },
                  ui.button {
                    id = "login",
                    label = "登录",
                    action = "open:accountManager",
                    width = "28%",
                    corner = 4,
                    border = { width = 1, color = C.accent },
                    style = { background = C.cardWhite, tint = C.accent, font = 13 },
                  },
                },
              },
              -- 次要链接（灰色小字，» 开头）
              ui.row {
                id = "links",
                spacing = 22,
                children = {
                  ui.text { text = "» 购买正版", style = { font = 12, color = C.textSub } },
                  ui.text { text = "» 更换皮肤", style = { font = 12, color = C.textSub } },
                },
              },
              ui.spacer { weight = 2 },
              -- 启动游戏主按钮（白底蓝描边，两行文字，高 ≈ 0.1H）
              ui.column {
                id = "launchBtn",
                action = "launch",
                width = "85%",
                height = ui.dimen({ phone = 58, pad = 90 }),
                background = C.cardWhite,
                border = { width = 1.5, color = C.accent },
                corner = 7,
                justify = "center",
                crossAlign = "center",
                spacing = 3,
                children = {
                  ui.text { id = "launchTitle", text = "启动游戏", style = { font = 22, weight = "bold", color = C.text } },
                  ui.text { id = "launchSub", text = "尚未选择版本", style = { font = 12, color = C.textSub } },
                },
              },
              -- 版本选择 / 版本设置（贴底，各占 48%，高 ≈ 0.055H）
              ui.row {
                id = "versionRow",
                width = "85%",
                height = ui.dimen({ phone = 40, pad = 52 }),
                spacing = 12,
                children = {
                  ui.button {
                    id = "pickVersion",
                    label = "选择版本",
                    action = "open:versionManager",
                    weight = 1,
                    corner = 6,
                    border = { width = 1, color = C.btnBorder },
                    style = { background = C.cardWhite, tint = C.text, font = 14 },
                  },
                  ui.button {
                    id = "versionSetup",
                    label = "版本设置",
                    action = "open:profileEditor",
                    weight = 1,
                    corner = 6,
                    border = { width = 1, color = C.btnBorder },
                    style = { background = C.cardWhite, tint = C.text, font = 14 },
                  },
                },
              },
            },
          },
          -- 右区：浅蓝对角渐变（装饰底，原生功能页透明叠加其上）
          ui.content {
            id = "content",
            weight = 1,
            initialPage = "home",
            background = { from = C.gradFrom, to = C.gradTo, angle = 45 },
          },
        },
      },
    },
  }
end

-- ===== 交互（规格第七节：顶栏药丸随页签切换；页面变化跟随真实内容页）=====

local selectedTab = nil

local function selectTab(tabId)
  selectedTab = tabId
  for _, t in ipairs(TABS) do
    local sel = (t.id == tabId)
    launcher.view(t.id):setStyle(sel
      and { background = C.white, tint = C.accent }   -- 选中药丸纯白（规格：白色全圆药丸）
      or  { background = C.transparent, tint = C.white })
  end
end

-- 页面标识 → 页签（二级页如版本设置不改页签选中态，与 PCL2 一致）
local PAGE_TAB = {
  home = "tab.home",
  download = "tab.download",
  multiplayer = "tab.multi",
  settings = "tab.setup",
  more = "tab.other",
}

local function refreshAccount(account)
  local name = (account and account.name and account.name ~= "") and account.name or "未登录"
  launcher.view("accountPicker"):setText(name)
end

local function refreshVersion(version)
  local name = (version and version.name and version.name ~= "") and version.name or nil
  launcher.view("launchSub"):setText(name or "尚未选择版本")
  launcher.view("launchTitle"):setText(name and "启动游戏" or "启动游戏")
end

function onReady()
  local state = launcher.state or {}
  selectTab("tab.home")
  refreshAccount(state.account)
  refreshVersion(state.version)
end

function onAccountChange(account)
  refreshAccount(account)
end

function onPageChange(page)
  local tabId = PAGE_TAB[page]
  if tabId then selectTab(tabId) end
  -- PCL2 导航行为：左栏启动区（账号/启动按钮）仅存在于启动页；
  -- 其余页面收起左栏，内容区全幅铺开（隐藏节点在布局引擎中坍缩为零尺寸）
  launcher.view("left"):setVisible(page == "home")
end

function onClick(id)
  -- 页签点击即时高亮（页面切换事件随后到达做最终同步）
  for _, t in ipairs(TABS) do
    if t.id == id then selectTab(t.id) end
  end
end
