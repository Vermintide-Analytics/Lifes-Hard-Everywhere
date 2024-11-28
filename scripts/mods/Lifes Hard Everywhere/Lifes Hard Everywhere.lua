local mod = get_mod("Lifes Hard Everywhere")
local vmf

local bl = nil

local difficulty_codes =
{
	normal = 1,
	hard = 2,
	harder = 3,
	hardest = 4,
	cataclysm = 5,
	cataclysm_2 = 6,
	cataclysm_3 = 7,
}
local get_difficulty_code = function()
	local current_difficulty = Managers.state.difficulty:get_difficulty()
	return difficulty_codes[current_difficulty]
end

local enemy_codes =
{
	beastmen_bestigor						= 1	,		--a Bestigor
	beastmen_gor							= 2	,		--a Gor
	beastmen_minotaur						= 3	,		--a Minotaur
	beastmen_standard_bearer				= 4	,		--a Standard Bearer
	beastmen_ungor							= 5	,		--an Ungor
	beastmen_ungor_archer					= 6	,		--an Ungor Archer
	chaos_berzerker							= 7	,		--a Berserker
	chaos_corruptor_sorcerer				= 8	,		--a Life Leech
	chaos_fanatic							= 9	,		--a Fanatic
	chaos_marauder							= 10,		--a Marauder
	chaos_marauder_with_shield				= 11,		--a Marauder
	chaos_raider							= 12,		--a Mauler
	chaos_spawn								= 13,		--a Chaos Spawn
	chaos_troll								= 14,		--a Troll
	chaos_vortex_sorcerer					= 15,		--a Blightstormer
	chaos_warrior							= 16,		--a Chaos Warrior
	skaven_clan_rat							= 17,		--a Clan Rat
	skaven_clan_rat_with_shield				= 18,		--a Clan Rat
	skaven_gutter_runner					= 19,		--an Assassin
	skaven_pack_master						= 20,		--a Hook Rat
	skaven_plague_monk						= 21,		--a Plague Monk
	skaven_poison_wind_globadier			= 22,		--a Gas Rat
	skaven_rat_ogre							= 23,		--a Rat Ogre
	skaven_ratling_gunner					= 24,		--a Ratling Gunner
	skaven_slave							= 25,		--a Slave Rat
	skaven_storm_vermin						= 26,		--a Stormvermin
	skaven_storm_vermin_commander			= 27,		--a Stormvermin
	skaven_storm_vermin_with_shield			= 28,		--a Stormvermin
	skaven_stormfiend						= 29,		--a Stormfiend
	skaven_warpfire_thrower					= 30,		--a Warpfire Thrower

	chaos_exalted_champion_norsca			= 31,		--Gatekeeper Naglfahr
	chaos_spawn_exalted_champion_norsca		= 32,		--Blessed Gatekeeper Naglfahr
	chaos_exalted_champion_warcamp			= 33,		--Bödvarr Ribspreader
	chaos_exalted_sorcerer					= 34,		--Burblespue Halescourge
	chaos_exalted_sorcerer_drachenfels		= 35,		--Nurgloth the Eternal
	skaven_grey_seer						= 36,		--Rasknitt
	skaven_storm_vermin_warlord				= 37,		--Skarrik Spinemanglr
	skaven_stormfiend_boss					= 38,		--Deathrattler

	skaven_storm_vermin_champion			= 39,		--a Stormvermin Champion

	shadow_lieutenant						= 40,		--a Shadow Lieutenant
	chaos_mutator_sorcerer					= 41,		--a Leech Spirit
	curse_mutator_sorcerer					= 42,		--a Leech Spirit
	chaos_plague_sorcerer					= 43,		--a Plague Brewer

	-- Mods may repurpose/enable some of these
	chaos_marauder_tutorial					= 44,		--a Savage Marauder
	chaos_raider_tutorial					= 45,		--a Mauler
	skaven_clan_rat_tutorial				= 46,		--a Purple/Yellow Monk
	skaven_dummy_clan_rat					= 47,		--a Marauder
	skaven_dummy_slave						= 48,		--a Stormvermin
	beastmen_bestigor_dummy					= 49,		--a Bestigor
	beastmen_standard_bearer_crater			= 50,		--a Standard Bearer
	beastmen_gor_dummy						= 51,		--a Gor

	skaven_explosive_loot_rat				= 52,		--a Bomb Rat
}

local special_damage_codes =
{
	dot_debuff								= 1005,		-- Unattributed damage over time
	burninating								= 1007,		-- Fire
	skulls_of_fury							= 1008,		-- Khorne Skull Explosion
	bolt_of_change							= 1009,		-- Tzeentch lightning
}

local map_event_codes =
{
	-- Righteous Stand
	military_courtyard_event_01				= 1001,
	military_courtyard_event_02				= 1001,
	military_end_event_survival_start		= 1002,

	-- Convocation of Decay
	catacombs_puzzle_event_start			= 1003,
	catacombs_end_event_pool_challenge		= 1004,

	-- Hunger in the Dark
	mines_end_event_start					= 1005,

	-- Halescourge
	gz_chaos_boss							= 1006,

	-- Athel Yenlui
	elven_ruins_end_event					= 1007,

	-- Screaming Bell
	canyon_bell_event						= 1008,

	-- Fort Brachsenbrucke
	fort_horde_gate							= 1009,

	-- Into the Nest
	stronghold_boss							= 1010,

	-- Against the Grain
	farmlands_rat_ogre						= 1011,
	farmlands_storm_fiend					= 1011,
	farmlands_chaos_troll					= 1011,
	farmlands_chaos_spawn					= 1011,
	farmlands_prisoner_event_01				= 1012,

	-- Empire in Flames
	ussingen_payload_event_01				= 1013,
	ussingen_payload_event_02				= 1013,
	ussingen_payload_event_03				= 1013,

	-- Festering Ground
	nurgle_end_event_start					= 1014,

	-- The War Camp
	warcamp_payload							= 1015,
	warcamp_chaos_boss						= 1016,

	-- The Skittergate
	skittergate_chaos_boss					= 1017,
	skittergate_rasknitt_boss				= 1018,

	-- Old Haunts
	dlc_portals_temple_yard					= 1019,
	dlc_portals_end_event_guards			= 1020,

	-- Blood in the Darkness
	bastion_gate_event						= 1021,
	bastion_finale_sorcerer					= 1022,

	-- The Enchanter's Lair
	castle_chaos_boss						= 1023,

	-- The Pit
	dlc_bogenhafen_slum_event_start			= 1024,
	dlc_bogenhafen_slum_gauntlet_wall_smash = 1025,

	-- The Blightreaper
	dlc_bogenhafen_city_sewer_start			= 1026,
	dlc_bogenhafen_city_temple_start		= 1027,

	-- The Horn of Magnus
	magnus_door_event_guards				= 1028,
	magnus_end_event						= 1029,

	-- Garden of Morr
	cemetery_plague_brew_event_1_a			= 1030,
	cemetery_plague_brew_event_1_b			= 1030,

	-- Engines of War
	forest_skaven_camp_loop					= 1031,
	forest_end_event_loop					= 1032,

	-- Dark Omens
	crater_mid_event						= 1033,
	crater_end_event_intro_wave				= 1034,

	-- A Quiet Drink
	crawl_floor_fall						= 1035
}

