local mod = get_mod("Lifes Hard Everywhere")

return {
	name = "Life's Hard Everywhere",
	description = mod:localize("mod_description"),
	is_togglable = true,
	options = {
		widgets = {
			{
				setting_id  = "discord_integration",
				type        = "checkbox",
				default_value = false,
				sub_widgets = {
					{
						setting_id = "discord_bully",
						type = "checkbox",
						default_value = false
					},
					{
						setting_id = "display_community_reactions",
						type = "checkbox",
						default_value = true
					},
					{
						setting_id = "reaction_polling_interval",
						type = "numeric",
						default_value = 15,
						range = {5, 60},
						unit_text = "unit_seconds",
						decimals_number = 0
					},
				}
			},
			--{
			--	setting_id  = "event_phrase",
			--	type        = "text",
			--	default_value = "",
			--	max_length = 20,
			--	validate = function(value)
			--		return value and (string.len(value) == 0 or mod.event_phrases[value])
			--	end
			--},
			{
				setting_id  = "max_bloodstains_group",
				type        = "group",
				sub_widgets = {
					{
						setting_id = "max_bloodstains_global",
						type = "numeric",
						default_value = 150,
						range = {0, 10000},
						decimals_number = 0
					},
					{
						setting_id = "max_bloodstains_fow",
						type = "numeric",
						default_value = 40,
						range = {0, 10000},
						decimals_number = 0
					},
					{
						setting_id  = "max_bloodstains_chaos_wastes_group",
						type        = "group",
						sub_widgets = {
							{
								setting_id = "max_bloodstains_chaos_wastes_global",
								type = "numeric",
								default_value = 150,
								range = {0, 10000},
								decimals_number = 0
							},
							{
								setting_id = "max_bloodstains_arena_of_determination",
								type = "numeric",
								default_value = 100,
								range = {0, 10000},
								decimals_number = 0
							},
							{
								setting_id = "max_bloodstains_arena_of_fortitude",
								type = "numeric",
								default_value = 50,
								range = {0, 10000},
								decimals_number = 0
							},
							{
								setting_id = "max_bloodstains_arena_of_courage",
								type = "numeric",
								default_value = 35,
								range = {0, 10000},
								decimals_number = 0
							},
							{
								setting_id = "max_bloodstains_citadel_arena",
								type = "numeric",
								default_value = 150,
								range = {0, 10000},
								decimals_number = 0
							},
							{
								setting_id = "max_bloodstains_belakor_arena",
								type = "numeric",
								default_value = 60,
								range = {0, 10000},
								decimals_number = 0
							}
						}
					}
				}
			},
			{
				setting_id = "ping_for_bloodstain_details",
				type = "checkbox",
				default_value = true
			},
			{
				setting_id = "bloodstain_size",
				type = "numeric",
				default_value = 1,
				range = {0.1, 10},
				decimals_number = 2
			},
			{
				setting_id  = "advanced_group",
				type        = "group",
				sub_widgets = {
					{
						setting_id = "pillar_mode",
						type = "checkbox",
						default_value = false,
						sub_widgets = {
							{
								setting_id = "pillar_height",
								type = "numeric",
								default_value = 1,
								range = {0.01, 10},
								decimals_number = 2
							},
							{
								setting_id = "pillar_width",
								type = "numeric",
								default_value = 1,
								range = {0.5, 10},
								decimals_number = 2
							},
						}
					},
					{
						setting_id = "mod_debug",
						type = "checkbox",
						default_value = false
					},
				}
			}
		},
	},
}
