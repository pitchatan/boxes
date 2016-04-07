void(string map) G_LoadLevel =
{
	self = world;
	self.model = strcat("maps/", map, ".bsp");
	precache_model(self.model);
	self.solid = SOLID_NOT;
	setmodel(self, self.model);	/*THIS LINE CHANGES THE WORLD*/

	CSQC_WorldLoaded();
};


void() G_Set_View =
{
	view_angles = getproperty(VF_ANGLES); 
	view_origin = getproperty(VF_ORIGIN);
};


void() vid_stage1 =
{
	// always clear our scene from all elements (2d,3d etc) before next renderframe.
	clearscene();
	
// Always setviewprops and addentities after clearscene...

	// Assign Standard Viewflags
	// Draw the World (and sky)
	setviewprop(VF_DRAWWORLD, 1);
	// Change Perspective 1: normal, 0: isometric
	setviewprop(VF_PERSPECTIVE, 1);
	// dont render engine crosshair
	setviewprop(VF_DRAWCROSSHAIR, 0);
	// Do not Draw the Engine Status Bar (the default Quake HUD)
	setviewprop(VF_DRAWENGINESBAR, 1);	
	
	// Get Frame Data for our Resolution Scaling.
	//setviewprop(VF_RT_DESTCOLOUR,"screenview",3,[vres_x,vres_y]);

	if(CLIENT_STATE == "disconnected")
	{
	// Set Camera to Forced Origin
	setproperty(VF_ORIGIN,[0,0,0]);
	}
	else
	{

	}
	
	// add entities with relevant .drawmasks
	addentities(MASK_ENGINE | MASK_VIEWMODEL); 
	
	// adds a crappy dynamic light to our scene.
	//	dynamiclight_add(view_origin,900,[1,1,1]); 
	
	// render our fancy scene!
	renderscene();	
	// this will end/reset our frame capture. If we dont end it, it wont work properly.
	//setviewprop(VF_RT_DESTCOLOUR,""); 
};

void() vid_stage2 =
{
	clearscene();
	
	
// Always setviewprops and addentities after clearscene...
	// Assign Standard Viewflags
	// Draw the World (and sky)
	setviewprop(VF_DRAWWORLD, 0);
	// Change Perspective 1: normal, 0: isometric
	setviewprop(VF_PERSPECTIVE, 1);
	// dont render engine crosshair
	setviewprop(VF_DRAWCROSSHAIR, 0);
	// Do not Draw the Engine Status Bar (the default Quake HUD)
	setviewprop(VF_DRAWENGINESBAR, 0);	
	// Set our virtual resolution scaling.	
	setviewprop(VF_SIZE,screen_size);

	// Render our scene..	
	renderscene();


};

float() Draw_Standard = 
{
	self.drawmask = MASK_ENGINE;
	G_Set_View();	
	makevectors(view_angles);
	self.origin = view_origin + (v_forward * 120);
//	self.angles = vectoangles(self.origin - view_origin);
	local vector angler = vectoangles(self.origin - view_origin);
	
	self.angles_x = angler_x;
	self.angles_y = angler_y;
	self.movetype = MOVETYPE_WALK;
	if(self.anim_time < time)
	{
	self.angles_z += 0.1;
	self.anim_time = time + 0.01;
	}
	
	self.renderflags = RF_DEPTHHACK;
	return FALSE;
}



void() G_Player_Physics =
{
	if(self.movetype == MOVETYPE_WALK)
	{
		if(self.flags == FL_ONGROUND)
		{
		//	self.velocity += [0,0,-10];		
		}
		else
		{
			self.velocity = self.velocity + [0,0,1];
		}
	}
	
	print(ftos(self.movetype));
	
};


void() G_Player_Think =
{
	
};

void() G_Start_Game =
{
	
	print("Starting Game!\n");
	GAME_STATE = STAGE_LEVEL;
	
	G_MenuToggle();
//	G_Fade(0.5);
};


void() G_Draw_Pointer =
{
	drawstring(INPUT_MOUSE,"+",[15,15],[1,1,1],1,0);
};