local career_codes =
{
	es_mercenary = 1101,
	es_huntsman = 1102,
	es_knight = 1103,
	es_questingknight = 1104,

	dr_ranger = 1105,
	dr_ironbreaker = 1106,
	dr_slayer = 1107,
	dr_engineer = 1108,

	we_waywatcher = 1109,
	we_maidenguard = 1110,
	we_shade = 1111,
	we_thornsister = 1112,

	wh_captain = 1113,
	wh_bountyhunter = 1114,
	wh_zealot = 1115,
	wh_priest = 1116,

	bw_adept = 1117,
	bw_scholar = 1118,
	bw_unchained = 1119,
	bw_4 = 1120
}

local get_damage_source_code = function(damage_source, is_ff, is_self, ff_breed_name)
	if not damage_source then
		return nil
	end

	if damage_source == "knockdown_bleed" then
		return 1003
	elseif damage_source == "ground_impact" then
		return 1004
	end

	if is_self then
		return 1001
	elseif is_ff then
		if not ff_breed_name then
			return 1002
		end

		return career_codes[ff_breed_name] or 1002
	end
	
	return special_damage_codes[damage_source] or enemy_codes[damage_source:gsub("vs_", "")]
end

local num_players = 0

local is_in_chaos_wastes = false
local chaos_wastes_levels_started = 0

local get_mod_state_code = function()
	if is_in_chaos_wastes then
		if get_mod("Peregrinaje") then
			if bl and bl.mod_mutator_state and bl.mod_mutator_state.deathwish == bl.DEATHWISH.On or deathwishmode then
				return 13
			end
			return 12
		end
		return nil
	end

	if not bl or not bl.mod_mutator_state then
		return nil
	end

	local deathwish = bl.mod_mutator_state.deathwish == bl.DEATHWISH.On
	local onslaught = bl.mod_mutator_state.onslaught == bl.ONSLAUGHT.Onslaught
	local onslaught_plus = bl.mod_mutator_state.onslaught == bl.ONSLAUGHT.OnslaughtPlus
	local onslaught_squared = bl.mod_mutator_state.onslaught == bl.ONSLAUGHT.OnslaughtSquared
	local spicy_onslaught = bl.mod_mutator_state.onslaught == bl.ONSLAUGHT.SpicyOnslaught
	local dutch_spice = bl.mod_mutator_state.onslaught == bl.ONSLAUGHT.DutchSpice
	local dutch_spice_tourney = bl.mod_mutator_state.onslaught == bl.ONSLAUGHT.DutchSpiceTourney

	if deathwish then
		if onslaught then
			return 3
		elseif onslaught_plus then
			return 5
		elseif onslaught_squared then
			return 7
		elseif spicy_onslaught then
			return 9
		elseif dutch_spice then
			return 11
		elseif dutch_spice_tourney then
			return 15
		else
			return 2
		end
	else
		if onslaught then
			return 1
		elseif onslaught_plus then
			return 4
		elseif onslaught_squared then
			return 6
		elseif spicy_onslaught then
			return 8
		elseif dutch_spice then
			return 10
		elseif dutch_spice_tourney then
			return 14
		else
			return nil
		end
	end
end

local deaths = {}

local bloodstain_unit_path = "units/Bloodstain"
local bloodstain_golden_unit_path = "units/BloodstainGolden"
local bloodstain_azure_unit_path = "units/BloodstainAzure"

local pillar_unit_path = "units/Pillar"
local pillar_golden_unit_path = "units/PillarGolden"
local pillar_azure_unit_path = "units/PillarAzure"

local discord_integration = mod:get("discord_integration")
local display_community_reactions = mod:get("display_community_reactions")
local reaction_polling_interval = mod:get("reaction_polling_interval")

local player_id = mod:get("player_id")
local max_bloodstains_global = mod:get("max_bloodstains_global")
local ping_bloodstains = mod:get("ping_for_bloodstain_details")
local bloodstain_size = mod:get("bloodstain_size")
local pillar_mode = mod:get("pillar_mode")
local pillar_height = mod:get("pillar_height")
local pillar_width = mod:get("pillar_width")
local mod_debug = mod:get("mod_debug")

local debug_echo = function(output)
	if mod_debug then
		mod:echo(output)
	end
end
local debug_error = function(output)
	if mod_debug then
		mod:error(output)
	end
end

mod.event_phrases =
{
	["test"]					= -1,
	["VMT:Rebalance2022"]		= 1,
	["OSCharity22"]				= 2,
	["OSMay23"]					= 3,
	["OSVersusKickoff"]			= 4
}
local event_phrase = mod:get("event_phrase")
local event = nil
local update_event_code = function()
	if event_phrase then
		event = mod.event_phrases[event_phrase]
	end
end

local get_bloodstain_unit_given_event = function(event_code)
	if event_code == 2 then
		return bloodstain_azure_unit_path
	elseif event_code == 1 or event_code == 3 or event_code == 4 then
		return bloodstain_golden_unit_path
	end

	return bloodstain_unit_path
end

local get_pillar_unit_given_event = function(event_code)
	if event_code == 2 then
		return pillar_azure_unit_path
	elseif event_code == 1 or event_code == 3 or event_code == 4 then
		return pillar_golden_unit_path
	end

	return pillar_unit_path
end

local bloodstains = {}

local on_bloodstains_loaded = {}

local can_die = false
local display_world = nil
local display_line_object = nil
local o = require("scripts/mods/Lifes Hard Everywhere/db_key")

local random_spin = function()
	local rand = math.random(-math.pi, math.pi)
	return Quaternion.axis_angle(Vector3(0, 0, 1), rand)
end

local GET_headers = {
	"apikey: " .. o,
	"Authorization: Bearer " .. o,
	"User-agent: Vermintide"
}
local POST_headers = {
	"apikey: " .. o,
	"Authorization: Bearer " .. o,
	"Content-Type: application/json",
	"User-agent: Vermintide",
	-- NOTE IF EDITING THESE HEADER ENTRIES
	-- Elsewhere in the code, we overwrite entry number 5
	-- expecting it to override the one just below
	"Prefer: return=representation"
}

local already_synced_player_id = false

