void() G_Player_Physics =
{

		if(FL_ONGROUND)
		{
			self.velocity = [0,0,0];		
		}
		else
		{
			self.velocity = [0,0,1];
		}

	
	print(ftos(self.movetype));
	
	//self.nextthink = time + 0.01;
	
};

entity() G_Spawn_Find =
{
	local entity spot_list[50];
	local float spot_count = 0;
	local entity result;
	local entity spot = findchain(classname,"info_player_deathmatch");
	
	while(spot)
	{
		spot_count++;
	//	print(strcat("found: [", ftos(spot_count) ,"]",vtos(spot.origin),"\n"));
		spot_list[spot_count] = spot;
		spot = spot.chain;

	}
	
	local float randomized = rint(random(0,spot_count));
//	print(strcat("spawning: [", ftos(randomized) ,"]\n"));
	result = spot_list[randomized];
	
	return result;
}


void() G_Player_Spawn =
{
	local entity spot = G_Spawn_Find();
	self.velocity = [0,0,0];
	setsize(self,[-10,-10,-25],[10,10,40]);
	setorigin(self,spot.origin);
	self.fixangle = TRUE;
	self.angles = spot.angles;
	self.movetype = MOVETYPE_WALK;
	self.velocity = [0,0,0];
	self.solid = SOLID_SLIDEBOX; 
	self.health = 100;
	setmodel(self,"models/player/erebus.iqm");
	self.classname = "player";
	self.currentammo = 1;
	self.weapon = 1;
	self.customphysics = G_Player_Physics;
	self.view_ofs = [0,0,35];
	self.flags = FL_CLIENT;
	setsize(dummy,[-15,-15,-25],[15,15,40]);
};


void() G_Dummy_Spawn =
{
	local entity spot = G_Spawn_Find();
	local vector spot_origin = spot.origin;
	print(strcat(vtos(spot.origin),"\n"));	
	dummy = spawn();
	setsize(dummy,[-15,-15,-25],[15,15,40]);
	setorigin(dummy,spot_origin + [0,0,30]);


	dummy.fixangle = TRUE;
	dummy.angles = spot.angles;
	precache_model("models/player/erebus.iqm");
	setmodel(dummy,"models/player/erebus.iqm");
	dummy.classname = "player";
	dummy.solid = SOLID_SLIDEBOX;
	dummy.movetype = MOVETYPE_WALK;
	dummy.classname = "player";
	dummy.health = 120;
	dummy.bot = TRUE;
	//setorigin(dummy,spot.origin);
	setsize(dummy,[-15,-15,-25],[15,15,40]);
};

float() G_Attack_Float =
{
	if(self.weapon == 1)
		return 4;
	else
		return 4;
};

void(entity target,vector pushangle) G_Attack_Damage =
{
	
	if(target != world && target.classname == "player")
	{
		if(target.health > 0)
		{
			target.health += - G_Attack_Float();
			
			if(target.health <= 0)
			{
				if(target.bot == TRUE)
				remove(target);
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
	
		if(finder != other && finder.classname == "player")
		{
		length = vlen(self.origin - finder.origin);
		total = length / 120;
			

			finder.velocity += + (normalize(finder.origin - self.origin) * rint(1600 * total));			
		
			if(finder == self.owner)
			self.owner.velocity += + (normalize(finder.origin - self.owner.origin) * rint(1200 * total));
			
			finder.health += - rint(100 * total);
			
			if(finder.health <= 0)
			{
				if(other.bot == TRUE)
				remove(finder);
			}
			
	
			
		}

	
	finder = finder.chain;
	}
};


void() G_Fire_Rocket_Touch =
{

	if(other.classname == "player")
	{
		/*
		G_Attack_Damage(other,G_Weapon_Launcher);
		G_Attack_Plume(other,100,self.origin);	
		*/
		if(other.health > 0)
		{
			other.health += -100;
			if(other.health <= 0)
			{
				if(other.flags != FL_CLIENT)
				remove(other);
			}	
			
			local vector movedir = normalize(other.origin - self.origin);
			other.velocity += (movedir * 600); 
		}



	}
	G_Fire_Rocket_Explode();
//	pointparticles(particleeffectnum("box.explode"),self.origin);
	remove(self);
};





void() G_Fire_Rocket =
{
	rocket = spawn();
	rocket.owner = self;
	//precache_model("models/test.iqm");
	setmodel(rocket,"asdf");
	setsize(rocket,[-2,-2,-2],[2,2,2]);
	rocket.classname = "rocket";
	rocket.movetype = MOVETYPE_FLYMISSILE;
	rocket.solid = SOLID_BBOX;
	makevectors(self.v_angle);
	//rocket.traileffectnum = particleeffectnum("box.a");
	rocket.origin = self.origin + (v_forward * 15) + self.view_ofs;
	rocket.velocity = v_forward * 1000;
	rocket.touch = G_Fire_Rocket_Touch;
	rocket.flags = rocket.flags + FL_LAGGEDMOVE;
	self.attack_finished = time + 0.8;
};

void(entity target,vector pushangle) Cmd_G_Client_Damage_ev =
{
	if(self.health > 0)
	{
		if(self.weapon == 1)
		{
			if(target != world && target.classname == "player")
				G_Attack_Damage(target,pushangle);
		}
		else
		{
		G_Fire_Rocket();
		}
		//	print(etos(target));
	}
};

void(float gun) Cmd_G_Player_Weapon_Change_f =
{
	self.weapon = gun;
};