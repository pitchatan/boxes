void() G_MenuDraw =
{
	G_Fade(0.5);	// Fades the background into half opacity
	drawfont = loadfont("","fonts/papercuts.ttf","24",1); // This initializes and uses the font we want,  any other drawfont or loadfont that replaces the same slot will remove the current one.
	drawstring([screen_center_x - ((strlen("Paperman") * 64) / 2),10], strcat(GAME_TITLE,": ",GAME_UNDERTITLE),[64,64],[1,1,1],1,0); // TITLE LOGO


	if(MENU_STAGE == STAGE_MAIN) // This is our main menu
	{
		STAGE_OPTIONS_ITEM = 0; // Resets the options item to 0, remove this if you want to keep some persistanse while browsing the menus.
		drawfill([screen_center_x - ((strlen("Paperman") * 64) / 2),80] + [0,-5] + [0,MENU_Animate()],[(strlen("Paperman") * 24),34],[0.01,0.01,0.01],0.4,0); // this is our filler background, has bobbing animation.
		drawstring([screen_center_x - ((strlen("Paperman") * 64) / 2),80] + [0,MENU_Animate()], MENU_Items[MENU_Selection],[32,32],[1,1,1],1,0); // This is our current menu selection, also has bobbing animation.
	
		if(MENU_Selection < 4) // if Selection goes past 4 arrow will dissapear.
			drawstring([screen_center_x - 100,80 + MENU_Animate()],">",[32,32],[1,1,1],1,0); // Draws an arrow to indicate that more options are available.
	}
	else if(MENU_STAGE == STAGE_OPTIONS) // This is our options menu
	{
		drawfill([screen_center_x - ((strlen("Paperman") * 64) / 2),80] + [0,-5] + [0,MENU_Animate()],[(strlen("Paperman") * 26),34],[0.01,0.01,0.01],0.4,0); // this is our filler background, has bobbing animation.


		// These are our option selections, up/down arrow will toggle between them while left/right will change their respective values
		if(STAGE_OPTIONS_ITEM == STAGE_OPTIONS_SCALE)
			drawstring([screen_center_x - ((strlen("Paperman") * 64) / 2),80] + [0,MENU_Animate()], strcat("^1Render Scale^7 X", ftos(cvar("r_renderscale"))),[32,32],[1,1,1],1,0); // Render Scale string
		if(STAGE_OPTIONS_ITEM == STAGE_OPTIONS_SENS)
			drawstring([screen_center_x - ((strlen("Paperman") * 64) / 2),80] + [0,MENU_Animate()], strcat("^1Sensitivity Scale^7 X", ftos(cvar("sensitivity"))),[32,32],[1,1,1],1,0); // sensitivity Scale String
		if(STAGE_OPTIONS_ITEM == STAGE_OPTIONS_RAGDOLL)
			drawstring([screen_center_x - ((strlen("Paperman") * 64) / 2),80] + [0,MENU_Animate()], strcat("^1Ragdolls^7 ", ftos(cvar("cg_player_deaths"))),[32,32],[1,1,1],1,0); // ragdoll on or off			
		if(STAGE_OPTIONS_ITEM == STAGE_OPTIONS_PLUMES)
			drawstring([screen_center_x - ((strlen("Paperman") * 64) / 2),80] + [0,MENU_Animate()], strcat("^1Damage Indicator^7 ", ftos(cvar("cg_draw_plumes"))),[32,32],[1,1,1],1,0); // damage plumes on or off	
		if(STAGE_OPTIONS_ITEM == STAGE_OPTIONS_IMPACT)
			drawstring([screen_center_x - ((strlen("Paperman") * 64) / 2),80] + [0,MENU_Animate()], strcat("^1Laser Impact^7 ", ftos(cvar("cg_draw_laser_impact"))),[32,32],[1,1,1],1,0); // damage plumes on or off	
		if(STAGE_OPTIONS_ITEM == STAGE_OPTIONS_LASER1)
			drawfill([screen_center_x - ((strlen("Paperman") * 64) / 2),80] + [0,MENU_Animate()] + [5,0],[200,25],[1,0,0],0.8);
		if(STAGE_OPTIONS_ITEM == STAGE_OPTIONS_LASER2)
			drawfill([screen_center_x - ((strlen("Paperman") * 64) / 2),80] + [0,MENU_Animate()] + [5,0],[200,25],[0,1,0],0.8);
		if(STAGE_OPTIONS_ITEM == STAGE_OPTIONS_LASER3)
			drawfill([screen_center_x - ((strlen("Paperman") * 64) / 2),80] + [0,MENU_Animate()] + [5,0],[200,25],[0,0,1],0.8);

		if(STAGE_OPTIONS_ITEM == STAGE_OPTIONS_LASER1 || STAGE_OPTIONS_ITEM == STAGE_OPTIONS_LASER2 || STAGE_OPTIONS_ITEM == STAGE_OPTIONS_LASER3)
		{
			drawfill([screen_center_x - ((strlen("Paperman") * 64) / 2),80] + [0,32 + MENU_Animate()] + [5,0],[200,25],[autocvar_cg_draw_laser_colour_red,autocvar_cg_draw_laser_colour_green,autocvar_cg_draw_laser_colour_blue],0.8);			
			drawstring([screen_center_x - ((strlen("Paperman") * 64) / 2),80] + [10,42 + MENU_Animate()], strcat("^1Laser Colour^7 ", vtos([autocvar_cg_draw_laser_colour_red,autocvar_cg_draw_laser_colour_green,autocvar_cg_draw_laser_colour_blue])),[12,12],[1,1,1],1,0); // damage plumes on or off				
		}

								
		drawfill([screen_center_x,80],[250,60],[0.01,0.01,0.01],0.4,0); // our info background.
		drawstring([screen_center_x + 10,90],"UP and DOWN arrows will switch between settings",[12,12],[1,1,1],1,0); // tells people what to do rawrr..
		drawstring([screen_center_x + 10,105],"LEFT and RIGHT to change values",[12,12],[1,1,1],1,0); // tells people more what to do RAAAWWRRR..
		drawstring([screen_center_x + 10,120],"PRESS backspace to go back",[12,12],[1,1,1],1,0); // Now its just being rude...
		
	}
		drawstring([screen_center_x - ((strlen("Paperman") * 64) / 2),180],"press ENTER to access menu selection",[12,12],[1,1,1],1,0); // Enter to use, straight forward!  Will be rendered/displayed ontop of the rest of the menu.
};

