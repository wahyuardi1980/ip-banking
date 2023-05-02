fx_version 'bodacious'
games { 'gta5' }
lua54 'yes'


shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua'
}


client_scripts {
    'config.lua',
    'client.lua'
}

server_script {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

server_export 'updateLast'

ui_page 'ui/index.html'

files {
    'ui/*'
}
