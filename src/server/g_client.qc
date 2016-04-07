void() ClientKill = { };
void() ClientConnect = { };
void() ClientDisconnect = {};
void() PlayerPreThink = { };
void() PlayerPostThink = {
	if(self.classname == "player")
	{
		if(self.health <= 0)
		{
		G_Player_Spawn();	
		}
	}	
	
	 };
void() PutClientInServer = 
{ 	


	G_Player_Spawn();

};

void() SpectatorConnect = {}