void(float value,optional float toggle) G_Menu_Navigate = 
{
	if(toggle == 1) // If toggle is set, up/down arrows will change between option items.
	{
		if(MENU_STAGE == STAGE_OPTIONS) // options screen behaviour.
		{
			if(STAGE_OPTIONS_ITEM + value <= STAGE_OPTIONS_MAX -1 && STAGE_OPTIONS_ITEM + value >= 0) // checks that value is in range
			STAGE_OPTIONS_ITEM += value; // if in range, add value to item.
		}
	}
	else
	{
		if(MENU_STAGE == STAGE_MAIN) // Our main menu.
		{
			if(MENU_Selection + value <= 0)
				MENU_Selection = 0;

			if(MENU_Selection + value > 4)
				MENU_Selection = 4;
			else if(MENU_Selection + value < 0)
				MENU_Selection = 0;
			else
				MENU_Selection += value;

		}
		else if(MENU_STAGE == STAGE_OPTIONS) // option specific stuff
		{		
			if(STAGE_OPTIONS_ITEM == STAGE_OPTIONS_SCALE)
			{
				if(cvar("r_renderscale") + (value * 0.1) > 1)
					cvar_set("r_renderscale","1");
				else if(cvar("r_renderscale") + (value * 0.1) < 0)
					cvar_set("r_renderscale","0");
				else
					cvar_set("r_renderscale",ftos(cvar("r_renderscale") + (value * 0.1)));
			}
			
			if(STAGE_OPTIONS_ITEM == STAGE_OPTIONS_SENS)
			{
				if(cvar("sensitivity") < 0)
					cvar_set("sensitivity","0");
				else
					cvar_set("sensitivity",ftos(cvar("sensitivity") + (value * 0.5)));
			}
			
			if(STAGE_OPTIONS_ITEM == STAGE_OPTIONS_RAGDOLL)
			{
				if(cvar("cg_player_deaths") + value < 0)
					cvar_set("cg_player_deaths","0");
				else if(cvar("cg_player_deaths") + value > 1)
					cvar_set("cg_player_deaths","1");					
				else
					cvar_set("cg_player_deaths",ftos(cvar("cg_player_deaths") + (value * 1)));
			}

			if(STAGE_OPTIONS_ITEM == STAGE_OPTIONS_PLUMES)
			{
				if(cvar("cg_draw_plumes") + value < 0)
					cvar_set("cg_draw_plumes","0");
				else if(cvar("cg_draw_plumes") + value > 1)
					cvar_set("cg_draw_plumes","1");					
				else
					cvar_set("cg_draw_plumes",ftos(cvar("cg_draw_plumes") + (value * 1)));
			}

			if(STAGE_OPTIONS_ITEM == STAGE_OPTIONS_IMPACT)
			{
				if(cvar("cg_draw_laser_impact") + value < 0)
					cvar_set("cg_draw_laser_impact","0");
				else if(cvar("cg_draw_laser_impact") + value > 1)
					cvar_set("cg_draw_laser_impact","1");					
				else
					cvar_set("cg_draw_laser_impact",ftos(cvar("cg_draw_laser_impact") + (value * 1)));
			}
			if(STAGE_OPTIONS_ITEM == STAGE_OPTIONS_LASER1 || STAGE_OPTIONS_ITEM == STAGE_OPTIONS_LASER2 || STAGE_OPTIONS_ITEM == STAGE_OPTIONS_LASER3)
			{	
				if(value == -1)
					value = -0.01;
				else if(value == 1)
					value = 0.01;
					
				if(STAGE_OPTIONS_ITEM == STAGE_OPTIONS_LASER1)
				{
					if(autocvar_cg_draw_laser_colour_red + value < 0)
						cvar_set("cg_draw_laser_colour_red","0");
					else if(autocvar_cg_draw_laser_colour_red + value > 1)
						cvar_set("cg_draw_laser_colour_red","1");					
					else
						cvar_set("cg_draw_laser_colour_red",ftos(autocvar_cg_draw_laser_colour_red + (value)));
				}
				else if(STAGE_OPTIONS_ITEM == STAGE_OPTIONS_LASER2)
				{
					if(autocvar_cg_draw_laser_colour_green + value < 0)
						cvar_set("cg_draw_laser_colour_green","0");
					else if(autocvar_cg_draw_laser_colour_green + value > 1)
						cvar_set("cg_draw_laser_colour_green","1");					
					else
						cvar_set("cg_draw_laser_colour_green",ftos(autocvar_cg_draw_laser_colour_green + (value)));
				}
				else if(STAGE_OPTIONS_ITEM == STAGE_OPTIONS_LASER3)
				{
					if(autocvar_cg_draw_laser_colour_blue + value < 0)
						cvar_set("cg_draw_laser_colour_blue","0");
					else if(autocvar_cg_draw_laser_colour_blue + value > 1)
						cvar_set("cg_draw_laser_colour_blue","1");					
					else
						cvar_set("cg_draw_laser_colour_blue",ftos(autocvar_cg_draw_laser_colour_blue + (value)));
				}
			}
		}
	}
};


