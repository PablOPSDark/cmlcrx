function InvokeNative(returnType, hash)
    local arg1, arg2 = type(returnType) == "string" and returnType or "Void", hash or returnType
    return function(...) return Natives[string.format("Invoke%s", arg1)](arg2, ...) end
end
-- Natives

Native = {
    CUTSCENE = { STOP_CUTSCENE_IMMEDIATELY = InvokeNative(0xD220BDD222AC4A1E) },
    MONEY = {
        NETWORK_GET_VC_BANK_BALANCE   = InvokeNative("Int", 0x76EF28DA05EA395A),
        NETWORK_GET_VC_WALLET_BALANCE = InvokeNative("Int", 0xA40F9C2623F6A8B5)
    },
    NETSHOPPING = {
        NET_GAMESERVER_GET_PRICE               = InvokeNative("Int", 0xC27009422FCCA88D),
        NET_GAMESERVER_BASKET_IS_ACTIVE        = InvokeNative("Bool", 0xA65568121DF2EA26),
        NET_GAMESERVER_BASKET_END              = InvokeNative("Bool", 0xFA336E7F40C0A0D0),
        NET_GAMESERVER_TRANSFER_BANK_TO_WALLET = InvokeNative("Bool", 0xD47A2C1BA117471D),
        NET_GAMESERVER_TRANSFER_WALLET_TO_BANK = InvokeNative("Bool", 0xC2F7FE5309181C7D)
    },
    NETWORK = {
        NETWORK_GET_HOST_OF_SCRIPT = InvokeNative("Int", 0x1D6A14F1F9A736FC),
        NETWORK_IS_SESSION_STARTED = InvokeNative("Bool", 0x9DE624D2FC4B603F),
        NETWORK_IS_SESSION_ACTIVE  = InvokeNative("Bool", 0xD83C2B94E7508980)
    },
    PAD = {
        ENABLE_CONTROL_ACTION        = InvokeNative(0x351220255D64C155),
        SET_CONTROL_VALUE_NEXT_FRAME = InvokeNative("Bool", 0xE8A25867FBA3B05E),
        SET_CURSOR_POSITION          = InvokeNative("Bool", 0xFC695459D4D0E219)
    },
    PLAYER = { GET_NUMBER_OF_PLAYERS = InvokeNative("Int", 0x407C7F91DDB46C16),
                GET_PLAYER_PED         = InvokeNative("Int", 0x43A66C31C68491C0),
                GET_PLAYER_INDEX       = InvokeNative("Int", 0xA5EDC40EF369B48D)
                },
    SCRIPT = {
        REQUEST_SCRIPT                                          = InvokeNative(0x6EB5F71AA68F2E8E),
        SET_SCRIPT_AS_NO_LONGER_NEEDED                          = InvokeNative(0xC90D2DCACD56184C),
        GET_NUMBER_OF_THREADS_RUNNING_THE_SCRIPT_WITH_THIS_HASH = InvokeNative("Int", 0x2C83A9DA6BFFC4F9),
        DOES_SCRIPT_EXIST                                       = InvokeNative("Bool", 0xFC04745FBE67C19A),
        HAS_SCRIPT_LOADED                                       = InvokeNative("Bool", 0xE6CC9F3BA0FB9EF1)
    },


    STATS = { SET_PACKED_STAT_BOOL_CODE = InvokeNative(0xDB8A58AEAA67CD07),
            SET_PACKED_STAT_INT_CODE = InvokeNative(0x1581503AE529CD2E), 
       
    },

    SYSTEM = { START_NEW_SCRIPT = InvokeNative("Int", 0xE81651AD79516E48) },
    ENTITY = {
        SET_ENTITY_COORDS_NO_OFFSET = InvokeNative(0x239A3351AC1DA385),
        GET_ENTITY_COORDS           = InvokeNative("Bool", 0x3FEF770D40960D5A),

        
    },
    PED = {
        SET_PED_COORDS_KEEP_VEHICLE = InvokeNative(0x9AFEFF481A85AB2E)}
}
   
--MISC VARIABLES
local Player_user_ped = Native.PLAYER.GET_PLAYER_PED(Native.PLAYER.GET_PLAYER_INDEX())  
local Player_ID =   Native.PLAYER.GET_PLAYER_INDEX()
local DELAY_LOOP = 1
local TRANSACTION_TYPE = "Basket Transaction"
INT_MIN = -2147483648
INT_MAX = 2147483647
-- local PLAYER_CHAR = STATS.STAT_GET_INT(Utils.Joaat("MPPLY_LAST_MP_CHAR"))

function TELEPORT(X, Y, Z)
    Native.ENTITY.SET_ENTITY_COORDS(Native.PLAYER.GET_PLAYER_PED(Native.PLAYER.GET_PLAYER_INDEX()), X, Y , Z, 1, 0, 0, 1)
end
function SetHeading(heading)
    Native.ENTITY.SET_ENTITY_HEADING(Player_user_ped, heading)
end
function SetLocalInt(scriptHash, locall, value) 
    ScriptLocal.SetInt(Utils.Joaat(scriptHash), locall, value)
end
function GetLocalInt(scriptHash, locall, value) 
    return ScriptLocal.SetInt(Utils.Joaat(scriptHash), locall, value)
end
function SetGlobalFloat(scriptHash, value) 
    ScriptGlobal.SetFloat(scriptHash, value)
end
function SetGlobalInt(scriptHash, locall) 
    ScriptGlobal.SetInt(scriptHash, locall)
end
function GetGlobalInt(scriptHash, locall) 
   return ScriptGlobal.GetInt(scriptHash, locall)
end
function SetTunableInt(hash, value)
    ScriptGlobal.SetInt(ScriptGlobal.GetTunableByHash(262145 + hash), value)
end

function GetStatInt(stat)
    return Stats.GetInt(Utils.Joaat(stat))
end
function SetStatInt(stat, value)
    Stats.SetInt(Utils.Joaat(stat), value)
end
function SetPackedStatBool(stat, value)
   Native.STATS.SET_PACKED_STAT_BOOL_CODE(stat, value, -1)
end
function SetPackedStatInt(stat, value)
    Native.STATS.SET_PACKED_STAT_INT_CODE(stat, value, -1)
