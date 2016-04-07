void(float apilevel, string enginename, float engineversion) CSQC_Init = // Called on CSQC Start
{
	
	if(autocvar_v_vresm == 0) // if our resolution scaler starts at 0, default to 1.  0/1 is the same.
		autocvar_v_vresm = 1;
	
	// GAME_STATE Controls if you are ingame/playing or not. STAGE_NONE represents no game has started yet.
	GAME_STATE = STAGE_NONE;
	// MENU_STAGE controls what Menu You are in, will persist between menu toggles. Starts in Main Menu
	MENU_STAGE = STAGE_MAIN;

	// Tries to center our mouse cursor.
	INPUT_MOUSE = screen_center;

	// Menu Items are initialized here, these can be switched out as long as you define the replacement ones.
	MENU_Items[0] = MENU_NEWGAME;
	MENU_Items[1] = MENU_SAVEGAME;
	MENU_Items[2] = MENU_LOADGAME;
	MENU_Items[3] = MENU_OPTIONS;
	MENU_Items[4] = MENU_QUIT;
		
	precache_model("models/pistol.iqm");
	precache_model("models/launcher.iqm");

	CLIENT_STATE = serverkey("constate");	// Get constate on init, updateview isnt fast enough at start! >:P
	
	dprint(strcat("\n","^1",CLIENT_STATE,"\n"));

	if(CLIENT_STATE == "disconnected") // check if current constate is disconnected
	{
		setviewprop(VF_ANGLES,[0,0,0]); // set view origin to [0,0,0]
		
//		G_LoadLevel("start"); // Start the menu Level
/*	
		// some random test entities
		test = spawn();
		setorigin(test,[10,0,0]);
		precache_model("models/test.iqm");
		setmodel(test,"models/test.iqm");
		test.drawmask = 1;
		test.predraw = Draw_Standard;
		MENU_Active = TRUE;

		// Player Entity Spawned!
		player = spawn();
		makevectors(view_angles);
		setorigin(player,(view_origin + (v_forward * 40)));
		setmodel(player,"models/test.iqm");
		player.drawmask = MASK_ENGINE;
		player.solid = SOLID_BBOX;
		player.movetype = MOVETYPE_WALK;
		MENU_STAGE = STAGE_NONE;
*/
	}
	else if(CLIENT_STATE == "connecting")
	{
		//G_LoadLevel(mapname); // Start our outline map file.	
		GAME_STATE = STAGE_LEVEL;
		
		PLAYER_ARM = spawn();
		PLAYER_ARM.origin = autocvar_cg_gun_pos;
		PLAYER_ARM.drawmask = MASK_ENGINE;
		PLAYER_ARM.predraw = PRE_VIEWWEAPON;
		precache_model("models/left_arm.iqm");
		setmodel(PLAYER_ARM,"models/left_arm.iqm");

		G_Outline_Spawn();

		PLAYER_GUN = spawn();
		PLAYER_GUN.origin = autocvar_cg_gun_pos;
		PLAYER_GUN.drawmask = MASK_ENGINE;
		PLAYER_GUN.predraw = PRE_VIEWWEAPON;
		setmodel(PLAYER_GUN,"models/launcher.iqm");
		setattachment(PLAYER_GUN,PLAYER_ARM,"hand_bone");
		G_Current_Weapon = getstatf(STAT_ACTIVEWEAPON);
	//	G_Player_Weapon_Change(G_Weapon_Uzi);
	
	precache_model("asdf");
	}
};


void() CSQC_Shutdown = // Called on CSQC Shutdown
{
	
};