local sync_player_id_and_details = function(avatar_url, team_name)
	-- Only do this once per session (with some exceptions)
	if already_synced_player_id then
		return
	end

	local player = Managers.player:local_human_player()
	if player and player:name() then
		-- UPSERT name and set player_id to the resulting id if didn't already have one
		local special_POST_headers = table.clone(POST_headers)
		special_POST_headers[5] = "Prefer: resolution=merge-duplicates,return=representation"

		local bully = mod:get("discord_bully") == true

		local body = {
			["name"] = player:name(),
			["bully"] = bully
		}
		
		if avatar_url then
			body["avatar"] = avatar_url
		end

		if team_name then
			body["team"] = team_name
		end

		local current_id = mod:get("player_id")
		if current_id then
			body["id"] = current_id
		end

		Managers.curl:post("https://nutenihectpiffozotah.supabase.co/rest/v1/Players", cjson.encode(body), special_POST_headers, function(success, code, headers, data, userdata)
			if not success or code ~= 201 or not data then
				mod:echo("Life's Hard Everywhere was unable to sync player info with the database and may not function properly.")
				return
			end

			local decoded = cjson.decode(data)
			if decoded and decoded[1] and decoded[1].id then
				already_synced_player_id = true
				if not current_id then
					mod:set("player_id", decoded[1].id)
				end
			end
		end)
	end
end

local level_table = {}
Managers.curl:get("https://nutenihectpiffozotah.supabase.co/rest/v1/Levels?select=*", GET_headers, function(success, code, headers, data, userdata)
	-- Callback on completion of GET Levels
	if not success then
		debug_error("Received failure status code " .. tostring(code) .. " from LHE server")
		return
	end

	local decoded = cjson.decode(data)

	if not decoded then
		debug_error("Response from LHE server could not be decoded")
		return
	end

	for _,value in ipairs(decoded) do
		level_table[value.name] = value.id
	end
end)

local get_level_key = function()
	local game_mode = Managers.state.game_mode
	if not game_mode then
		return nil
	end
	local level_key = game_mode:level_key()
	if not level_key then
		return nil
	end

	if level_key == "arena_belakor" then
		return level_key
	end

	-- Remove Chaos Wastes name modifiers
	level_key = level_key:gsub("_wastes", "")
	level_key = level_key:gsub("_khorne", "")
	level_key = level_key:gsub("_nurgle", "")
	level_key = level_key:gsub("_slaanesh", "")
	level_key = level_key:gsub("_tzeentch", "")
	level_key = level_key:gsub("_belakor", "")
	level_key = level_key:gsub("_path(%d+)", "")
	level_key = level_key:gsub("_%a$", "")

	return level_key
end

local get_progress_percent = function()
	local success, progress = mod:pcall(function()
		local conflict_director = Managers.state.conflict
		if not conflict_director then
			return nil
		end

		local level_analysis = conflict_director.level_analysis
		if not level_analysis then
			return nil
		end

		local main_path_data = level_analysis.main_path_data
		if not main_path_data then
			return nil
		end

		if not conflict_director.main_path_info then
			return nil
		end

		local ahead_travel_dist = conflict_director.main_path_info.ahead_travel_dist
		if not ahead_travel_dist then
			return nil
		end

		local total_travel_dist = main_path_data.total_dist
		if not total_travel_dist then
			return nil
		end

		return ahead_travel_dist/total_travel_dist*100
	end)

	if not success or not progress then
		return nil
	end

	if is_in_chaos_wastes then
		-- In the Chaos Wastes, there are 5 levels to get through, so this level is only 1/5 as meaningful
		-- But also add 20% for each level already completed
		progress = progress / 5
		progress = progress + (chaos_wastes_levels_started - 1)*20
	end

	return progress
end

local debug_reset_render = function()
	if display_world and display_line_object then
		mod:pcall(function(world, line_object)
			LineObject.reset(line_object)
			LineObject.dispatch(world, line_object)
			World.destroy_line_object(display_world, display_line_object)
		end, display_world, display_line_object)
	end
	display_line_object = nil
	display_world = nil
end

local debug_render = function(data)
	debug_reset_render()

	if Managers.world:has_world("level_world") then
		display_world = Managers.world:world("level_world")
		display_line_object = World.create_line_object(display_world, false)

		for _,value in ipairs(data) do
			local color = Color(255, 255, 0, 0)
			if value.event == 1 then
				color = Color(255, 245, 200, 35)
			end
			LineObject.add_sphere(display_line_object, color, Vector3(value.x, value.y, value.z), 0.25)
		end

		LineObject.dispatch(display_world, display_line_object)
	end
end

local reset_render = function()
	if display_world then
		for _,value in ipairs(bloodstains) do
			World.destroy_unit(display_world, value)
		end
	end
	bloodstains = {}
end

local render = function(data)
	reset_render()

	if Managers.world:has_world("level_world") then
		display_world = Managers.world:world("level_world")
		for _,value in ipairs(data) do
			local path_to_unit = get_bloodstain_unit_given_event(value.event)
			local new_unit = World.spawn_unit(display_world, path_to_unit, Vector3(value.x, value.y, value.z + 0.075), random_spin())
			Unit.set_local_scale(new_unit, 0, Vector3(bloodstain_size, bloodstain_size, bloodstain_size))
			Unit.set_data(new_unit, "LHE_bloodstain_data", value)
			table.insert(bloodstains, new_unit)
		end
	end
end

local pillar_render = function(data)
	reset_render()

	if Managers.world:has_world("level_world") then
		display_world = Managers.world:world("level_world")
		for _,value in ipairs(data) do
			local path_to_unit = get_pillar_unit_given_event(value.event)
			local new_unit = World.spawn_unit(display_world, path_to_unit, Vector3(value.x, value.y, value.z), random_spin())
			Unit.set_local_scale(new_unit, 0, Vector3(pillar_width, pillar_width, pillar_height))
			table.insert(bloodstains, new_unit)
		end
	end
end

local bloodstain_limit = function()
	local level_key = get_level_key()

	if is_in_chaos_wastes then
		local chaos_wastes_max = math.min(max_bloodstains_global, mod:get("max_bloodstains_chaos_wastes_global"))

		if level_key == "arena_ice" then
			return math.min(chaos_wastes_max, mod:get("max_bloodstains_arena_of_determination"))
		end
		if level_key == "arena_ruin" then
			return math.min(chaos_wastes_max, mod:get("max_bloodstains_arena_of_fortitude"))
		end
		if level_key == "arena_cave" then
			return math.min(chaos_wastes_max, mod:get("max_bloodstains_arena_of_courage"))
		end
		if level_key == "arena_citadel" then
			return math.min(chaos_wastes_max, mod:get("max_bloodstains_citadel_arena"))
		end
		if level_key == "arena_belakor" then
			return math.min(chaos_wastes_max, mod:get("max_bloodstains_belakor_arena"))
		end

		return chaos_wastes_max
	else
		if level_key == "plaza" then
			return math.min(max_bloodstains_global, mod:get("max_bloodstains_fow"))
		end
	end
	return max_bloodstains_global
