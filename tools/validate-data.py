#!/usr/bin/env python3
"""validate-data.py - Cross-reference validator cho Naruto Roblox JSON data files."""

import json
import sys
from pathlib import Path

DATA_DIR = Path(__file__).parent.parent / "Data"
FILES = {
    "balance": DATA_DIR / "balance-config.json",
    "items":   DATA_DIR / "item-definitions.json",
    "jutsu":   DATA_DIR / "jutsu-definitions.json",
    "npc":     DATA_DIR / "npc-data.json",
    "clan":    DATA_DIR / "clan-data.json",
    "quest":   DATA_DIR / "quest-definitions.json",
}

errors = []
warnings = []

def err(msg):
    errors.append("  [ERROR] " + msg)

def warn(msg):
    warnings.append("  [WARN]  " + msg)

# --- Load all files ---
data = {}
for key, path in FILES.items():
    if not path.exists():
        warn("File khong ton tai: " + path.name)
        data[key] = None
        continue
    try:
        with open(path, encoding="utf-8") as f:
            data[key] = json.load(f)
        print("  OK  " + path.name)
    except json.JSONDecodeError as e:
        err("JSON parse loi tai " + path.name + ": " + str(e))
        data[key] = None

# --- Build ID sets ---
item_ids = {i["id"] for i in data["items"]["items"]} if data["items"] else set()
jutsu_ids = {j["id"] for j in data["jutsu"]["jutsu"]} if data["jutsu"] else set()
location_ids = set()
boss_stat_ids = set()

if data["npc"]:
    location_ids = set(data["npc"].get("locationDirectory", {}).keys())
    for zone in data["npc"].get("zones", []):
        for loc in zone.get("locations", []):
            if isinstance(loc, dict):
                location_ids.add(loc.get("id", ""))
            elif isinstance(loc, str):
                location_ids.add(loc)

if data["balance"]:
    boss_stat_ids = set(data["balance"].get("bossStats", {}).get("bosses", {}).keys())

# ============================================================
# 1. balance-config: bossSchedule vs bossStats
# ============================================================
print("\n[1] balance-config: bossSchedule vs bossStats")
STORY_BOSSES = {"hakuren", "zaborax", "sazuki"}  # story bosses - khong can bossSchedule

if data["balance"]:
    schedule_bosses = set(data["balance"].get("eventSystem", {}).get("bossSchedule", {}).keys())
    for boss_id in schedule_bosses:
        if boss_id not in boss_stat_ids:
            err("Boss '" + boss_id + "' co trong bossSchedule nhung khong co trong bossStats")
    for boss_id in boss_stat_ids:
        if boss_id not in schedule_bosses and boss_id not in STORY_BOSSES:
            warn("Boss '" + boss_id + "' co trong bossStats nhung khong co trong bossSchedule")

    for boss_id, boss in data["balance"].get("bossStats", {}).get("bosses", {}).items():
        for tier, loot in (boss.get("lootTable") or {}).items():
            for item_id in (loot.get("items") or []):
                if item_id not in item_ids:
                    err("bossStats." + boss_id + ".lootTable." + tier + ": item '" + item_id + "' khong co trong item-definitions")

# ============================================================
# 2. npc-data: shop items, loot items, location refs
# ============================================================
print("[2] npc-data: shop items, loot items, locations")
if data["npc"]:
    for npc in data["npc"].get("npcs", []):
        npc_id = npc.get("id", "?")

        shop = npc.get("shopInventory") or {}
        for item in shop.get("items", []):
            iid = item.get("id") or item.get("itemId")
            if iid and iid not in item_ids:
                err("NPC " + npc_id + " shop: item '" + iid + "' khong co trong item-definitions")

        loot = npc.get("lootTable") or {}
        for tier, tier_data in (loot if isinstance(loot, dict) else {}).items():
            for item_id in (tier_data.get("items") or []):
                if item_id not in item_ids:
                    err("NPC " + npc_id + " lootTable." + tier + ": item '" + item_id + "' khong co trong item-definitions")

        special = npc.get("specialItem")
        if special:
            special_id = special.get("id") if isinstance(special, dict) else special
            if special_id and special_id not in item_ids:
                err("NPC " + npc_id + " specialItem: '" + special_id + "' khong co trong item-definitions")

        loc = npc.get("primaryLocation")
        if loc and loc not in location_ids:
            warn("NPC " + npc_id + " primaryLocation: '" + loc + "' khong co trong locationDirectory")

