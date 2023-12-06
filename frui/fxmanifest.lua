shared_script '@fr-ac/ai_module_fg-obfuscated.lua'
fx_version 'bodacious'
games { 'gta5' }
description "RP module/framework"
ui_page "ui/index.html"
-- client scripts
client_scripts{
    "@fr/lib/utils.lua",
    "client/*.lua",
}
-- client files
files{
    "ui/*.ttf",
    "ui/*.otf",
    "ui/*.woff",
    "ui/*.woff2",
    "ui/*.css",
    "ui/*.png",
    "ui/main.js",
    "ui/index.html",
    -- Loading Screen
    'loading/**',
}
loadscreen 'loading/loading.html'
loadscreen_cursor 'yes'
loadscreen_manual_shutdown "yes"
