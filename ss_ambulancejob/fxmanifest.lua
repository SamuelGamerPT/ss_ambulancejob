fx_version "adamant"

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

games {"rdr3"}

client_scripts {
    "config.lua",
    "client/main.lua",
    "client/warmenu.lua"
}

server_script {
    "@mysql-async/lib/MySQL.lua",
    "config.lua",
    "server/main.lua",
}