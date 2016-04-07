float(float evtype, float scanx, float chary, float devid) CSQC_InputEvent =
{
	/*
		event is one of: 0:key pressed, 1:key released, 2:mouse move.
		This is called if setwantskeys was last called with the parameter true.
		This func returns a value. "false" signalize that engine *should* take care of the keypress or mouse move, a return value of true will make the engine otherwise ignore the event ever happened. This helps to use only keys that are really needed.
		With keyboard events, parama is set to the keycode. The key values are as in the menu.dat (and DarkPlaces), and consistant between engines.
		With mouse movement events, parama contains the X motion of the mouse, while paramb contains the Y motion of the mouse.
		To implement a mouse cursor, update your internal mouse cursor pos based on the params, and return true (to stop it from looking around). Remember to draw the mouse cursor, and clip it to the screen.
	*/
	
	local float result;

	if(evtype == 0)
	{
		if(scanx == K_ESCAPE)
		{
	//	G_MenuToggle();
		}
		
		if(scanx == K_LEFTARROW)
			G_Menu_Navigate(-1);
		if(scanx == K_RIGHTARROW)
			G_Menu_Navigate(+1);		
		
	if(MENU_STAGE != STAGE_NONE)
	{
		if(scanx == K_UPARROW)
			G_Menu_Navigate(-1,1);
		if(scanx == K_DOWNARROW)
			G_Menu_Navigate(1,1);
	}		
		
		if(scanx == K_BACKSPACE)
			MENU_STAGE = STAGE_NONE;
		
		if(scanx == K_ENTER)
			G_MenuSelect();
	}
	else if(evtype == 2)
	{
		if(MENU_Active == TRUE)
		INPUT_MOUSE += [(scanx * 0.1) * cvar("sensitivity"),(chary * 0.1) * cvar("sensitivity")];
		
		if(MENU_Active == TRUE)
		result = TRUE;
	}


	  switch(evtype)
	  {
	    case IE_KEYDOWN:
	    case IE_KEYUP:
	    if (scanx == K_MOUSE1)
	    {
	      mouseisheld = (evtype == IE_KEYDOWN);	      
	      return mouseisheld;
	    }
	    break;
	  }




	return result;
};


void() CSQC_Input_Frame = // is called everytime the client recieves a input command (input_impulse,input_move, etc)
{
	if(MENU_Active == TRUE)
		input_movevalues = [0,0,0];
	else
		input_movevalues += [0,0,800];
		
	if(input_buttons == 1)
	{

		
	}
	
	
	if(input_impulse == 2)
		G_Dummy_Spawn();
};