end
function SetPackedBoolsRanged(statStart, statEnd, value)
    for i = statStart, statEnd do
        SetPackedStatBool(i, value)
    end
end
function MPX()
	local shit, PI = GetStatInt("MPPLY_LAST_MP_CHAR")
	if PI == 0 then
		return "MP0_"
	elseif PI == 1 then
		return "MP1_"
	else
		return "MP0_"
	end
end

function TOAST(msg)
    GUI.AddToast("[Debug] ChipsMoneyLua: " ,  msg, 5000, eToastPos.TOP_LEFT)
end
function J(to_joaat)
    return Utils.Joaat(to_joaat)
end

FeatureMgr.AddFeature(J("Unlock_Test"), "Unlock test", eFeatureType.Button, "", function()
    -- OSCAR GUZMAN FLIES AGAIN
    SetPackedStatBool(51280, true)
    SetPackedStatBool(51285, true)
    SetPackedStatBool(51278, true)
    SetPackedBoolsRanged(51286, 51291, true)
    SetPackedBoolsRanged(51292, 51297, true)
    SetStatInt(MPX() .. "PROG_HUB_MFH_EARNINGS", 5000000)
    SetPackedStatBool(51279, true)

    SetPackedStatBool(36871, true)
    SetPackedStatBool(36872, true)
    SetPackedBoolsRanged(36875, 36887, true)
    SetPackedStatBool(36873, true)
    SetPackedStatBool(42001, true)
    SetPackedStatBool(36874, true)
    SetPackedBoolsRanged(36875, 36887, true)
    SetStatInt(MPX() .. "LIFETIME_BKR_SELL_COMPLETBC", 1)
    SetStatInt(MPX() .. "LIFETIME_BKR_SEL_COMPLETBC1", 1)
    SetStatInt(MPX() .. "LIFETIME_BKR_SEL_COMPLETBC2", 1)
    SetStatInt(MPX() .. "LIFETIME_BKR_SEL_COMPLETBC3", 1)
    SetStatInt(MPX() .. "LIFETIME_BKR_SEL_COMPLETBC4", 1)
    SetStatInt(MPX() .. "BAR_RESUPPLY_CR", 10)
    SetStatInt(MPX() .. "LIFETIME_BKR_SELL_EARNINGS0", 25000000)
    SetStatInt(MPX() .. "PROG_HUB_BIK_CUST_DEL_CASH", 2500000)
    SetStatInt(MPX() .. "PROG_HUB_CLBH_BAR_EARNINGS", 500000)
    SetStatInt(MPX() .. "PROG_HUB_BIK_CONTRACT_COUNT", 50)

    -- FURTHER ADVENTURES IN FINANCE AND FELONY
    SetPackedStatBool(36888, true)
    SetPackedStatBool(36889, true)
    SetPackedBoolsRanged(36892, 36915, true)
    SetPackedStatBool(36890, true)
    SetStatInt(MPX() .. "WARHOUSESLOT0", 1)
    SetStatInt(MPX() .. "LIFETIME_BUY_COMPLETE", 1)
    -- note: large custom ranges from C++ will be approximated by setting ranges where meaningful
    SetPackedBoolsRanged(7553, 7592, true)
    SetPackedStatBool(36891, true)
    SetPackedBoolsRanged(36892, 36915, true)
    SetPackedBoolsRanged(36839, 36865, true)
    SetStatInt(MPX() .. "PROG_HUB_FAIFAF_CRATES_COL", 250)
    SetStatInt(MPX() .. "LIFETIME_CONTRA_EARNINGS", 50000000)

    -- LOS SANTOS TUNERS
    SetStatInt(MPX() .. "CAR_CLUB_MEMBERSHIP", 1)
    SetPackedStatBool(31737, true)
    SetPackedStatBool(41870, true)
    SetPackedStatBool(31753, true)
    SetStatInt(MPX() .. "TUNER_COMP_BS", 255)
    SetStatInt(MPX() .. "AWD_AUTO_SHOP", 10)
    SetStatInt(MPX() .. "AWD_CAR_CLUB_MEM", 100)
    SetStatInt(MPX() .. "TUNER_COMP_BS", 255)
    SetPackedStatBool(32397, true)
    SetStatInt(MPX() .. "AWD_GROUNDWORK", 1)
    SetPackedStatInt(30226, 10)
    SetStatInt(MPX() .. "TUNER_COUNT", 25)
    SetStatInt(MPX() .. "PROG_HUB_TUNER_CUS_DEL_CASH", 5000000)
    SetStatInt(MPX() .. "AWD_CAR_CLUB_MEM", 100)

    -- THE DIAMOND CASINO & RESORT
    SetPackedStatBool(27089, true)
    SetPackedStatBool(27090, true)
    SetStatInt(MPX() .. "VCM_FLOW_PROGRESS", 6)
    SetStatInt(MPX() .. "VCM_FLOW_PROGRESS", 12)
    SetStatInt(MPX() .. "VCM_FLOW_PROGRESS", 11)
    SetStatInt(MPX() .. "VCM_FLOW_PROGRESS", 17)
    SetPackedStatBool(36916, true)
    SetStatInt(MPX() .. "AWD_ODD_JOBS", 100)
    SetPackedBoolsRanged(36844, 36859, true)
    SetPackedBoolsRanged(41548, 41553, true)
    SetPackedStatBool(41868, true)
    SetPackedStatInt(42093, 11)
    SetPackedBoolsRanged(41560, 41565, true)
    SetPackedBoolsRanged(41554, 41559, true)
    SetStatInt(MPX() .. "AWD_ODD_JOBS", 100)

  

    -- WEAPONS EXPERT
    SetPackedStatBool(36934, true)
    SetPackedStatBool(36935, true)
    SetPackedStatBool(36936, true)
    SetPackedStatBool(36937, true)
    SetPackedStatBool(36938, true)
    SetPackedStatBool(36920, true)
    SetStatInt(MPX() .. "PROG_HUB_WEAP_TYPE_ANSR", -1)
    SetPackedStatInt(41242, 8)
    SetPackedStatBool(36942, true)
    SetStatInt(MPX() .. "PROG_HUB_10_CHAL_ANSR", 10)
    SetPackedBoolsRanged(42002, 42013, true)
    SetPackedStatBool(36941, true)
    SetPackedBoolsRanged(15456, 15460, true)

    -- AFTER THIS FEATURE finishes, you can add more sections from the list similarly
end)


