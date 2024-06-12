#include <sdkhooks>
#include <sdktools>

#pragma semicolon 1
#pragma newdecls required

#define ITEMBOX_MAX_ITEMS 20
#define PREFIX "[Item Blacklist] "

public Plugin myinfo = 
{
    name        = "[NMRiH] Item Blacklist",
    author      = "Dysphie",
    description = "Prevents specified inventory items from spawning",
    version     = "0.3.4",
    url         = "https://github.com/dysphie/nmrih-item-blacklist"
};

enum
{
	METHOD_IGNORE,
	METHOD_REPLACE,
	METHOD_REMOVE
}

char WEAPON_ALIASES[][] = 
{
	"none",
	"fa_glock17",
	"fa_m92fs",
	"fa_mkiii",
	"fa_1911",
	"fa_sw686",
	"fa_870",
	"fa_superx3",
	"fa_sv10",
	"fa_500a",
	"fa_winchester1892",
	"fa_1022",
	"fa_1022_25mag",
	"fa_sks",
	"fa_sako85",
	"fa_cz858",
	"fa_jae700",
	"fa_fnfal",
	"fa_mac10",
	"fa_mp5a3",
	"fa_m16a4",
	"fa_m16a4_carryhandle",
	"bow_deerhunter",
	"tool_barricade",
	"tool_extinguisher",
	"tool_flare_gun",
	"tool_welder",
	"me_axe_fire",
	"me_bat_metal",
	"me_crowbar",
	"me_chainsaw",
	"me_abrasivesaw",
	"me_etool",
	"me_fists",
	"me_fubar",
	"me_hatchet",
	"me_kitknife",
	"me_machete",
	"me_pipe_lead",
	"me_shovel",
	"me_sledge",
	"me_wrench",
	"item_maglite",
	"item_walkietalkie",
	"item_pills",
	"item_first_aid",
	"item_gene_therapy",
	"item_bandages",
	"item_zippo",
	"exp_grenade",
	"exp_molotov",
	"exp_tnt",
	"ammobox_9mm",
	"ammobox_45acp",
	"ammobox_357",
	"ammobox_12gauge",
	"ammobox_22lr",
	"ammobox_308",
	"ammobox_556",
	"ammobox_762mm",
	"ammobox_arrow",
	"ammobox_board",
	"ammobox_fuel",
	"ammobox_flare",
	"me_pickaxe",
	"me_cleaver",
	"fa_sks_nobayo",
	"fa_sako85_ironsights"
};

enum
{
	INVALID_ITEM,
	FA_GLOCK17 = 1, 
	FA_M92FS, 
	FA_MKIII, 
	FA_1911, 
	FA_SW686, 
	FA_870, 
	FA_SUPERX3, 
	FA_SV10, 
	FA_500A, 
	FA_WINCHESTER1892, 
	FA_1022, 
	FA_1022_25MAG, 
	FA_SKS, 
	FA_SAKO85, 
	FA_CZ858, 
	FA_JAE700, 
	FA_FNFAL, 
	FA_MAC10, 
	FA_MP5A3, 
	FA_M16A4, 
	FA_M16A4_CARRYHANDLE, 
	BOW_DEERHUNTER, 
	TOOL_BARRICADE, 
	TOOL_EXTINGUISHER, 
	TOOL_FLARE_GUN, 
	TOOL_WELDER, 
	ME_AXE_FIRE, 
	ME_BAT_METAL, 
	ME_CROWBAR, 
	ME_CHAINSAW, 
	ME_ABRASIVESAW, 
	ME_ETOOL, 
	ME_FISTS, 
	ME_FUBAR, 
	ME_HATCHET, 
	ME_KITKNIFE, 
	ME_MACHETE, 
	ME_PIPE_LEAD, 
	ME_SHOVEL, 
	ME_SLEDGE, 
	ME_WRENCH, 
	ITEM_MAGLITE, 
	ITEM_WALKIETALKIE, 
	ITEM_PILLS, 
	ITEM_FIRST_AID, 
	ITEM_GENE_THERAPY, 
	ITEM_BANDAGES, 
	ITEM_ZIPPO, 
	EXP_GRENADE, 
	EXP_MOLOTOV, 
	EXP_TNT, 
	AMMOBOX_9MM, 
	AMMOBOX_45ACP, 
	AMMOBOX_357, 
	AMMOBOX_12GAUGE, 
	AMMOBOX_22LR, 
	AMMOBOX_308, 
	AMMOBOX_556, 
	AMMOBOX_762MM, 
	AMMOBOX_ARROW, 
	AMMOBOX_BOARD, 
	AMMOBOX_FUEL, 
	AMMOBOX_FLARE, 
	ME_PICKAXE, 
	ME_CLEAVER, 
	FA_SKS_NOBAYO, 
	FA_SAKO85_IRONSIGHTS,
	MAX_ITEMS
};