float G_Fade_Time;
void(float value) G_Fade = // This will add a smooth fade effect when going between menus and levels.
{
	if(value == 1337) // value of 1337 will default into normal behaviour ie: fading in/out based on G_Fade_Target.
	{
		if(G_Fade_Value != G_Fade_Target)
		{
			if(G_Fade_Time < cltime)
			{
				if(G_Fade_Value < G_Fade_Target)
					G_Fade_Value = G_Fade_Value + 0.02;
				else if(G_Fade_Value > G_Fade_Target)
					G_Fade_Value = G_Fade_Value - 0.02;

			
			G_Fade_Time = cltime + 0.01;
			}
		}
		
		drawfill([0,0],screen_size,[0.001,0.001,0.001],G_Fade_Value);
	}
	else
	{	
		if(value >= 0 && value <= 1) // if else it will check that value is in range between 0 and 1,  if it is in range it sets G_Fade_Target to Value.
			G_Fade_Target = value;
	}
};


float() PRE_OUTLINE
{
	
	if(autocvar_cg_outlines > 0)
	{
		self.alpha = 1;
		self.fatness = autocvar_cg_outlines_fatness;
		self.scale = autocvar_cg_outlines_scale;
		self.forceshader = shaderforname("outlines");
		self.colormod = [0.01,0.01,0.01];
	}
	else
	{
		self.alpha = 0.01;
	}
	
	return FALSE;
};


void() G_Outline_Spawn =
{

	if(PLAYER_GUN.outline == world)
	{

		//print("outline spawned!");
		PLAYER_GUN.outline = spawn();
		PLAYER_GUN.outline.scale = 1.05;
		PLAYER_GUN.outline.origin = [0,0,0];
		PLAYER_GUN.outline.angles = [0,0,0];
		PLAYER_GUN.outline.drawmask = MASK_ENGINE;


		PLAYER_GUN.outline.renderflags = RF_DEPTHHACK;
		PLAYER_GUN.outline.classname = "outline";
		PLAYER_GUN.outline.predraw = PRE_VIEWWEAPON;
		PLAYER_GUN.outline.owner = PLAYER_GUN;
	}
};


float() PRE_RAGDOLL = 
{
	
	#if 1
	if (!self.animobject)
	{
		self.animobject = skel_create(self.modelindex);
		skel_build(self.animobject, self, self.modelindex, 0, 0, 0, 1);
	}
	#else
	skel_build(self.skeletonindex, self, self.modelindex, 0, 0, 0, 1);
	#endif
	
	skel_ragupdate(self, "", self.animobject);
	
	/*
	self.skeletonindex = skel_create(self.modelindex);
	skel_build(self.skeletonindex, self, self.modelindex, 0, 0, 0, 1);
	skel_ragupdate(self, "doll test.doll", self.animobject);
	skel_ragupdate(self, "animate 0", self.animobject);
	*/
	return FALSE;
};


