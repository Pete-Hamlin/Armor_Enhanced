// Contains all available armor upgrades/hardpoints added to the game.

class ArmorEnhanced_Upgrades extends X2Item config(ArmorEnhanced_Upgrades);

var config int BASIC_PRICE, ADVANCED_PRICE, SUPERIOR_PRICE;

static function array<X2DataTemplate> CreateTemplates() {
    local array<X2DataTemplate> Upgrades;

    Upgrades.AddItem(CreateBasicAblativePadding());
    Upgrades.AddItem(CreateAdvancedAblativePadding());
    Upgrades.AddItem(CreateSuperiorAblativePadding());
    Upgrades.AddItem(CreateBasicArmorPlate());
    Upgrades.AddItem(CreateAdvancedArmorPlate());
    Upgrades.AddItem(CreateSuperiorArmorPlate());

    return Upgrades;
}

// #######################################################################################
// -------------------- UPGRADE FUNCTIONS ----------------------------------------------
// #######################################################################################


static function X2DataTemplate CreateBasicAblativePadding() {
    local X2WeaponUpgradeTemplate Template;
    `CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'AblativePadding_BscArmor')
    SetUpArmorGraphics_Blank(Template);
    SetUpTier1Upgrade(Template);

}

static function X2DataTemplate CreateAdvancedAblativePadding() {
    local X2WeaponUpgradeTemplate Template;
    `CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'AblativePadding_AdvArmor')
    SetUpArmorGraphics_Blank(Template);
    SetUpTier1Upgrade(Template);

}

static function X2DataTemplate CreateSuperiorAblativePadding() {
    local X2WeaponUpgradeTemplate Template;
    `CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'AblativePadding_SupArmor')
    SetUpArmorGraphics_Blank(Template);
    SetUpTier1Upgrade(Template);

}

static function X2DataTemplate CreateBasicArmorPlate() {
    local X2WeaponUpgradeTemplate Template;
    `CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'ArmorPlate_BscArmor')
    SetUpArmorGraphics_Blank(Template);
    SetUpTier1Upgrade(Template);

}

static function X2DataTemplate CreateAdvancedArmorPlate() {
    local X2WeaponUpgradeTemplate Template;
    `CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'ArmorPlate_AdvArmor')
    SetUpArmorGraphics_Blank(Template);
    SetUpTier1Upgrade(Template);

}

static function X2DataTemplate CreateSuperiorArmorPlate() {
    local X2WeaponUpgradeTemplate Template;
    `CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'ArmorPlate_SupArmor')
    SetUpArmorGraphics_Blank(Template);
    SetUpTier1Upgrade(Template);

}

// #######################################################################################
// -------------------- GENERIC SETUP FUNCTIONS ------------------------------------------
// #######################################################################################

static function SetUpTier1Upgrade(out X2WeaponUpgradeTemplate Template)
{
	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_PRICE;
	Template.Tier = 0;
}

static function SetUpTier2Upgrade(out X2WeaponUpgradeTemplate Template)
{
	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentB';
	Template.TradingPostValue = default.ADVANCED_PRICE;
	Template.Tier = 1;
}

static function SetUpTier3Upgrade(out X2WeaponUpgradeTemplate Template)
{
	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.SUPERIOR_PRICE;
	Template.Tier = 2;
}

// #######################################################################################
// -------------------- GRAPHICAL FUNCTIONS ----------------------------------------------
// #######################################################################################

static function SetUpArmorGraphics_Blank(out X2WeaponUpgradeTemplate Template)
{
	Template.CanApplyUpgradeToWeaponFn = CanApplyUpgradeToWeaponArmor;

	//Template.CanBeBuilt = false;
	Template.MaxQuantity = 1;

	Template.BlackMarketTexts = class'X2Item_DefaultUpgrades'.default.UpgradeBlackMarketTexts;
}

// #######################################################################################
// -------------------- UPGRADE FUNCTIONS ------------------------------------------------
// #######################################################################################

static function bool CanApplyUpgradeToWeaponArmor(X2WeaponUpgradeTemplate UpgradeTemplate, XComGameState_Item Weapon, int SlotIndex)
{
	local array<X2WeaponUpgradeTemplate> AttachedUpgradeTemplates;
	local X2WeaponUpgradeTemplate AttachedUpgrade;
	local int iSlot;

	AttachedUpgradeTemplates = Weapon.GetMyWeaponUpgradeTemplates();

	if ( Weapon.InventorySlot != eInvSlot_Armor )
	{
		return false;
	}

	foreach AttachedUpgradeTemplates(AttachedUpgrade, iSlot)
	{
		// Slot Index indicates the upgrade slot the player intends to replace with this new upgrade
		if (iSlot == SlotIndex)
		{
			// The exact upgrade already equipped in a slot cannot be equipped again
			// This allows different versions of the same upgrade type to be swapped into the slot
			if (AttachedUpgrade == UpgradeTemplate)
			{
				return false;
			}
		}
		else if (UpgradeTemplate.MutuallyExclusiveUpgrades.Find(AttachedUpgrade.Name) != INDEX_NONE)
		{
			// If the new upgrade is mutually exclusive with any of the other currently equipped upgrades, it is not allowed
			return false;
		}
	}

	return true;
}
