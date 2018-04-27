function getSpeed(vehicleid)
{
	local velo = getVehicleSpeed(vehicleid);
	return sqrt(pow(velo[0], 2) + pow(velo[1], 2) + pow(velo[2], 2))*2.27*1.61;
}

local screen = getScreenSize( );
local text_width = 600.0;

local stats_window;
local close_window;
local button1;
local button2;

local job_taxi;
local job_bb;

local biznes;
local job;
local exp;
local crimes;
local house;
local drugs;
local fish;
local money;
local bank;
local playername;
local car_slot;

local carmarker = 0;
local spawnx;
local spawny;
local blipcar1;
local blipcar2;

function infocar()
{
	destroyBlip( blipcar1 );
	destroyBlip( blipcar2 );
	sendMessage("Маркер удален.", 255, 255, 0);

	carmarker = 0;
}

addEventHandler( "search_car",
function( id1, id2)
{
	if(carmarker == 0)
	{
		local rTimer = timer( infocar, 10000, 1 );//инфа координат машин

		carmarker = 1;
		spawnx = id1;
		spawny = id2;

		blipcar1 = createBlip( id1, id2, 0, 4 );
		blipcar2 = createBlip( id1, id2, 8, 0 );

		sendMessage("Метка машины создана на карте.", 255, 255, 0);
	}
	else
	{
		sendMessage("[ERROR] Подождите пока не удалится метка.", 255, 0, 0);
	}

});

local housemarker = 0;
local spawnx_house;
local spawny_house;
local blipcar1_house;
local blipcar2_house;

function infohouse()
{
	destroyBlip( blipcar1_house );
	destroyBlip( blipcar2_house );
	sendMessage("Маркер удален.", 255, 255, 0);

	housemarker = 0;
}

addEventHandler( "search_house",
function( id1, id2 )
{
	if(housemarker == 0)
	{
		local rTimer = timer( infohouse, 10000, 1 );//инфа координат машин

		housemarker = 1;
		spawnx_house = id1;
		spawny_house = id2;

		blipcar1_house = createBlip( id1, id2, 0, 4 );
		blipcar2_house = createBlip( id1, id2, 6, 0 );

		sendMessage("Метка дома создана на карте.", 255, 255, 0);
	}
	else
	{
		sendMessage("[ERROR] Подождите пока не удалится метка.", 255, 0, 0);
	}
});

function en() 
{
	if(isPlayerInVehicle(getLocalPlayer()))
	{
		local vehicleid = getPlayerVehicle(getLocalPlayer());

		if(getSpeed(vehicleid).tointeger() == 0)
		{
			triggerServerEvent( "en" );
		}
		else
		{
			sendMessage("[ERROR] Остановите машину.", 255, 0, 0);
		}
	}

	triggerServerEvent( "jobdocker_leave" );
	triggerServerEvent( "jobdriver_leave" );
	triggerServerEvent( "jobmetal_leave" );
	triggerServerEvent( "jobbusdriver_leave" );
	triggerServerEvent( "eat" );
}
addEventHandler("onClientScriptInit", function() {
    bindKey( "q", "down", en );
});

addEventHandler( "stats_client",
function( id1, id2, id4, id5, id6, id7, id8, id9, id10, id11, id12)
{
	biznes = id1;
	job = id2;
	exp = id4;
	crimes = id5;
	house = id6;
	drugs = id7;
	fish = id8;
	money = id9;
	bank = id10;
	playername = id11;
	car_slot = id12;
});

addEventHandler( "onGuiElementClick",
function( element )
{
	if( element == close_window ) 
	{
		callEvent( "close", "" );
		callEvent( "close_cursor", "" );
		return;
	}
	if( element == button1 ) 
	{
		callEvent( "close", "" );
		callEvent( "help_player", "" );
		return;
	}
	if( element == button2 ) 
	{
		callEvent( "close", "" );
		callEvent( "help_cops", "" );
		return;
	}
	if( element == job_taxi ) 
	{
		triggerServerEvent( "jobtaxi" );
		return;
	}
	if( element == job_bb ) 
	{
		triggerServerEvent( "jobbigbreak" );
		return;
	}

});

addEventHandler( "close",
function( playerid )
{
	guiDestroyElement( stats_window );
});

addEventHandler( "close_cursor",
function( playerid )
{
	showCursor( false );
	triggerServerEvent( "stats_close" );
});

