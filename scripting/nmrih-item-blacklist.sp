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
    version     = "0.1.0",
    url         = ""
};

char CLASSNAMES[][] = 
{
	"unknown",
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

enum NMRItemID
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

NMRItemID SC_DEFAULT_WEAPONS[] = 
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
	ME_AXE_FIRE,
	ME_BAT_METAL,
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
	ME_WRENCH,
};

NMRItemID SC_DEFAULT_MEDICAL[] = 
{
	ITEM_BANDAGES,
	ITEM_FIRST_AID,
	ITEM_GENE_THERAPY,
	ITEM_PILLS
};

NMRItemID SC_DEFAULT_AMMO[] =
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
	AMMOBOX_BOARD,
	AMMOBOX_FLARE,
	AMMOBOX_FUEL
};

stock Address operator+(Address base, int off) {
	return base + view_as<Address>(off);
}

// Profiler prof;
bool g_Blacklisted[MAX_ITEMS];
ConVar cvBlacklist;
ConVar cvSupplyHack;
ConVar cvVerbose;
ArrayList allowedCrateWeapons;
ArrayList allowedCrateMedical;
ArrayList allowedCrateAmmo;
int offs_itemCount;
int offs_itemIDs;
StringMap g_ItemIDs;
bool lateloaded;

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	lateloaded = late;
	return APLRes_Success;
}

public void OnPluginStart()
{
	FeatureStatus status = GetFeatureStatus(FeatureType_Capability, "SDKHook_OnEntitySpawned");
	if (status != FeatureStatus_Available)
		SetFailState("Sourcemod 1.11 or higher required");
	 
	g_ItemIDs = new StringMap();
	for (int i = 1; i < sizeof(CLASSNAMES); i++)
		g_ItemIDs.SetValue(CLASSNAMES[i], i);

	GameData g = new GameData("item-blacklist.games");
	if (!g)
		SetFailState("Failed to open \"gamedata/item-blacklist.games.txt\"");

	offs_itemCount = g.GetOffset("CItem_InventoryBox::_itemCount");
	if (offs_itemCount == -1)
		SetFailState("Failed to get CItem_InventoryBox::_itemCount offset");

	offs_itemIDs = g.GetOffset("CItem_InventoryBox::_weaponItemIds");
	if (offs_itemIDs == -1)
		SetFailState("Failed to get CItem_InventoryBox::_weaponItemIds offset");

	delete g;

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
		LateRemoveBlacklisted();
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
		if (!IsValidEdict(e))
			continue;

		GetEntityClassname(e, classname, sizeof(classname));
		if (IsInventoryItem(e) && IsBlacklistedItemClassname(classname))
		{
			int owner = GetEntPropEnt(e, Prop_Data, "m_hOwner");
			if (0 < owner <= MaxClients)
				SDKHooks_DropWeapon(owner, e);
			RemoveEntity(e);
			continue;
		}

		if (StrEqual(classname, "item_inventory_box"))
			OnInventoryBoxSpawned(e);
	}
}

void BuildWhitelists()
{
	allowedCrateMedical.Clear();
	allowedCrateWeapons.Clear();
	allowedCrateAmmo.Clear();

	for (int i; i < sizeof(g_Blacklisted); i++)
		g_Blacklisted[i] = false;

	char buffer[1024];
	cvBlacklist.GetString(buffer, sizeof(buffer));

	char ids[MAX_ITEMS][3];
	int numIDs = ExplodeString(buffer, " ", ids, sizeof(ids), sizeof(ids[]));

	for (int i; i < numIDs; i++)
	{
		NMRItemID id = view_as<NMRItemID>(StringToInt(ids[i]));
		if (IsValidItemID(id))
			g_Blacklisted[id] = true;
	}

	for (int i; i < sizeof(SC_DEFAULT_WEAPONS); i++)
		if (!IsItemBlacklisted(SC_DEFAULT_WEAPONS[i]))
			allowedCrateWeapons.Push(SC_DEFAULT_WEAPONS[i]);

	for (int i; i < sizeof(SC_DEFAULT_MEDICAL); i++)
		if (!IsItemBlacklisted(SC_DEFAULT_MEDICAL[i]))
			allowedCrateMedical.Push(SC_DEFAULT_MEDICAL[i]);

	for (int i; i < sizeof(SC_DEFAULT_AMMO); i++)
		if (!IsItemBlacklisted(SC_DEFAULT_AMMO[i]))
			allowedCrateAmmo.Push(SC_DEFAULT_AMMO[i]);
}

public void OnEntitySpawned(int entity, const char[] classname)
{
	if (StrEqual(classname, "item_inventory_box"))
	{
		OnInventoryBoxSpawned(entity);
		return;
	}

	NMRItemID itemID;
	if (g_ItemIDs.GetValue(classname, itemID) && IsItemBlacklisted(itemID))
	{
		if (cvVerbose.BoolValue)
			PrintToServer(PREFIX ... "Prevented spawning %s", classname);
		RemoveEntity(entity);
	}
}

void OnInventoryBoxSpawned(int box)
{
	Address base = GetEntityAddress(box);
	Address items = base + offs_itemIDs;
	
	for (int i; i < ITEMBOX_MAX_ITEMS; i++, items += 4)
	{
		NMRItemID originalID = view_as<NMRItemID>(LoadFromAddress(items, NumberType_Int32));
		if (!IsItemBlacklisted(originalID))
			continue;

		if (cvSupplyHack.IntValue == 2)
		{
			StoreToAddress(items, -1, NumberType_Int32);
			Address addrItemCount = base + offs_itemCount;
			int n = LoadFromAddress(addrItemCount, NumberType_Int32);
			StoreToAddress(addrItemCount, --n, NumberType_Int32);

			if (cvVerbose.BoolValue)
				PrintToServer(PREFIX ... "Supply crate patch: deleted %s", CLASSNAMES[originalID]);
			continue;
		}

		ArrayList alternatives;
		if (i < 8)
			alternatives = allowedCrateWeapons;
		else if (i < 12)
			alternatives = allowedCrateMedical;
		else if (i < 20)
			alternatives = allowedCrateAmmo;

		int numAlternatives = alternatives.Length;
		if (!numAlternatives)
			continue;

		int rnd = GetRandomInt(0, --numAlternatives);
		int alternativeID = alternatives.Get(rnd);
		StoreToAddress(items, alternativeID, NumberType_Int32);

		if (cvVerbose.BoolValue)
			PrintToServer(PREFIX ... "Supply crate patch: replaced %s with %s", 
				CLASSNAMES[originalID], CLASSNAMES[alternativeID]);
	}
}

bool IsItemBlacklisted(NMRItemID itemID)
{
	if (!IsValidItemID(itemID))
		ThrowError("Invalid item ID %d", itemID);
	return g_Blacklisted[itemID];
}

bool IsValidItemID(NMRItemID itemID)
{
	return INVALID_ITEM < itemID < MAX_ITEMS;
}

bool IsBlacklistedItemID(NMRItemID itemID)
{
	return IsValidItemID(itemID) && g_Blacklisted[itemID];
}

bool IsBlacklistedItemClassname(const char[] classname)
{
	NMRItemID itemID;
	g_ItemIDs.GetValue(classname, itemID);
	return IsBlacklistedItemID(itemID);
}

bool IsInventoryItem(int item)
{
	return HasEntProp(item, Prop_Send, "m_iClip1") || 
		HasEntProp(item, Prop_Send, "m_szAmmoName");
}
