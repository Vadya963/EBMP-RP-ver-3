//рандом
function random(min=0, max=RAND_MAX)
{
    srand(getTickCount() * rand());
    return (rand() % ((max + 1) - min)) + min;
}

function getSpeed(vehicleid)
{
	local velo = getVehicleSpeed(vehicleid);
	return sqrt(pow(velo[0], 2) + pow(velo[1], 2) + pow(velo[2], 2))*2.27*1.61;
}

local speed;
local probeg = 0;

//ники админов
local developer_chislo = 1;//сюда надо написать сколько всего ников
local developer = ["Paolo"];//сюда надо дописывать ники админов через запятую ["nik1", "nik2", "nik3"]; и тд.

//докер
local box_hud = false;
local box = 0;

local randomx = 5000;
local randomy = 5000;

local screen = getScreenSize( );
local hud = true;

local chas = 0;
local chas_min = 0;
local money = "0";

//патруль
local gonka = false;

addEventHandler( "timeserver_client",
function( id1, id2, id3 )
{
	chas = id1;
	chas_min = id2;
	money = id3;
});

addEventHandler( "mileage",
function( id1 )
{
	probeg = id1;
});

addEventHandler( "box",
function( id1 )
{
	box = id1;
});

addEventHandler( "box_hud",
function( id1 )
{
	if(box_hud == false)
	{
		box_hud = true;
	}
	else
	{
		box_hud = false;
	}
});

addEventHandler( "job_taxi",
function( id1, id2 )
{
	randomx = id1;
	randomy = id2;
});

function init()
{
	setRenderNametags(false);
	setRenderHealthbar(false);
}
addEventHandler( "onClientScriptInit", init );

addEventHandler( "onClientFrameRender", 
function( post )
{
	if(isPlayerInVehicle(getLocalPlayer()))
	{
		local vehicleid = getPlayerVehicle(getLocalPlayer());
		speed = getSpeed(vehicleid).tointeger();
	}
		if( post && hud )
		{
			local currentDate = date();
			dxDrawText( "FPS: " +getFPS()+ " | Ping: " +getPlayerPing(getLocalPlayer())+ " | ID: " +getLocalPlayer()+ " | Игроков онлайн: " +(getPlayerCount()+1)+ " | " +getDateTime(), 2.0, 0.0, fromRGB( 255, 255, 130 ), true, "tahoma-bold" );
			
			if(isPlayerInVehicle(getLocalPlayer()))
			{
				local vehicleid = getPlayerVehicle(getLocalPlayer());
				local dimensions = dxGetTextDimensions( "Километраж "+probeg.tointeger()+" | Бензин " +getVehicleFuel(vehicleid).tointeger()+ " | " +speed+ " КМ/Ч", 1.5, "tahoma-bold" );

				dxDrawRectangle( (screen[0]-dimensions[0]-40.0), (screen[1]-55.0), (dimensions[0]+40.0), 55.0, fromRGB( 0, 0, 0, 200 ) );

				dxDrawText( "Километраж "+probeg.tointeger()+" | Бензин " +getVehicleFuel(vehicleid).tointeger()+ " | " +speed+ " КМ/Ч", (screen[0]-dimensions[0]-30.0), (screen[1]-40), fromRGB( 255, 255, 130 ), false, "tahoma-bold", 1.5 );
			}

			local dimensions = dxGetTextDimensions( "Дата: " +currentDate["day"] + "." + currentDate["month"] + "." + (currentDate["year"]-66) + " День в году: " + (currentDate["yearday"]+1)+"/365", 1.0, "tahoma-bold" );
			dxDrawText( "Дата: " +currentDate["day"] + "." + currentDate["month"] + "." + (currentDate["year"]-66) + " День в году: " + (currentDate["yearday"]+1)+"/365", (screen[0] - 20 - dimensions[0]), 0.0, fromRGB( 255, 255, 130 ), true, "tahoma-bold", 1.0 );
			
			if( chas_min >= 0 && chas_min <= 9)
			{
				local dimensions = dxGetTextDimensions( chas+ ":0" +chas_min, 2.0, "tahoma-bold" );
				dxDrawText( chas+ ":0" +chas_min, (screen[0] - 40 - dimensions[0]), 25.0, fromRGB( 255, 255, 130 ), true, "tahoma-bold", 2.0 );
			}
			if(chas_min >= 10 )
			{
				local dimensions = dxGetTextDimensions( chas+ ":" +chas_min, 2.0, "tahoma-bold" );
				dxDrawText( chas+ ":" +chas_min, (screen[0] - 40 - dimensions[0]), 25.0, fromRGB( 255, 255, 130 ), true, "tahoma-bold", 2.0 );
			}

			local dimensions = dxGetTextDimensions( money, 2.0, "tahoma-bold" );
			dxDrawText( money+"$", (screen[0] - 50 - dimensions[0]), 50.0, fromRGB( 0, 200, 0 ), true, "tahoma-bold", 2.0 );
			
			for (local i = 0; i < developer_chislo; i++) 
			{
				if(getPlayerName(getLocalPlayer()) == developer[i])
				{
					local myPos = getPlayerPosition( getLocalPlayer() );
					local rot = getPlayerRotation( getLocalPlayer() );
					dxDrawText( myPos[0].tointeger()+" | "+myPos[1].tointeger()+" | "+myPos[2].tointeger()+" | R "+rot[0].tointeger(), 5.0, screen[1]-50, fromRGB( 255, 255, 255 ), true, "tahoma-bold", 1.0 );
				}
			}
		}

		if(post && box_hud )
		{
			local dimensions = dxGetTextDimensions( "Ящики " +box, 2.0, "tahoma-bold" );
			dxDrawText( "Ящики " +box, (screen[0] - 42 - dimensions[0]), 75.0, fromRGB( 0, 200, 0 ), true, "tahoma-bold", 2.0 );
		}

	}
);