addEventHandler( "open",
function( playerid )
{
	local stats_width = 200.0;
	local stats_height = 300.0;

	showCursor( true );

	stats_window = guiCreateElement( 0, "Статиcтиска", (screen[0]/2)-(stats_width/2), (screen[1]/2)-(stats_height/2), stats_width, stats_height );
	guiSetAlpha( stats_window, 1.0 );

	local nik = guiCreateElement( 6, "Гражданин: "+playername, 10.0, 20.0, text_width, 25.0, false, stats_window );

	if(job == "0")
	{
		local job = guiCreateElement( 6, "Работа: Безработный", 10.0, 40.0, text_width, 25.0, false, stats_window );
	}
	else if(job == "1")
	{
		local job = guiCreateElement( 6, "Работа: Докер", 10.0, 40.0, text_width, 25.0, false, stats_window );
	}
	else if(job == "2")
	{
		local job = guiCreateElement( 6, "Работа: Таксист", 10.0, 40.0, text_width, 25.0, false, stats_window );
	}
	else if(job == "3")
	{
		local job = guiCreateElement( 6, "Работа: Сборщик металла", 10.0, 40.0, text_width, 25.0, false, stats_window );
	}
	else if(job == "4")
	{
		local job = guiCreateElement( 6, "Работа: Водитель автобуса", 10.0, 40.0, text_width, 25.0, false, stats_window );
	}
	else if(job == "5")
	{
		local job = guiCreateElement( 6, "Работа: Полицейский  Exp: "+exp, 10.0, 40.0, text_width, 25.0, false, stats_window );
	}
	else if(job == "6")
	{
		local job = guiCreateElement( 6, "Работа: Радиоведущий", 10.0, 40.0, text_width, 25.0, false, stats_window );
	}
	else if(job == "7")
	{
		local job = guiCreateElement( 6, "Работа: Развозчик сигарет", 10.0, 40.0, text_width, 25.0, false, stats_window );
	}
	else if(job == "8")
	{
		local job = guiCreateElement( 6, "Работа: Парамедик  Exp: "+exp, 10.0, 40.0, text_width, 25.0, false, stats_window );
	}
	else if(job == "9")
	{
		local job = guiCreateElement( 6, "Работа: Риэлтор", 10.0, 40.0, text_width, 25.0, false, stats_window );
	}

	local cr_s = guiCreateElement( 6, "Преступлений: "+crimes, 10.0, 60.0, text_width, 25.0, false, stats_window );

	if(biznes == "0")
	{
		local biz = guiCreateElement( 6, "Бизнес: Нету", 10.0, 80.0, text_width, 25.0, false, stats_window );
	}
	else if(biznes == "1")
	{
		local biz = guiCreateElement( 6, "Бизнес: Сеть Заправок", 10.0, 80.0, text_width, 25.0, false, stats_window );
	}
	else if(biznes == "2")
	{
		local biz = guiCreateElement( 6, "Бизнес: Сеть Закусочных", 10.0, 80.0, text_width, 25.0, false, stats_window );
	}
	else if(biznes == "3")
	{
		local biz = guiCreateElement( 6, "Бизнес: Сеть Автомастерских", 10.0, 80.0, text_width, 25.0, false, stats_window );
	}
	else if(biznes == "4")
	{
		local biz = guiCreateElement( 6, "Бизнес: Сеть Магазинов оружия", 10.0, 80.0, text_width, 25.0, false, stats_window );
	}

	if(house == "0")
	{
		local dom = guiCreateElement( 6, "Дом: Бездомный", 10.0, 100.0, text_width, 25.0, false, stats_window );
	}
	else
	{
		local dom = guiCreateElement( 6, "Дом: Есть", 10.0, 100.0, text_width, 25.0, false, stats_window );
	}

	local slot1 = guiCreateElement( 6, "Наркотики: "+drugs+" гр", 10.0, 120.0, text_width, 25.0, false, stats_window );
	local slot2 = guiCreateElement( 6, "Рыба: "+fish+" кг", 10.0, 140.0, text_width, 25.0, false, stats_window );
	local slot3 = guiCreateElement( 6, "Наличные: "+money+"$", 10.0, 160.0, text_width, 25.0, false, stats_window );
	local slot4 = guiCreateElement( 6, "В банке: "+bank+"$", 10.0, 180.0, text_width, 25.0, false, stats_window );
	local slot5 = guiCreateElement( 6, "Кол-во авто: "+car_slot, 10.0, 200.0, text_width, 25.0, false, stats_window );


	close_window = guiCreateElement( 2, "Закрыть", 10.0, 265.0, stats_width-20.0, 25.0, false, stats_window );
});