# ============================================================
# 3. item-definitions: jutsuRef, combineResult, bundleOf
# ============================================================
print("[3] item-definitions: jutsuRef, combineResult")
if data["items"]:
    for item in data["items"]["items"]:
        iid = item.get("id", "?")

        jutsu_ref = item.get("jutsuRef")
        if jutsu_ref and jutsu_ref not in jutsu_ids:
            err("Item '" + iid + "' jutsuRef: '" + jutsu_ref + "' khong co trong jutsu-definitions")

        combine_result = item.get("combineResult")
        if combine_result and combine_result not in item_ids:
            err("Item '" + iid + "' combineResult: '" + combine_result + "' khong co trong item-definitions")

        bundle_of = item.get("bundleOf")
        if bundle_of and bundle_of not in item_ids:
            warn("Item '" + iid + "' bundleOf: '" + bundle_of + "' co the la base item chua dang ky")

# ============================================================
# 4. quest-definitions: reward items, unlockJutsu
# ============================================================
print("[4] quest-definitions: reward items, unlockJutsu")
if data["quest"]:
    for quest in data["quest"].get("quests", []):
        qid = quest.get("id", "?")

        for item_entry in quest.get("rewards", {}).get("items", []):
            iid = item_entry.get("itemId")
            if iid and iid not in item_ids:
                err("Quest " + qid + " reward: item '" + iid + "' khong co trong item-definitions")

        for jutsu_id in quest.get("unlockJutsu", []):
            if jutsu_id not in jutsu_ids:
                err("Quest " + qid + " unlockJutsu: '" + jutsu_id + "' khong co trong jutsu-definitions")

        for cp in quest.get("choicePoints", []):
            for opt in cp.get("options", []):
                item_reward = opt.get("itemReward")
                if item_reward and item_reward not in item_ids:
                    err("Quest " + qid + " cp." + cp["id"] + "." + opt["id"] + " itemReward: '" + item_reward + "' khong co trong item-definitions")
                for jutsu_id in opt.get("unlockJutsu", []):
                    if jutsu_id not in jutsu_ids:
                        err("Quest " + qid + " cp." + cp["id"] + "." + opt["id"] + " unlockJutsu: '" + jutsu_id + "' khong co trong jutsu-definitions")

# ============================================================
# 5. jutsu-definitions: source refs
# ============================================================
print("[5] jutsu-definitions: source item refs")
if data["jutsu"]:
    for jutsu in data["jutsu"].get("jutsu", []):
        jid = jutsu.get("id", "?")
        for source in jutsu.get("source", []):
            if ("_scroll" in source or "_fragment" in source) and source not in item_ids:
                warn("Jutsu " + jid + " source: '" + source + "' looks like item ID but not in item-definitions")

# ============================================================
# 6. clan-data: noClanBonusSPCap consistency
# ============================================================
print("[6] clan-data: noClanBonusSPCap consistency")
if data["clan"] and data["balance"]:
    cap = data["balance"].get("skillPointSystem", {}).get("noClanBonusSPCap")
    note = data["clan"].get("balanceNotes", {}).get("noClanViability", "")
    if cap is not None and str(cap) not in note:
        warn("noClanBonusSPCap=" + str(cap) + " trong balance-config nhung khong khop clan-data balanceNotes")

# ============================================================
# Ket qua
# ============================================================
print("\n" + "="*60)
if errors:
    print("ERRORS (" + str(len(errors)) + "):")
    for e in errors:
        print(e)
else:
    print("Khong co loi!")

if warnings:
    print("\nWARNINGS (" + str(len(warnings)) + "):")
    for w in warnings:
        print(w)
else:
    print("Khong co warning.")

print("="*60)
if errors:
    sys.exit(1)
else:
    print("Validation PASSED.")
