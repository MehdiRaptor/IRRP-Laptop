fx_version 'bodacious'
game 'gta5'

client_scripts {
    'client.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server.lua'
}

shared_scripts {
    'config.lua'
}

ui_page('ui/index.html')

files {
    'ui/index.html',
    'ui/script.js',
    'ui/style.css',
    'ui/img/typ.png',
    'ui/img/bg.jpg'
}