addEventHandler( "help",
function( playerid )
{
	local help_width = 300.0;
	local help_height = 80.0+(25.0)+10.0;

	showCursor( true );

	stats_window = guiCreateElement( 0, "Помощь (Скобочки не писать!!!)", (screen[0]/2)-(help_width/2), (screen[1]/2)-(help_height/2), help_width, help_height );
	guiSetAlpha( stats_window, 1.0 );

	button1 = guiCreateElement( 2, "Команды игрока", 10.0, 20.0, help_width-20.0, 25.0, false, stats_window );
	button2 = guiCreateElement( 2, "Команды копов", 10.0, 50.0, help_width-20.0, 25.0, false, stats_window );

	close_window = guiCreateElement( 2, "Закрыть", 10.0, 80.0, help_width-20.0, 25.0, false, stats_window );
});

addEventHandler( "help_player",
function( playerid )
{
	local help_width = 600.0;
	local help_height = 520.0+(25.0*2)+10.0;

	showCursor( true );

	stats_window = guiCreateElement( 0, "Помощь (Скобочки не писать!!!)", (screen[0]/2)-(help_width/2), (screen[1]/2)-(help_height/2), help_width, help_height );
	guiSetAlpha( stats_window, 1.0 );

	local help = guiCreateElement( 6, "/курс - посмотреть курс сервера", 10.0, 20.0, text_width, 25.0, false, stats_window );
	local help = guiCreateElement( 6, "/пароль (указать новый пароль) - изменить пароль", 10.0, 40.0, text_width, 25.0, false, stats_window );
	local help = guiCreateElement( 6, "/заплатить (ид игрока) (сумма) - передать деньги игроку", 10.0, 60.0, text_width, 25.0, false, stats_window );
	local help = guiCreateElement( 6, "/статка - статистика игрока", 10.0, 80.0, text_width, 25.0, false, stats_window );
	local help = guiCreateElement( 6, "/документы (ид игрока) - показать документы игроку", 10.0, 100.0, text_width, 25.0, false, stats_window );
	local help = guiCreateElement( 6, "/лицензии (ид игрока) - показать лицензии игроку", 10.0, 120.0, text_width, 25.0, false, stats_window );
	local help = guiCreateElement( 6, "/ключ (ид игрока) (номер машины) - передать ключ от машины игроку", 10.0, 140.0, text_width, 25.0, false, stats_window );
	local help = guiCreateElement( 6, "/владелец (номер машины) - узнать владельца авто (около EBPD)", 10.0, 160.0, text_width, 25.0, false, stats_window );
	local help = guiCreateElement( 6, "/парковка - припарковать своё авто", 10.0, 180.0, text_width, 25.0, false, stats_window );
	local help = guiCreateElement( 6, "/приобрести бизнес - нужно находится около бизнеса", 10.0, 200.0, text_width, 25.0, false, stats_window );
	local help = guiCreateElement( 6, "/продать бизнес (ид игрока) - отдать бизнес игроку", 10.0, 220.0, text_width, 25.0, false, stats_window );
	local help = guiCreateElement( 6, "/цена - установить цену за товар для бизнесов", 10.0, 240.0, text_width, 25.0, false, stats_window );
	local help = guiCreateElement( 6, "/продукты - покупка товаров для бизнесов", 10.0, 260.0, text_width, 25.0, false, stats_window );
	local help = guiCreateElement( 6, "/использовать канистру - заправить машину из канистры", 10.0, 280.0, text_width, 25.0, false, stats_window );
	local help = guiCreateElement( 6, "/очистить - очистить чат", 10.0, 300.0, text_width, 25.0, false, stats_window );
	local help = guiCreateElement( 6, "/тюрьма - узнать сколько сидеть", 10.0, 320.0, text_width, 25.0, false, stats_window );
	local help = guiCreateElement( 6, "/продать дом (ид игрока) - продать дом игроку (для риэлтора)", 10.0, 340.0, text_width, 25.0, false, stats_window );
	local help = guiCreateElement( 6, "/письмо (ид игрока) (текст) - написать определенному игроку", 10.0, 360.0, text_width, 25.0, false, stats_window );
	local help = guiCreateElement( 6, "/эфир (текст) - радио города (для радиоведущих)", 10.0, 380.0, text_width, 25.0, false, stats_window );
	local help = guiCreateElement( 6, "/подсказки - вкл(выкл) подсказки", 10.0, 400.0, text_width, 25.0, false, stats_window );
	local help = guiCreateElement( 6, "/передать дом (ид игрока) - отдать дом игроку", 10.0, 420.0, text_width, 25.0, false, stats_window );
	local help = guiCreateElement( 6, "/сейф - положить(забрать) оружие (около дома)", 10.0, 440.0, text_width, 25.0, false, stats_window );
	local help = guiCreateElement( 6, "/покушать - пополнить хп (около дома)", 10.0, 460.0, text_width, 25.0, false, stats_window );
	local help = guiCreateElement( 6, "/показать дом (ид игрока) - показать дом на карте", 10.0, 480.0, text_width, 25.0, false, stats_window );
	local help = guiCreateElement( 6, "/сдаться - явка с повинной у ПД (сидеть в 2 раза меньше)", 10.0, 500.0, text_width, 25.0, false, stats_window );
	local help = guiCreateElement( 6, "/поиск (номер машины) - найти свою машину", 10.0, 520.0, text_width, 25.0, false, stats_window );

	close_window = guiCreateElement( 2, "Закрыть", 10.0, 520.0+25.0, help_width-20.0, 25.0, false, stats_window );
});