void() G_MenuSelect = // This function will start whatever function we assign to respective MENU_Item.
{
	if(MENU_Active == TRUE) // Only allow activation of menu items if the menu is actually active!
	{
		if(MENU_STAGE == STAGE_NONE) // First menu stage.
		{
			if(MENU_Items[MENU_Selection] == MENU_NEWGAME)
				G_Start_Game(); // STart our game obviously.
			else if(MENU_Items[MENU_Selection] == MENU_SAVEGAME)
				print("Saving game!");
			else if(MENU_Items[MENU_Selection] == MENU_LOADGAME)
				print("Loading game!");
			else if(MENU_Items[MENU_Selection] == MENU_OPTIONS)
				G_Menu_Options(); // Open our menu.
			else if(MENU_Items[MENU_Selection] == MENU_QUIT)
				localcmd("quit"); // force local console command quit.
		}
		
		if(MENU_STAGE == STAGE_OPTIONS) // Option menu stage!
		{
			localcmd("cfg_save"); // automatically save values to config, is currently setup to happen everytime you press enter.
		}
	}
};




void() G_MenuToggle = 
{
	if(GAME_STATE != STAGE_NONE || CLIENT_STATE != "disconnected")
	{
		if(MENU_Active == TRUE && GAME_STATE == STAGE_LEVEL)
			MENU_Active = FALSE;
		else
			MENU_Active = TRUE;	
	}
};

void() G_Menu = 
{
/*
	Check if MENU_Active is TRUE, render if so!
*/

	if(MENU_Active == TRUE)
		G_MenuDraw();
	else
		G_Fade(0);
		

};

float() MENU_Animate =
{
	// This is just a simple bobbing animation and is intended to be used every frame.

	local float result;

	
	if(MENU_Anim_Time < time)
	{

		if(MENU_Anim_Toggle == 0)
		{
			MENU_Anim_Hover = MENU_Anim_Hover + 0.1;
			if(MENU_Anim_Hover >= 10)
				MENU_Anim_Toggle = 1;
		}
		else
		{
			MENU_Anim_Hover = MENU_Anim_Hover - 0.1;
			if(MENU_Anim_Hover <= 0)
				MENU_Anim_Toggle = 0;
		}
				
		MENU_Anim_Time = time + 0.005;
	}

	
	result = MENU_Anim_Hover;
	
	return result;
}



void() G_Menu_Options = 
{
	MENU_STAGE = STAGE_OPTIONS; // This Setups up MENU_STAGE to display the options screen.
	// FUrther functions pertaining the options menu will be placed inside here..
};
