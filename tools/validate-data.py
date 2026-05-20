#!/usr/bin/env python3
"""validate-data.py - Cross-reference validator cho Naruto Roblox JSON data files.
Chay: python3 tools/validate-data.py
Tu thu muc goc cua project (naruto_roblox/)
"""

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

# ============================================================
# Load all files
# ============================================================
data = {}
print("Loading files...")
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

# ============================================================
# Build ID registries
# ============================================================
item_ids    = {i["id"] for i in data["items"]["items"]} if data["items"] else set()
jutsu_ids   = {j["id"] for j in data["jutsu"]["jutsu"]} if data["jutsu"] else set()
boss_ids    = set(data["balance"].get("bossStats", {}).get("bosses", {}).keys()) if data["balance"] else set()

npc_ids    = set()
enemy_ids  = set()
if data["npc"]:
    for npc in data["npc"].get("npcs", []):
        npc_ids.add(npc["id"])
        if npc.get("type") == "enemy":
            enemy_ids.add(npc["id"])

# Build location_ids: top-level keys + all subLocations (flatten)
location_ids = set()
if data["npc"]:
    loc_dir = data["npc"].get("locationDirectory", {})
    for loc_key, loc_val in loc_dir.items():
        location_ids.add(loc_key)
        for sub in loc_val.get("subLocations", []):
            location_ids.add(sub)

quest_ids = set()
if data["quest"]:
    for q in data["quest"].get("quests", []):
        quest_ids.add(q["id"])

print("\nRegistries:")
print("  item_ids:    ", len(item_ids))
print("  jutsu_ids:   ", len(jutsu_ids))
print("  npc_ids:     ", len(npc_ids))
print("  enemy_ids:   ", len(enemy_ids))
print("  boss_ids:    ", len(boss_ids))
print("  location_ids:", len(location_ids))
print("  quest_ids:   ", len(quest_ids))

# ============================================================
# 1. balance-config: bossSchedule vs bossStats
# ============================================================
print("\n[1] balance-config: bossSchedule vs bossStats")
STORY_BOSSES = {"hakuren", "zaborax", "sazuki"}

if data["balance"]:
    schedule_bosses = set(data["balance"].get("eventSystem", {}).get("bossSchedule", {}).keys())
    for boss_id in schedule_bosses:
        if boss_id not in boss_ids:
            err("Boss '" + boss_id + "' co trong bossSchedule nhung khong co trong bossStats")
    for boss_id in boss_ids:
        if boss_id not in schedule_bosses and boss_id not in STORY_BOSSES:
            warn("Boss '" + boss_id + "' co trong bossStats nhung khong co trong bossSchedule")

    for boss_id, boss in data["balance"].get("bossStats", {}).get("bosses", {}).items():
        for tier, loot in (boss.get("lootTable") or {}).items():
            for iid in (loot.get("items") or []):
                if iid not in item_ids:
                    err("bossStats." + boss_id + ".lootTable." + tier + ": item '" + iid + "' not in item-definitions")

# ============================================================
# 2. npc-data: shop items, loot items
# ============================================================
print("[2] npc-data: shop items, loot items")
if data["npc"]:
    for npc in data["npc"].get("npcs", []):
        npc_id = npc.get("id", "?")

        shop = npc.get("shopInventory") or {}
        for item in shop.get("items", []):
            iid = item.get("id") or item.get("itemId")
            if iid and iid not in item_ids:
                err("NPC " + npc_id + " shop: item '" + iid + "' not in item-definitions")

        loot = npc.get("lootTable") or {}
        for tier, tier_data in (loot if isinstance(loot, dict) else {}).items():
            for iid in (tier_data.get("items") or []):
                if iid not in item_ids:
                    err("NPC " + npc_id + " lootTable." + tier + ": item '" + iid + "' not in item-definitions")

        special = npc.get("specialItem")
        if special:
            special_id = special.get("id") if isinstance(special, dict) else special
            if special_id and special_id not in item_ids:
                err("NPC " + npc_id + " specialItem '" + str(special_id) + "' not in item-definitions")

# ============================================================
# 3. item-definitions: jutsuRef, combineResult, bundleOf
# ============================================================
print("[3] item-definitions: jutsuRef, combineResult")
if data["items"]:
    for item in data["items"]["items"]:
        iid = item.get("id", "?")

        ref = item.get("jutsuRef")
        if ref and ref not in jutsu_ids:
            err("Item '" + iid + "' jutsuRef '" + ref + "' not in jutsu-definitions")

        cr = item.get("combineResult")
        if cr and cr not in item_ids:
            err("Item '" + iid + "' combineResult '" + cr + "' not in item-definitions")

        bo = item.get("bundleOf")
        if bo and bo not in item_ids:
            warn("Item '" + iid + "' bundleOf '" + bo + "' may be unregistered base item")

