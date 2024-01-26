return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`Lifes Hard Everywhere` mod must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("Lifes Hard Everywhere", {
			mod_script       = "scripts/mods/Lifes Hard Everywhere/Lifes Hard Everywhere",
			mod_data         = "scripts/mods/Lifes Hard Everywhere/Lifes Hard Everywhere_data",
			mod_localization = "scripts/mods/Lifes Hard Everywhere/Lifes Hard Everywhere_localization",
		})
	end,
	packages = {
		"resource_packages/Lifes Hard Everywhere/Lifes Hard Everywhere",
	},
}
