#!/usr/bin/env python3
"""UI pack 校验脚本，供 GitHub Actions 调用。

用法：
  python3 validate_pack.py manifest --file=main.lua --colors=colors.json
  python3 validate_pack.py colors
"""
import json
import sys


def check_manifest(file, colors):
    with open("manifest.json", encoding="utf-8") as f:
        js = json.load(f)
    assert js.get("schemaVersion") == 2, "schemaVersion 必须为 2"
    assert js.get("id"), "缺少 id"
    assert js.get("name"), "缺少 name"
    version = js.get("version")
    assert version, "缺少 version"
    assert js.get("entry") == file, f"entry 必须为 {file}"
    assert js.get("colors") == colors, f"colors 必须为 {colors}"
    for path in (file, colors):
        with open(path, encoding="utf-8") as g:
            assert g.read(), f"{path} 为空"
    print(f"manifest OK  version={version}")


def check_colors():
    with open("colors.json", encoding="utf-8") as f:
        c = json.load(f)
    for key in ("topbar", "card", "accent", "hover", "cardBorder", "accentBorder"):
        assert key in c, f"colors.json 缺少键 {key}"
    print("colors OK")


def main():
    cmd = sys.argv[1]
    if cmd == "manifest":
        args = dict(a.lstrip("-").split("=", 1) for a in sys.argv[2:])
        check_manifest(args["file"], args["colors"])
    elif cmd == "colors":
        check_colors()
    else:
        raise SystemExit(f"未知命令 {cmd}")


if __name__ == "__main__":
    main()