function fe() 
{
	triggerServerEvent( "helpbank" );
	triggerServerEvent( "buycardm" );
	triggerServerEvent( "helpgun" );
	triggerServerEvent( "helprep" );
	triggerServerEvent( "helpfuel" );
	triggerServerEvent( "buyskin" );
	triggerServerEvent( "avtorinok" );
	triggerServerEvent( "hmeria" );
	triggerServerEvent( "cops" );
	triggerServerEvent( "subway_menu" );
	triggerServerEvent( "helphouse" );
	triggerServerEvent( "robbery" );
	triggerServerEvent( "jobdocker" );
	triggerServerEvent( "jobdriver" );
	triggerServerEvent( "taxi_money" );
	triggerServerEvent( "jobmetal" );
	triggerServerEvent( "hobby_fish" );
	triggerServerEvent( "sell_fish" );
	triggerServerEvent( "buydrugs" );
	triggerServerEvent( "helpcasino" );
	triggerServerEvent( "jobbusdriver" );
	triggerServerEvent( "jobbigbreak_kiosk" );
	triggerServerEvent( "egh" );
	triggerServerEvent( "egh_paramedic" );

	triggerServerEvent( "entrance_and_exit" );
}
addEventHandler("onClientScriptInit", function() {
    bindKey( "e", "down", fe );
});

function chatik() 
{
	triggerServerEvent( "chatnumber" );
}
addEventHandler("onClientScriptInit", function() {
    bindKey( "tab", "down", chatik );
});

function hidechat()
{
    if( isChatVisible() )
    {
        showChat( false );
    }
    else
    {
        showChat( true );
    }
}
addEventHandler("onClientScriptInit", function() {
    bindKey( "f1", "down", hidechat );
});

function hud1()//скрыть показать надписи
{
    if( hud == true )
    {
        hud = false;
    }
    else
    {
        hud = true;
    }
}
addEventHandler("onClientScriptInit", function() {
    bindKey( "f9", "down", hud1 );
});

local blipmap = 0;
local dm;
local bank1;
local bank2;
local docker;
local taxi;
local metal;
local meria;
local odejda1;
local odejda2;
local ebpd;
local subway1;
local subway2;
local subway3;
local subway4;
local subway5;
local subway6;
local subway7;
local casino;
local triada;
local fish;
local bus;
local hospital;