end

local GET_callback = function(success, code, headers, data, userdata)
	if not success then
		debug_error("Received failure status code " .. tostring(code) .. " from LHE server")
		return
	end

	local decoded = cjson.decode(data)

	if not decoded then
		debug_error("Response from LHE server could not be decoded")
		debug_error(data)
		return
	end

	if mod_debug then
		mod:echo("Successfully retrieved bloodstain data from LHE server")
		debug_render(decoded)
	elseif pillar_mode then
		pillar_render(decoded)
	else
		render(decoded)
	end
	
	for _,callback in ipairs(on_bloodstains_loaded) do
		callback()
	end
	on_bloodstains_loaded = {}
end

local GET = function(map_key)
	if (map_key == "inn_level" or map_key == "morris_hub") then
		return
	end

	local max_bloodstains = bloodstain_limit()
	if max_bloodstains == 0 then
		return
	end

	Managers.curl:get("https://nutenihectpiffozotah.supabase.co/rest/v1/OrderedPositions?map=eq." .. map_key .. "&select=*&limit=" .. tostring(max_bloodstains), GET_headers, GET_callback)
end

local last_POST_body = nil
local POST_callback_stored = nil
local POST_callback = function(success, code, headers, data, userdata)
	if success and code == 201 then
		last_POST_body = nil
		debug_echo("Death succesfully recorded on LHE server")
		if data then
			local decoded = cjson.decode(data)
			if decoded and decoded[1] and decoded[1].id then
				deaths[decoded[1].id] = {
					id = decoded[1].id,
					lifetime = 0,
					time_since_check = 0
				}
			end
		end
	else
		debug_error("Received failure status code " .. tostring(code) .. " from LHE server")
		if last_POST_body and last_POST_body.event then
			debug_echo("Retrying death submission with no event")
			last_POST_body.event = nil
			Managers.curl:post("https://nutenihectpiffozotah.supabase.co/rest/v1/Positions", cjson.encode(last_POST_body), POST_headers, POST_callback_stored)
		else
			debug_echo("Not retrying")
		end
	end
end
POST_callback_stored = POST_callback

local POST = function(map_key, x, y, z, cause)
	local body = {
		["level"] = level_table[map_key],
		["x"] = x,
		["y"] = y,
		["z"] = z
	}

	local level_progress = get_progress_percent()
	if level_progress then
		body["progress"] = level_progress
		debug_echo("Recording death with level progress: " .. tostring(level_progress))
	else
		debug_echo("Recording death with no level progress")
	end

	if cause then
		body["cause"] = cause
		debug_echo("Recording death with cause: " .. tostring(cause))
	else
		debug_echo("Recording death with no cause")
	end

	local difficulty_code = get_difficulty_code()
	local mod_state_code = get_mod_state_code()

	if difficulty_code then
		body["difficulty"] = difficulty_code
		debug_echo("Recording death in difficulty: " .. tostring(difficulty_code))
	else
		debug_echo("Recording death with no difficulty")
	end

	if mod_state_code then
		body["mods"] = mod_state_code
		debug_echo("Recording death with difficulty mods: " .. tostring(mod_state_code))
	else
		debug_echo("Recording death with no difficulty mods")
	end

	if num_players == 1 then
		body["true_solo"] = true
		debug_echo("Recording death as true solo run")
	elseif num_players == 2 then
		body["duo"] = true
		debug_echo("Recording death as duo run")
	end

	local player_id = mod:get("player_id")
	if discord_integration and player_id then
		body["player"] = player_id
		debug_echo("Recording death as player id: " .. tostring(player_id))
	else
		debug_echo("Recording death as no player")
	end

	if event then
		body["event"] = event
		debug_echo("Recording death with event: " .. tostring(event_phrase))
	else
		debug_echo("Recording death with no event")
	end

	last_POST_body = body
	Managers.curl:post("https://nutenihectpiffozotah.supabase.co/rest/v1/Positions", cjson.encode(body), POST_headers, POST_callback)
end

local validate_level_in_table = function(level, callback)
	if level_table[level] then
		if callback then
			callback()
		end
		return
	end

	local body = {
		["name"] = level,
		["display"] = level
	}
	Managers.curl:post("https://nutenihectpiffozotah.supabase.co/rest/v1/Levels", cjson.encode(body), POST_headers, function(success, code, headers, data, userdata)
		-- POST callback
		if success and code == 201 then
			Managers.curl:get("https://nutenihectpiffozotah.supabase.co/rest/v1/Levels?name=eq." .. level .. "&select=*", GET_headers, function(success, code, headers, data, userdata)
				-- GET callback
				if not success then
					-- GET failed
					-- TODO logging
					return
				end

				local decoded = cjson.decode(data)

				if not decoded then
					debug_error("Response from LHE server could not be decoded")
					debug_error(data)
					return
				end

				level_table[decoded[1].name] = decoded[1].id

				if not level_table[level] then
					-- TODO logging
					return
				end

				if callback then
					callback()
				end
			end)
		else
			-- POST failed
			-- TODO logging
		end
	end)
end

local process_death = function(player_unit, cause)
	local level_key = get_level_key()
	if (level_key == "inn_level" or level_key == "morris_hub") then
		return
	end
	if player_unit and level_key then
		local x = Unit.world_position(player_unit, 0).x
		local y = Unit.world_position(player_unit, 0).y
		local z = Unit.world_position(player_unit, 0).z

		validate_level_in_table(level_key, function()
			POST(level_key, x, y, z, cause)
		end)
	end
end

mod:command("lifeshardforcerefresh", "", function()
	local level_key = get_level_key()
	GET(level_key)
end)

mod:command("teamname", "Set your team name", function(...)
	local args = {...}
	if not args or args.n == 0 then
		mod:echo("Please provide a name")
		return
	end

	args.n = nil
	local name = table.concat(args, " ")

	already_synced_player_id = false
	sync_player_id_and_details(nil, name)
	mod:echo("Team name set")
end)

mod:command("lifeshardavatar", "Set a URL to an image which will be displayed next to your name in Discord when you die", function(url)
	if not url then
		mod:echo("Please provide a URL to set as your avatar")
		return
	end

	already_synced_player_id = false
	sync_player_id_and_details(url, nil)
	mod:echo("Avatar set")
end)