float() PRE_VIEWWEAPON =
{
	
	local vector ARM_FORWARD;
	local vector ARM_UP;
	local vector ARM_SIDE;
	local vector ARM_POS;
	local vector ARM_OFFSET;
	PLAYER_GUN_HAND_BONE = gettaginfo(PLAYER_ARM,gettagindex(PLAYER_ARM,"hand_bone"));	
	ARM_FORWARD = v_forward;
	ARM_UP = v_up;
	ARM_SIDE = v_right;
	
	if(self.model == "models/left_arm.iqm")
	{
	G_Set_View();
	makevectors(view_angles);
	ARM_POS = (v_right * autocvar_cg_gun_pos_y) + (v_forward * autocvar_cg_gun_pos_x) + (v_up * autocvar_cg_gun_pos_z);
	ARM_OFFSET = (v_right * 5) + (v_forward * 15) + (v_up * -25);
	self.origin = view_origin + ARM_OFFSET + ARM_POS;
	self.solid = SOLID_NOT;
	setsize(self,[-1,-1,-1],[1,1,1]);
	self.angles = vectoangles(v_forward * 20);
	self.renderflags = RF_DEPTHHACK;
	}


	if(self.model == "models/launcher.iqm")
	{
	self.origin = PLAYER_GUN_HAND_BONE + [0,0,0];
	self.solid = SOLID_NOT;
	setsize(self,[-1,-1,-1],[1,1,1]);
	makevectors(view_angles);
	self.angles = vectoangles(v_forward);
	self.renderflags = RF_DEPTHHACK;
	self.colormod = [1,0,0];
//	self.effects = EF_FULLBRIGHT;	
	
	}

	
	if(self.model == "models/pistol.iqm")
	{
		
	//void(entity e, entity tagentity, string tagname) setattachment = #443; /* Part of DP_GFX_QUAKE3MODELTAGS*/

	//gettaginfo(PLAYER_ARM,gettagindex(PLAYER_ARM,"hand_bone"));	
	self.origin = PLAYER_GUN_HAND_BONE;
	self.solid = SOLID_NOT;
	setsize(self,[-1,-1,-1],[1,1,1]);
	makevectors(view_angles);
	self.angles = vectoangles(v_forward);
	self.renderflags = RF_DEPTHHACK;
	self.colormod = [0.1,0.1,1];
//	self.effects = EF_FULLBRIGHT;

//void(string texturename, optional float flags, optional float is2d) R_BeginPolygon = #306; /*
//void(vector org, vector texcoords, vector rgb, float alpha) R_PolygonVertex = #307; /*
//void() R_EndPolygon = #308; 	
//void(vector start, vector mins, vector maxs, vector end, float nomonsters, entity ent) tracebox = #90; /* Part of DP_QC_TRACEBOX


	if(G_Uzi_Beam_Time > time && G_Weapon_Switch_Time < time)
	{





		local vector colour;
		colour = [autocvar_cg_draw_laser_colour_red,autocvar_cg_draw_laser_colour_green,autocvar_cg_draw_laser_colour_blue];
//void(vector org, vector texcoords, vector rgb, float alpha) R_PolygonVertex = #307; /*		

		makevectors(view_angles);
		tracebox(view_origin,[-4,-4,-4],[4,4,4],view_origin + (v_forward * 600),0,PLAYER_ARM);
		
			if(trace_fraction < 1 && cvar("cg_draw_laser_impact") == 1)
			{
				local vector adjust = (v_up * 5) + (v_right * -5);
				
				R_BeginPolygon("beamer_hit");
				R_PolygonVertex(trace_endpos + adjust,[1,0],[1,1,1],1); // start poly
				R_PolygonVertex(trace_endpos + (v_up * -10) + adjust,[1,0],[1,1,1],1); // start down
				R_PolygonVertex(trace_endpos + (v_up * -10) + (v_right * 10) + adjust,[0,1],[1,1,1],1); // start down
				
				R_PolygonVertex(trace_endpos + (v_right * 10) + adjust,[1,0],[1,1,1],1); // end poly left
				R_PolygonVertex(trace_endpos + (v_right * 10) + (v_up * -10) + adjust,[1,0],[1,1,1],1); // end poly left down
				R_PolygonVertex(trace_endpos + (v_up * -10) + adjust,[1,0],[1,1,1],1); // end poly right down	
				R_EndPolygon();	
				
			}



		R_BeginPolygon("gfx/beamer.jpg");
		R_PolygonVertex(self.origin,[1,0],colour,0.5);
		R_PolygonVertex(self.origin + [0,0,5],[1,0],colour,0.5);

		//traceline(view_origin,view_origin + (v_forward * 600),0,PLAYER_ARM);
		R_PolygonVertex(trace_endpos,[0,1],colour,0.5);
		R_PolygonVertex(trace_endpos,[0,1],colour,0.5);
		R_EndPolygon();
		
		
		makevectors(view_angles);
		R_BeginPolygon("gfx/beamer.jpg");
		R_PolygonVertex(self.origin + (v_right * -2.5) + (v_up * 2.5),[1,0],colour,0.5);
		R_PolygonVertex(self.origin + (v_right * 2.5) + (v_up * 2.5),[1,0],colour,0.5);
		
		R_PolygonVertex(trace_endpos,[1,1],colour,0.5);
		R_PolygonVertex(trace_endpos,[1,1],colour,0.5);
		R_EndPolygon();
		if(PLAYER_ARM.attack_time < time)
		{
			
			sendevent("G_Client_Damage","ev",trace_ent,(view_origin + (v_forward * 600)));
		
			if(trace_ent.classname == "player" && trace_ent != world)
			{
				G_Attack_Damage(trace_ent,G_Weapon_Uzi);
				G_Attack_Plume(trace_ent,4,trace_endpos);
			}

		PLAYER_ARM.attack_time = time + 0.05;
		}
		

		
	}
	
	
	

	


	
	
	}

	if(self.classname == "outline")
	{
		setmodel(self,PLAYER_GUN.model);
		setsize(self,[-1,-1,-1],[1,1,1]);
		//setmodel(self,"models/pistol.iqm");
	//	self.origin = PLAYER_GUN_HAND_BONE;
		makevectors(view_angles);
		self.angles = vectoangles(v_forward);
		self.forceshader = shaderforname("outlines");
		self.colormod = [16,1,1];
		self.solid = SOLID_NOT;
		self.effects = EF_FULLBRIGHT;
	}
	
	if(cvar("chase_active"))
		return TRUE;
	else
		return FALSE;
};