--[[
gta_util::find_script_thread(RAGE_JOAAT("CASINO_SLOTS"));
                        auto local_219 = script_local(slots_thread, 219);
                        auto local_2131 = script_local(slots_thread, 2131).as<int*>();
 
                        local_219.at(local_2131, 21).at(16).as<int*>() = 500;
                        script_local(slots_thread, 2134).as<int>() = 5;
Always 2.5m payout chips
auto slots_thread = gta_util::find_script_thread(RAGE_JOAAT("CASINO_SLOTS"));
                    script_local(slots_thread, 1644).as<int>() = 50341673;
]]






---@param category integer  -- Categoría de la transacción (ej: Utils.Joaat("category_name"))
---@param action_type integer -- Tipo de acción (ej: Utils.Joaat("action_type"))
---@param flag integer       -- Bandera de configuración
---@param items table        -- Lista de ítems (tabla de tablas con 5 enteros cada una)
function basket_transaction_att(category, action_type, flag, items)
    if Native.NETSHOPPING.NET_GAMESERVER_BASKET_IS_ACTIVE() then
        Native.NETSHOPPING.NET_GAMESERVER_BASKET_END()
    end
     if Native.NETSHOPPING.NET_GAMESERVER_BASKET_IS_ACTIVE() then
        Native.NETSHOPPING.NET_GAMESERVER_BASKET_END()
    end
     if Native.NETSHOPPING.NET_GAMESERVER_BASKET_IS_ACTIVE() then
        Native.NETSHOPPING.NET_GAMESERVER_BASKET_END()
    end
   
    local success, transaction_id = GTA.BasketStart(category, action_type, flag)
    if not success then
        TOAST("Error: cant start basket transaction.\ntransaction too fast? :/")
        return
    end

   
    for _, item in ipairs(items) do
       
        if #item ~= 5 then
            
            
            return
        end

        local add_success = GTA.BasketAddItem(item)
        if not add_success then
            TOAST("Error: CAnt add item to basket.")
           
            return
        end
    end

    
    if not GTA.CheckoutStart(transaction_id) then
        TOAST("Error: Cant start checkout.")
    
    end
  
   
end
local category = 1950528552
local SELL_ACTION_TYPE = -22148635
local BUY_ACTION_TYPE = -126744038
local flag = 4  
local ENABLE_NOTIFICATIONS_DEBUG= true
local SHOULD_BUY_CHIPS = true
local DELAY_LOOP = 1700
local chipsAmount = 1