mod:command("lifeshardevent", "View or set an event phrase for Life's Hard Everywhere", function(phrase)
	local old_event_phrase = mod:get("event_phrase")

	if phrase then
		mod:set("event_phrase", phrase)
		event_phrase = mod:get("event_phrase")
		vmf.save_unsaved_settings_to_file()
	end

	update_event_code()
	if event then
		mod:echo("Event set to: \"".. event_phrase .. "\"")
		mod:echo("The event will only be set for the current V2 session (unless the game crashes). LHE will notify you on startup when it resets the event.")
	else
		event_phrase = old_event_phrase
		mod:set("event_phrase", old_event_phrase)
		if phrase then
			mod:echo("Event \"" .. phrase .. "\" not recognized")
		else
			mod:echo("No event currently set. Use \"/lifeshardevent NameOfEvent\" to set your event.")
		end
	end
end)

local clear_event = function()
	event = nil
	event_phrase = nil
	mod:set("event_phrase", nil)

	update_event_code()
end

mod:command("lifeshardclearevent", "Clear the event phrase for Life's Hard Everywhere", function()
	clear_event()
	mod:echo("Event cleared")
	vmf.save_unsaved_settings_to_file()
end)

--mod:command("lifeshardfakedeath", "", function(cause_code)
--	local player = Managers.player:local_human_player()
--	if not player then
--		return
--	end
--	local player_unit = player.player_unit
--	
--	if player_unit then
--		process_death(player_unit, tonumber(cause_code) or 1001)
--	end
--end)

--mod:command("level", "", function()
--	local level_key = get_level_key()
--	mod:echo(level_key)
--end)

--mod:command("position", "", function()
--	local player = Managers.player:local_human_player()
--	if not player then
--		mod:echo("No player!")
--		return
--	end
--	local player_unit = player.player_unit
--	mod:echo("x: " .. Unit.world_position(player_unit, 0).x)
--	mod:echo("y: " .. Unit.world_position(player_unit, 0).y)
--	mod:echo("z: " .. Unit.world_position(player_unit, 0).z)
--end)

--mod:command("spawnbloodstains", "", function(width)
--	width = width or 1
--
--	local player = Managers.player:local_human_player()
--	if not player then
--		mod:echo("No player!")
--		return
--	end
--	local player_unit = player.player_unit
--	if not player_unit then
--		return
--	end
--	
--	local x = Unit.world_position(player_unit, 0).x
--	local y = Unit.world_position(player_unit, 0).y
--	local z = Unit.world_position(player_unit, 0).z
--	
--	
--	
--	display_world = Managers.world:world("level_world")
--	if not display_world then
--		return
--	end
--	
--	if width == 1 then
--		World.spawn_unit(display_world, bloodstain_unit_path, Vector3(x, y, z + 0.075), random_spin())
--		return
--	end
--	
--	local grid_size = 0.5
--	local spawned = 0
--	
--	for l = 1, width, 1 do
--		local l_offset = (l-width)*grid_size*3
--		for w = 1, width, 1 do
--			local w_offset = (w-width)*grid_size*3
--			for h = 1, width, 1 do
--				local h_offset = (h-width)*grid_size
--				
--				local new_unit = World.spawn_unit(display_world, bloodstain_unit_path, Vector3(x + l_offset, y + w_offset, z + h_offset), random_spin())
--				spawned = spawned + 1
--			end
--		end
--	end
--	
--	mod:echo("Spawned " .. tostring(spawned) .. " bloodstains")
--end)

--mod:command("spawnpillars", "", function(width)
--	width = width or 1
--
--	local player = Managers.player:local_human_player()
--	if not player then
--		mod:echo("No player!")
--		return
--	end
--	local player_unit = player.player_unit
--	if not player_unit then
--		return
--	end
--	
--	local x = Unit.world_position(player_unit, 0).x
--	local y = Unit.world_position(player_unit, 0).y
--	local z = Unit.world_position(player_unit, 0).z
--	
--	
--	
--	display_world = Managers.world:world("level_world")
--	if not display_world then
--		return
--	end
--	
--	if width == 1 then
--		local single_unit = World.spawn_unit(display_world, pillar_azure_unit_path, Vector3(x, y, z), random_spin())
--		return
--	end
--	
--	local grid_size = 0.5
--	local spawned = 0
--	
--	for l = 1, width, 1 do
--		local l_offset = (l-width)*grid_size*3
--		for w = 1, width, 1 do
--			local w_offset = (w-width)*grid_size*3
--			
--			local new_unit = World.spawn_unit(display_world, pillar_azure_unit_path, Vector3(x + l_offset, y + w_offset, z), random_spin())
--			spawned = spawned + 1
--		end
--	end
--	
--	mod:echo("Spawned " .. tostring(spawned) .. " pillars")
--end)

--mod:command("playername", "", function()
--	local player = Managers.player:local_human_player()
--	if not player then
--		mod:echo("No player!")
--		return
--	end
--	mod:echo(tostring(player:name()))
--end)

--mod:command("difficulty", "", function()
--	mod:echo(tostring(Managers.state.difficulty:get_difficulty()))
--end)

--mod:command("player_id", "", function()
--	mod:echo(tostring(mod:get("player_id")))
--end)

local tagging_input_extension = nil
local tagging_first_person_extension = nil
mod:hook_safe(ContextAwarePingExtension, "extensions_ready", function(self, world, unit)
	tagging_input_extension = ScriptUnit.extension(unit, "input_system")
	tagging_first_person_extension = ScriptUnit.extension(unit, "first_person_system")
end)

mod:hook_safe(ContextAwarePingExtension, "_check_raycast", function(self, unit)
	if not ping_bloodstains then
		return
	end
	if not display_world then
		return
	end
	if not tagging_input_extension or not tagging_first_person_extension then
		return
	end

	local camera_position = tagging_first_person_extension:current_position()
	local camera_rotation = tagging_first_person_extension:current_rotation()
	local camera_forward = Quaternion.forward(camera_rotation)

	-- Check before we divide by 0
	if camera_forward.z == 0 then
		return
	end

	for k,v in pairs(bloodstains) do
		local bloodstain_position = Unit.world_position(v, 0)
		local camera_to_bloodstain = bloodstain_position - camera_position

		-- Rule out all bloodstains that are behind us
		if Vector3.dot(camera_to_bloodstain, camera_forward) <= 0 then
			goto continue
		end

		-- Calculate the x,y of the point where camera_forward intersects the z-plane of the bloodstain
		local z_factor = camera_to_bloodstain.z / camera_forward.z
		local x_travel = camera_forward.x * z_factor
		local y_travel = camera_forward.y * z_factor
		local intersect = Vector3(camera_position.x + x_travel, camera_position.y + y_travel, bloodstain_position.z)

		if Vector3.distance(intersect, bloodstain_position) < bloodstain_size * 0.63 and Vector3.distance(intersect, camera_position) < 50 then
			if Unit.has_data(v, "LHE_bloodstain_data") then
				local player_name = "A player"
				local cause = "mysterious circumstances..."
				local data = Unit.get_data(v, "LHE_bloodstain_data")
				if type(data.player) == "string" then
					player_name = data.player
				end
				if type(data.cause) == "string" then
					cause = data.cause
				end
				mod:echo(player_name .. " died to " .. cause)
			end
		end

		::continue::
	end
end)

