return {
	settings = {
		tailwindCSS = {
			experimental = {
				classRegex = {
					-- tailwind variants
					{
						"tv\\((([^()]*|\\([^()]*\\))*)\\)",
						"[\"'`]([^\"'`]*).*?[\"'`]",
					},
					-- react-native-tw (tailwind/tw) fn
					{
						"tailwind|tw\\(([^)]*)\\)",
						"[\"'`]([^\"'`]*).*?[\"'`]",
					},
				},
			},
		},
	},
}