function fone1() 
{
	if(isMainMenuShowing())
	{
		return;
	}
	
	if( blipmap == 0 )
    {
		dm = createBlip( -199.473,838.605, 21, 0 );
		bank1 = createBlip( 67.2002,-202.94, 0, 4 );
		bank2 = createBlip( 67.2002,-202.94, 10, 0 );
		meria = createBlip( -115.11,-63.1035, 23, 0 );
		odejda1 = createBlip( -252.324,-79.688, 0, 4 );
		odejda2 = createBlip( -252.324,-79.688, 2, 0 );
		ebpd = createBlip( -378.987,654.699, 24, 0 );

		docker = createBlip( -350.47,-726.813, 0, 3 );
		taxi = createBlip( 763.599,802.275, 0, 3 );
		metal = createBlip( -80.3572,1742.86, 0, 3 );
		bus = createBlip( -422.731,479.451, 0, 3 );
		
		subway1 = createBlip( -554.36,1592.92, 0, 12 );
		subway2 = createBlip( -1119.15,1376.71, 0, 12 );
		subway3 = createBlip( -1535.55,-231.03, 0, 12 );
		subway4 = createBlip( -511.412,20.1703, 0, 12 ); 
		subway5 = createBlip( -113.792,-481.71, 0, 12 );
		subway6 = createBlip( 234.395,380.914, 0, 12 );
		subway7 = createBlip( -293.069,568.25, 0, 12 ); //7
		
		casino = createBlip( -539.082,-91.9283, 0, 9 );
		triada = createBlip( 426.998,78.4652, 26, 0 );
		fish = createBlip( 564.845,-555.782, 0, 11 );
		hospital = createBlip( -393.394,913.983, 0, 5 );

		openMap();
		showChat( true );
		blipmap = 1;
	}
	else
	{
		destroyBlip( dm );
		destroyBlip( bank1 );
		destroyBlip( bank2 );
		destroyBlip( meria );
		destroyBlip( odejda1 );
		destroyBlip( odejda2 );
		destroyBlip( ebpd );

		destroyBlip( docker );
		destroyBlip( taxi );
		destroyBlip( metal );
		destroyBlip( bus );
		
		destroyBlip( subway1 );
		destroyBlip( subway2 );
		destroyBlip( subway3 );
		destroyBlip( subway4 );
		destroyBlip( subway5 );
		destroyBlip( subway6 );
		destroyBlip( subway7 );
		
		destroyBlip( casino );
		destroyBlip( triada );
		destroyBlip( fish );
		destroyBlip( hospital );

		openMap();
		showChat( true );
		blipmap = 0;
	}
}
addEventHandler("onClientScriptInit", function() {
    bindKey( "m", "down", fone1 );
});

function avar() 
{
	triggerServerEvent( "avar" );
}
addEventHandler("onClientScriptInit", function() {
    bindKey( "c", "down", avar );
});

function left() 
{
	triggerServerEvent( "left" );
}
addEventHandler("onClientScriptInit", function() {
    bindKey( "z", "down", left );
});

function right() 
{
	triggerServerEvent( "right" );
}
addEventHandler("onClientScriptInit", function() {
    bindKey( "x", "down", right );
});

//бинды
local tune_id = 0;
function meg() 
{
	for (local i = 0; i < developer_chislo; i++) 
	{
		if(getPlayerName(getLocalPlayer()) == developer[i])
		{
			if( isPlayerInVehicle( getLocalPlayer() ) )
			{
				if(tune_id == 0)
				{
					local vehicleid = getPlayerVehicle( getLocalPlayer() );
					repairVehicle( vehicleid );
					setVehicleTuningTable( vehicleid, 3 );
					tune_id = 1;
				}
				else
				{
					local vehicleid = getPlayerVehicle( getLocalPlayer() );
					repairVehicle( vehicleid );
					setVehicleTuningTable( vehicleid, 0 );
					tune_id = 0;
				}
			}

			setPlayerHealth( getLocalPlayer(), 720.0 );
		}
	}
}
addEventHandler("onClientScriptInit", function() {
    bindKey( "num_0", "down", meg );
});

//измеритель разгона
local spcar = 0.0;
local rTimer;
local timer_speed = 0;
local porog = 100;
function testik()
{
	if(speed > 0 && speed <= porog)
	{
		spcar++;
	}
	if(speed >= porog)
	{
		local vehicleid = getPlayerVehicle( getLocalPlayer() );
		
		sendMessage("====[ Speed Test ]====");
		sendMessage("car model ["+getVehicleModel(vehicleid)+"] tune ["+getVehicleTuningTable(vehicleid)+"] speed "+porog+" km/h = "+spcar/10);
		triggerServerEvent("testcar", getVehicleModel(vehicleid), getVehicleTuningTable(vehicleid), porog, spcar/10);
		
		spcar = 0.0;
		
		rTimer.Kill();
		timer_speed = 0;
		
		sendMessage("timer off");
	}
}