local last_event_POST_body = nil
local event_POST_callback_stored = nil
local event_POST_callback = function(success, code, headers, data, userdata)
	if success and code == 201 then
		last_event_POST_body = nil
		debug_echo("Event start succesfully recorded on LHE server")
	else
		debug_error("Received failure status code " .. tostring(code) .. " from LHE server")
		if last_event_POST_body and last_event_POST_body.event then
			debug_echo("Retrying event start submission with no community event")
			last_event_POST_body.event = nil
			Managers.curl:post("https://nutenihectpiffozotah.supabase.co/rest/v1/EventStarts", cjson.encode(last_event_POST_body), POST_headers, event_POST_callback_stored)
		else
			debug_echo("Not retrying")
		end
	end
end
event_POST_callback_stored = POST_callback

local event_POST = function(event_code)
	local body = {
		["level_event"] = event_code
	}

	local player_id = mod:get("player_id")
	if discord_integration and player_id then
		body["player"] = player_id
		debug_echo("Recording event start as player id: " .. tostring(player_id))
	else
		debug_echo("Recording event start as no player")
	end

	if event then
		body["event"] = event
		debug_echo("Recording event start with community event: " .. tostring(event_phrase))
	else
		debug_echo("Recording event start with no community event")
	end

	last_event_POST_body = body
	Managers.curl:post("https://nutenihectpiffozotah.supabase.co/rest/v1/EventStarts", cjson.encode(body), POST_headers, event_POST_callback)
end

local already_activated_events = {}

mod:hook_safe(TerrorEventMixer, "start_event", function(event_name, data)
	if not Managers.player.is_server or not event_name then
		return
	end

	if map_event_codes[event_name] and not already_activated_events[map_event_codes[event_name]] then
		already_activated_events[map_event_codes[event_name]] = true
		event_POST(map_event_codes[event_name])
	end
end)

local last_monster_POST_body = nil
local monster_POST_callback_stored = nil
local monster_POST_callback = function(success, code, headers, data, userdata)
	if success and code == 201 then
		last_monster_POST_body = nil
		debug_echo("Monster spawn succesfully recorded on LHE server")
	else
		debug_error("Received failure status code " .. tostring(code) .. " from LHE server")
		if last_monster_POST_body and last_monster_POST_body.event then
			debug_echo("Retrying monster spawn submission with no community event")
			last_monster_POST_body.event = nil
			Managers.curl:post("https://nutenihectpiffozotah.supabase.co/rest/v1/MonsterSpawns", cjson.encode(last_monster_POST_body), POST_headers, monster_POST_callback_stored)
		else
			debug_echo("Not retrying")
		end
	end
end
monster_POST_callback_stored = POST_callback

local monster_POST = function(monster_code, player_id, level_key)
	local body = {
		["monster"] = monster_code,
		["player"] = player_id,
		["level"] = level_table[level_key],
	}

	if event then
		body["event"] = event
		debug_echo("Recording monster spawn with community event: " .. tostring(event_phrase))
	else
		debug_echo("Recording monster spawn with no community event")
	end

	Managers.curl:post("https://nutenihectpiffozotah.supabase.co/rest/v1/MonsterSpawns", cjson.encode(body), POST_headers, event_POST_callback)
end

local monster_codes = {
	["units/beings/enemies/skaven_rat_ogre/chr_skaven_rat_ogre"] = 1,
	["units/beings/enemies/skaven_stormfiend/chr_skaven_stormfiend"] = 2,
	["units/beings/enemies/chaos_troll/chr_chaos_troll"] = 3,
	["units/beings/enemies/chaos_spawn/chr_chaos_spawn"] = 4,
	["units/beings/enemies/beastmen_minotaur/chr_beastmen_minotaur"] = 5,
}

mod:hook_safe(UnitSpawner, "spawn_local_unit_with_extensions", function(self, unit_name, unit_template_name, extension_init_data, position, rotation, material)
	if not Managers.player or not Managers.player.is_server or not unit_name then
		return
	end

	local monster_code = monster_codes[unit_name]

	if not monster_code then
		return
	end

	if not discord_integration then
		return
	end
	local player_id = mod:get("player_id")
	if not player_id then
		return
	end

	local level_key = get_level_key()
	if (level_key == "inn_level" or level_key == "morris_hub") then
		return
	end

	monster_POST(monster_code, player_id, level_key)
end)


local last_damage_cause_override = nil
local last_damage_source = nil
local last_damage_is_ff = false
local last_damage_is_self = false
local last_ff_breed = nil

local knocked_down_cause_override = nil
local knocked_down_damage_source = nil
local knocked_down_damage_is_ff = false
local knocked_down_damage_is_self = false
local knocked_down_ff_breed = nil

mod:hook_safe(BulldozerPlayer, "spawn", function (self, optional_position, optional_rotation, is_initial_spawn, ammo_melee, ammo_ranged, healthkit, potion, grenade, ability_cooldown_percent_int, additional_items, initial_buff_names)
	can_die = true

	last_damage_cause_override = nil
	knocked_down_cause_override = nil
	local level_key = get_level_key()

	if level_key then
		GET(level_key)
	end
end)

local damage_taken_exclusions =
{
	"temporary_health_degen"
}
local function consider_damage_taken(source)
	for i,exclusion in ipairs(damage_taken_exclusions) do
		if source == exclusion then
			return false
		end
	end
	return true
end

local friendly_fire_exclusions =
{
	"temporary_health_degen",
	"knockdown_bleed",
	"ground_impact"
}
local function can_be_friendly_fire(source)
	for i,exclusion in ipairs(friendly_fire_exclusions) do
		if source == exclusion then
			return false
		end
	end
	return true
end

local disabled_by_assassin = function(status_extension)
	return status_extension:is_pounced_down()
end

local disabled_by_hook_rat = function(status_extension)
	return status_extension:is_grabbed_by_pack_master() or status_extension:is_hanging_from_hook()
end

local disabled_by_life_leech = function(status_extension)
	status_extension:is_grabbed_by_corruptor()
end

