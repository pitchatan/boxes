	entity dummy;
void() G_Player_Physics;
void() G_Player_Spawn;
entity() G_Spawn_Find;
void() info_player_deathmatch = {};
void() G_Dummy_Spawn;
void() G_Fire_Rocket;
entity rocket;
.float attack_finished;
void() SUB_Remove = 
{
	remove(self);
};


.float bot;