int SC_DEFAULT_WEAPONS[] = 
{
	BOW_DEERHUNTER,
	FA_1022,
	FA_1022_25MAG,
	FA_1911,
	FA_500A,
	FA_870,
	FA_CZ858,
	FA_FNFAL,
	FA_GLOCK17,
	FA_JAE700,
	FA_M16A4,
	FA_M16A4_CARRYHANDLE,
	FA_M92FS,
	FA_MAC10,
	FA_MKIII,
	FA_MP5A3,
	FA_SAKO85,
	FA_SAKO85_IRONSIGHTS,
	FA_SKS,
	FA_SKS_NOBAYO,
	FA_SUPERX3,
	FA_SV10,
	FA_SW686,
	FA_WINCHESTER1892,
	ME_ABRASIVESAW,
	ME_AXE_FIRE,
	ME_BAT_METAL,
	ME_CHAINSAW,
	ME_CLEAVER,
	ME_CROWBAR,
	ME_ETOOL,
	ME_FUBAR,
	ME_HATCHET,
	ME_KITKNIFE,
	ME_MACHETE,
	ME_PICKAXE,
	ME_PIPE_LEAD,
	ME_SHOVEL,
	ME_SLEDGE,
	ME_WRENCH
};

int SC_DEFAULT_MEDICAL[] = 
{
	ITEM_BANDAGES,
	ITEM_FIRST_AID,
	ITEM_GENE_THERAPY,
	ITEM_PILLS
};

int SC_DEFAULT_AMMO[] =
{
	AMMOBOX_12GAUGE,
	AMMOBOX_22LR,
	AMMOBOX_308,
	AMMOBOX_357,
	AMMOBOX_45ACP,
	AMMOBOX_556,
	AMMOBOX_762MM,
	AMMOBOX_9MM,
	AMMOBOX_ARROW,
	AMMOBOX_FLARE,
	AMMOBOX_FUEL
};

// Profiler prof;
bool g_Blacklisted[MAX_ITEMS] = { false, ...};
ConVar cvBlacklist;
ConVar cvSupplyHack;
ConVar cvVerbose;
ArrayList allowedCrateWeapons;
ArrayList allowedCrateMedical;
ArrayList allowedCrateAmmo;
int off_itemIDs = -1;
StringMap g_ItemIDs;
bool lateloaded;
StringMap ammoMdlToType;

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	lateloaded = late;
	return APLRes_Success;
}