mod:hook(PlayerUnitHealthExtension, "add_damage", function (func, self, attacker_unit, damage_amount, hit_zone_name, damage_type, hit_position, damage_direction, damage_source_name, hit_ragdoll_actor, source_attacker_unit, hit_react_type, is_critical_strike, added_dot, first_hit, total_hits, attack_type, backstab_multiplier)
	local local_player_unit = Managers.player:local_human_player().player_unit

	if self:is_alive() and self.unit == local_player_unit and consider_damage_taken(damage_source_name) then

		local attacker_side = nil
		if attacker_unit then
			attacker_side = Managers.state.side.side_by_unit[attacker_unit]
			if not attacker_side and source_attacker_unit then
				attacker_side = Managers.state.side.side_by_unit[source_attacker_unit]
			end
		end
		local self_side = Managers.state.side.side_by_unit[self.unit]
		local is_friendly_fire = (attacker_side == self_side) and can_be_friendly_fire(damage_source_name)

		local status_extension = ScriptUnit.extension(local_player_unit, "status_system")

		if status_extension then
			if disabled_by_assassin(status_extension) then
				last_damage_cause_override = enemy_codes.skaven_gutter_runner
			elseif disabled_by_hook_rat(status_extension) then
				last_damage_cause_override = enemy_codes.skaven_pack_master
			elseif disabled_by_life_leech(status_extension) then
				last_damage_cause_override = enemy_codes.chaos_corruptor_sorcerer
			else
				last_damage_cause_override = nil
			end
		else
			last_damage_cause_override = nil
		end

		if last_damage_cause_override == nil then
			if damage_type == "burninating" or
				damage_type == "skulls_of_fury" or
				damage_type == "bolt_of_change"
			then
				last_damage_cause_override = damage_type
			end
		end

		last_damage_source = damage_source_name
		last_damage_is_ff = is_friendly_fire
		last_damage_is_self = (attacker_unit or source_attacker_unit) == local_player_unit

		if last_damage_is_ff and attacker_unit and Unit.alive(attacker_unit) then
			local breed = Unit.get_data(attacker_unit, "breed")
			if breed then
				last_ff_breed = breed.name
			elseif source_attacker_unit and Unit.alive(source_attacker_unit) then
				breed = Unit.get_data(source_attacker_unit, "breed")
				if breed then
					last_ff_breed = breed.name
				end
			end
		elseif last_damage_is_ff and source_attacker_unit and Unit.alive(source_attacker_unit) then
			local breed = Unit.get_data(source_attacker_unit, "breed")
			if breed then
				last_ff_breed = breed.name
			end
		end
	end
	func(self, attacker_unit, damage_amount, hit_zone_name, damage_type, hit_position, damage_direction, damage_source_name, hit_ragdoll_actor, source_attacker_unit, hit_react_type, is_critical_strike, added_dot, first_hit, total_hits, attack_type, backstab_multiplier)
end)

mod:hook_safe(GenericStatusExtension, "set_knocked_down", function (self, knocked_down)
	local player = Managers.player:local_human_player()
	if not player then
		return
	end
	local player_unit = player.player_unit
	if player_unit ~= self.unit then
		return
	end

	if not knocked_down then
		knocked_down_cause_override = nil
		knocked_down_damage_source = nil
		knocked_down_damage_is_ff = false
		knocked_down_damage_is_self = false
		knocked_down_ff_breed = nil
		return
	end

	local status_extension = ScriptUnit.extension(player_unit, "status_system")

	if status_extension then
		if disabled_by_assassin(status_extension) then
			knocked_down_cause_override = enemy_codes.skaven_gutter_runner
		elseif disabled_by_hook_rat(status_extension) then
			knocked_down_cause_override = enemy_codes.skaven_pack_master
		elseif disabled_by_life_leech(status_extension) then
			knocked_down_cause_override = enemy_codes.chaos_corruptor_sorcerer
		end
	end

	knocked_down_damage_source = last_damage_source
	knocked_down_damage_is_ff = last_damage_is_ff
	knocked_down_damage_is_self = last_damage_is_self
	knocked_down_ff_breed = last_ff_breed
end)

local determine_cause_and_process_death = function()
	local player = Managers.player:local_human_player()
	if not player then
		return
	end
	local player_unit = player.player_unit

	local status_extension = ScriptUnit.extension(player_unit, "status_system")

	if not status_extension then
		process_death(player_unit, get_damage_source_code(last_damage_source, last_damage_is_ff, last_damage_is_self, last_ff_breed))
		return
	end

	local cause = nil
	if disabled_by_assassin(status_extension) then
		cause = 19
	elseif disabled_by_hook_rat(status_extension) then
		cause = 20
	elseif disabled_by_life_leech(status_extension) then
		cause = 8
	elseif status_extension:is_knocked_down() then
		if knocked_down_cause_override then
			cause = knocked_down_cause_override
		else
			cause = get_damage_source_code(knocked_down_damage_source, knocked_down_damage_is_ff, knocked_down_damage_is_self, knocked_down_ff_breed)
		end
	else
		if last_damage_cause_override then
			cause = last_damage_cause_override
		else
			cause = get_damage_source_code(last_damage_source, last_damage_is_ff, last_damage_is_self, last_ff_breed)
		end
	end

	process_death(player_unit, cause)
end

mod:hook_safe(GenericStatusExtension, "set_dead", function (self, dead)
	local player = Managers.player:local_human_player()
	if not player then
		return
	end
	local player_unit = player.player_unit
	if player_unit ~= self.unit then
		return
	end

	if can_die and dead then
		can_die = false
		determine_cause_and_process_death()
	end
end)


local disabled_or_downed = function(status_extension)
	return (status_extension:is_disabled_non_temporarily() or status_extension:is_knocked_down()) and not status_extension:is_dead() and not status_extension:is_ready_for_assisted_respawn()
end