# ============================================================
# 4. quest-definitions: comprehensive checks
# ============================================================
print("[4] quest-definitions: full cross-reference")
if data["quest"]:
    for quest in data["quest"].get("quests", []):
        qid = quest.get("id", "?")

        # (a) questGiver in npc_ids
        giver = quest.get("questGiver")
        if giver is not None and giver not in npc_ids:
            err("Quest " + qid + " questGiver '" + giver + "' not in npc-data")

        # (b) location in location_ids
        loc = quest.get("location")
        if loc and loc not in location_ids:
            err("Quest " + qid + " location '" + loc + "' not in locationDirectory (including subLocations)")

        # (c) nextQuest in quest_ids
        nq = quest.get("nextQuest")
        if nq is not None and nq not in quest_ids:
            err("Quest " + qid + " nextQuest '" + nq + "' not in quest-definitions")

        # (d) prerequisiteQuests in quest_ids
        for pq in quest.get("prerequisiteQuests", []):
            if pq not in quest_ids:
                err("Quest " + qid + " prerequisiteQuests '" + pq + "' not in quest-definitions")

        # (e) prerequisiteQuestsAny in quest_ids
        for pq in quest.get("prerequisiteQuestsAny", []):
            if pq not in quest_ids:
                err("Quest " + qid + " prerequisiteQuestsAny '" + pq + "' not in quest-definitions")

        # (f/g) task refs: enemyIds, bossId
        for task in quest.get("tasks", []):
            tid = task.get("id", "?")
            for eid in task.get("enemyIds", []):
                if eid not in enemy_ids:
                    err("Quest " + qid + " task " + tid + " enemyId '" + eid + "' not in npc-data (type=enemy)")
            boss_ref = task.get("bossId")
            if boss_ref and boss_ref not in boss_ids:
                err("Quest " + qid + " task " + tid + " bossId '" + boss_ref + "' not in bossStats")

        # (h) rewards.items itemId
        for item_entry in quest.get("rewards", {}).get("items", []):
            iid = item_entry.get("itemId")
            if iid and iid not in item_ids:
                err("Quest " + qid + " rewards item '" + iid + "' not in item-definitions")

        # (j) unlockJutsu
        for jid in quest.get("unlockJutsu", []):
            if jid not in jutsu_ids:
                err("Quest " + qid + " unlockJutsu '" + jid + "' not in jutsu-definitions")

        # (i/j) choicePoint options
        for cp in quest.get("choicePoints", []):
            for opt in cp.get("options", []):
                ir = opt.get("itemReward")
                if ir and ir not in item_ids:
                    err("Quest " + qid + " cp." + cp["id"] + "." + opt["id"] + " itemReward '" + ir + "' not in item-definitions")
                for jid in opt.get("unlockJutsu", []):
                    if jid not in jutsu_ids:
                        err("Quest " + qid + " cp." + cp["id"] + "." + opt["id"] + " unlockJutsu '" + jid + "' not in jutsu-definitions")

# ============================================================
# 5. jutsu source refs
# ============================================================
print("[5] jutsu-definitions: source item refs")
if data["jutsu"]:
    for jutsu in data["jutsu"].get("jutsu", []):
        jid = jutsu.get("id", "?")
        for source in jutsu.get("source", []):
            if ("_scroll" in source or "_fragment" in source) and source not in item_ids:
                warn("Jutsu " + jid + " source '" + source + "' looks like itemId but not in item-definitions")

# ============================================================
# 6. clan-data consistency
# ============================================================
print("[6] clan-data: noClanBonusSPCap")
if data["clan"] and data["balance"]:
    cap = data["balance"].get("skillPointSystem", {}).get("noClanBonusSPCap")
    note = data["clan"].get("balanceNotes", {}).get("noClanViability", "")
    if cap is not None and str(cap) not in note:
        warn("noClanBonusSPCap=" + str(cap) + " in balance-config but not reflected in clan-data balanceNotes")

# ============================================================
# Results
# ============================================================
print("\n" + "="*60)
if errors:
    print("ERRORS (" + str(len(errors)) + "):")
    for e in errors:
        print(e)
else:
    print("No errors!")

if warnings:
    print("\nWARNINGS (" + str(len(warnings)) + "):")
    for w in warnings:
        print(w)
else:
    print("No warnings.")

print("="*60)
if errors:
    sys.exit(1)
else:
    print("Validation PASSED.")