addEventHandler( "help_cops",
function( playerid )
{
	local help_width = 600.0;
	local help_height = 200.0+(25.0*2)+10.0;

	showCursor( true );

	stats_window = guiCreateElement( 0, "Помощь (Скобочки не писать!!!)", (screen[0]/2)-(help_width/2), (screen[1]/2)-(help_height/2), help_width, help_height );
	guiSetAlpha( stats_window, 1.0 );

	local help = guiCreateElement( 6, "/обыскать (ид игрока) - обыскать игрока", 10.0, 20.0, text_width, 25.0, false, stats_window );
	local help = guiCreateElement( 6, "/забрать права (ид игрока) - забрать права", 10.0, 40.0, text_width, 25.0, false, stats_window );
	local help = guiCreateElement( 6, "/забрать лно (ид игрока) - забрать лицензию на оружие", 10.0, 60.0, text_width, 25.0, false, stats_window );
	local help = guiCreateElement( 6, "/оглушить (ид игрока) - ударить дубинкой", 10.0, 80.0, text_width, 25.0, false, stats_window );
	local help = guiCreateElement( 6, "/наручники (ид игрока) - надеть(снять) наручники", 10.0, 100.0, text_width, 25.0, false, stats_window );
	local help = guiCreateElement( 6, "/арест (ид игрока) - посадить в тюрьму", 10.0, 120.0, text_width, 25.0, false, stats_window );
	local help = guiCreateElement( 6, "/штраф (сумма) - выписать штраф машине", 10.0, 140.0, text_width, 25.0, false, stats_window );
	local help = guiCreateElement( 6, "/р (текст) - полицейская волна", 10.0, 160.0, text_width, 25.0, false, stats_window );
	local help = guiCreateElement( 6, "/розыск (ид игрока) - объявить розыск", 10.0, 180.0, text_width, 25.0, false, stats_window );
	local help = guiCreateElement( 6, "/отменить розыск - отменить розыск", 10.0, 200.0, text_width, 25.0, false, stats_window );


	close_window = guiCreateElement( 2, "Закрыть", 10.0, 200.0+25.0, help_width-20.0, 25.0, false, stats_window );
});

addEventHandler( "jobmenu",
function( playerid )
{	
	local stats_width = 200.0;
	local stats_height = 80.0+(25.0)+10.0;

	showCursor( true );

	stats_window = guiCreateElement( 0, "Работы", (screen[0]/2)-(stats_width/2), (screen[1]/2)-(stats_height/2), stats_width, stats_height );
	guiSetAlpha( stats_window, 1.0 );

	job_taxi = guiCreateElement( 2, "Водитель такси", 10.0, 20.0, stats_width-20.0, 25.0, false, stats_window );
	job_bb = guiCreateElement( 2, "Развозчик сигарет", 10.0, 50.0, stats_width-20.0, 25.0, false, stats_window );

	close_window = guiCreateElement( 2, "Закрыть", 10.0, 80.0, stats_width-20.0, 25.0, false, stats_window );
});