void CSQC_UpdateView(float vwidth, float vheight, float notmenu) =
{
	/*
		UpdateView all things rendering will be done in here..
		Good practice is to think in stages when you setup your rendering.
	*/
	
	view_framerate = rint(1 / frametime);	// Uses frame time to calculate framerate, framerate is then rounded up..
	
	// Updates ping and packetloss values every frame but does not retrieve the values every frame.
	player_ping = stof(getplayerkeyvalue(player_localnum, "ping"));
	player_pl = stof(getplayerkeyvalue(player_localnum, "pl"));
	player_health = getstatf(STAT_HEALTH);
	screen_size = screen_center = '0 0 0';//prevent noref warning
	
	screen_size_x = vwidth; // width of current screen
	screen_size_y = vheight; // height of current screen
	screen_center_x = screen_size_x/2; // width halved, gives us the horizontal center
	screen_center_y = screen_size_y/2; // height halved, gives us the vertical center
		
	// Will Retrieve the current client state every frame
	CLIENT_STATE = serverkey("constate");
	

	G_Set_View();	// retrieve the current view origin and view angles

	vid_stage1();   // first render pass (world,entities, etc).
	//vid_stage2();	// Second Render pass (crosshair,hud,etc).

	spawn_time = 0; // set to avoid warning, unused currently.
	

	//drawfill([0,0],screen_size,[4,0.1,0.1],1);	// draws a reddish background if we choose to have custom aspect ratios for our view while still retaining resolution.
	//drawpic([0,0],"screenview",screen_size,[1,1,1],1); // Draws the current frame from vid_stage1(), this allows for resolution scaling and other shader doodas to be performed.
	
	G_Fade(1337);	// Fade between scenes
	
	G_Menu();  // Will render our menu  if MENU_ACTIVE  is true.					
	
	if(rint(autocvar_cg_drawinfo) > 0) // renders client state if TRUE(1) or higher.
		drawstring([0,0],CLIENT_STATE,[12,12],[1,1,1],1,0);  // just our client state.
	
	if(rint(autocvar_cg_drawfps) > 0) // If cvar is true(1) or higher
		drawstring([screen_size_x,0] - [strlen(ftos(view_framerate)) * 12,0],ftos(view_framerate),[12,12],[1,1,1],1,0);  // renders current framerate
	
	if(rint(autocvar_cg_showtime) > 0) // if cvar is true(1) or higher
		drawstring([screen_size_x,24] - [strlen(ftos(time)) * 12,0],ftos(time),[12,12],[1,1,1],1,0);  // renders current server time
	if(CLIENT_STATE == "active")
	{
		if(G_Current_Weapon == G_Weapon_Uzi)
			PLAYER_GUN.model = "models/pistol.iqm";
		else if(G_Current_Weapon == G_Weapon_Launcher)
			PLAYER_GUN.model = "models/launcher.iqm";
		

		G_Attack_Plume_Draw();	
		G_Draw_Crosshair();
		
		
		if(getstatf(STAT_ACTIVEWEAPON) != G_Current_Weapon)
		{
			if(getstatf(STAT_ACTIVEWEAPON) == G_Weapon_Uzi)
				setmodel(PLAYER_GUN,"models/pistol.iqm");
			else if(getstatf(STAT_ACTIVEWEAPON) == G_Weapon_Launcher)
				setmodel(PLAYER_GUN,"models/launcher.iqm");	
		}
		G_Current_Weapon = getstatf(STAT_ACTIVEWEAPON);	
		
		
		if(G_Current_Weapon != G_Weapon_Buffer)
		G_Player_Weapon_Change(G_Weapon_Buffer);
	}
	
	G_Draw_Pointer(); // Draws our mouse pointer
	
	drawstring([0,0,0],ftos(player_ping),[24,24],[1,1,1],1,0);
	drawstring([0,26],ftos(G_Current_Weapon),[24,24],[1,1,1],1,0);	
	
	if(mouseisheld && mouseretrigger < time)
	{	
		if(player_health > 0)
		{
			if(G_Current_Weapon == G_Weapon_Uzi)
			{
				G_Uzi_Beam_Time = time + 0.08;
			}
			else if(G_Current_Weapon == G_Weapon_Launcher && PLAYER_GUN.attack_finished < time && G_Weapon_Switch_Time < time)
			{
				G_Fire_Rocket();
			}
		}
		
		
		mouseretrigger = time + 0.001;
	}
	
	
	if(delta_time < time)
	{
		deltalisten("models/player/erebus.iqm",G_Player_Delta,FALSE);
		deltalisten("asdf",G_Rocket_Delta,FALSE);
		delta_time = time + 1;
	}
};