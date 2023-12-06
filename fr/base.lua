MySQL = module("modules/MySQL")

Proxy = module("lib/Proxy")
Tunnel = module("lib/Tunnel")
Lang = module("lib/Lang")
Debug = module("lib/Debug")

local config = module("cfg/base")
local version = module("version")
local WhiteListed = false
local verify_card = {
    ["type"] = "AdaptiveCard",
    ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
    ["version"] = "1.3",
    ["backgroundImage"] = {
        ["url"] = "",
    },
    ["body"] = {
        {
            ["type"] = "TextBlock",
            ["text"] = "In order to connect to FR you must be in our discord and verify your account. please follow the below instructions",
            ["horizontalAlignment"] = "Center",
            ["size"] = "Large",
            ["wrap"] = true,
            ["weight"] = "Bolder"
        },
        {
            ["type"] = "Container",
            ["horizontalAlignment"] = "Center",
            ["size"] = "Large",
            ["items"] = {
                {
                    ["type"] = "TextBlock",
                    ["text"] = "Join the FR discord (discord.gg/fr5m)",
                    ["horizontalAlignment"] = "Center",
                    ["size"] = "Large",
                    ["wrap"] = false,
                },
                {
                    ["type"] = "TextBlock",
                    ["text"] = "In the #verify channel, type the following command",
                    ["horizontalAlignment"] = "Center",
                    ["size"] = "Large",
                    ["wrap"] = false,
                },
                {
                    ["type"] = "TextBlock",
                    ["color"] = "Attention",
                    ["horizontalAlignment"] = "Center",
                    ["size"] = "Large",
                    ["text"] = "!verify NULL",
                    ["wrap"] = false,
                },
                {
                    ["type"] = "TextBlock",
                    ["color"] = "Attention",
                    ["horizontalAlignment"] = "Center",
                    ["size"] = "Large",
                    ["text"] = "Your account has not beem verified yet. (Attempt 0)",
                    ["wrap"] = false,
                }
            }
        },
        {
            ['type'] = 'ActionSet',
            ["horizontalAlignment"] = "Center",
            ["size"] = "Large",
            ['actions'] = {
                {
                    ['type'] = 'Action.Submit',
                    ['title'] = 'Enter FR',
                    ["horizontalAlignment"] = "Center",
                    ["size"] = "Large",
                    ['id'] = 'connectButton', -- Add an ID to the button action
                    ['data'] = {
                        ['action'] = 'connectClicked',
                    },
                },             
            },
        },
    }
}
local ban_card = {
    ["type"] = "AdaptiveCard",
    ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
    ["version"] = "1.3",
    ["backgroundImage"] = {
        ["url"] = "",
    },
    ["body"] = {
        {
            ["type"] = "TextBlock",
            ["text"] = "FR Public",
            ["highlight"] = true,
            ["horizontalAlignment"] = "Center",
            ["size"] = "Medium",
            ["wrap"] = true,
            ["weight"] = "Bolder",
        },
        {
            ["type"] = "Container",
            ["horizontalAlignment"] = "Center",
            ["items"] = {
                {
                    ["type"] = "TextBlock",
                    ["text"] = "Ban expires in NULL",
                    ["horizontalAlignment"] = "Center",
                    ["size"] = "Large",
                    ["wrap"] = false,

                },
                {
                    ["type"] = "TextBlock",
                    ["text"] = "Your ID: NULL",
                    ["horizontalAlignment"] = "Center",
                    ["size"] = "Large",
                    ["wrap"] = false,
                },
                {
                    ["type"] = "TextBlock",
                    ["horizontalAlignment"] = "Center",
                    ["size"] = "Large",
                    ["text"] = "Reason: NULL",
                    ["wrap"] = false,
                },
                {
                    ["type"] = "TextBlock",
                    ["color"] = "Attention",
                    ["horizontalAlignment"] = "Center",
                    ["size"] = "Medium",
                    ["color"] = "Warning",
                    ["text"] = "If you believe this ban is invalid, please appeal on our discord",
                    ["wrap"] = false,
                    ["isSubtle"] = true,
                },
            }
        },
        {
            ['type'] = 'ActionSet',
            ["horizontalAlignment"] = "Center",
            ["size"] = "Large",
            ['actions'] = {
                {
                    ['type'] = 'Action.OpenUrl',
                    ['title'] = 'FR Discord',
                    ["horizontalAlignment"] = "Center",
                    ["size"] = "Large",
                    ["url"] = "https://discord.gg/fr5m",
                },
                {
                    ['type'] = 'Action.Submit',
                    ['title'] = 'FR Support',
                    ["horizontalAlignment"] = "Center",
                    ["size"] = "Large",
                    ["url"] = "https://discord.gg/TpGbCTVvsa",
                },
            },
        }
    }
}





Debug.active = config.debug
FR = {}
Proxy.addInterface("FR",FR)

tFR = {}
Tunnel.bindInterface("FR",tFR) -- listening for client tunnel

-- load language 
local dict = module("cfg/lang/"..config.lang) or {}
FR.lang = Lang.new(dict)

-- init
FRclient = Tunnel.getInterface("FR","FR") -- server -> client tunnel