public void OnPluginStart()
{
	// Game doesn't properly populate CItem_AmmoBox->m_hAmmoFileInfo->m_szAmmoType nor
	// CItem_AmmoBox->m_szAmmoName so let's just infer it from their model
	ammoMdlToType = new StringMap();
	ammoMdlToType.SetString("models/items/ammo/ammo_762.mdl", "ammobox_762mm");
	ammoMdlToType.SetString("models/items/ammo/ammo_arrow_box.mdl", "ammobox_arrow");
	ammoMdlToType.SetString("models/items/ammo/ammo_arrow_single.mdl", "ammobox_arrow");
	ammoMdlToType.SetString("models/items/ammo/ammo_flares.mdl", "ammobox_flare");
	ammoMdlToType.SetString("models/items/ammo/ammo_gascan.mdl", "ammobox_fuel");
	ammoMdlToType.SetString("models/items/ammo/ammo_9mm.mdl", "ammobox_9mm");
	ammoMdlToType.SetString("models/items/ammo/ammo_12g.mdl", "ammobox_12gauge");
	ammoMdlToType.SetString("models/items/ammo/ammo_22lr.mdl", "ammobox_22lr");
	ammoMdlToType.SetString("models/items/ammo/ammo_45acp.mdl", "ammobox_45acp");
	ammoMdlToType.SetString("models/items/ammo/ammo_308.mdl", "ammobox_308");
	ammoMdlToType.SetString("models/items/ammo/ammo_357.mdl", "ammobox_357");
	ammoMdlToType.SetString("models/items/ammo/ammo_556.mdl", "ammobox_556");
	ammoMdlToType.SetString("models/items/ammo/ammo_556.mdl", "ammobox_556");
	ammoMdlToType.SetString("models/weapons/tool_barricade/w_barricadeboard.mdl", "ammobox_board");

	g_ItemIDs = new StringMap();
	for (int i = 1; i < sizeof(WEAPON_ALIASES); i++)
		g_ItemIDs.SetValue(WEAPON_ALIASES[i], i);

	GameData gamedata = new GameData("item-blacklist.games");
	if (!gamedata)
	{
		SetFailState("Failed to open \"gamedata/item-blacklist.games.txt\"");
	}

	SetupOffsets(gamedata);

	delete gamedata;

	allowedCrateWeapons = new ArrayList();
	allowedCrateMedical = new ArrayList();
	allowedCrateAmmo = new ArrayList();

	cvSupplyHack = CreateConVar("item_blacklist_supply_patch_method", "1",
		"How to deal with blacklisted items in supply crates. \
		1 = Replace with item of same class, 2 = Leave slot empty");
	cvVerbose = CreateConVar("item_blacklist_verbose", "0", "Print item removals to console");
	cvBlacklist = CreateConVar("item_blacklist_ids", "", "Space separated list of weapon IDs to blacklist");
	cvBlacklist.AddChangeHook(OnBlacklistChanged);

	AutoExecConfig();
}

public void OnConfigsExecuted()
{
	BuildWhitelists();
	if (lateloaded)
	{
		LateRemoveBlacklisted();
	}
}

public void OnBlacklistChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
	BuildWhitelists();
	LateRemoveBlacklisted();
}

void LateRemoveBlacklisted()
{
	char classname[64];
	int maxEnts = GetMaxEntities();
	for (int e; e < maxEnts; e++)
	{
		if (IsValidEdict(e))
		{
			GetEntityClassname(e, classname, sizeof(classname));
			ProcessEntity(e, classname, true);
		}
	}
}

void BuildWhitelists()
{
	allowedCrateMedical.Clear();
	allowedCrateWeapons.Clear();
	allowedCrateAmmo.Clear();

	for (int i; i < sizeof(g_Blacklisted); i++)
	{
		g_Blacklisted[i] = false;
	}

	char buffer[1024];
	cvBlacklist.GetString(buffer, sizeof(buffer));

	char ids[MAX_ITEMS][3];
	int numIDs = ExplodeString(buffer, " ", ids, sizeof(ids), sizeof(ids[]));

	for (int i; i < numIDs; i++)
	{
		int id = StringToInt(ids[i]);
		if (IsValidItemID(id))
		{
			g_Blacklisted[id] = true;

			if (cvVerbose.BoolValue)
			{
				PrintToServer(PREFIX ... "Blacklisted %s", WEAPON_ALIASES[id]);
			}
		}
	}

	for (int i; i < sizeof(SC_DEFAULT_WEAPONS); i++)
		if (!g_Blacklisted[SC_DEFAULT_WEAPONS[i]])
			allowedCrateWeapons.Push(SC_DEFAULT_WEAPONS[i]);

	for (int i; i < sizeof(SC_DEFAULT_MEDICAL); i++)
		if (!g_Blacklisted[SC_DEFAULT_MEDICAL[i]])
			allowedCrateMedical.Push(SC_DEFAULT_MEDICAL[i]);

	for (int i; i < sizeof(SC_DEFAULT_AMMO); i++)
		if (!g_Blacklisted[SC_DEFAULT_AMMO[i]])
			allowedCrateAmmo.Push(SC_DEFAULT_AMMO[i]);
}

public void OnEntityCreated(int entity, const char[] classname)
{
	ProcessEntity(entity, classname, false);
}