void() G_Draw_Crosshair = 
{
	local float adjust = autocvar_cg_crosshair_size / 2;
	local float size = autocvar_cg_crosshair_size;
	drawpic(screen_center - [adjust,adjust],"gfx/crosshairs/cross.png",[size,size],[1,1,1],1,0);

};


void() G_Dummy_Spawn =
{
	dummy = spawn();
	makevectors(view_angles);
	setorigin(dummy,view_origin + (v_forward * 200));
	precache_model("models/test.iqm");
	setmodel(dummy,"models/test.iqm");
	setsize(dummy,[-10,-10,-25],[10,10,40]);
	dummy.solid = SOLID_SLIDEBOX;
	dummy.movetype = MOVETYPE_WALK;
	dummy.classname = "player";
	dummy.health = 120;
	dummy.drawmask = MASK_ENGINE;
	physics_enable(dummy,FALSE);
};


void() G_Attack_Beep =
{
	precache_sound("sounds/weapons/hit/hit.wav");
	sound(PLAYER_ARM,CHAN_AUTO,"sounds/weapons/hit/hit.wav",0.5,ATTN_NONE,random(100,110));	
};

void(entity target,float weapon) G_Attack_Damage =
{
	if(target.classname == "player" && target != world && target.dead == FALSE)
	{
		if(cvar("cg_predict_hitbeep") > 0)	
		G_Attack_Beep();
		

		/*
		
		if(autocvar_gunny == G_Weapon_Uzi)
			target.health += -4;
			
		if(target.health <= 0 && target.dead == FALSE)
		{

	//	setsize(target, VEC_HULL_MIN, VEC_HULL_MAX);

		
		
		
		

		target.dead = TRUE;

		if(cvar("cg_player_deaths") == 1)
		{		
			local entity e;
			e = spawn();
			e.movetype = MOVETYPE_NONE;
			e.solid = SOLID_NOT;
			e.owner = world;
			e.angles = target.angles;
			e.angles_x *= -1;
			e.mass = 0.1;
			e.drawmask = MASK_ENGINE;
			e.predraw = PRE_RAGDOLL;
			e.alpha = 1;
			e.think = SUB_Remove;
			e.nextthink = time + 2;
			makevectors(view_angles);
			e.velocity = target.velocity + v_forward * 1000;
			precache_model("models/player/erebus.iqm");
			setmodel(e, "models/player/erebus.iqm");
			setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
			setorigin(e, target.origin);
			e.skeletonindex = skel_create(e.modelindex);
			skel_build(e.skeletonindex, e, e.modelindex, 0, 0, 0, 1);
			skel_ragupdate(e, "doll models/player/erebus.doll", e.animobject);
			skel_ragupdate(e, "animate 0", e.animobject);
		}
  		remove(target);
  		
		}
		*/
		
	}
};

void(entity target,float damage,vector pos) G_Attack_Plume =
{
	if(cvar("cg_draw_plumes") == 1)
	{
		plume = spawn();
		setorigin(plume,pos);
		plume.movetype = MOVETYPE_TOSS;
		makevectors(view_angles);
		plume.velocity += (v_right * random(-200,200)) + (v_up * random(300,550));//[random(-200,200),random(-200,200),random(300,550)];
		plume.classname = "damage";
		plume.solid = SOLID_NOT;
		setsize(plume,[-1,-1,-1],[1,1,1]);
		plume.health = damage;
		plume.attack_time = time + 1.5;
		plume.owner = PLAYER_ARM;
		plume.gravity = 10;
		plume.touch = SUB_Remove;
		plume.nextthink = time + 1;
		plume.think = SUB_Remove;
	}
};


void() G_Attack_Plume_Draw =
{
	local entity dmg;

	if(cvar("cg_draw_plumes") == 1)
	{
		dmg = findchain(classname,"damage");
		while(dmg)
		{
			if(dmg != world)
			{	
				local float length,value;
				local vector projected = project(dmg.origin);
				length = vlen(view_origin - dmg.origin);

				traceline(view_origin,dmg.origin,0,self);
				
				if(trace_fraction > 0.5)
				{
					if(length > 2000)
					length = 2000;
					
					value = length / 2000;
					value = 1 - value;
					
					drawfont = 1;
					if(projected_z > 0)
						drawstring(project(dmg.origin),ftos(dmg.health),[15 * value,15 * value],[1,1,1],1 * value,0);
					
						

				}
				dmg = dmg.chain;
			}
		}
	}
};