FR.users = {} -- will store logged users (id) by first identifier
FR.rusers = {} -- store the opposite of users
FR.user_tables = {} -- user data tables (logger storage, saved to database)
FR.user_tmp_tables = {} -- user tmp data tables (logger storage, not saved)
FR.user_sources = {} -- user sources 
Citizen.CreateThread(function()
    Wait(1000) -- Wait for GHMatti to Initialize
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS fr_users(
    id INTEGER AUTO_INCREMENT,
    last_login VARCHAR(100),
    username VARCHAR(100),
    license VARCHAR(100),
    banned BOOLEAN,
    bantime VARCHAR(100) NOT NULL DEFAULT "",
    banreason VARCHAR(1000) NOT NULL DEFAULT "",
    banadmin VARCHAR(100) NOT NULL DEFAULT "",
    baninfo VARCHAR(2000) NOT NULL DEFAULT "",
    CONSTRAINT pk_user PRIMARY KEY(id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS fr_user_ids (
    identifier VARCHAR(100) NOT NULL,
    user_id INTEGER,
    banned BOOLEAN,
    CONSTRAINT pk_user_ids PRIMARY KEY(identifier)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS fr_user_ids (
    identifier VARCHAR(100) NOT NULL,
    user_id INTEGER,
    banned BOOLEAN,
    CONSTRAINT pk_user_ids PRIMARY KEY(identifier)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS cardevs (
    userid varchar(255),
    reportscompleted int,
    currentreport int,
    PRIMARY KEY(userid)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS cardev (
    reportid int NOT NULL AUTO_INCREMENT,
    spawncode varchar(255),
    issue varchar(255), 
    reporter varchar(255), 
    claimed varchar(255),
    completed boolean,
    notes varchar(255),
    PRIMARY KEY (reportid)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS fr_user_data(
    user_id INTEGER,
    dkey VARCHAR(100),
    dvalue TEXT,
    CONSTRAINT pk_user_data PRIMARY KEY(user_id,dkey),
    CONSTRAINT fk_user_data_users FOREIGN KEY(user_id) REFERENCES fr_users(id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS fr_user_moneys(
    user_id INTEGER,
    wallet bigint,
    bank bigint,
    CONSTRAINT pk_user_moneys PRIMARY KEY(user_id),
    CONSTRAINT fk_user_moneys_users FOREIGN KEY(user_id) REFERENCES fr_users(id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS fr_srv_data(
    dkey VARCHAR(100),
    dvalue TEXT,
    CONSTRAINT pk_srv_data PRIMARY KEY(dkey)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS fr_user_vehicles(
    user_id INTEGER,
    vehicle VARCHAR(100),
    vehicle_plate varchar(255) NOT NULL,
    rented BOOLEAN NOT NULL DEFAULT 0,
    rentedid varchar(200) NOT NULL DEFAULT '',
    rentedtime varchar(2048) NOT NULL DEFAULT '',
    locked BOOLEAN NOT NULL DEFAULT 0,
    fuel_level FLOAT NOT NULL DEFAULT 100,
    impounded BOOLEAN NOT NULL DEFAULT 0,
    impound_info varchar(2048) NOT NULL DEFAULT '',
    impound_time VARCHAR(100) NOT NULL DEFAULT '',
    CONSTRAINT pk_user_vehicles PRIMARY KEY(user_id,vehicle),
    CONSTRAINT fk_user_vehicles_users FOREIGN KEY(user_id) REFERENCES fr_users(id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS fr_user_identities(
    user_id INTEGER,
    registration VARCHAR(100),
    phone VARCHAR(100),
    firstname VARCHAR(100),
    name VARCHAR(100),
    age INTEGER,
    CONSTRAINT pk_user_identities PRIMARY KEY(user_id),
    CONSTRAINT fk_user_identities_users FOREIGN KEY(user_id) REFERENCES fr_users(id) ON DELETE CASCADE,
    INDEX(registration),
    INDEX(phone)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS fr_warnings (
    warning_id INT AUTO_INCREMENT,
    user_id INT,
    warning_type VARCHAR(25),
    duration INT,
    admin VARCHAR(100),
    warning_date DATE,
    reason VARCHAR(2000),
    point INT,
    PRIMARY KEY (warning_id)
    )
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS fr_gangs (
    gangname VARCHAR(255) NULL DEFAULT NULL,
    gangmembers VARCHAR(3000) NULL DEFAULT NULL,
    funds BIGINT NULL DEFAULT NULL,
    logs VARCHAR(3000) NULL DEFAULT NULL,
    gangfit TEXT DEFAULT NULL,
    lockedfunds BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (gangname)
    )
    ]])              
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS fr_user_notes (
    user_id INT,
    info VARCHAR(500) NULL DEFAULT NULL,
    PRIMARY KEY (user_id)
    )
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS fr_user_homes(
    user_id INTEGER,
    home VARCHAR(100),
    number INTEGER,
    rented BOOLEAN NOT NULL DEFAULT 0,
    rentedid varchar(200) NOT NULL DEFAULT '',
    rentedtime varchar(2048) NOT NULL DEFAULT '',
    CONSTRAINT pk_user_homes PRIMARY KEY(home),
    CONSTRAINT fk_user_homes_users FOREIGN KEY(user_id) REFERENCES fr_users(id) ON DELETE CASCADE,
    UNIQUE(home,number)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS fr_bans_offenses(
    UserID INTEGER AUTO_INCREMENT,
    Rules TEXT NULL DEFAULT NULL,
    points INT(10) NOT NULL DEFAULT 0,
    CONSTRAINT pk_user PRIMARY KEY(UserID)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS fr_dvsa(
    user_id INT(11),
    licence VARCHAR(100) NULL DEFAULT NULL,
    testsaves VARCHAR(1000) NULL DEFAULT NULL,
    points VARCHAR(500) NULL DEFAULT NULL,
    id VARCHAR(500) NULL DEFAULT NULL,
    datelicence VARCHAR(500) NULL DEFAULT NULL,
    penalties VARCHAR(500) NULL DEFAULT NULL,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS fr_subscriptions (
    user_id INT(11),
    plathours FLOAT(10) NULL DEFAULT NULL,
    plushours FLOAT(10) NULL DEFAULT NULL,
    last_used VARCHAR(100) NOT NULL DEFAULT "",
    redeemed INT DEFAULT 0,
    CONSTRAINT pk_user PRIMARY KEY (user_id)
    );
    ]]);      
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS fr_casino_chips(
    user_id INT(11),
    chips bigint NOT NULL DEFAULT 0,
    CONSTRAINT pk_user PRIMARY KEY(user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS fr_verification(
    user_id INT(11),
    code VARCHAR(100) NULL DEFAULT NULL,
    discord_id VARCHAR(100) NULL DEFAULT NULL,
    verified TINYINT NULL DEFAULT NULL,
    CONSTRAINT pk_user PRIMARY KEY(user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS phone_users_contacts (
    id int(11) NOT NULL AUTO_INCREMENT,
    identifier varchar(60) CHARACTER SET utf8mb4 DEFAULT NULL,
    number varchar(10) CHARACTER SET utf8mb4 DEFAULT NULL,
    display varchar(64) CHARACTER SET utf8mb4 NOT NULL DEFAULT '-1',
    PRIMARY KEY (id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS phone_messages (
    id int(11) NOT NULL AUTO_INCREMENT,
    transmitter varchar(10) NOT NULL,
    receiver varchar(10) NOT NULL,
    message varchar(255) NOT NULL DEFAULT '0',
    time timestamp NOT NULL DEFAULT current_timestamp(),
    isRead int(11) NOT NULL DEFAULT 0,
    owner int(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS phone_calls (
    id int(11) NOT NULL AUTO_INCREMENT,
    owner varchar(10) NOT NULL COMMENT 'Num such owner',
    num varchar(10) NOT NULL COMMENT 'Reference number of the contact',
    incoming int(11) NOT NULL COMMENT 'Defined if we are at the origin of the calls',
    time timestamp NOT NULL DEFAULT current_timestamp(),
    accepts int(11) NOT NULL COMMENT 'Calls accept or not',
    PRIMARY KEY (id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS phone_app_chat (
    id int(11) NOT NULL AUTO_INCREMENT,
    channel varchar(20) NOT NULL,
    message varchar(255) NOT NULL,
    time timestamp NOT NULL DEFAULT current_timestamp(),
    PRIMARY KEY (id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS twitter_tweets (
    id int(11) NOT NULL AUTO_INCREMENT,
    authorId int(11) NOT NULL,
    realUser varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    message varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
    time timestamp NOT NULL DEFAULT current_timestamp(),
    likes int(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    KEY FK_twitter_tweets_twitter_accounts (authorId),
    CONSTRAINT FK_twitter_tweets_twitter_accounts FOREIGN KEY (authorId) REFERENCES twitter_accounts (id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS twitter_likes (
    id int(11) NOT NULL AUTO_INCREMENT,
    authorId int(11) DEFAULT NULL,
    tweetId int(11) DEFAULT NULL,
    PRIMARY KEY (id),
    KEY FK_twitter_likes_twitter_accounts (authorId),
    KEY FK_twitter_likes_twitter_tweets (tweetId),
    CONSTRAINT FK_twitter_likes_twitter_accounts FOREIGN KEY (authorId) REFERENCES twitter_accounts (id),
    CONSTRAINT FK_twitter_likes_twitter_tweets FOREIGN KEY (tweetId) REFERENCES twitter_tweets (id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS twitter_accounts (
    id int(11) NOT NULL AUTO_INCREMENT,
    username varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT '0',
    password varchar(50) COLLATE utf8mb4_bin NOT NULL DEFAULT '0',
    avatar_url varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY username (username)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS fr_community_pot (
    fr VARCHAR(65) NOT NULL,
    value BIGINT(11) NOT NULL,
    PRIMARY KEY (fr)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS fr_quests (
    user_id INT(11),
    quests_completed INT(11) NOT NULL DEFAULT 0,
    reward_claimed BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS fr_weapon_whitelists (
    user_id INT(11),
    weapon_info varchar(2048) DEFAULT '{}',
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS fr_weapon_codes (
    user_id INT(11),
    spawncode varchar(2048) NOT NULL DEFAULT '',
    weapon_code int(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (weapon_code)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS fr_prison (
    user_id INT(11),
    prison_time INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS fr_staff_tickets (
    user_id INT(11),
    ticket_count INT(11) NOT NULL DEFAULT 0,
    username VARCHAR(100) NOT NULL,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS fr_daily_rewards (
    user_id INT(11),
    last_reward INT(11) NOT NULL DEFAULT 0,
    streak INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS `fr_user_tokens` (
    `token` varchar(200) NOT NULL,
    `user_id` int(11) DEFAULT NULL,
    `banned` tinyint(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`token`)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS `fr_user_device` (
    `devices` longtext NOT NULL,
    `user_id` int(11) DEFAULT NULL,
    `banned` tinyint(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`user_id`)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS fr_police_hours (
    user_id INT(11),
    weekly_hours FLOAT(10) NOT NULL DEFAULT 0,
    total_hours FLOAT(10) NOT NULL DEFAULT 0,
    username VARCHAR(100) NOT NULL,
    last_clocked_date VARCHAR(100) NOT NULL,
    last_clocked_rank VARCHAR(100) NOT NULL,
    total_players_fined INT(11) NOT NULL DEFAULT 0,
    total_players_jailed INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS fr_stores (
    code VARCHAR(255) NOT NULL,
    item VARCHAR(255) NOT NULL,
    user_id INT(11),
    PRIMARY KEY (code)
    );
    ]])
    MySQL.SingleQuery("ALTER TABLE fr_users ADD IF NOT EXISTS bantime varchar(100) NOT NULL DEFAULT '';")
    MySQL.SingleQuery("ALTER TABLE fr_users ADD IF NOT EXISTS banreason varchar(100) NOT NULL DEFAULT '';")
    MySQL.SingleQuery("ALTER TABLE fr_users ADD IF NOT EXISTS banadmin varchar(100) NOT NULL DEFAULT ''; ")
    MySQL.SingleQuery("ALTER TABLE fr_user_vehicles ADD IF NOT EXISTS rented BOOLEAN NOT NULL DEFAULT 0;")
    MySQL.SingleQuery("ALTER TABLE fr_user_vehicles ADD IF NOT EXISTS rentedid varchar(200) NOT NULL DEFAULT '';")
    MySQL.SingleQuery("ALTER TABLE fr_user_vehicles ADD IF NOT EXISTS rentedtime varchar(2048) NOT NULL DEFAULT '';")
    MySQL.createCommand("FRls/create_modifications_column", "alter table fr_user_vehicles add if not exists modifications text not null")
	MySQL.createCommand("FRls/update_vehicle_modifications", "update fr_user_vehicles set modifications = @modifications where user_id = @user_id and vehicle = @vehicle")
	MySQL.createCommand("FRls/get_vehicle_modifications", "select modifications, vehicle_plate from fr_user_vehicles where user_id = @user_id and vehicle = @vehicle")
	MySQL.execute("FRls/create_modifications_column")
    print("[FR] ^2Base tables initialised.^0")
end)

MySQL.createCommand('FR/CreateUser', 'INSERT INTO fr_users(license,banned) VALUES(@license,false)')
MySQL.createCommand('FR/GetUserByLicense', 'SELECT id FROM fr_users WHERE license = @license')
MySQL.createCommand("FR/AddIdentifier", "INSERT INTO fr_user_ids (identifier, user_id, banned) VALUES(@identifier, @user_id, false)")
MySQL.createCommand("FR/GetUserByIdentifier", "SELECT user_id FROM fr_user_ids WHERE identifier = @identifier")
MySQL.createCommand("FR/GetIdentifiers", "SELECT identifier FROM fr_user_ids WHERE user_id = @user_id")
MySQL.createCommand("FR/BanIdentifier", "UPDATE fr_user_ids SET banned = @banned WHERE identifier = @identifier")

MySQL.createCommand("FR/identifier_all","SELECT * FROM fr_user_ids WHERE identifier = @identifier")
MySQL.createCommand("FR/select_identifier_byid_all","SELECT * FROM fr_user_ids WHERE user_id = @id")

MySQL.createCommand("FR/set_userdata","REPLACE INTO fr_user_data(user_id,dkey,dvalue) VALUES(@user_id,@key,@value)")
MySQL.createCommand("FR/get_userdata","SELECT dvalue FROM fr_user_data WHERE user_id = @user_id AND dkey = @key")

MySQL.createCommand("FR/set_srvdata","REPLACE INTO FR_srv_data(dkey,dvalue) VALUES(@key,@value)")
MySQL.createCommand("FR/get_srvdata","SELECT dvalue FROM FR_srv_data WHERE dkey = @key")

MySQL.createCommand("FR/get_banned","SELECT banned FROM fr_users WHERE id = @user_id")
MySQL.createCommand("FR/set_banned","UPDATE fr_users SET banned = @banned, bantime = @bantime,  banreason = @banreason,  banadmin = @banadmin, baninfo = @baninfo WHERE id = @user_id")
MySQL.createCommand("FR/set_identifierbanned","UPDATE fr_user_ids SET banned = @banned WHERE identifier = @iden")
MySQL.createCommand("FR/getbanreasontime", "SELECT * FROM fr_users WHERE id = @user_id")

MySQL.createCommand("FR/set_last_login","UPDATE fr_users SET last_login = @last_login WHERE id = @user_id")
MySQL.createCommand("FR/get_last_login","SELECT last_login FROM fr_users WHERE id = @user_id")

--Token Banning 
MySQL.createCommand("FR/add_token","INSERT INTO fr_user_tokens(token,user_id) VALUES(@token,@user_id)")
MySQL.createCommand("FR/check_token","SELECT user_id, banned FROM fr_user_tokens WHERE token = @token")
MySQL.createCommand("FR/check_token_userid","SELECT token FROM fr_user_tokens WHERE user_id = @id")
MySQL.createCommand("FR/ban_token","UPDATE fr_user_tokens SET banned = @banned WHERE token = @token")
MySQL.createCommand("FR/delete_token","DELETE FROM fr_user_tokens WHERE token = @token")
--Device Banning
MySQL.createCommand("device/add_info", "INSERT IGNORE INTO fr_user_device SET user_id = @user_id")
MySQL.createCommand("FR/get_device", "SELECT devices FROM fr_user_device WHERE user_id = @user_id")
MySQL.createCommand("FR/set_device", "UPDATE fr_user_device SET devices = @devices WHERE user_id = @user_id")
MySQL.createCommand("FR/get_device_banned", "SELECT banned FROM fr_user_device WHERE devices = @devices")
MySQL.createCommand("FR/check_device_userid","SELECT devices FROM fr_user_device WHERE user_id = @id")
MySQL.createCommand("FR/ban_device","UPDATE fr_user_device SET banned = @banned WHERE devices = @devices")
MySQL.createCommand("FR/check_device","SELECT user_id, banned FROM fr_user_device WHERE devices = @devices")
MySQL.createCommand("ac/delete_ban","DELETE FROM fr_anticheat WHERE @user_id = user_id")

function FR.getUsers()
    local users = {}
    for k,v in pairs(FR.user_sources) do
        users[k] = v
    end
    return users
end
-- [[ Discord Names ]] --

discordnames = {}
function FR.GetDiscordName(source, user_id)
    local discord_id = exports["fr"]:executeSync("SELECT discord_id FROM `fr_verification` WHERE user_id = @user_id", {user_id = user_id})[1].discord_id
    local nickname = Get_Guild_Nickname(1127275385751613543, discord_id)
    if nickname then
        discordnames[user_id] = nickname
        for k, v in pairs(FR.getUsers()) do
            FRclient.addDiscordNames(v, {user_id, nickname})
        end
    end
end
function FR.SetDiscordNameAdmin(user_id, name)
    discordnames[user_id] = name
    for k,v in pairs(FR.getUsers()) do
        FRclient.setDiscordNames(v, {discordnames})
    end
end


RegisterServerEvent("FR:SetDiscordName")
AddEventHandler("FR:SetDiscordName", function()
    local source = source
    local user_id = FR.getUserId(source)
    while user_id == nil do
        Citizen.Wait(0)
        user_id = FR.getUserId(source)
    end
    FR.GetDiscordName(source, user_id)
	FRclient.setDiscordNames(source, {discordnames})
    FRclient.addDiscordNames(-1, {user_id, nickname})
end)

function FR.getPlayerName(source , user_id)
    if not user_id then
		user_id = FR.getUserId(source)
	end
	return discordnames[user_id]
end
Citizen.CreateThread(function()
    while true do 
        for i,v in pairs(FR.getUsers()) do
            local source = v
            FRclient.setDiscordNames(source, {discordnames})
        end
        Citizen.Wait(60000)
    end
end)
exports('GetDiscordName', function(source)
    return FR.getPlayerName(source)
end)


-- [[ User Information ]] --


function FR.checkidentifiers(userid,identifier,cb)
    for A,B in pairs(identifier) do
        MySQL.query("FR/GetUserByIdentifier", {identifier = B}, function(rows, affected)
            if rows[1] then
                if rows[1].id ~= userid then
                    FR.isBanned(rows[1].id, function(banned)
                        if banned then
                            cb(true, rows[1].id,"Ban Evading",B)
                        else
                            cb(true, rows[1].id,"Multi Accounting",B)
                        end
                    end)
                end
            else
                if A ~= "ip" then
                    MySQL.query("FR/AddIdentifier", {identifier = B, user_id = userid})
                end
            end
        end)
    end
end

function FR.getUserByLicense(license, cb)
    MySQL.query('FR/GetUserByLicense', {license = license}, function(rows, affected)
        if rows[1] then
            cb(rows[1].id)
        else
            MySQL.query('FR/CreateUser', {license = license}, function(rows, affected)
                if rows.affectedRows > 0 then
                    FR.getUserByLicense(license, cb)
                end
            end)
            for k, v in pairs(FR.getUsers()) do
                FRclient.notify(v, {'~g~You have received £100,000 as someone new has joined the server.'})
                FR.giveBankMoney(k, 100000)
            end
        end
    end)
end


function FR.SetIdentifierban(user_id,banned)
    MySQL.query("FR/GetIdentifiers", {user_id = user_id}, function(rows)
        if banned then
            for i=1, #rows do
                MySQL.query("FR/BanIdentifier", {identifier = rows[i].identifier, banned = true})
                Wait(50)
            end
        else
            for i=1, #rows do
                MySQL.query("FR/BanIdentifier", {identifier = rows[i].identifier, banned = false})
            end
        end
    end)
end

-- return identification string for the source (used for non FR identifications, for rejected players)
function FR.getSourceIdKey(source)
    local Identifiers = GetPlayerIdentifiers(source)
    local idk = "idk_"
    for k,v in pairs(Identifiers) do
        idk = idk..v
    end
    return idk
end

function FR.getPlayerIP(player)
    return GetPlayerEP(player) or "0.0.0.0"
end

--- sql

function FR.ReLoadChar(source)
    local Identifiers = GetPlayerIdentifiers(source)
    local ids = {}
    for _,identifier in pairs(Identifiers) do
        local key,value = string.match(identifier, "([^:]+):(.+)")
        if key and value then
            ids[key] = ids[key] or key..":"..value
        end
    end
    if ids.license then
        FR.getUserByLicense(ids.license, function(user_id)
            FR.GetDiscordName(source, user_id)
            Wait(100)
            if user_id ~= nil then
                local name = FR.getPlayerName(source, user_id) or discordnames[user_id]
                FR.StoreTokens(source, user_id) 
                if FR.rusers[user_id] == nil then
                    FR.users[Identifiers[1]] = user_id
                    FR.rusers[user_id] = Identifiers[1]
                    FR.user_tables[user_id] = {}
                    FR.user_tmp_tables[user_id] = {}
                    FR.user_sources[user_id] = source
                    FR.getUData(user_id, "FR:datatable", function(sdata)
                        local data = json.decode(sdata)
                        if type(data) == "table" then FR.user_tables[user_id] = data end
                        local tmpdata = FR.getUserTmpTable(user_id)
                        FR.getLastLogin(user_id, function(last_login)
                            tmpdata.last_login = last_login or ""
                            tmpdata.spawns = 0
                            local last_login_stamp = os.date("%H:%M:%S %d/%m/%Y")
                            MySQL.execute("FR/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                            print("[FR] "..name.." ^2Joined^0 | Perm ID: "..user_id)
                            TriggerEvent("FR:playerJoin", user_id, source, name, tmpdata.last_login)
                            TriggerClientEvent("FR:CheckIdRegister", source)
                        end)
                    end)
                else -- already connected
                    print("[FR] "..name.." ^2Re-Joined^0 | Perm ID: "..user_id)
                    TriggerEvent("FR:playerRejoin", user_id, source, name)
                    TriggerClientEvent("FR:CheckIdRegister", source)
                    local tmpdata = FR.getUserTmpTable(user_id)
                    tmpdata.spawns = 0
                end
            end
        end)
    end
end

exports("frbot", function(method_name, params, cb)
    if cb then 
        cb(FR[method_name](table.unpack(params)))
    else 
        return FR[method_name](table.unpack(params))
    end
end)

RegisterNetEvent("FR:CheckID")
AddEventHandler("FR:CheckID", function()
    local source = source
    local user_id = FR.getUserId(source)
    if not user_id then
        FR.ReLoadChar(source)
    end
end)

function FR.isBanned(user_id, cbr)
    local task = Task(cbr, {false})
    MySQL.query("FR/get_banned", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].banned})
        else
            task()
        end
    end)
end
function FR.getLastLogin(user_id, cbr)
    local task = Task(cbr,{""})
    MySQL.query("FR/get_last_login", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].last_login})
        else
            task()
        end
    end)
end

function FR.fetchBanReasonTime(user_id,cbr)
    MySQL.query("FR/getbanreasontime", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then 
            cbr(rows[1].bantime, rows[1].banreason, rows[1].banadmin)
        end
    end)
end

function FR.setUData(user_id,key,value)
    MySQL.execute("FR/set_userdata", {user_id = user_id, key = key, value = value})
end

function FR.getUData(user_id,key,cbr)
    local task = Task(cbr,{""})
    MySQL.query("FR/get_userdata", {user_id = user_id, key = key}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].dvalue})
        else
            task()
        end
    end)
end

function FR.setSData(key,value)
    MySQL.execute("FR/set_srvdata", {key = key, value = value})
end

function FR.getSData(key, cbr)
    local task = Task(cbr,{""})
    MySQL.query("FR/get_srvdata", {key = key}, function(rows, affected)
        if rows and #rows > 0 then
            task({rows[1].dvalue})
        else
            task()
        end
    end)
end

-- return user data table for FR internal persistant connected user storage
function FR.getUserDataTable(user_id)
    return FR.user_tables[user_id]
end

function FR.getUserTmpTable(user_id)
    return FR.user_tmp_tables[user_id]
end

function FR.isConnected(user_id)
    return FR.rusers[user_id] ~= nil
end

function FR.isFirstSpawn(user_id)
    local tmp = FR.getUserTmpTable(user_id)
    return tmp and tmp.spawns == 1
end

function FR.getUserId(source)
    if source ~= nil then
        local Identifiers = GetPlayerIdentifiers(source)
        if Identifiers ~= nil and #Identifiers > 0 then
            return FR.users[Identifiers[1]]
        end
    end
    return nil
end

-- return source or nil
function FR.getUserSource(user_id)
    return FR.user_sources[user_id]
end

function FR.IdentifierBanCheck(source,user_id,cb)
    for i,v in pairs(GetPlayerIdentifiers(source)) do 
        MySQL.query('FR/identifier_all', {identifier = v}, function(rows)
            for i = 1,#rows do 
                if rows[i].banned then 
                    if user_id ~= rows[i].user_id then 
                        cb(true, rows[i].user_id, v)
                    end 
                end
            end
        end)
    end
end

function FR.BanIdentifiers(user_id, value)
    MySQL.query('FR/select_identifier_byid_all', {id = user_id}, function(rows)
        for i = 1, #rows do 
            MySQL.execute("FR/set_identifierbanned", {banned = value, iden = rows[i].identifier })
        end
    end)
end

function calculateTimeRemaining(expireTime)
    local datetime = ''
    local expiry = os.date("%d/%m/%Y at %H:%M", tonumber(expireTime))
    local hoursLeft = ((tonumber(expireTime)-os.time()))/3600
    local minutesLeft = nil
    if hoursLeft < 1 then
        minutesLeft = hoursLeft * 60
        minutesLeft = string.format("%." .. (0) .. "f", minutesLeft)
        datetime = minutesLeft .. " mins" 
        return datetime
    else
        hoursLeft = string.format("%." .. (0) .. "f", hoursLeft)
        datetime = hoursLeft .. " hours" 
        return datetime
    end
    return datetime
end

function FR.setBanned(user_id,banned,time,reason,admin,baninfo)
    if banned then 
        MySQL.execute("FR/set_banned", {user_id = user_id, banned = banned, bantime = time, banreason = reason, banadmin = admin, baninfo = baninfo})
        FR.BanIdentifiers(user_id, true)
        FR.BanTokens(user_id, true)
        FR.BanUserInfo(user_id, true)
    else 
        MySQL.execute("FR/set_banned", {user_id = user_id, banned = banned, bantime = "", banreason =  "", banadmin =  "", baninfo = ""})
        FR.BanIdentifiers(user_id, false)
        FR.BanTokens(user_id, false)
        FR.BanUserInfo(user_id, false)
        MySQL.execute("ac/delete_ban", {user_id = user_id})
    end 
end

function FR.ban(adminsource,permid,time,reason,baninfo)
    local adminPermID = FR.getUserId(adminsource)
    local PlayerSource = FR.getUserSource(tonumber(permid))
    local getBannedPlayerSrc = FR.getUserSource(tonumber(permid))
    local adminname = FR.getPlayerName(adminsource, adminPermID) or discordnames[adminPermID]
    if getBannedPlayerSrc then 
        if tonumber(time) then
            FR.setBucket(PlayerSource, permid)
            FR.setBanned(permid,true,time,reason,adminname,baninfo)
            FR.kick(getBannedPlayerSrc,"[FR] Ban expires in: "..calculateTimeRemaining(time).."\nYour ID is: "..permid.."\nReason: " .. reason .. "\nAppeal @ discord.gg/fr5m") 
        else
            FR.setBucket(PlayerSource, permid)
            FR.setBanned(permid,true,"perm",reason,adminname,baninfo)
            FR.kick(getBannedPlayerSrc,"[FR] Permanent Ban\nYour ID is: "..permid.."\nReason: " .. reason .. "\nAppeal @ discord.gg/fr5m") 
        end
        FRclient.notify(adminsource,{"~g~Success banned! User PermID: " .. permid})
    else 
        if tonumber(time) then 
            FR.setBanned(permid,true,time,reason,adminname,baninfo)
        else 
            FR.setBanned(permid,true,"perm",reason,adminname,baninfo)
        end
        FRclient.notify(adminsource,{"~g~Success banned! User PermID: " .. permid})
    end
end

function FR.banConsole(permid,time,reason)
    local adminPermID = "FR"
    local getBannedPlayerSrc = FR.getUserSource(tonumber(permid))
    if getBannedPlayerSrc then 
        if tonumber(time) then 
            local banTime = os.time()
            banTime = banTime  + (60 * 60 * tonumber(time))  
            FR.setBanned(permid,true,banTime,reason, adminPermID)
            FR.kick(getBannedPlayerSrc,"[FR] Ban expires in "..calculateTimeRemaining(banTime).."\nYour ID is: "..permid.."\nReason: " .. reason .. "\nBanned by FR \nAppeal @ discord.gg/fr5m") 
        else 
            FR.setBanned(permid,true,"perm",reason, adminPermID)
            FR.kick(getBannedPlayerSrc,"[FR] Permanent Ban\nYour ID is: "..permid.."\nReason: " .. reason .. "\nBanned by FR \nAppeal @ discord.gg/fr5m") 
        end
        print("Successfully banned Perm ID: " .. permid)
    else 
        if tonumber(time) then 
            local banTime = os.time()
            banTime = banTime  + (60 * 60 * tonumber(time))  
            FR.setBanned(permid,true,banTime,reason, adminPermID)
        else 
            FR.setBanned(permid,true,"perm",reason, adminPermID)
        end
        print("Successfully banned Perm ID: " .. permid)
    end
end
function FR.banAnticheat(permid,time,reason)
    local adminPermID = "FR"
    local getBannedPlayerSrc = FR.getUserSource(tonumber(permid))
    if getBannedPlayerSrc then 
        if tonumber(time) then 
            local banTime = os.time()
            banTime = banTime  + (60 * 60 * tonumber(time))  
            FR.setBanned(permid,true,banTime,reason, adminPermID)
            Citizen.Wait(20000)
            FR.kick(getBannedPlayerSrc,"[FR] Ban expires in "..calculateTimeRemaining(banTime).."\nYour ID is: "..permid.."\nReason: " .. reason .. "\nBanned by FR \nAppeal @ discord.gg/fr5m") 
        else 
            FR.setBanned(permid,true,"perm",reason, adminPermID)
            Citizen.Wait(20000)
            FR.kick(getBannedPlayerSrc,"[FR] Permanent Ban\nYour ID is: "..permid.."\nReason: " .. reason .. "\nBanned by FR \nAppeal @ discord.gg/fr5m") 
        end
    else 
        if tonumber(time) then 
            local banTime = os.time()
            banTime = banTime  + (60 * 60 * tonumber(time))  
            FR.setBanned(permid,true,banTime,reason, adminPermID)
        else 
            FR.setBanned(permid,true,"perm",reason, adminPermID)
        end
    end
end

function FR.banDiscord(permid,time,reason,adminPermID,baninfo)
    local getBannedPlayerSrc = FR.getUserSource(tonumber(permid))
    if tonumber(time) then 
        local banTime = os.time()
        banTime = banTime  + (60 * 60 * tonumber(time))
        FR.setBanned(permid,true,banTime,reason, adminPermID, baninfo)
        if getBannedPlayerSrc then 
            FR.kick(getBannedPlayerSrc,"[FR] Ban expires in "..calculateTimeRemaining(banTime).."\nYour ID is: "..permid.."\nReason: " .. reason .. "\nAppeal @ discord.gg/fr5m") 
        end
    else 
        FR.setBanned(permid,true,"perm",reason,  adminPermID)
        if getBannedPlayerSrc then
            FR.kick(getBannedPlayerSrc,"[FR] Permanent Ban\nYour ID is: "..permid.."\nReason: " .. reason .. "\nAppeal @ discord.gg/fr5m") 
        end
    end
end

function FR.StoreTokens(source, user_id) 
    if GetNumPlayerTokens then 
        local numtokens = GetNumPlayerTokens(source)
        for i = 1, numtokens do
            local token = GetPlayerToken(source, i)
            MySQL.query("FR/check_token", {token = token}, function(rows)
                if token and rows and #rows <= 0 then 
                    MySQL.execute("FR/add_token", {token = token, user_id = user_id})
                end        
            end)
        end
    end
end


function FR.CheckTokens(source, user_id) 
    if GetNumPlayerTokens then 
        local banned = false;
        local numtokens = GetNumPlayerTokens(source)
        for i = 1, numtokens do
            local token = GetPlayerToken(source, i)
            local rows = MySQL.asyncQuery("FR/check_token", {token = token, user_id = user_id})
                if #rows > 0 then 
                if rows[1].banned then 
                    return rows[1].banned, rows[1].user_id
                end
            end
        end
    else 
        return false; 
    end
end

function FR.BanTokens(user_id, banned) 
    if GetNumPlayerTokens then 
        MySQL.query("FR/check_token_userid", {id = user_id}, function(id)
            sleep = banned and 50 or 0
            for i = 1, #id do
                if banned then
                    MySQL.execute("FR/ban_token", {token = id[i].token, banned = banned})

                else
                    MySQL.execute("FR/delete_token", {token = id[i].token})
                end
                Wait(sleep)
            end
        end)
    end
end

function FR.kick(source,reason)
    DropPlayer(source,reason)
end

-- tasks

function task_save_datatables()
    TriggerEvent("FR:save")
    Debug.pbegin("FR save datatables")
    for k,v in pairs(FR.user_tables) do
        FR.setUData(k,"FR:datatable",json.encode(v))
    end
    Debug.pend()
    SetTimeout(config.save_interval*1000, task_save_datatables)
end
task_save_datatables()
function FR.GetPlayerIdentifiers(source)
    local Identifiers = GetPlayerIdentifiers(source)
    local ids = {}
    for _,identifier in pairs(Identifiers) do
        local key,value = string.match(identifier, "([^:]+):(.+)")
        if key and value then
            ids[key] = ids[key] or key..":"..value
        end
    end
    return ids
end
local forbiddenNames = {
	"%^1",
	"%^2",
	"%^3",
	"%^4",
	"%^5",
	"%^6",
	"%^7",
	"%^8",
	"%^9",
	"%^%*",
	"%^_",
	"%^=",
	"%^%~",
	"admin",
    "nigger",
    "faggot",
    "*"
}

AddEventHandler("playerConnecting", function(name, setMessage, deferrals)
    deferrals.defer()
    local source = source
    local Identifiers = GetPlayerIdentifiers(source)
    local ids = {}
    for _,identifier in pairs(Identifiers) do
        local key,value = string.match(identifier, "([^:]+):(.+)")
        if key and value then
            ids[key] = ids[key] or key..":"..value
        end
    end
    if GetNumPlayerTokens(source) <= 0 then
        deferrals.done("[FR] Please restart your game and try again.")
        return
    end
    if not ids.steam then
        deferrals.done("[FR] You Must Have Steam Running To Join This Server.")
        return
    end
    if ids.license then
        deferrals.update("[FR] Checking For User ID...")
        FR.getUserByLicense(ids.license, function(user_id)
            deferrals.update("[FR] Checking For  Identifiers...")
            FR.checkidentifiers(user_id, ids, function(banned, userid, reason, identifier)
                if banned and reason == "Ban Evading" then
                    deferrals.done("\n[FR] Permanently Banned\nUser ID: "..user_id.."\nReason: "..reason.."\nAppeal: https://discord.gg/fr5m")
                    FR.setBanned(user_id,true,"perm","Ban Evading","FR","ID Banned: "..userid)
                    FR.sendWebhook('ban-evaders', 'FR Ban Evade Logs', "> Player Name: **"..GetPlayerName(source).."**\n> Player Current Perm ID: **"..user_id.."**\n> Player Banned PermID: **"..userid.."**\n> Banned Identifier: **"..identifier.."**")
                    return
                end
            end)
            if user_id ~= nil then
                deferrals.update("[FR] Checking If WhiteListed...")
                if WhiteListed then
                    if not FR.checkForRole(user_id, '1173635160856604702') then
                        deferrals.done("[FR]: Your Perm ID Is [".. user_id .."] server is whitelisted (discord.gg/fr5m)")
                        return
                    end
                end
                deferrals.update("[FR] Checking If Verified...")
                local verified = exports["fr"]:executeSync("SELECT * FROM fr_verification WHERE user_id = @user_id", { user_id = user_id })
                if #verified == 0 then
                    exports["fr"]:executeSync("INSERT IGNORE INTO fr_verification(user_id,verified) VALUES(@user_id,false)", {user_id = user_id})
                end
                if verified[1].verified == 0 then
                    if code == nil then
                        code = string.upper(generateUUID("verifycode", 6, "alphanumeric"))
                        exports["fr"]:executeSync("UPDATE fr_verification SET code = @code WHERE user_id = @user_id", { user_id = user_id, code = code })
                    else
                        code = string.upper(generateUUID("verifycode", 6, "alphanumeric"))
                        exports["fr"]:executeSync("UPDATE fr_verification SET code = @code WHERE user_id = @user_id", { user_id = user_id, code = code })
                    end
                    show_auth_card(code, deferrals, function(data)
                        check_verified(deferrals, code, user_id)
                    end)
                    Wait(100000)
                end
                if #verified == 1 then
                    deferrals.update("[FR] Checking For Ban...")
                    FR.StoreTokens(source, user_id) 
                    FR.isBanned(user_id, function(banned)
                        if not banned then
                            if not FR.checkForRole(user_id, '1181616885209514036') then
                                deferrals.done("[FR]: Your Perm ID Is [".. user_id .."] you are required to be in the discord to join (discord.gg/fr5m)")
                                return
                            end
                            deferrals.update("[FR] Getting User Name...")
                            FR.GetDiscordName(source, user_id)  
                            Wait(100)                            
                            if FR.CheckTokens(source, user_id) then 
                                deferrals.done("[FR]: You are banned from this server, please do not try to evade your ban. If you believe this was an error quote your ID which is: " .. user_id)
                                FR.banConsole(user_id, "perm", "1.11 Ban Evading")
                                return
                            end
                            Wait(2000)
                            FR.SteamAgeCheck(ids.steam, user_id, name)
                            deferrals.update("[FR] Checking User Data...")
                            Citizen.Wait(1000)
                            FR.users[Identifiers[1]] = user_id
                            FR.rusers[user_id] = Identifiers[1]
                            FR.user_tables[user_id] = {}
                            FR.user_tmp_tables[user_id] = {}
                            FR.user_sources[user_id] = source
                            deferrals.update("[FR] Getting User Data...")
                            FR.getUData(user_id, "FR:datatable", function(sdata)
                                local data = json.decode(sdata)
                                if type(data) == "table" then 
                                    FR.user_tables[user_id] = data 
                                end
                                local tmpdata = FR.getUserTmpTable(user_id)
                                FR.getLastLogin(user_id, function(last_login)
                                    tmpdata.last_login = last_login or ""
                                    tmpdata.spawns = 0
                                    local last_login_stamp = os.date("%H:%M:%S %d/%m/%Y")
                                    MySQL.execute("FR/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                                    deferrals.update("[FR] Got User Data...")
                                    print("[FR] "..FR.getPlayerName(source).." ^2Joined^0 | PermID: "..user_id)
                                    TriggerEvent("FR:playerJoin", user_id, source, FR.getPlayerName(source), tmpdata.last_login)
                                    Wait(500)
                                    deferrals.done()
                                end)
                            end)
                        else
                            FR.fetchBanReasonTime(user_id, function(bantime, banreason, banadmin)
                                if tonumber(bantime) then 
                                    local timern = os.time()
                                    if timern > tonumber(bantime) then 
                                        FR.setBanned(user_id, false)
                                        if FR.rusers[user_id] == nil then
                                            FR.users[Identifiers[1]] = user_id
                                            FR.rusers[user_id] = Identifiers[1]
                                            FR.user_tables[user_id] = {}
                                            FR.user_tmp_tables[user_id] = {}
                                            FR.user_sources[user_id] = source
                                            FR.getUData(user_id, "FR:datatable", function(sdata)
                                                local data = json.decode(sdata)
                                                if type(data) == "table" then 
                                                    FR.user_tables[user_id] = data 
                                                end
                                                local tmpdata = FR.getUserTmpTable(user_id)
                                                FR.getLastLogin(user_id, function(last_login)
                                                    tmpdata.last_login = last_login or ""
                                                    tmpdata.spawns = 0
                                                    local last_login_stamp = os.date("%H:%M:%S %d/%m/%Y")
                                                    MySQL.execute("FR/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                                                    print("[FR] "..FR.getPlayerName(source).." ^3Joined after their ban expired.^0 (Perm ID = "..user_id..")")
                                                    TriggerEvent("FR:playerJoin", user_id, source, FR.getPlayerName(source), tmpdata.last_login)
                                                    deferrals.done()
                                                end)
                                            end)
                                        else
                                            print("[FR] "..FR.getPlayerName(source).." ^3Re-joined after their ban expired.^0 | Perm ID = "..user_id)
                                            TriggerEvent("FR:playerRejoin", user_id, source, FR.getPlayerName(source))
                                            deferrals.done()
                                            local tmpdata = FR.getUserTmpTable(user_id)
                                            tmpdata.spawns = 0
                                        end
                                    end

                                    print("[FR] "..GetPlayerName(source).." ^1Rejected: "..banreason.."^0 | Perm ID = "..user_id)
                                    local baninfo = {}
                                    local calbantime = calculateTimeRemaining(bantime)
                                    baninfo[user_id] = {user_id = user_id, time = calbantime, reason = banreason}
                                    show_ban_card(baninfo[user_id], deferrals)
                                    --deferrals.done("\n[FR] Ban expires in "..calculateTimeRemaining(bantime).."\nYour ID: "..user_id.."\nReason: "..banreason.."\nAppeal @ discord.gg/fr5m")
                                else 
                                    print("[FR] "..GetPlayerName(source).." ^1Rejected: "..banreason.."^0 | Perm ID = "..user_id)
                                    local baninfo = {}
                                    baninfo[user_id] = {user_id = user_id, time = "perm", reason = banreason}
                                    show_ban_card(baninfo[user_id], deferrals)
                                    --deferrals.done("\n[FR] Permanent Ban\nYour ID: "..user_id.."\nReason: "..banreason.."\nAppeal @ discord.gg/fr5m")
                                end
                            end)
                        end
                    end)
                end
            end
        end)
    end
end)
local trys = {}
function show_auth_card(code, deferrals, callback)
    if trys[code] == nil then
        trys[code] = 0
    end
    verify_card["body"][2]["items"][3]["text"] = "!verify "..code
    verify_card["body"][2]["items"][3]["color"] = "Good"
    verify_card["body"][2]["items"][4]["text"] = "Your account has not been verified yet. (Attempt "..trys[code]..")"
    deferrals.presentCard(verify_card, callback)
end

function check_verified(deferrals, code, user_id, data)
    local data_verified = exports["fr"]:executeSync("SELECT verified FROM fr_verification WHERE user_id = @user_id", { user_id = user_id })
    
    verify_card["body"][2]["items"][3]["text"] = "Checking Verification..."
    verify_card["body"][2]["items"][3]["color"] = "Good"
    deferrals.presentCard(verify_card, callback)
    
    if data_verified[1] and data_verified[1].verified == 1 then
        verify_card["body"][2]["items"][3]["text"] = "Verification Successful!"
        verify_card["body"][2]["items"][3]["color"] = "Good"
        verify_card["body"][2]["items"][4]["text"] = ""
        deferrals.presentCard(verify_card, callback)
        Wait(3000)
        deferrals.done()
    end
    if trys[code] == 5 then
        verify_card["body"][2]["items"][3]["text"] = ""
        verify_card["body"][2]["items"][4]["text"] = "You Have Reached The Maximum Amount Of Attempts"
        deferrals.presentCard(verify_card, callback)
        Wait(2000)
        deferrals.done("[FR]: Failed to verify your account, please try again.")
    end
    
    trys[code] = trys[code] + 1
    show_auth_card(code, deferrals, callback)
end
function show_ban_card(baninfo, deferrals, callback)
    if baninfo.time == "perm" then
        ban_card["body"][2]["items"][1]["text"] = "Permanent Ban"
        ban_card["body"][2]["items"][2]["text"] = "Your ID: "..baninfo.user_id
        ban_card["body"][2]["items"][3]["text"] = "Reason: "..baninfo.reason
    else
        ban_card["body"][2]["items"][1]["text"] = "Ban expires in ".. baninfo.time
        ban_card["body"][2]["items"][2]["text"] = "Your ID: "..baninfo.user_id
        ban_card["body"][2]["items"][3]["text"] = "Reason: "..baninfo.reason
    end
    deferrals.presentCard(ban_card, callback)
end






AddEventHandler("playerDropped", function(reason)
    local source = source
    local user_id = FR.getUserId(source)
    local name = FR.getPlayerName(source, user_id) or discordnames[user_id]
    local Identifiers = GetPlayerIdentifiers(source)
    local ids = {}
    for _,identifier in pairs(Identifiers) do
        local key,value = string.match(identifier, "([^:]+):(.+)")
        if key and value then
            ids[key] = ids[key] or key..":"..value
        end
    end
    if user_id ~= nil then
        TriggerEvent("FR:playerLeave", user_id, source)
        FR.setUData(user_id, "FR:datatable", json.encode(FR.getUserDataTable(user_id)))
        print("[FR] " .. name .. " ^1Disconnected^0 | Perm ID: "..user_id)
        FR.users[FR.rusers[user_id]] = nil
        FR.rusers[user_id] = nil
        FR.user_tables[user_id] = nil
        FR.user_tmp_tables[user_id] = nil
        FR.user_sources[user_id] = nil
        FR.sendWebhook('leave', "FR Leave Logs", "> Name: **" .. name .. "**\n> PermID: **" .. user_id .. "**\n> Temp ID: **" .. source .. "**\n> Reason: **" .. reason .. "**\n```"..ids.steam.."\n"..ids.license.."```")
    else
        print('[FR] SEVERE ERROR: Failed to save data for: ' .. name .. ' Rollback expected!')
    end
    FRclient.removeBasePlayer(-1, {source})
    FRclient.removePlayer(-1, {source})
end)

MySQL.createCommand("FR/setusername", "UPDATE fr_users SET username = @username WHERE id = @user_id")

RegisterServerEvent("FRcli:playerSpawned")
AddEventHandler("FRcli:playerSpawned", function()
    local source = source
    local Identifiers = GetPlayerIdentifiers(source)
    local Tokens = GetNumPlayerTokens(source)
    local ids = {}
    for _,identifier in pairs(Identifiers) do
        local key,value = string.match(identifier, "([^:]+):(.+)")
        if key and value then
            ids[key] = ids[key] or key..":"..value
        end
    end
    local user_id = FR.getUserId(source)
    local name = FR.getPlayerName(source, user_id) or discordnames[user_id] or GetPlayerName(source)
    local player = source
    FRclient.addBasePlayer(-1, {player, user_id})
    if user_id ~= nil then
        FR.user_sources[user_id] = source
        local tmp = FR.getUserTmpTable(user_id)
        tmp.spawns = tmp.spawns + 1
        local first_spawn = (tmp.spawns == 1)
        local playertokens = {} 
        for i = 1, Tokens do
            local token = GetPlayerToken(source, i)
            if token then
                if not playertokens[source] then
                    playertokens[source] = {} 
                end
                table.insert(playertokens[source], token)
            end
        end   
        FR.sendWebhook('join', "FR Join Logs", "> Name : **" .. name .. "**\n> TempID: **" .. source .. "**\n> PermID: **" .. user_id .. "**\n```"..ids.steam.."\n\n"..ids.license.."\n\n"..table.concat(playertokens[source], "\n\n").."```")
        if first_spawn then
            for k, v in pairs(FR.user_sources) do
                FRclient.addPlayer(source, {v})
            end
            FRclient.addPlayer(-1, {source})
            MySQL.execute("FR/setusername", {user_id = user_id, username = name})
        end
        TriggerEvent("FR:playerSpawn", user_id, player, first_spawn)
        TriggerClientEvent("FR:onClientSpawn", player, user_id, first_spawn)
    end
end)
RegisterServerEvent("FR:playerRespawned")
AddEventHandler("FR:playerRespawned", function()
    local source = source
    TriggerClientEvent('FR:ForceRefreshData', -1)
    TriggerClientEvent('FR:onClientSpawn', source)
end)

local Online = true
exports("getServerStatus", function(params, cb)
    if not Online then
        cb("🛑 Offline")
    else
        cb("✅ Online")
    end
end)

exports("getConnected", function(params, cb)
    if FR.getUserSource(params[1]) then
        cb('connected')
    else
        cb('not connected')
    end
end)

function FR.SteamAgeCheck(steam, user_id,name)
    local steam64 = tonumber(steam:gsub("steam:", ""), 16)
    PerformHttpRequest("https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=F018A7525FA287EB3FE52FF9E95CCFEA&steamids=" .. steam64, function(statusCode, text, headers)
        if statusCode == 200 and text ~= nil then
            local data = json.decode(text)
            if data["response"]["players"][1] and data["response"]["players"][1]["timecreated"] then
                timecreated = data["response"]["players"][1]["timecreated"]
                timecreated = math.floor((os.time() - timecreated) / 86400)
            else
                timecreated = false
            end
            profileVisibility = data['response']['players'][1]['communityvisibilitystate']
        else
            timecreated = 20
        end
        gotAccount = true
        if timecreated < 20 then
            FR.sendWebhook('steam', 'Steam Account Age', "> Player Name: **" .. name .. "**\n> Player Perm ID: **" .. user_id .. "**\n> Steam Account Age: **" .. timecreated .. "**\n> Steam: **" .. steam .. "**")
        end
    end, "GET", json.encode({}), {["Content-Type"] = 'application/json'})
end


function FR.NameCheck(name, cb)
    for v in pairs(forbiddenNames) do
        if(string.gsub(string.gsub(string.gsub(string.gsub(name:lower(), "-", ""), ",", ""), "%.", ""), " ", ""):find(forbiddenNames[v])) then
            cb(true)
            return
        end
    end
end


local devs = {
    [0] = true,
    [-1] = true,
    [3] = true,
    [61] = true,
}


function FR.isDevelper(user_id)
    if IsDuplicityVersion() then
        return devs[tonumber(user_id)]
    else
        return devs[tFR.getUserId()]
    end
end