void ProcessEntity(int entity, const char[] classname, bool spawned)
{
	if (cvSupplyHack.IntValue == METHOD_IGNORE)
	{
		return;
	}

	// NMRiH 1.12.0 is crashing if entities are removed on the frame 
	// they've been spawned, hence the RequestFrames

	if (StrEqual(classname, "item_inventory_box"))
	{
		SDKHook(entity, SDKHook_Use, OnInventoryBoxUse);
	}
	
	else if (StrEqual(classname, "item_ammo_box"))
	{
		RequestFrame(CheckAmmoModel, EntIndexToEntRef(entity));
	}

	else if (strncmp(classname, "fa_", 3) == 0 || 
		strncmp(classname, "me_", 3) == 0 || 
		strncmp(classname, "bow_", 4) == 0 || 
		strncmp(classname, "exp_", 4) == 0 || 
		strncmp(classname, "tool_", 5) == 0 || 
		strncmp(classname, "item_", 5) == 0)
	{
		if (CheckShouldRemove(entity, classname, spawned))
		{
			RequestFrame(FrameRemoveEntity, EntIndexToEntRef(entity));
		}
	}
}

void CheckAmmoModel(int entityRef)
{
	int entity = EntRefToEntIndex(entityRef);
	if (entity == -1)
		return;

	char buffer[512];
	GetEntPropString(entity, Prop_Data, "m_ModelName", buffer, sizeof(buffer));

	if (buffer[0] && ammoMdlToType.GetString(buffer, buffer, sizeof(buffer)) && IsAliasBlacklisted(buffer))
	{
		if (CheckShouldRemove(entity, buffer))
		{
			RemoveEntity(entity);
		}
	}
}

void FrameRemoveEntity(int entityRef)
{
	int entity = EntRefToEntIndex(entityRef);
	if (entity != -1)
		RemoveEntity(entity);
}

bool CheckShouldRemove(int entity, const char[] alias, bool clearOwner = false)
{
	if (!IsAliasBlacklisted(alias))
	{
		return false;
	}
	
	if (clearOwner && HasEntProp(entity, Prop_Data, "m_hOwner")) 
	{
		int owner = GetEntPropEnt(entity, Prop_Data, "m_hOwner");
		if (0 < owner <= MaxClients)
		{
			SDKHooks_DropWeapon(owner, entity);
		}
	}

	if (cvVerbose.BoolValue)
	{
		PrintToServer(PREFIX ... "Prevented spawning %s", alias);
	}

	return true;
}

bool IsAliasBlacklisted(const char[] alias)
{
	int itemID;
	return g_ItemIDs.GetValue(alias, itemID) && g_Blacklisted[itemID];
}

Action OnInventoryBoxUse(int box, int activator, int caller, UseType type, float value)
{	
	if (cvSupplyHack.IntValue == METHOD_IGNORE)
	{
		return Plugin_Continue;
	}

	for (int i; i < ITEMBOX_MAX_ITEMS; i++)
	{
		int originalID = InventoryBox_GetItem(box, i);
		if (!g_Blacklisted[originalID])
		{
			continue;
		}

		int replacementID = INVALID_ITEM;

		if (cvSupplyHack.IntValue == METHOD_REPLACE)
		{
			ArrayList alternatives;
			if (i < 8)
			{
				alternatives = allowedCrateWeapons;
			}
			else if (i < 12)
			{
				alternatives = allowedCrateMedical;
			}
			else if (i < 20)
			{
				alternatives = allowedCrateAmmo;
			}

			if (alternatives && alternatives.Length > 0)
			{
				int rnd = GetRandomInt(0,  alternatives.Length - 1);
				replacementID = alternatives.Get(rnd);
			}
		}

		InventoryBox_SetItem(box, i, replacementID);

		if (cvVerbose.BoolValue)
		{
			PrintToServer(PREFIX ... "Supply crate patch: replaced %s with %s", 
				WEAPON_ALIASES[originalID], WEAPON_ALIASES[replacementID]);
		}
	}

	return Plugin_Continue;
}

int InventoryBox_GetItem(int box, int index)
{
	return GetEntData(box, off_itemIDs + index * 4);
}

void InventoryBox_SetItem(int box, int index, int itemID)
{
	SetEntData(box, off_itemIDs + index * 4, itemID, 4);
}

bool IsValidItemID(int itemID)
{
	return INVALID_ITEM < itemID < MAX_ITEMS;
}

void SetupOffsets(GameData gamedata)
{
	off_itemIDs = gamedata.GetOffset("CItem_InventoryBox::_weaponItemIds");
	if (off_itemIDs == -1)
	{
		SetFailState("Failed to get CItem_InventoryBox::_weaponItemIds offset");
	}
}