local function format_number_dots(n)
    n = tonumber(n) or 0
    local s = tostring(math.floor(n))
    local neg = s:sub(1,1) == '-'
    if neg then s = s:sub(2) end
    local out = ''
    while #s > 3 do
        out = '.' .. s:sub(#s-2, #s) .. out
        s = s:sub(1, #s-3)
    end
    out = s .. out
    if neg then out = '-' .. out end
    return out
end

function get_chips()
    local _, stat_int = GetStatInt(MPX() .. "CASINO_CHIPS")
    return format_number_dots(stat_int)
end

FeatureMgr.AddFeature(Utils.Joaat("custom_amount_chips_global"), "Global Custom Amount", eFeatureType.InputInt, "this works or everything"):SetLimitValues(1, 1000000):SetStepSize(1):SetFastStepSize(1000)
chipsAmount = FeatureMgr.GetFeatureInt(Utils.Joaat("custom_amount_chips_global"))

FeatureMgr.AddFeature(J("chips_bonus_test"), "get 1k Bonus Chip", eFeatureType.Button, "", function(r)
    local items = {
        {657241867, -1, 0, 0, 1000},
        {1848798713, -1, 0, 0, 1},
    }
    basket_transaction_att(category, BUY_ACTION_TYPE, flag, items)
    if(ENABLE_NOTIFICATIONS_DEBUG) then
        TOAST("Added 1k chips \nCurrent Chips: " .. get_chips())
    end


end)
FeatureMgr.AddFeature(J("chip_mision_test"), "get 25k chips", eFeatureType.Button, "", function(r)
    local items = {
        {657241867, -1, 0, 0, 25000},
        {1138851024, -1, 0, 0, 1},
    }
    basket_transaction_att(category, BUY_ACTION_TYPE, flag, items)
    if(ENABLE_NOTIFICATIONS_DEBUG) then
        TOAST("Added 25k chips \nCurrent Chips: " .. get_chips())
    end

end)

FeatureMgr.AddFeature(J("buy_vehicle_casino"), "get casino vehicle", eFeatureType.Button, "", function(r)
    local items = {
        {657241867, -1, 0, 0, 1},
        {-1297103179, -1, 0, 0, 1},
    }
    basket_transaction_att(category, BUY_ACTION_TYPE, flag, items)
    if(ENABLE_NOTIFICATIONS_DEBUG) then
        TOAST("Done \nCurrent Chips: " .. get_chips())
    end

end)
-- buy deluxo

--buy example:
--[[basket_transaction_att(
        Utils.Joaat("CATEGORY_VEHICLE"), 
        Utils.Joaat("NET_SHOP_ACTION_BUY_VEHICLE"), 
        4, 
        { 
            { Utils.Joaat("MP_STAT_MPSV_MODEL_9"), Utils.Joaat("VE_ZOMBIEB_t0_v3_CESP"), 0, 1, 1 } 
        }
    )
    Script.Yield(yieldCompra)

    basket_transaction_att(
        Utils.Joaat("CATEGORY_VEHICLE"), 
         Utils.Joaat("NET_SHOP_ACTION_SELL_VEHICLE"), 
        4, 
        { 
            { Utils.Joaat("MP_STAT_MPSV_MODEL_9"), 0, precio, 1, 1 } 
        }
    )]]


FeatureMgr.AddFeature(J("buy_deluxo_test"), "buy & sell deluxo ", eFeatureType.Button, "you must have 5750000 to use this", function(r)
    local items = {
        {Utils.Joaat("MP_STAT_MPSV_MODEL_9"), Utils.Joaat("VE_DELUXO_t0_v29"), 5750000, 1, 1},
        
    }
    basket_transaction_att(Utils.Joaat("CATEGORY_VEHICLE"), Utils.Joaat("NET_SHOP_ACTION_BUY_VEHICLE"), flag, items)
    if(ENABLE_NOTIFICATIONS_DEBUG) then
        TOAST("Bought Deluxo")
    end
    Script.Yield(2000)
    local items2 = {
        {Utils.Joaat("MP_STAT_MPSV_MODEL_9"), 0, 6750000, 1, 1},
        
    }
    basket_transaction_att(Utils.Joaat("CATEGORY_VEHICLE"), Utils.Joaat("NET_SHOP_ACTION_SELL_VEHICLE"), flag, items2)
    if(ENABLE_NOTIFICATIONS_DEBUG) then
        TOAST("Selled Deluxo \nProfit: 1M")
    end
end)
FeatureMgr.AddFeature(J("withdraw_all_chips"), "Withdraw All Chips", eFeatureType.Button, "", function(r)
    local items = {
        {657241867, -1, 1, 0, get_chips()},
        {-1612659516, -1, 0, 0, 1},
    }
    basket_transaction_att(category, SELL_ACTION_TYPE, flag, items)
    if(ENABLE_NOTIFICATIONS_DEBUG) then
        TOAST("Withdrew all chips \nCurrent Chips: " .. get_chips())
    end
end)

FeatureMgr.AddFeature(J("chips_buy_test"), "buy custom Chip", eFeatureType.Button, "max 50k", function(r)
    chipsAmount = FeatureMgr.GetFeatureInt(Utils.Joaat("custom_amount_chips_global"))
    if chipsAmount > 50000 then
        chipsAmount = 50000
    end
    local items = {
        {657241867, -1, 1, 0, chipsAmount},
        {-2043662707, -1, 0, 0, 1},
    }
    basket_transaction_att(category, BUY_ACTION_TYPE, flag, items)
    if(ENABLE_NOTIFICATIONS_DEBUG) then
        TOAST("Bought " .. chipsAmount .. " chips \nCurrent Chips: " .. get_chips())
    end


end)
FeatureMgr.AddFeature(J("chips_bet_test"), "bet custom Chip", eFeatureType.Button, "max 55k", function(r)
chipsAmount = FeatureMgr.GetFeatureInt(Utils.Joaat("custom_amount_chips_global"))
    if chipsAmount > 55000 then
        chipsAmount = 55000
    end
    local items = {
        {657241867, -1, 0, 0, 55000},
        {-1304782539, -1, 0, 0, 1},
    }
    basket_transaction_att(category, SELL_ACTION_TYPE, flag, items)
    if(ENABLE_NOTIFICATIONS_DEBUG) then
        TOAST("Bet " .. chipsAmount .. " chips \nCurrent Chips: " .. get_chips())
    end

end)
FeatureMgr.AddFeature(J("chips_claim_test"), "claim custom Chip", eFeatureType.Button, "max 1M", function(r)
chipsAmount = FeatureMgr.GetFeatureInt(Utils.Joaat("custom_amount_chips_global"))
    if chipsAmount > 1000000 then
        chipsAmount = 1000000
    end
    -- Cambia este valor por la cantidad de chips que deseas canjear
    local items = {
        {657241867, -1, 0, 0, chipsAmount},
        {1196301501, -1, 0, 0, 1},
    }
    basket_transaction_att(category, SELL_ACTION_TYPE, flag, items)
    if(ENABLE_NOTIFICATIONS_DEBUG) then
        TOAST("Claimed " .. chipsAmount .. " chips \nCurrent Chips: " .. get_chips())
    end
end)
FeatureMgr.AddFeature(J("chips_withdraw_test"), "withdraw custom Chip", eFeatureType.Button, "max Int", function(r)
chipsAmount = FeatureMgr.GetFeatureInt(Utils.Joaat("custom_amount_chips_global"))

    local items = {
        {657241867, -1, 1, 0, chipsAmount},
        {-1612659516, -1, 0, 0, 1},
    }
    basket_transaction_att(category, SELL_ACTION_TYPE, flag, items)
    if(ENABLE_NOTIFICATIONS_DEBUG) then
        TOAST("Withdrew " .. chipsAmount .. " chips \nCurrent Chips: " .. get_chips())
    end
end)

FeatureMgr.AddFeature(J("new_chip_loop"), "New 1M Chip Loop", eFeatureType.Toggle, "buy, bet, win, lose, lose. Repeat", function(r)
       while r:IsToggled() do
           local items = {
               {657241867, -1, 1, 0, 50000},
               {-2043662707, -1, 0, 0, 1},
           }
           if SHOULD_BUY_CHIPS then
               basket_transaction_att(category, BUY_ACTION_TYPE, flag, items)
           end

        Script.Yield(DELAY_LOOP)
        
        local items2 = {
            {657241867, -1, 0, 0, 55000},
            {-1304782539, -1, 0, 0, 1},
        }
        basket_transaction_att(category, SELL_ACTION_TYPE, flag, items2)
        Script.Yield(DELAY_LOOP)
        local items3 = {
            {657241867, -1, 0, 0, 1000000},
            {1196301501, -1, 0, 0, 1},
        }
        basket_transaction_att(category, BUY_ACTION_TYPE, flag, items3)
        Script.Yield(DELAY_LOOP)
         local items4 = {
            {657241867, -1, 0, 0, 55000},
            {-1304782539, -1, 0, 0, 1},
        }
        basket_transaction_att(category, SELL_ACTION_TYPE, flag, items4)
        Script.Yield(DELAY_LOOP)
         local items5 = {
            {657241867, -1, 0, 0, 55000},
            {-1304782539, -1, 0, 0, 1},
        }
        basket_transaction_att(category, SELL_ACTION_TYPE, flag, items5)
        if(ENABLE_NOTIFICATIONS_DEBUG) then
            TOAST("Added 1M chips \nBet 55k  Lost 55k Lost 55k \nProfit 1M - 165k = " .. (1000000 - 165000) .. " chips" .. "\nCurrent Chips: " .. get_chips())
        end
        Script.Yield(DELAY_LOOP)
    end
end)

FeatureMgr.AddFeature(J("new_chips_1.8"), "1.8M Chip Loop", eFeatureType.Toggle, "buy, bet, win, lose, lose. Repeat", function(r)
       while r:IsToggled() do
           local items = {
               {657241867, -1, 1, 0, 50000},
               {-2043662707, -1, 0, 0, 1},
           }
           if SHOULD_BUY_CHIPS then
               basket_transaction_att(category, BUY_ACTION_TYPE, flag, items)
           end

        Script.Yield(DELAY_LOOP)
        
        local items2 = {
            {657241867, -1, 0, 0, 55000},
            {-1304782539, -1, 0, 0, 1},
        }
        basket_transaction_att(category, SELL_ACTION_TYPE, flag, items2)
        Script.Yield(DELAY_LOOP)
        local items3 = {
            {657241867, -1, 0, 0, 1800000},
            {1196301501, -1, 0, 0, 1},
        }
        basket_transaction_att(category, BUY_ACTION_TYPE, flag, items3)
        Script.Yield(DELAY_LOOP)
         local items4 = {
            {657241867, -1, 0, 0, 55000},
            {-1304782539, -1, 0, 0, 1},
        }
        basket_transaction_att(category, SELL_ACTION_TYPE, flag, items4)
        Script.Yield(DELAY_LOOP)
         local items5 = {
            {657241867, -1, 0, 0, 55000},
            {-1304782539, -1, 0, 0, 1},
        }
        basket_transaction_att(category, SELL_ACTION_TYPE, flag, items5)
        if(ENABLE_NOTIFICATIONS_DEBUG) then
            TOAST("Added 1.8M chips \nBet 55k  Lost 55k Lost 55k \nProfit 1.8M - 165k = " .. (1800000 - 165000) .. " chips" .. "\nCurrent Chips: " .. get_chips())
        end
        Script.Yield(DELAY_LOOP)
    end
end)

FeatureMgr.AddFeature(J("new_2m_loop"), "2M Chip Loop", eFeatureType.Toggle, "buy, bet, win, lose, lose. Repeat", function(r)
       while r:IsToggled() do
           local items = {
               {657241867, -1, 1, 0, 50000},
               {-2043662707, -1, 0, 0, 1},
           }
           if SHOULD_BUY_CHIPS then
               basket_transaction_att(category, BUY_ACTION_TYPE, flag, items)
           end

        Script.Yield(DELAY_LOOP)
        
        local items2 = {
            {657241867, -1, 0, 0, 55000},
            {-1304782539, -1, 0, 0, 1},
        }
        basket_transaction_att(category, SELL_ACTION_TYPE, flag, items2)
        Script.Yield(DELAY_LOOP)
        local items3 = {
            {657241867, -1, 0, 0, 2000000},
            {1196301501, -1, 0, 0, 1},
        }
        basket_transaction_att(category, BUY_ACTION_TYPE, flag, items3)
        Script.Yield(DELAY_LOOP)
         local items4 = {
            {657241867, -1, 0, 0, 55000},
            {-1304782539, -1, 0, 0, 1},
        }
        basket_transaction_att(category, SELL_ACTION_TYPE, flag, items4)
        Script.Yield(DELAY_LOOP)
         local items5 = {
            {657241867, -1, 0, 0, 55000},
            {-1304782539, -1, 0, 0, 1},
        }
        basket_transaction_att(category, SELL_ACTION_TYPE, flag, items5)
        if(ENABLE_NOTIFICATIONS_DEBUG) then
            TOAST("Added 2M chips \nBet 55k  Lost 55k Lost 55k \nProfit 2M - 165k = " .. (2000000 - 165000) .. " chips" .. "\nCurrent Chips: " .. get_chips())
        end
        Script.Yield(DELAY_LOOP)
    end
end)
FeatureMgr.AddFeature(J("new_2.4m_loop"), "2.4M Chip Loop", eFeatureType.Toggle, "buy, bet, win, lose, lose. Repeat", function(r)
       while r:IsToggled() do
           local items = {
               {657241867, -1, 1, 0, 50000},
               {-2043662707, -1, 0, 0, 1},
           }
           if SHOULD_BUY_CHIPS then
               basket_transaction_att(category, BUY_ACTION_TYPE, flag, items)
           end

        Script.Yield(DELAY_LOOP)
        
        local items2 = {
            {657241867, -1, 0, 0, 55000},
            {-1304782539, -1, 0, 0, 1},
        }
        basket_transaction_att(category, SELL_ACTION_TYPE, flag, items2)
        Script.Yield(DELAY_LOOP)
        local items3 = {
            {657241867, -1, 0, 0, 2400000},
            {1196301501, -1, 0, 0, 1},
        }
        basket_transaction_att(category, BUY_ACTION_TYPE, flag, items3)
        Script.Yield(DELAY_LOOP)
         local items4 = {
            {657241867, -1, 0, 0, 55000},
            {-1304782539, -1, 0, 0, 1},
        }
        basket_transaction_att(category, SELL_ACTION_TYPE, flag, items4)
        Script.Yield(DELAY_LOOP)
         local items5 = {
            {657241867, -1, 0, 0, 55000},
            {-1304782539, -1, 0, 0, 1},
        }
        basket_transaction_att(category, SELL_ACTION_TYPE, flag, items5)
        if(ENABLE_NOTIFICATIONS_DEBUG) then
            TOAST("Added 2.4M chips \nBet 55k  Lost 55k Lost 55k \nProfit 2.4M - 165k = " .. (2400000 - 165000) .. " chips" .. "\nCurrent Chips: " .. get_chips())
        end
        Script.Yield(DELAY_LOOP)
    end
end)
FeatureMgr.AddFeature(J("chips_loop_bonus"), "Daily Chips Loop", eFeatureType.Toggle, "1k every sec", function(r)
   while r:IsToggled() do
       local items = {
           {657241867, -1, 0, 0, 1000},
           {1848798713, -1, 0, 0, 1},
       }
       basket_transaction_att(category, BUY_ACTION_TYPE, flag, items)
       if(ENABLE_NOTIFICATIONS_DEBUG) then
              TOAST("Added 1k chips \nCurrent Chips: " .. get_chips())
       end
       Script.Yield(DELAY_LOOP)
   end
end)
FeatureMgr.AddFeature(J("chips_loop_reward"), "5k Chips Loop", eFeatureType.Toggle, "5k every sec", function(r)
   while r:IsToggled() do
       local items = {
           {657241867, -1, 0, 0, 5000},
           {-1964607937, -1, 0, 0, 1},
       }
       basket_transaction_att(category, BUY_ACTION_TYPE, flag, items)
       if(ENABLE_NOTIFICATIONS_DEBUG) then
              TOAST("Added 5k chips \nCurrent Chips: " .. get_chips())
       end
       Script.Yield(DELAY_LOOP)
   end
end)
FeatureMgr.AddFeature(J("chips_loop_mision"), "25k Chips Loop", eFeatureType.Toggle, "25k every sec", function(r)
   while r:IsToggled() do
       local items = {
           {657241867, -1, 0, 0, 25000},
           {1138851024, -1, 0, 0, 1},
       }
       basket_transaction_att(category, BUY_ACTION_TYPE, flag, items)
       if(ENABLE_NOTIFICATIONS_DEBUG) then
              TOAST("Added 25k chips \nCurrent Chips: " .. get_chips())
       end
       Script.Yield(DELAY_LOOP)
   end
end)


FeatureMgr.AddFeature(J("chips_random_loop"), "Random Chips Loop", eFeatureType.Toggle, "randomized buy/bet/win/lose/lose", function(r)
    if not _CHIPS_RAND_SEEDED then
        math.randomseed(os.time()); _CHIPS_RAND_SEEDED = true
    end
    while r:IsToggled() do
        local buy_amt = math.random(1, 50000)
        local bet_amt = math.random(1, 55000)
        if buy_amt < bet_amt then buy_amt = math.min(50000, bet_amt) end

        local mult = math.random(2, 20)
        local win_amt = bet_amt * mult
        if win_amt > 1000000 then win_amt = 1000000 end
        if win_amt < 1 then win_amt = 1 end

        local lose1 = math.floor(math.min(55000, math.max(1, bet_amt * (math.random(50, 120) / 100))))
        local lose2 = math.floor(math.min(55000, math.max(1, bet_amt * (math.random(50, 120) / 100))))


        local items1 = {
            {657241867, -1, 1, 0, buy_amt},
            {-2043662707, -1, 0, 0, 1},
        }
        if SHOULD_BUY_CHIPS then
            basket_transaction_att(category, BUY_ACTION_TYPE, flag, items1)
        end
       
        Script.Yield(DELAY_LOOP)
        local items2 = {
            {657241867, -1, 0, 0, bet_amt},
            {-1304782539, -1, 0, 0, 1},
        }
        basket_transaction_att(category, SELL_ACTION_TYPE, flag, items2)
        Script.Yield(DELAY_LOOP)

       
        local items3 = {
            {657241867, -1, 0, 0, win_amt},
            {1196301501, -1, 0, 0, 1},
        }
     
        basket_transaction_att(category, BUY_ACTION_TYPE, flag, items3)
        Script.Yield(DELAY_LOOP)

      
        local items4 = {
            {657241867, -1, 0, 0, lose1},
            {-1304782539, -1, 0, 0, 1},
        }
        basket_transaction_att(category, SELL_ACTION_TYPE, flag, items4)
        Script.Yield(DELAY_LOOP)

   
        local items5 = {
            {657241867, -1, 0, 0, lose2},
            {-1304782539, -1, 0, 0, 1},
        }
        basket_transaction_att(category, SELL_ACTION_TYPE, flag, items5)

        if (ENABLE_NOTIFICATIONS_DEBUG) then
            TOAST(string.format(
                "Random loop:\nBuy %d\nBet %d x%d -> Win %d\nLose %d, Lose %d\nCurrent Chips: %d",
                buy_amt, bet_amt, mult, win_amt, lose1, lose2, get_chips()
            ))
        end
        Script.Yield(DELAY_LOOP)
    end
end)


local should_use_custom_betting = false


local DEFAULT_BUY  = 25000
local DEFAULT_BET  = 27500
local DEFAULT_MULT = 10
local DEFAULT_LOSE = 27500
local DEFAULT_DELAY = 1700


local USE_CUSTOM_BUY   = false
local USE_CUSTOM_BET   = false
local USE_CUSTOM_MULT  = false
local USE_CUSTOM_LOSE  = false
local USE_CUSTOM_DELAY = false

-- Toggle features
FeatureMgr.AddFeature(J("use_custom_buy"), "Use Custom Buy Amount", eFeatureType.Toggle, "Use the custom buy amount below", function(r)
    USE_CUSTOM_BUY = r:IsToggled()
end)
FeatureMgr.AddFeature(J("use_custom_bet"), "Use Custom Bet Amount", eFeatureType.Toggle, "Use the custom bet amount below", function(r)
    USE_CUSTOM_BET = r:IsToggled()
end)
FeatureMgr.AddFeature(J("use_custom_mult"), "Use Custom Multiplier", eFeatureType.Toggle, "Use the custom multiplier below", function(r)
    USE_CUSTOM_MULT = r:IsToggled()
end)
FeatureMgr.AddFeature(J("use_custom_lose"), "Use Custom Lose Amount", eFeatureType.Toggle, "Use the custom lose amount below", function(r)
    USE_CUSTOM_LOSE = r:IsToggled()
end)
FeatureMgr.AddFeature(J("use_custom_delay"), "Use Custom Delay", eFeatureType.Toggle, "Override the loop delay with the value below", function(r)
    USE_CUSTOM_DELAY = r:IsToggled()
    DELAY_LOOP = USE_CUSTOM_DELAY and FeatureMgr.GetFeatureInt(J("custom_delay_loop")) or DEFAULT_DELAY
end)

-- Input features
FeatureMgr.AddFeature(J("custom_buying_amount"), "Custom Buy Amount", eFeatureType.InputInt, "100 - 50000")
    :SetLimitValues(100, 50000):SetStepSize(100):SetFastStepSize(1000)
FeatureMgr.AddFeature(J("custom_betting_amount"), "Custom Bet Amount", eFeatureType.InputInt, "100 - 55000")
    :SetLimitValues(100, 55000):SetStepSize(100):SetFastStepSize(1000)
FeatureMgr.AddFeature(J("custom_betting_multiplier"), "Custom Multiplier", eFeatureType.InputInt, "2 - 20")
    :SetLimitValues(2, 20):SetStepSize(1):SetFastStepSize(1)
FeatureMgr.AddFeature(J("custom_losing_amount"), "Custom Lose Amount", eFeatureType.InputInt, "100 - 55000")
    :SetLimitValues(100, 55000):SetStepSize(100):SetFastStepSize(1000)
FeatureMgr.AddFeature(J("custom_delay_loop"), "Custom Delay (ms)", eFeatureType.InputInt, "500 - 10000", function(t)
    if USE_CUSTOM_DELAY then
        DELAY_LOOP = t:GetIntValue()
    end
end):SetLimitValues(500, 10000):SetStepSize(100):SetFastStepSize(500)


FeatureMgr.AddFeature(J("advanced_chips_loop"), "Advanced Chips Loop", eFeatureType.Toggle, "customized buy/bet/win/lose/lose", function(r) --agregar nuevas opciones
    
    while r:IsToggled() do
        local buy_amt = USE_CUSTOM_BUY and FeatureMgr.GetFeatureInt(J("custom_buying_amount")) or DEFAULT_BUY
        local bet_amt = USE_CUSTOM_BET and FeatureMgr.GetFeatureInt(J("custom_betting_amount")) or DEFAULT_BET
        if buy_amt < bet_amt then buy_amt = math.min(50000, bet_amt) end

        local mult = USE_CUSTOM_MULT and FeatureMgr.GetFeatureInt(J("custom_betting_multiplier")) or DEFAULT_MULT
        local win_amt = bet_amt * mult
        if win_amt > 1000000 then win_amt = 1000000 end
        if win_amt < 1 then win_amt = 1 end

        local lose1 = USE_CUSTOM_LOSE and FeatureMgr.GetFeatureInt(J("custom_losing_amount")) or DEFAULT_LOSE
        local lose2 = USE_CUSTOM_LOSE and FeatureMgr.GetFeatureInt(J("custom_losing_amount")) or DEFAULT_LOSE
        local items1 = {
            {657241867, -1, 1, 0, buy_amt},
            {-2043662707, -1, 0, 0, 1},
        }
        if SHOULD_BUY_CHIPS then
            basket_transaction_att(category, BUY_ACTION_TYPE, flag, items1)
        end
        Script.Yield(DELAY_LOOP)
        local items2 = {
            {657241867, -1, 0, 0, bet_amt},
            {-1304782539, -1, 0, 0, 1},
        }
        basket_transaction_att(category, SELL_ACTION_TYPE, flag, items2)
        Script.Yield(DELAY_LOOP)
        local items3 = {
            {657241867, -1, 0, 0, win_amt},
            {1196301501, -1, 0, 0, 1},
        }
        basket_transaction_att(category, BUY_ACTION_TYPE, flag, items3)
        Script.Yield(DELAY_LOOP)
        local items4 = {
            {657241867, -1, 0, 0, lose1},
            {-1304782539, -1, 0, 0, 1},
        }
        basket_transaction_att(category, SELL_ACTION_TYPE, flag, items4)
        Script.Yield(DELAY_LOOP)
        local items5 = {
            {657241867, -1, 0, 0, lose2},
            {-1304782539, -1, 0, 0, 1},
        }
        basket_transaction_att(category, SELL_ACTION_TYPE, flag, items5)
        if (ENABLE_NOTIFICATIONS_DEBUG) then
            TOAST(string.format(
                "Advanced loop:\nBuy %d\nBet %d x%d -> Win %d\nLose %d, Lose %d\nCurrent Chips: %s",
                buy_amt, bet_amt, mult, win_amt, lose1, lose2, get_chips()
            ))--bad argument #8 to 'format' (number expected, got string)

        end
        Script.Yield(DELAY_LOOP)
    end
  
end)



--[[
            ENCONTRADOS:

            BONUS DIARIO:
            {657241867, -1, 0, 0, 10000},
            {1848798713, -1, 0, 0, 1},

            COMPRAR CHIPS:
            {657241867, -1, 1, 0, 50000},
            {-2043662707, -1, 0, 0, 1},

            APOSTAR CHIPS:
            {657241867, -1, 0, 0, 55000},
            {-1304782539, -1, 0, 0, 1},

            CANJEAR CHIPS:
            {657241867, -1, 0, 0, chipsAmount},
            {1196301501, -1, 0, 0, 1},

            REWARD DIARIO:
            {657241867, -1, 0, 0, 5000},
            {-1964607937, -1, 0, 0, 1},

            RETIRAR CHIPS:
            {657241867, -1, 1, 0, amountchips},
            {-1612659516, -1, 0, 0, 1},

            MISION CHIPS:
            {657241867, -1, 0, 0, 25000},
            {1138851024, -1, 0, 0, 1},

]]


--buy & sell vehicles
local function buy_sell_vehicle(buy_price, sell_price, vehicle_variant_hash)
    local items = {
        {Utils.Joaat("MP_STAT_MPSV_MODEL_9"), vehicle_variant_hash, buy_price, 1, 1},
        
    }
    basket_transaction_att(Utils.Joaat("CATEGORY_VEHICLE"), Utils.Joaat("NET_SHOP_ACTION_BUY_VEHICLE"), flag, items)
    if(ENABLE_NOTIFICATIONS_DEBUG) then
        TOAST("Bought Vehicle")
    end
    Script.Yield(3500)
    local items2 = {
        {Utils.Joaat("MP_STAT_MPSV_MODEL_9"), 0,sell_price , 1, 1},
        
    }
    basket_transaction_att(Utils.Joaat("CATEGORY_VEHICLE"), Utils.Joaat("NET_SHOP_ACTION_SELL_VEHICLE"), flag, items2)
    if(ENABLE_NOTIFICATIONS_DEBUG) then
        TOAST("Selled Vehicle \nProfit: " .. (sell_price - buy_price))
    end
end





---settttttings
FeatureMgr.AddFeature(J("debug_chips"), "Disable Notifications", eFeatureType.Toggle, "Disable Debug Notifications", function(r)
    ENABLE_NOTIFICATIONS_DEBUG = not r:IsToggled()
end)

FeatureMgr.AddFeature(J("should_buy_chips"), "Buy Chips before betting", eFeatureType.Toggle, "Automatically buy chips before betting", function(r)
    SHOULD_BUY_CHIPS = r:IsToggled()
end)
FeatureMgr.ToggleFeature(J("should_buy_chips"))

FeatureMgr.AddFeature(J("should_use_custom_betting"), "Use custom Betting", eFeatureType.Toggle, "Use custom betting logic", function(r)
    should_use_custom_betting = r:IsToggled()
end)

FeatureMgr.AddFeature(Utils.Joaat("delay_loop"), "Delay Loop (ms)", eFeatureType.InputInt, "min 100ms max 10000ms", function(t)
    DELAY_LOOP = (t:GetIntValue())
end):SetLimitValues(100, 10000):SetStepSize(100):SetFastStepSize(500)

FeatureMgr.SetFeatureInt(Utils.Joaat("delay_loop"), 1700)



ClickGUI.AddTab("ChipsMoneyLua", function()
    if ImGui.BeginTabBar("ChipsMoneyLua") then
        if ImGui.BeginTabItem("Chips") then

            ImGui.TextColored(0.98, 0.82, 0.0, 1.0, "Chips & Casino Manager")
            ImGui.Spacing()

            ImGui.Text("Quick Actions")
            ImGui.Separator()
            ClickGUI.RenderFeature(Utils.Joaat("chips_bonus_test"))
            ImGui.SameLine()
            ClickGUI.RenderFeature(Utils.Joaat("chip_mision_test"))
            ClickGUI.RenderFeature(Utils.Joaat("buy_vehicle_casino"))
            ImGui.SameLine()
            --ClickGUI.RenderFeature(Utils.Joaat("buy_deluxo_test"))
            ClickGUI.RenderFeature(Utils.Joaat("withdraw_all_chips"))
            ImGui.SameLine()
            ImGui.TextColored(1.0, 0.0, 0.0, 1.0, "<-- Use at your own risk!")

            ImGui.Spacing()

            ImGui.Text("Transactions")
            ImGui.Separator()
            ClickGUI.RenderFeature(Utils.Joaat("custom_amount_chips_global"))
            ImGui.SameLine()
            ClickGUI.RenderFeature(Utils.Joaat("chips_buy_test"))
            ClickGUI.RenderFeature(Utils.Joaat("chips_bet_test"))
            ImGui.SameLine()
            ClickGUI.RenderFeature(Utils.Joaat("chips_claim_test"))
            ClickGUI.RenderFeature(Utils.Joaat("chips_withdraw_test"))

            ImGui.Spacing()

            ImGui.Text("Automation")
            ImGui.Separator()
           
           ClickGUI.RenderFeature(Utils.Joaat("new_2.4m_loop"))
            ImGui.SameLine()
            ClickGUI.RenderFeature(Utils.Joaat("new_2m_loop"))
            ImGui.SameLine()
            ClickGUI.RenderFeature(Utils.Joaat("new_chips_1.8"))
            ImGui.SameLine()
            ClickGUI.RenderFeature(Utils.Joaat("new_chip_loop"))
            ClickGUI.RenderFeature(Utils.Joaat("chips_random_loop"))
            ImGui.SameLine()
            ClickGUI.RenderFeature(Utils.Joaat("chips_loop_bonus"))
            ImGui.SameLine()
            ClickGUI.RenderFeature(Utils.Joaat("chips_loop_reward"))
            ImGui.SameLine()
            ClickGUI.RenderFeature(Utils.Joaat("chips_loop_mision"))
            ImGui.Spacing()
            if(should_use_custom_betting) then
                 ImGui.Text("Custom Values (optional)")
                    ImGui.Separator()
                -- Buy
            ClickGUI.RenderFeature(J("use_custom_buy"))
            ImGui.SameLine()
            ClickGUI.RenderFeature(J("custom_buying_amount"))

            -- Bet
            ClickGUI.RenderFeature(J("use_custom_bet"))
            ImGui.SameLine()
            ClickGUI.RenderFeature(J("custom_betting_amount"))

            -- Multiplier
            ClickGUI.RenderFeature(J("use_custom_mult"))
            ImGui.SameLine()
            ClickGUI.RenderFeature(J("custom_betting_multiplier"))

            -- Lose
            ClickGUI.RenderFeature(J("use_custom_lose"))
            ImGui.SameLine()
            ClickGUI.RenderFeature(J("custom_losing_amount"))

            -- Delay
            ClickGUI.RenderFeature(J("use_custom_delay"))
            ImGui.SameLine()
            ClickGUI.RenderFeature(J("custom_delay_loop"))

            ClickGUI.RenderFeature(J("advanced_chips_loop"))
            end

            ImGui.EndTabItem()
        end
       

         if ImGui.BeginTabItem("Settings") then
            ImGui.TextColored(0.98, 0.82, 0.0, 1.0, "Settings")
            ImGui.Spacing()
            ClickGUI.RenderFeature(J("debug_chips"))
            ImGui.SameLine()
            ClickGUI.RenderFeature(J("should_buy_chips"))
            ClickGUI.RenderFeature(J("should_use_custom_betting"))
            ClickGUI.RenderFeature(J("delay_loop"))
            ImGui.Spacing()
            ImGui.Separator()

            ImGui.Spacing()
            ImGui.Separator()
            ImGui.TextColored(1.0, 0.0, 0.0, 1.0, "Please, do not share this script or would be detected quickly")
            ImGui.TextColored(1.0, 0.0, 0.0, 1.0, "This script has not been tested yet\nUse at your own risk!")

            ImGui.EndTabItem()
        end
    end
    ImGui.EndTabBar()
end)