void() G_Fire_Rocket_Explode = 
{
	local entity finder = findradius(self.origin,120);
	local float length,total;
	
	while(finder)
	{
	
		if(finder != other && finder.classname == "player" || other == self.owner)
		{
		length = vlen(self.origin - finder.origin);
		total = length / 120;
			
			
		
		finder.velocity += + (normalize(finder.origin - self.velocity) * 600);
		G_Attack_Damage(finder,G_Weapon_Launcher);
		G_Attack_Plume(finder,rint(100 * total),finder.origin);			
		
		}
	
	
	finder = finder.chain;
	}
};

void() G_Fire_Rocket_Touch =
{


	if(other.classname == "player")
	{
		G_Attack_Damage(other,G_Weapon_Launcher);
		G_Attack_Plume(other,100,self.origin);	
		
					
		local vector movedir = normalize(other.origin - self.origin);
		other.velocity += (movedir * 600); 	
	}
	G_Fire_Rocket_Explode();
	pointparticles(particleeffectnum("box.explode"),self.origin);
	remove(self);
};

void() G_Fire_Rocket_Think =
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("box.a"),self.origin,(self.origin + v_forward)); //,vectoangles(v_forward));
	self.nextthink = time;
};

void() G_Fire_Rocket =
{
	if(cvar("cg_predict_rockets") > 0)
	{
		rocket = spawn();
		rocket.owner = PLAYER_ARM;
		setmodel(rocket,"asdf");

		rocket.classname = "rocket";
		rocket.movetype = MOVETYPE_FLYMISSILE;
		rocket.solid = SOLID_BBOX;
	//	G_Set_View();
		makevectors(view_angles);
		rocket.angles = vectoangles(v_forward * 200);
		rocket.origin = view_origin + (v_forward * 15);
		//rocket.origin = self.origin + (v_forward * 15) + self.view_ofs + [0,0,-10] + (v_forward * 20);
		rocket.velocity = v_forward * 1000;
		rocket.think = G_Fire_Rocket_Think;
		rocket.nextthink = time;
		rocket.touch = G_Fire_Rocket_Touch;

		setsize(rocket,[-2,-2,-2],[2,2,2]);	

	}
	PLAYER_GUN.attack_finished = time + 0.8;
	sendevent("G_Client_Damage","ev",trace_ent,(view_origin + (v_forward * 600)));
};

float(float isnew) G_Player_Delta =
{
	if(isnew)
	{
		
		//__variant(float entnum, float fieldnum) getentity = #504; /*
	self.health = 120;

			
	precache_model("models/player/erebus.iqm");
	setmodel(self,"models/player/erebus.iqm");
	self.frame = 0;
	self.predraw = G_Player_Predraw;
	self.drawmask = MASK_ENGINE;
	
	if(self.entnum == player_localentnum)
		self.renderflags = RF_EXTERNALMODEL;

	if(self.entnum == player_localentnum)
		self.solid = SOLID_NOT;
	
	if(self.entnum == player_localentnum)
		self.owner = PLAYER_ARM;

	self.movetype = MOVETYPE_WALK;
	self.classname = "player";
	self.origin = self.origin;
	self.solid = SOLID_BBOX;
	

	
	
	}
	
	if(self.entnum == player_localentnum)
	setsize(self,[-1,-1,-1],[1,1,1]);		
	else
	setsize(self,[-15,-15,-25],[15,15,40]);
	
return TRUE;
};

float(float isnew) G_Rocket_Delta =
{
	if(isnew)
	{
	setmodel(self,"asdf");

//	self.predraw = G_Player_Predraw;
	self.drawmask = MASK_ENGINE;
	self.classname = "rocket";
	self.nextthink = time;
	self.think = G_Fire_Rocket_Think;
	}
return TRUE;
};

float() G_Player_Predraw =
{
	self.frame = 0;
	self.frame1time = 0;
	self.frame2time = 0;
	
	if(self.entnum == player_localentnum)
		self.colormod = [0,1,0];
	else
		self.colormod = [1,0,0];
		
return FALSE;	
};


void() G_Player_Attack =
{ 
	
};


void(float weapon) G_Player_Weapon_Change =
{
	if(G_Weapon_Switch_Time < time && G_Current_Weapon != weapon)
	{
	sendevent("G_Player_Weapon_Change","f",weapon);

	dprint(strcat("gun: ",ftos(weapon),"\n"));
		
	PLAYER_ARM.attack_finished = time + 0.4;
	G_Weapon_Switch_Time = time + 0.25;
	}
	
	
	G_Weapon_Buffer = weapon;
};