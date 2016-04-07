// Screen/World related vectors
vector screen_size;
vector screen_center;
vector view_origin;
vector view_angles;
vector autocvar_v_vres;
float autocvar_v_vresm;
float view_framerate;
float autocvar_cg_showtime = 0;
float autocvar_cg_drawfps = 1;
float autocvar_cg_drawinfo = 0;
void(float value) G_Fade;
float G_Fade_Value;
float G_Fade_Target;
void() G_Draw_Pointer;
float autocvar_cg_outlines;
float autocvar_cg_outlines_fatness;
float autocvar_cg_outlines_scale;
float autocvar_cg_player_deaths = 0;
float autocvar_cg_draw_plumes = 1;
float autocvar_cg_draw_laser_impact = 0;
vector autocvar_cg_draw_laser_colour;
float autocvar_cg_draw_laser_colour_red;
float autocvar_cg_draw_laser_colour_green;
float autocvar_cg_draw_laser_colour_blue;
float autocvar_cg_predict_hitbeep = 1;
float autocvar_cg_predict_rockets = 1;
float G_Weapon_Switch_Time;
float G_Weapon_Buffer;

// Local Client information (floats,strings)
string CLIENT_STATE;
float GAME_STATE;

// Game Specifics - Titles,names etc.
const string GAME_TITLE = "BoxWars";
const string GAME_UNDERTITLE = "The Boxening";

// Input
vector INPUT_MOUSE;
float mouseisheld,mouseretrigger;
float delta_time;
/*
vector VEC_HULL_MIN;
vector VEC_HULL_MAX;
*/
// Menu Stuff
float MENU_Active;
void() G_MenuToggle;
void() G_Menu;
void() G_MenuDraw;
void() G_MenuSelect;
void() G_Menu_Options;
void(float value,optional float toggle) G_Menu_Navigate;
.float animobject;

// Game Stuff
void() G_Start_Game;
void() G_Player_Think;
entity PLAYER_ARM;
entity PLAYER_GUN;
vector PLAYER_GUN_HAND_BONE;
.entity outline;
vector autocvar_cg_gun_pos;
float() PRE_VIEWWEAPON;
void() G_Outline_Spawn;
void(entity target,float weapon) G_Attack_Damage;
void(entity target,float damage,vector pos) G_Attack_Plume
void() G_Attack_Plume_Draw;
.float attack_time;
.float dead;
entity rocket;
void() 	G_Fire_Rocket;
.float attack_finished;
float(float isnew) G_Player_Delta;
float() G_Player_Predraw;
void() G_Player_Attack;
void(float weapon) G_Player_Weapon_Change;

// Menu Anim
float MENU_Anim_Hover;
float MENU_Anim_Time;
float MENU_Anim_Toggle;
float() MENU_Animate;

string MENU_Items[10];
float MENU_Selection;

// Menu Selections
const string MENU_NEWGAME = "^1NEW";
const string MENU_SAVEGAME = "^2SAVE";
const string MENU_LOADGAME = "^3LOAD";
const string MENU_OPTIONS = "^5OPTIONS";
const string MENU_QUIT = "^4QUIT";

// Menu specific - OPTION SCREEN
const float STAGE_OPTIONS_SCALE = 0;
const float STAGE_OPTIONS_SENS = 1;
const float STAGE_OPTIONS_RAGDOLL = 2;
const float STAGE_OPTIONS_PLUMES = 3;
const float STAGE_OPTIONS_IMPACT = 4;
const float STAGE_OPTIONS_LASER1 = 5;
const float STAGE_OPTIONS_LASER2 = 6;
const float STAGE_OPTIONS_LASER3 = 7;

const float STAGE_OPTIONS_MAX = 8; // The Max Amount of Menu Items in OPTIONS.
float STAGE_OPTIONS_ITEM;


// Menu and Level stages
float MENU_STAGE;
const float STAGE_MAIN = 0;
const float STAGE_NONE = 0;
const float STAGE_NEW = 1;
const float STAGE_SAVE = 2;
const float STAGE_LOAD = 3;
const float STAGE_OPTIONS = 4;

const float STAGE_LEVEL = 1;

.float traileffectnum;

// overall stuff
//entity test;
float spawn_time;

// Get Player Stats
float player_ping;
float player_pl;
float player_health;
const float EV_STRING = 1;
const float EV_FLOAT = 2;
const float EV_VECTOR = 3;
const float EV_ENTITY = 4;
const float EV_FIELD = 5;
const float EV_FUNCTION = 6;
const float EV_POINTER = 7;
const float EV_INTEGER = 8;
const float EV_VARIANT = 9;
const float STAT_HEALTH = 0;
const float STAT_WEAPONMODELI = 2;	
const float STAT_AMMO = 3;
const float STAT_ARMOR = 4;
const float STAT_WEAPONFRAME = 5;
const float STAT_SHELLS = 6;
const float STAT_NAILS = 7;
const float STAT_ROCKETS = 8;
const float STAT_CELLS = 9;
const float STAT_ACTIVEWEAPON = 10;
const float STAT_TOTALSECRETS = 11;
const float STAT_TOTALMONSTERS = 12;
const float STAT_FOUNDSECRETS = 13;
const float STAT_KILLEDMONSTERS = 14;
const float STAT_ITEMS = 15;	


// animation shite
.float anim_time;

//game entitys
//entity player; // this is our player entity,   server side qc uses self when dealing with clients, csqc doesnt use one.
void() G_Dummy_Spawn;
entity dummy;
entity plume;

// weapon stuff
float G_Uzi_Beam_Time;
float G_Current_Weapon;
float autocvar_gunny;

//game functions
void() G_Player_Physics; // this is our custom physics function..


//ingame hud
void() G_Draw_Crosshair;
float autocvar_cg_crosshair_size;
.float health;

// weapons
const float G_Weapon_Pistol = 1;
const float G_Weapon_Uzi = 1;
const float G_Weapon_Launcher = 2;

void() SUB_Remove = 
{
	remove(self);
};