-- Handle the game ending in most cases (leaving won't hit this)
local function handle_evaluate_end_conditions(func, self, round_started, dt, t, ...)
	local ended, reason = func(self, round_started, dt, t, ...)

	if ended then
		if reason ~= "won" and can_die then
			local player = Managers.player:local_human_player()
			if not player then
				return
			end
			local player_unit = player.player_unit

			local status_extension = ScriptUnit.extension(player_unit, "status_system")

			if status_extension and disabled_or_downed(status_extension) then
				determine_cause_and_process_death()
			end
		end
		can_die = false
	end

	return ended, reason
end

-- Utility function to hook onto "evaluate_end_conditions" for a given game mode.
-- This will handle most cases for the server
local function hook_evaluate_end_conditions(game_mode_object)
	mod:hook(game_mode_object, "evaluate_end_conditions", function(func, self, round_started, dt, t, ...)
		return handle_evaluate_end_conditions(func, self, round_started, dt, t, ...)
	end)
end

hook_evaluate_end_conditions(GameModeAdventure)
hook_evaluate_end_conditions(GameModeDeus)
hook_evaluate_end_conditions(GameModeWeave)
hook_evaluate_end_conditions(GameModeSurvival)

mod:hook_safe(GameNetworkManager, "rpc_gm_event_end_conditions_met", function (self, channel_id, reason_id, checkpoint_available, peer_ids, local_player_ids, percentages)
	if not self.is_server and can_die then
		local end_reason = NetworkLookup.game_end_reasons[reason_id]

		if end_reason ~= "won" then
			local player = Managers.player:local_human_player()
			if not player then
				return
			end
			local player_unit = player.player_unit

			local status_extension = ScriptUnit.extension(player_unit, "status_system")
			if status_extension and disabled_or_downed(status_extension) then
				determine_cause_and_process_death()
			end
		end
		can_die = false
	end
end)

-- Failsafe hook in case we didn't hit "evalutate_end_conditions"
mod:hook_safe(StateIngame, "_check_and_add_end_game_telemetry", function (self, application_shutdown)
	if can_die then
		local player = Managers.player:player_from_peer_id(self.peer_id)
		if not player then
			return
		end
		local player_unit = player.player_unit
		if not player_unit then
			return
		end

		local status_extension = ScriptUnit.extension(player_unit, "status_system")
		if status_extension and disabled_or_downed(status_extension) then
			determine_cause_and_process_death()
		end
		can_die = false
	end
end)

mod:hook_safe(GameModeDeus, "init", function (self, settings, world, network_server, is_server, profile_synchronizer, level_key, statistics_db, game_mode_settings)
	is_in_chaos_wastes = true
	chaos_wastes_levels_started = chaos_wastes_levels_started + 1
end)

local time_to_quit = false
mod:hook_safe(GameStateMachine, "post_update", function(dt)
	if Boot.quit_game and not time_to_quit then
		if event_phrase then
			mod:set("startup_notice_event", "LHE has automatically turned off event mode for \"" .. event_phrase .. "\"\nIf you are still participating in this event, run the command \"/lifeshardevent " .. event_phrase .. "\" again.")
			clear_event()
		end
	end
end)

mod.on_all_mods_loaded = function()
	vmf = get_mod("VMF")
	bl = get_mod("Beastmen Loader")

	local startup_notice_event = mod:get("startup_notice_event")
	if startup_notice_event then
		mod:set("startup_notice_event", nil)
		mod:echo(startup_notice_event)
		vmf.save_unsaved_settings_to_file()
	end
end

mod.on_game_state_changed = function(status, state_name)
	already_activated_events = {}

	if state_name == "StateLoading" then
		num_players = 0
		is_in_chaos_wastes = false

		if status == "enter" then
			tagging_input_extension = nil
			tagging_first_person_extension = nil
			display_world = nil
		end
	end

	local level_key = get_level_key()

	if state_name == "StateIngame" and level_key == "morris_hub" then
		chaos_wastes_levels_started = 0
	end

	if state_name == "StateIngame" and level_key == "inn_level" and mod:get("discord_integration") then
		sync_player_id_and_details(nil, nil)
	end

	if mod_debug then
		debug_reset_render()
	else
		reset_render()
	end
end

local new_reactions_callback = function(death, success, code, headers, data, userdata)
	if not success or not data or code ~= 200 or headers["Content-Type"] ~= "application/json; charset=utf-8" then
		return
	end

	mod:pcall(function(death, data)
		local decoded = cjson.decode(data)

		if not decoded then
			return
		end

		for _,value in ipairs(decoded) do
			local discord_user = value.user or "Someone"
			mod:echo(discord_user .. " reacted with " .. value.emoji)
			if not death.last_retrieved or value.id > death.last_retrieved then
				death.last_retrieved = value.id
			end
		end
	end, death, data)

	if death.to_remove then
		deaths[death.id] = nil
	end
end

local check_for_reactions = function(death)
	local most_recent_retrieved_text = ""
	if death.last_retrieved then
		most_recent_retrieved_text = "&id=gt." .. death.last_retrieved
	end

	Managers.curl:get("https://nutenihectpiffozotah.supabase.co/rest/v1/Reactions?death=eq." .. death.id .. most_recent_retrieved_text .. "&select=*", GET_headers, function(success, code, headers, data, userdata)
		new_reactions_callback(death, success, code, headers, data, userdata)
	end)
end

mod.get_loaded_bloodstain_positions = function()
	local positions = {}
	for _,value in ipairs(bloodstains) do
		if Unit.has_data(value, "LHE_bloodstain_data") then
			local data = Unit.get_data(value, "LHE_bloodstain_data")
			local position = {}
			position.x = data.x
			position.y = data.y
			position.z = data.z
			table.insert(positions, position)
		end
	end
	return positions
end

mod.one_time_hook_bloodstains_loaded = function(callback)
	if callback == nil or type(callback) ~= "function" then
		return
	end
	table.insert(on_bloodstains_loaded, callback)
end

mod.update = function(dt)
	local current_num_players = Managers.player:num_players()
	if current_num_players > num_players then
		num_players = current_num_players
	end

	for id,value in pairs(deaths) do
		value.lifetime = value.lifetime + dt
		value.time_since_check = value.time_since_check + dt
		if value.lifetime > 600 then
			value.to_remove = true
		end
		if value.time_since_check > reaction_polling_interval then
			value.time_since_check = value.time_since_check - reaction_polling_interval
			if display_community_reactions then
				check_for_reactions(value)
			elseif value.to_remove then
				deaths[id] = nil
			end
		end
	end
end

mod.on_setting_changed = function(setting_id)
	if setting_id == "max_bloodstains_global" then
		max_bloodstains_global = mod:get("max_bloodstains_global")
	elseif setting_id == "discord_integration" then
		discord_integration = mod:get("discord_integration")
		if discord_integration then
			sync_player_id_and_details(nil, nil)
		end
	elseif setting_id == "discord_bully" then
		already_synced_player_id = false
		sync_player_id_and_details(nil, nil)
	elseif setting_id == "ping_for_bloodstain_details" then
		ping_bloodstains = mod:get("ping_for_bloodstain_details")
	elseif setting_id == "bloodstain_size" then
		bloodstain_size = mod:get("bloodstain_size")
	elseif setting_id == "mod_debug" then
		mod_debug = mod:get("mod_debug")
		if mod_debug then
			reset_render()
		else
			debug_reset_render()
		end
	elseif setting_id == "pillar_mode" then
		pillar_mode = mod:get("pillar_mode")
		reset_render()
	elseif setting_id == "pillar_height" then
		pillar_height = mod:get("pillar_height")
		reset_render()
	elseif setting_id == "pillar_width" then
		pillar_width = mod:get("pillar_width")
		reset_render()
	end

	local level_key = get_level_key()

	if level_key then
		GET(level_key)
	end
end

