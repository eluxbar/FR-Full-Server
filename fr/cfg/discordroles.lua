cfg = {
	Guild_ID = '1127275385751613543',
  	Multiguild = true,
  	Guilds = {
		['Main'] = '1127275385751613543', 
		['Police'] = '1130156614956101682', 
		['NHS'] = '1129257607861899365',
		['HMP'] = '1130155807879733388',
		--['Border'] = '1134450458006654976',
		--['LFB'] = '1008206756226277477',
  	},
	RoleList = {},

	CacheDiscordRoles = true, -- true to cache player roles, false to make a new Discord Request every time
	CacheDiscordRolesTime = 60, -- if CacheDiscordRoles is true, how long to cache roles before clearing (in seconds)
}

cfg.Guild_Roles = {
	['Main'] = {
		['Founder'] = 1127275748114321418, -- 12
		['Lead Developer'] = 1127275752010813450, -- 11
		['Operations Manager'] = 1130962065788522496, -- 10
		['Community Manager'] = 1127275759539601419, -- 9
		['Staff Manager'] = 1127275762345578547, -- 8
		['Head Administrator'] = 1127275764421775380, -- 7
		['Senior Administrator'] = 1127275769471709254, -- 6
		['Head Administrator'] = 1150560376170238113,
		['Administrator'] = 1127275772273508394, -- 5
		['Senior Moderator'] = 1127275778460102758, -- 4
		['Moderator'] = 1127275784105627699, -- 3
		['Support Team'] = 1127275786030825473, -- 2
		['Trial Staff'] = 1127275788585160826, -- 1
		['cardev'] = 1127275793890939020,
		['Cinematic'] = 1135927920305647728,
		['TutorialDone'] = 1181677693146763264,
	},

	['Police'] = {
        ['Commissioner'] = 1130156737417183252,
        ['Deputy Commissioner'] = 1130156738461581382,
        ['Assistant Commissioner'] = 1130156738973282385,
        ['Dep. Asst. Commissioner'] = 1130156740042821744,
        ['Commander'] = 1130156741003325530,
		['GC Advisor'] = 1130156742894960701,
        ['Chief Superintendent'] = 1130156751136759918,
        ['Superintendent'] = 1130156751929495693,
        ['Chief Inspector'] = 1130156757512110161,
        ['Inspector'] = 1130156758581645463,
        ['Sergeant'] = 1130156761135972534,
        ['Special Constable'] = 1130156767062544437,
        ['Senior Constable'] = 1130156762029363250,
		['PC'] = 1130156762826289172,
		['PCSO'] = 1130156765309317250,
		['Large Arms Access'] = 1130156844590047413,
		['Police Horse Trained'] = 1134593506384551936,
		['Drone Trained'] = 1130156859760844840,
		['NPAS'] = 1130160496801230920,
		['K9 Trained'] = 1134593520993316955,
	},

	['NHS'] = {
		['NHS Head Chief'] = 1129257726774628482,
		['NHS Assistant Chief'] = 1129257731358998598,
		['NHS Deputy Chief'] = 1129257729509310614,
		['NHS Captain'] = 1129257733120602242,
		['NHS Consultant'] = 1129257732290117672,
		['NHS Specialist'] = 1129257744600416426,
		['NHS Senior Doctor'] = 1129257748681465916,
		['NHS Doctor'] = 1129257749813923851,
		['NHS Experienced Paramedic'] = 1129257750631825418,
		['NHS Neurologist'] = 1142435989487370260,
		['NHS Physiotherapist'] = 1142435712382287962,
		['NHS GP'] = 1129257750770233386,
		['NHS Field Trained Paramedic'] = 1129257751537778759,
		['NHS Paramedic'] = 1129257752355680378,
		['NHS Ambulance Technician'] = 1129257753140011009,
		['Drone Trained'] = 1129257773926973540,
		['HEMS'] = 1129257765932642364,
	},

	['HMP'] = {
        ['Governor'] = 1130156157495951361,
        ['Deputy Governor'] = 1130156158825529468,
        ['Divisional Commander'] = 1130156159756681296,
        ['Custodial Supervisor'] = 1130156171865632808,
        ['Custodial Officer'] = 1130156172482203679,
        ['Honourable Guard'] = 1130156183991373884,
        ['Supervising Officer'] = 1130156178555551755,
        ['Principal Officer'] = 1130156179776094278, 
        ['Specialist Officer'] = 1130156180547833896, 
        ['Senior Officer'] = 1130156181319598120,
        ['Prison Officer'] = 1130156182343000074,
        ['Trainee Prison Officer'] = 1130156182716285082, 
	},

	['Border'] = {
        ['Director General'] = 1134450645341065366,
        ['Regional Director'] = 1134450651510870086,
        ['Assistant Director'] = 1134450656871190549,
        ['Headquarters'] = 1134450662353154058,
        ['Advisor'] = 1134450673942003752,
        ['Senior Immigration Officer'] = 1134450785065906176,
        ['Higher Immigration Officer'] = 1134450795237089381, 
        ['Immigration Officer'] = 1134450800836485210, 
        ['Assistant Immigration Officer'] = 1134450810454032424,
        ['Administrative Assistant'] = 1134450820545511464,
        ['Special Officer'] = 1134450825759035392, 
	},

	-- ['LFB'] = {
	-- 	['Chief Fire Command'] = 1008206875923324988,
	-- 	['Divisional Command'] = 1008206879731757157,
	-- 	['Sector Command'] = 1008206880738390016,
	-- 	['Honourable Firefighter'] = 1008206885251469353,
	-- 	['Leading Firefighter'] = 1008206886002237571,
	-- 	['Specialist Firefighter'] = 1008206886761418762,
	-- 	['Advanced Firefighter'] = 1008206887558324246,
	-- 	['Senior Firefighter'] = 1008206888778862733,
	-- 	['Firefighter'] = 1008206889768730695,
	-- 	['Junior Firefighter'] = 1008206890775359590,
	-- 	['Provisional Firefighter'] = 1008206891157028927,	
	-- },	
}

for faction_name, faction_roles in pairs(cfg.Guild_Roles) do
	for role_name, role_id in pairs(faction_roles) do
		cfg.RoleList[role_name] = role_id
	end
end


cfg.Bot_Token = 'MTE4MTU3NDgxMTcwMTQ3NzQ0OQ.GX99WJ.H9qD4QF8yLeZhhMb6dL7lxQXOmepRIA3t-G2d8'

return cfg