function sp() 
{
	if(timer_speed == 0)
	{
		rTimer = timer( testik, 100, -1 );
		timer_speed = 1;
		
		sendMessage("timer on");
	}
	else
	{
		spcar = 0.0;
		
		rTimer.Kill();
		timer_speed = 0;
		
		sendMessage("timer off");
	}
}
addEventHandler("onClientScriptInit", function() {
    bindKey( "num_1", "down", sp );
});

addEventHandler( "job_gps",
function( id1, id2 )
{
	setGPSTarget(id1.tofloat(),id2.tofloat());
});

addEventHandler( "removegps",
function( playerid )
{
	removeGPSTarget();
});

addEventHandler( "narko",
function( playerid )
{
	setPlayerDrunkLevel( 100 );
});

addEventHandler( "onClientFrameRender", 
function(post)
{
	local myPos = getPlayerPosition( getLocalPlayer() );
	local check1 = isPointInCircle2D( myPos[0], myPos[1], randomx.tofloat(),randomy.tofloat(), 50.0 );//работа таксиста

	if( check1 )
	{
		dxDrawText( "Нажмите Е чтобы пассажир сел(вышел)", 0.0, (screen[1]-40), fromRGB( 255, 255, 255 ), true, "tahoma-bold", 2.0 );
	}
});

// nametags.nut
local vectors = {};
local text;
local dimensions;
local boxWidth = 68.0;
local boxHeight = 10.0;

function framePreRender( )
{
    for( local i = 0; i < MAX_PLAYERS; i++ )
    {
        if( i != getLocalPlayer() && isPlayerConnected(i) )
        {			
            // Get the player position
			local pos = getPlayerPosition( i );
			
        	// Get the screen position from the world
        	vectors[i] <- getScreenFromWorld( pos[0], pos[1], (pos[2] + 2.0) );
        }
    }
}
addEventHandler( "onClientFramePreRender", framePreRender );

function frameRender( post_gui )
{
    if( !post_gui )
	{
		foreach (i, playername in getPlayers())
		{
			if( i != getLocalPlayer() && isPlayerConnected(i) && isPlayerOnScreen(i) )
			{
            	local pos = getPlayerPosition( i );
            	local lclPos = getPlayerPosition( getLocalPlayer() );
            	local fDistance = getDistanceBetweenPoints3D( pos[0], pos[1], pos[2], lclPos[0], lclPos[1], lclPos[2] );
            				
            	if( fDistance <= 10.0 )
				{
                	local fScale = 1.0;
                					
                	text = "Player (" + i.tostring() + ")";
                	dimensions = dxGetTextDimensions( text, fScale, "tahoma-bold" );
                	
					dxDrawText( text, (vectors[i][0] - (dimensions[0] / 2)), vectors[i][1], fromRGB( 255, 255, 130 ), true, "tahoma-bold", fScale );
					
					local healthWidth = (((clamp( 0.0, getPlayerHealth( i ), 720.0 ) * 100.0) / 720.0) / 100 * (boxWidth - 4.0));
                	dxDrawRectangle( ((vectors[i][0] - (boxWidth / 2)) + 2.0), (vectors[i][1] + 18.0), (boxWidth - 4.0), (boxHeight - 4.0), fromRGB( 100, 100, 100, 255 ) );
					
					if( getPlayerHealth( i ) >= 504.0 )
					{
						dxDrawRectangle( ((vectors[i][0] - (boxWidth / 2)) + 2.0), (vectors[i][1] + 18.0), healthWidth, (boxHeight - 4.0), fromRGB( 0, 255, 0, 255 ) );
						return;
					}
					if(getPlayerHealth( i ) > 288.0 && getPlayerHealth( i ) < 504.0 )
					{
						dxDrawRectangle( ((vectors[i][0] - (boxWidth / 2)) + 2.0), (vectors[i][1] + 18.0), healthWidth, (boxHeight - 4.0), fromRGB( 255, 255, 0, 255 ) );
						return;
					}
					if( getPlayerHealth( i ) <= 288.0 )
					{
						dxDrawRectangle( ((vectors[i][0] - (boxWidth / 2)) + 2.0), (vectors[i][1] + 18.0), healthWidth, (boxHeight - 4.0), fromRGB( 255, 0, 0, 255 ) );
						return;
					}
                }
            }
        }
    }
}
addEventHandler( "onClientFrameRender", frameRender )