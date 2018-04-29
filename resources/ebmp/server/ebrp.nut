//рандом
function random(min=0, max=RAND_MAX)
{
    srand(getTickCount() * rand());
    return (rand() % ((max + 1) - min)) + min;
}

function getSpeed(vehicleid)
{
	local velo = getVehicleSpeed(vehicleid);
	return sqrt(pow(velo[0], 2) + pow(velo[1], 2) + pow(velo[2], 2))*2.27*1.61;//1.61 - это перевод в км/ч из миль/ч
}

dofile("resources/ebmp/server/easyini.nut");

local script = "ebrp";
local database = sqlite( "ebmp-rp.db" );//база данных игроков
local upd = "UPDATE: 24.04.2018";
local pogoda = true;//включенно лето, false - зима
local novosti = 0;//в разработке
local me_radius = 10.0;//радиус отображения действий игрока в чате

//цвета сообщений
local color_tips = toRGBA(0xa8e4a0);//бабушкины яблоки
local yellow = toRGBA(0xffff00);//желтый
local red = toRGBA(0xff0000);//красный
local blue = toRGBA(0x0096ff);//синий
local white = toRGBA(0xffffff);//белый
local green = toRGBA(0x00ff00);//зеленый
local turquoise = toRGBA(0x00ffff);//бирюзовый
local orange = toRGBA(0xff6400);//оранжевый
local pink = toRGBA(0xff64ff);//розовый
local lyme = toRGBA(0x82ff00);//лайм админский цвет

//запрещенные ники
local no_niki_chislo = 4;
local no_niki = ["Player", "0", "null", "player"];

//ники админов
local developer_chislo = 1;//сюда надо написать сколько всего ников
local developer = ["Paolo"];//сюда надо дописывать ники админов через запятую ["nik1", "nik2", "nik3"]; и тд.

//зарплаты
local payday_busdriver = 3000;
local payday_bigbreak_driver = 200;
local payday_docker = 100;

//коэффициент деления payday, так как не каждый час, а каждые 15 мин
local ratiopd = 4;

//заправки
local fuel_price = 0;
local fuel_tanker = 0;
local fuel_ownername = "0";
local fuel_money = 0;
local fuel_nalog = 4000/ratiopd;
local fuel_buybiznes = 200000;

//закусочные + бары
local eda_price = 0;
local eda_tanker = 0;
local eda_ownername = "0";
local eda_money = 0;
local eda_nalog = 4000/ratiopd;
local eda_buybiznes = 200000;

//автомастерские
local repair_price = 0;
local repair_tanker = 0;
local repair_ownername = "0";
local repair_money = 0;
local repair_nalog = 4000/ratiopd;
local repair_buybiznes = 200000;

//оружейки
local gun_price = 0;
local gun_tanker = 0;
local gun_ownername = "0";
local gun_money = 0;
local gun_nalog = 4000/ratiopd;
local gun_buybiznes = 200000;

//курс
local course_fuel = 0;
local course_eda = 0;
local course_repair = 0;
local course_gun = 0;
local course_fish = 0;

//пресс
local metal_nob = 0;

//цены автосалона 27 авто можно купить
local motor_show = [//[ид,цена,вместимость бака]
[0,125000,60],
[1,65000,90],
[2,0,0],
[3,0,200],
[4,0,200],
[5,0,200],
[6,98000,70],
[7,195000,70],
[8,195000,70],
[9,35000,70],
[10,97000,70],
[11,0,58],
[12,67000,58],
[13,200000,90],
[14,40000,70],
[15,90000,90],
[16,0,0],
[17,0,0],
[18,110000,90],
[19,0,80],
[20,0,150],
[21,0,150],
[22,30000,70],
[23,32000,60],
[24,0,60],
[25,16000,65],
[26,0,0],
[27,0,100],
[28,40000,80],
[29,92000,70],
[30,0,65],
[31,22000,65],
[32,0,65],
[33,0,65],
[34,0,100],
[35,0,100],
[36,0,100],
[37,0,100],
[38,0,100],
[39,0,100],
[40,0,80],
[41,42000,80],
[42,0,80],
[43,5000,50],
[44,32000,65],
[45,137000,70],
[46,0,80],
[47,14000,65],
[48,12000,50],
[49,0,0],
[50,22000,70],
[51,0,70],
[52,73000,80],
[53,9000,40]
];

//будки
local player_id_cops = "0";//ник игрока, который находится в розыске
local coord_len_bydka = 16;
local coord_bydka = [
[-310.857,1694.88,-22.3773],
[-1170.57,1578.15,5.84156],
[-1654.61,1143.06,-7.10691],
[-1562.38,527.787,-20.1476],
[-1421.31,-191.48,-20.3052],
[-147.053,-595.967,-20.1636],
[283.082,-388.371,-20.1361],
[747.74,7.80397,-19.4607],
[-208.633,-45.6014,-12.0168],
[-584.811,89.4905,-0.21516],
[250.26,494.087,-20.046],
[612.189,845.402,-12.6476],
[112.488,847.435,-19.9109],
[139.371,1226.68,62.8897],
[-508.688,910.919,-19.055],
[-78.6843,233.494,-14.4042]
];

//цены домов
local house1_price = 100000;//hillwood
local house2_price = 10000;//hunters point
local house3_price = 40000;//oyster bay

//цены в мерии
local prava_price = 1000;
local weapon_price = 50000;
local biznes_price = 50000;
local tax = 100/ratiopd;//налог города
local tax_house = 1000/ratiopd;//жкх дома

//цена одежды
local odejda_price = 15000;

//цена метро
local subway_price = 10;

//нельзя купить
local no_skin_chislo = 34;
local no_skin = [0,3,11,14,15,16,21,23,25,26,29,30,31,33,34,36,75,76,82,128,136,155,156,157,158,159,160,161,165,166,167,168,169,170];

//киоски
local kiosk_chislo = 42;
local kiosk = [
[-632.282,955.495,-17.7324],//место погрузки сигарет
[400.47,745.517,-24.6665],
[164.257,657.558,-21.9641],
[33.6884,599.201,-19.9273],
[-121.101,622.605,-19.9023],
[-378.021,636.731,-10.5905],
[-502.091,802.291,-19.4324],
[-615.216,928.722,-18.7638],
[-728.608,864.547,-18.7325],
[-656.65,509.887,1.21776],
[-489.445,465.414,1.16478],
[-374.126,443.63,-1.07852],
[-187.223,423.631,-6.13807],
[29.9201,199.388,-15.8087],
[436.778,458.533,-23.4465],
[398.633,205.796,-20.678],
[-684.184,303.915,0.354372],
[-720.026,18.0805,1.02313],
[-504.309,8.96903,-0.348028],
[-378.354,-194.282,-10.1133],
[-238.823,-34.79,-11.4141],
[-65.7549,-309.509,-14.2386],
[306.183,-304.782,-20.0005],
[503.665,-295.996,-20.0115],
[282.229,4.70126,-22.9423],
[368.481,-301.162,-20.0041],
[564.192,-555.782,-22.5388],
[31.9624,-476.895,-19.22],
[-125.724,-526.665,-16.7269],
[-1564.69,-188.636,-20.1714],
[-1343.32,410.58,-23.564],
[-1601.5,970.578,-5.08525],
[-1425.34,975.599,-13.4643],
[-1194.98,1184.57,-13.4075],
[-1276.81,1337.04,-13.4034],
[-1115.83,1363.51,-13.371],
[-377.342,1585.2,-23.4306],
[-783.837,1517.4,-5.96645],
[-1576.02,1612.83,-5.91438],
[-1181.8,1589.17,5.90497],
[-1046.98,1446.22,-4.30739],
[229.585,703.815,-23.6116]
];

//места для парамедиков
local coord_paramedic_chislo = 40;
local coord_paramedic = [
[-384.272,-699.759,-21.7457],
[-599.382,-231.097,-4.48657],
[-331.772,185.195,-4.70247],
[-426.461,456.942,0.33153],
[-381.589,634.633,-10.5086],
[-285.195,862.815,-20.2061],
[380.308,897.225,-21.3149],
[588.524,813.404,-12.662],
[789.189,654.62,-12.0832],
[1275.02,1299.84,0.382549],
[-365.791,490.019,1.25577],
[-561.823,522.026,1.24924],
[-482.156,691.194,1.37447],
[-509.306,-11.1211,-0.239947],
[-599.34,89.5566,0.221444],
[-620.107,6.50564,1.11097],
[75.6369,-400.784,-19.8009],
[24.902,-429.961,-19.9375],
[83.6723,-513.269,-19.9458],
[32.3907,-691.08,-21.5265],
[164.266,-768.65,-21.546],
[136.311,-695.843,-21.525],
[-236.894,-768.073,-21.5981],
[-230.422,-544.231,-20.087],
[129.509,-447.703,-20.0917],
[398.212,-409.48,-20.0806],
[787.955,-147.139,-18.8826],
[602.867,-15.2144,-18.2204],
[265.477,39.5867,-23.1259],
[183.199,465.395,-19.9129],
[-1385.86,-285.641,-19.9089],
[-1698.15,-275.929,-20.1368],
[-1551.1,57.2085,-13.7276],
[-1504.34,513.324,-20.0701],
[-1262.55,574.842,-23.513],
[-1574,948.765,-4.98926],
[-1616.93,1092.38,-7.67462],
[-1163.86,1356.19,-13.353],
[-1069.93,1669.33,10.8248],
[-693.22,1881.85,-14.726]
];

local weather_server_true = [
[0,"DT_RTRclear_day_night"],
[1,"DT_RTRclear_day_night"],
[2,"DT14part11"],
[3,"DT_RTRfoggy_day_night"],
[4,"DT_RTRclear_day_early_morn1"],
[5,"DT_RTRrainy_day_early_morn"],
[6,"DT_RTRclear_day_early_morn2"],
[7,"DT_RTRrainy_day_morning"],
[8,"DT_RTRfoggy_day_morning"],
[9,"DT_RTRclear_day_morning"],
[10,"DT06part03"],
[11,"DT07part01fromprison"],
[12,"DT07part02dereksubquest"],
[13,"DT_RTRclear_day_afternoon"],
[14,"DT09part4MalteseFalcone2"],
[15,"DT08part02cigarettesmill"],
[16,"DT13part02"],
[17,"DT_RTRrainy_day_late_afternoon"],
[18,"DT08part03crazyhorse"],
[19,"DT_RTRfoggy_day_evening"],
[20,"DT_RTRclear_day_evening"],
[21,"DT11part04"],
[22,"DT08part04subquestwarning"],
[23,"DT_RTRclear_day_late_even"]
];

local weather_server_false = [
[0,"DT04part02"],
[1,"DT04part02"],
[2,"DT04part02"],
[3,"DT04part02"],
[4,"DT04part02"],
[5,"DT04part02"],
[6,"DT04part02"],
[7,"DT04part02"],
[8,"DT04part02"],
[9,"DT05part01JoesFlat"],
[10,"DT03part01JoesFlat"],
[11,"DTFreeRideDaySnow"],
[12,"DT05part02FreddysBar"],
[13,"DT05part04Distillery"],//туман
[14,"DT04part01JoesFlat"],//туман
[15,"DT02part01Railwaystation"],
[16,"DT02part02JoesFlat"],
[17,"DT02part04Giuseppe"],
[18,"DT05Distillery_inside"],
[19,"DT02part03Charlie"],//туман
[20,"DT05Distillery_inside"],//туман
[21,"DT02part05Derek"],
[22,"DT02NewStart1"],
[23,"DT03part04PriceOffice"]
];

//время сервера
local chas = 0;
local min = 0;

//переменные игрока(сох-ся)
local money = array(getMaxPlayers(), 0);
local bank = array(getMaxPlayers(), 0);
local driverlic = array(getMaxPlayers(), 0);
local car_slot = array(getMaxPlayers(), 0);
local biznes = array(getMaxPlayers(), 0);
local gun = array(getMaxPlayers(), 0);
local job = array(getMaxPlayers(), 0);
local skin = array(getMaxPlayers(), 0);
local job_p = array(getMaxPlayers(), 0);
local job_p1 = array(getMaxPlayers(), 0);
local exp = array(getMaxPlayers(), 0);
local can = array(getMaxPlayers(), 0);
local weaponlic = array(getMaxPlayers(), 0);
local bizneslic = array(getMaxPlayers(), 0);
local aresttimer = array(getMaxPlayers(), -1);
local crimes = array(getMaxPlayers(), 0);
local arest = array(getMaxPlayers(), 0);
local tips = array(getMaxPlayers(), 0);
local car_rental_fuel = array(getMaxPlayers(), 0);
local drugs = array(getMaxPlayers(), 0);
local fish = array(getMaxPlayers(), 0);
local house = array(getMaxPlayers(), 0);
local house_x = array(getMaxPlayers(), 0);
local house_y = array(getMaxPlayers(), 0);
local house_z = array(getMaxPlayers(), 0);
local house_gun = array(getMaxPlayers(), 0);

//не сохраняются
local logged = array(getMaxPlayers(), 0);
local dviglo = array(getMaxPlayers(), 0);
local sead = array(getMaxPlayers(), 0);
local stats_pass = array(getMaxPlayers(), 0);
local car_id = array(getMaxPlayers(), -1);
local gun_hand = array(getMaxPlayers(), 0);
local taizer = array(getMaxPlayers(), 0);
local probeg = array(getMaxPlayers(), 0);
local fish_array = array(getMaxPlayers(), 0);
local chat = array(getMaxPlayers(), 0);

//тест для копов
local test = array(getMaxPlayers(), 0);
local otvet = array(getMaxPlayers(), 0);
local ver_otvet = array(getMaxPlayers(), 0);

//рандомная позиция для таксиста
local randomx = array(getMaxPlayers(), 0);
local randomy = array(getMaxPlayers(), 0);

//ид рабочей машины
local car_rental = array(getMaxPlayers(), -1);

function timeserver()
{
	local date = split(getDateTime(), ": ");//установка времени
    chas = date[3].tointeger();
    min = date[4].tointeger();

	foreach(i, playername in getPlayers()) 
	{
		triggerClientEvent( i, "timeserver_client", chas.tointeger(), min.tointeger(), money[i].tostring());//время+деньги
		triggerClientEvent( i, "biznes_fuel", fuel_price.tostring(), fuel_tanker.tostring(), fuel_ownername.tostring(), fuel_money.tostring() );//заправки
		triggerClientEvent( i, "biznes_eda", eda_price.tostring(), eda_tanker.tostring(), eda_ownername.tostring(), eda_money.tostring() );//еда
		triggerClientEvent( i, "biznes_repair", repair_price.tostring(), repair_tanker.tostring(), repair_ownername.tostring(), repair_money.tostring() );//чинилки
		triggerClientEvent( i, "biznes_gun", gun_price.tostring(), gun_tanker.tostring(), gun_ownername.tostring(), gun_money.tostring() );//оружейки
	}
}

function mill()
{
	foreach(i, playername in getPlayers()) 
	{
		if(isPlayerInVehicle(i) && dviglo[i] == 1)
		{
			local vehicleid = getPlayerVehicle(i);
			local speed = getSpeed(vehicleid).tofloat();
			local number = getVehiclePlateText(vehicleid);

			if(speed > 1)
			{
				probeg[i] = probeg[i] + (speed/3600);
			}

			triggerClientEvent( i, "mileage", probeg[i].tofloat());
		}
	}
}

addEventHandler("car_rental_spawn",
function(playerid, model, id1, id2, id3, rot, color0, color1, color2, color3, color4, color5, fuel)
{
	local car_job = createVehicle( model, id1, id2, id3, rot, 0.0, 0.0 );
	setVehiclePlateText(car_job, "id-"+playerid);
	setVehicleColour(car_job, color0, color1, color2, color3, color4, color5);
	setVehicleFuel(car_job, fuel.tofloat());
	car_rental[playerid] = car_job;

	log("");
	log("[spawn_car_rental] "+getPlayerName(playerid)+" ["+playerid+"]"+" model ["+model+"]");
	log("");
});

addEventHandler("car_spawn",//спавн тачек авторынка
function(number)
{
	local vehicleid;
	local result = database.query( "SELECT * FROM carnumber_bd WHERE carnumber = '"+number+"'" );

	local myPos1 = result[1]["spawnx"];
	local myPos2 = result[1]["spawny"];
	local myPos3 = result[1]["spawnz"];
	local myrot = result[1]["rot"];
	vehicleid = createVehicle( result[1]["carmodel"], myPos1, myPos2, myPos3, myrot, 0.0, 0.0 );
	local color0 = toRGBA(result[1]["color0"]);
	local color1 = toRGBA(result[1]["color1"]);

	setVehicleColour(vehicleid, color0[0], color0[1], color0[2], color1[0], color1[1], color1[2]);
	setVehiclePlateText(vehicleid, result[1]["carnumber"]);
	setVehicleFuel(vehicleid, result[1]["fuel"]);
	setVehicleTuningTable(vehicleid, result[1]["tune"]);
	setVehicleDirtLevel(vehicleid, result[1]["dirtlvl"]);
	setVehicleWheelTexture( vehicleid, 0, result[1]["wheel0"]);
	setVehicleWheelTexture( vehicleid, 1, result[1]["wheel1"]);

	log("");
	log("[car_spawn] "+number);
	log("");
});

function timesever_pogoda()
{
	if(pogoda == true)
	{
		setWeather( weather_server_true[chas][1] );
	}
	else
	{
		setWeather( weather_server_false[chas][1] );
	}
		course_fuel = random(1,10);//курс
		course_eda = random(1,10);
		course_repair = random(1,10);
		course_gun = random(1,10);
		course_fish = random(1,10);
		log("");
		log("====[course]====");
		log("course_fuel = " +course_fuel);
		log("course_eda = " +course_eda);
		log("course_repair = " +course_repair);
		log("course_gun = " +course_gun);
		log("course_fish = " +course_fish);
		log("");

		foreach (i, playername in getPlayers())
		{
			if(logged[i] == 1)
			{

			sendPlayerMessage(i, "====[PAYDAY]====", white[0], white[1], white[2] );

			local formyla = ((bank[i]*0.05)/ratiopd).tointeger();
			bank[i] += formyla;

			sendPlayerMessage(i, "Банковский депозит: "+formyla+"$", white[0], white[1], white[2]);

			if(bank[i] >= tax)
			{
				bank[i] -= tax;

				sendPlayerMessage(i, "Налог города: -"+tax+"$", white[0], white[1], white[2] );
			}
			else
			{
				crimes[i] += 1;

				sendPlayerMessage(i, "Количество преступлений повысилось, неуплата городского налога :-(", blue[0], blue[1], blue[2] );
			}


			if(house[i] > 0)
			{
				if(bank[i] >= tax_house)
				{
					bank[i] -= tax_house;

					sendPlayerMessage(i, "ЖКХ дома: -"+tax_house+"$", white[0], white[1], white[2] );
				}
				else
				{
					crimes[i] += 1;

					sendPlayerMessage(i, "Количество преступлений повысилось, неуплата ЖКХ :-(", blue[0], blue[1], blue[2] );
				}
			}

			if(biznes[i] == 1)
			{
				if(bank[i] >= fuel_nalog)
				{
					bank[i] -= fuel_nalog;

					sendPlayerMessage(i, "Налог бизнеса: -"+fuel_nalog+"$", white[0], white[1], white[2] );
				}
				else
				{
					biznes[i] = 0;
					bank[i] += fuel_buybiznes*0.5;

					fuel_ownername = "0";

					sendPlayerMessage(i, "Бизнес продан за "+fuel_buybiznes*0.5+"$, надо было платить налоги :-(", green[0], green[1], green[2] );
				}
			}

			if(biznes[i] == 2)
			{
				if(bank[i] >= eda_nalog)
				{
					bank[i] -= eda_nalog;

					sendPlayerMessage(i, "Налог бизнеса: -"+eda_nalog+"$", white[0], white[1], white[2] );
				}
				else
				{
					biznes[i] = 0;
					bank[i] += eda_buybiznes*0.5;

					eda_ownername = "0";

					sendPlayerMessage(i, "Бизнес продан за "+eda_buybiznes*0.5+"$, надо было платить налоги :-(", green[0], green[1], green[2] );
				}
			}

			if(biznes[i] == 3)
			{
				if(bank[i] >= repair_nalog)
				{
					bank[i] -= repair_nalog;

					sendPlayerMessage(i, "Налог бизнеса: -"+repair_nalog+"$", white[0], white[1], white[2] );
				}
				else
				{
					biznes[i] = 0;
					bank[i] += repair_buybiznes*0.5;

					repair_ownername = "0";

					sendPlayerMessage(i, "Бизнес продан за "+repair_buybiznes*0.5+"$, надо было платить налоги :-(", green[0], green[1], green[2] );
				}
			}

			if(biznes[i] == 4)
			{
				if(bank[i] >= gun_nalog)
				{
					bank[i] -= gun_nalog;

					sendPlayerMessage(i, "Налог бизнеса: -"+gun_nalog+"$", white[0], white[1], white[2] );
				}
				else
				{
					biznes[i] = 0;
					bank[i] += gun_buybiznes*0.5;

					gun_ownername = "0";

					sendPlayerMessage(i, "Бизнес продан за "+gun_buybiznes*0.5+"$, надо было платить налоги :-(", green[0], green[1], green[2] );
				}
			}

			if(job[i] == 5)
			{
				local random_zp = 2000;
				bank[i] += exp[i]*random_zp;

				sendPlayerMessage(i, "Зарплата полицейского: "+exp[i]*random_zp+"$", white[0], white[1], white[2] );

				exp[i] = 0;

				if(crimes[i] >= 10)
				{
					job[i] = 0;

					removePlayerWeapon(i, gun[i], 0);

					gun[i] = 0;

					sendPlayerMessage(i, "Вас уволили за большое количество преступлений :-(", blue[0], blue[1], blue[2]);

					if(car_rental[i] != -1)
					{
						foreach(id, playername in getPlayers())
						{
							local carid = getPlayerVehicle(id);
							if(isPlayerInVehicle(id) && carid == car_rental[i])
							{
								removePlayerFromVehicle(id);
							}
						}
					}

					local rTimer = timer( delet_car_job, 1000, 1, i );
				}
			}

			if(job[i] == 8)
			{
				local random_zp = 500;
				bank[i] += exp[i]*random_zp;

				sendPlayerMessage(i, "Зарплата парамедика: "+exp[i]*random_zp+"$", white[0], white[1], white[2] );

				exp[i] = 0;
				test[i] = 0;
				otvet[i] = 0;

				if(crimes[i] >= 10)
				{
					job[i] = 0;

					triggerClientEvent(i, "removegps", "");
					triggerClientEvent(i, "delped", "");

					sendPlayerMessage(i, "Вас уволили за большое количество преступлений :-(", blue[0], blue[1], blue[2]);

					if(car_rental[i] != -1)
					{
						foreach(id, playername in getPlayers())
						{
							local carid = getPlayerVehicle(id);
							if(isPlayerInVehicle(id) && carid == car_rental[i])
							{
								removePlayerFromVehicle(id);
							}
						}
					}

					local rTimer = timer( delet_car_job, 1000, 1, i );
				}
			}

			sendPlayerMessage(i, "Состояние счета: "+bank[i]+"$", white[0], white[1], white[2]);

			}
		
		}
}

function EngineState()
{
	foreach(i, playername in getPlayers()) 
	{
		
	local vehicleid = getPlayerVehicle(i);
	local plate = getVehiclePlateText(vehicleid);
		
	if( isPlayerInVehicle( i ) )
	{
		if(sead[i] == 0)
		{
			if(dviglo[i] == 1)
			{
				if(getVehicleFuel(vehicleid) < 1)
				{
					setVehicleFuel(vehicleid, 0.0);
				}
				else
				{
					setVehicleFuel(vehicleid, getVehicleFuel(vehicleid));
				}

				if(car_rental[i] != -1 && vehicleid == car_rental[i])
				{
					car_rental_fuel[i] = getVehicleFuel(vehicleid);
				}
				
				local result = database.query( "SELECT COUNT() FROM carnumber_bd WHERE carnumber = '"+plate+"'" );
			    if(result[1]["COUNT()"] == 1)
				{
					result = database.query( "SELECT * FROM carnumber_bd WHERE carnumber = '"+plate+"'" );

					setVehicleWheelTexture(vehicleid, 0, result[1]["wheel0"]);
					setVehicleWheelTexture(vehicleid, 1, result[1]["wheel1"]);
				}
			}
			else
			{
				setVehicleEngineState(vehicleid, false);
				setVehicleSpeed( vehicleid, 0.0,0.0,0.0 );
			}
		}
	}

	}
}

function stats()
{
	database.query( "UPDATE biznes_bd SET price = '"+fuel_price+"', tanker = '"+fuel_tanker+"', money = '"+fuel_money+"', ownername = '"+fuel_ownername+"' WHERE name = 'Filling_Stations'");
	database.query( "UPDATE biznes_bd SET price = '"+eda_price+"', tanker = '"+eda_tanker+"', money = '"+eda_money+"', ownername = '"+eda_ownername+"' WHERE name = 'Eda_Bar'");
	database.query( "UPDATE biznes_bd SET price = '"+repair_price+"', tanker = '"+repair_tanker+"', money = '"+repair_money+"', ownername = '"+repair_ownername+"' WHERE name = 'Repair'");
	database.query( "UPDATE biznes_bd SET price = '"+gun_price+"', tanker = '"+gun_tanker+"', money = '"+gun_money+"', ownername = '"+gun_ownername+"' WHERE name = 'Gun'");
}

addCommandHandler("парковка", 
function(playerid) 
{
	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

			if( isPlayerInVehicle( playerid ) && dviglo[playerid] == 1 )
			{
				local vehicleid = getPlayerVehicle(playerid);
				local plate = getVehiclePlateText(vehicleid);

				if(getSpeed(vehicleid).tointeger() != 0)
				{
					sendPlayerMessage(playerid, "[ERROR] Остановите машину.", red[0], red[1], red[2] );
					return;
				}

				local result = database.query( "SELECT COUNT() FROM carnumber_bd WHERE carnumber = '"+plate+"'" );
			    if(result[1]["COUNT()"] == 1)
			    {
					local carpos = getVehiclePosition(vehicleid);
					local carrot = getVehicleRotation(vehicleid);
					local color = getVehicleColour(vehicleid);

					database.query( "UPDATE carnumber_bd SET fuel = '"+getVehicleFuel(vehicleid)+"', spawnx = '"+carpos[0]+"', spawny = '"+carpos[1]+"', spawnz = '"+carpos[2]+"', rot = '"+carrot[0]+"', dirtlvl = '"+getVehicleDirtLevel(vehicleid)+"', probeg = '"+probeg[playerid]+"', tune = '"+getVehicleTuningTable(vehicleid)+"', color0 = '"+fromRGB(color[0], color[1], color[2])+"', color1 = '"+fromRGB(color[3], color[4], color[5])+"' WHERE carnumber = '"+plate+"'");

					result = database.query( "SELECT * FROM carnumber_bd WHERE carnumber = '"+plate+"'" );

					setVehicleWheelTexture(vehicleid, 0, result[1]["wheel0"]);
					setVehicleWheelTexture(vehicleid, 1, result[1]["wheel1"]);

					sendPlayerMessage(playerid, "Вы припарковали своё авто.", yellow[0], yellow[1], yellow[2]);
				}
			}
			else
			{
				sendPlayerMessage(playerid, "[ERROR] Вы не завели двигатель или вы не в машине.", red[0], red[1], red[2]);
			}
});

local random_tips = 0;
function tips_player()
{
	foreach(i, playername in getPlayers()) 
	{
		if(tips[i] == 0)
		{
			if(random_tips == 0)
			{
				sendPlayerMessage(i, "[ПОДСКАЗКА] ЖДИТЕ AUTOSAVE ИНАЧЕ ВАШИ ДАННЫЕ НЕ СОХРАНЯТЬСЯ!!!", color_tips[0], color_tips[1], color_tips[2]);
			}

			if(random_tips == 1)
			{
				sendPlayerMessage(i, "[ПОДСКАЗКА] Переключение чатов осуществляется нажатием TAB", color_tips[0], color_tips[1], color_tips[2]);
			}

			if(random_tips == 2)
			{
				sendPlayerMessage(i, "[ПОДСКАЗКА] Чтобы скрыть текст нажмите F9", color_tips[0], color_tips[1], color_tips[2]);
			}

			if(random_tips == 3)
			{
				sendPlayerMessage(i, "[ПОДСКАЗКА] Чтобы скрыть миникарту с персонажем нажмите F10", color_tips[0], color_tips[1], color_tips[2]);
			}

			if(random_tips == 4)
			{
				sendPlayerMessage(i, "[ПОДСКАЗКА] Чтобы открыть карту нажмите M", color_tips[0], color_tips[1], color_tips[2]);
			}

			if(random_tips == 5)
			{
				sendPlayerMessage(i, "[ПОДСКАЗКА] Z - левый поворотник, X - правый поворотник, C - аварийки", color_tips[0], color_tips[1], color_tips[2]);
			}

			if(random_tips == 6)
			{
				sendPlayerMessage(i, "[ПОДСКАЗКА] Вы можете ограбить ювелирку или магазины одежды с первой секунды игры.", color_tips[0], color_tips[1], color_tips[2]);
			}

			if(random_tips == 7)
			{
				sendPlayerMessage(i, "[ПОДСКАЗКА] Пополнить здоровье вы можете в закусочных.", color_tips[0], color_tips[1], color_tips[2]);
			}

			if(random_tips == 8)
			{
				sendPlayerMessage(i, "[ПОДСКАЗКА] Звезды на карте это работы.", color_tips[0], color_tips[1], color_tips[2]);
			}

			if(random_tips == 9)
			{
				sendPlayerMessage(i, "[ПОДСКАЗКА] Для управления автомобилем вам необходимо купить права, это можно сделать в мерии (зеленый пятиугольник), добраться до неё можно на метро.", color_tips[0], color_tips[1], color_tips[2]);
			}

			if(random_tips == 10)
			{
				sendPlayerMessage(i, "[ПОДСКАЗКА] Чтобы узнать команды пропиши /помощь", color_tips[0], color_tips[1], color_tips[2]);
			}

			if(random_tips == 11)
			{
				sendPlayerMessage(i, "[ПОДСКАЗКА] Чтобы скрыть чат нажмите F1", color_tips[0], color_tips[1], color_tips[2]);
			}
		}
	}

	random_tips += 1;

	if(random_tips == 12)
	{
		random_tips = 0;
	}
}

function zona()
{
	foreach(i, playername in getPlayers()) 
	{
		if(aresttimer[i] != -1)
		{
			if(aresttimer[i] == 0)
			{
				aresttimer[i] = -1;
				crimes[i] = 0;

				setPlayerPosition( i, -378.987, 654.699, -11.5013 );
				setPlayerRotation( i, 0.0, 0.0, 180.0 );
				sendPlayerMessage( i, "Вы свободны.", yellow[0], yellow[1], yellow[2]);

				log("");
				log("[PRISON] "+getPlayerName(i)+" vishel");
			}
			else
			{
				aresttimer[i] -= 1;
			}
		}
	}
}

function search_player_cops()
{
	if(player_id_cops == "0")
	{
		return;
	}

	if(!isPlayerConnected(getPlayerIdFromName( player_id_cops )))
	{

		return;
	}

	for(local i = 0; i < coord_len_bydka; i++)
	{
		local myPos = getPlayerPosition(getPlayerIdFromName( player_id_cops ));
		local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], coord_bydka[i][0], coord_bydka[i][1], coord_bydka[i][2], 50.0 );

		if(check)
		{
			foreach (i, playername in getPlayers())
			{
				if(logged[i] == 1 && job[i] == 5)
				{
					sendPlayerMessage(i, "(ДИСПЕТЧЕР) Нам стало известно местонахождение "+player_id_cops, blue[0], blue[1], blue[2]);

					triggerClientEvent(i, "removegps", "");
					triggerClientEvent(i, "job_gps", myPos[0], myPos[1]);
				}
			}
		}
	}
}

addCommandHandler("курс", 
function(playerid) 
{
	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	sendPlayerMessage(playerid, "====[ КУРС ]====", yellow[0], yellow[1], yellow[2]);
	sendPlayerMessage(playerid, "1 галлон = " +course_fuel+ "$", yellow[0], yellow[1], yellow[2]);
	sendPlayerMessage(playerid, "1 продукт = " +course_eda+ "$", yellow[0], yellow[1], yellow[2]);
	sendPlayerMessage(playerid, "1 запчасть = " +course_repair+ "$", yellow[0], yellow[1], yellow[2]);
	sendPlayerMessage(playerid, "1 боеприпас = " +course_gun+ "$", yellow[0], yellow[1], yellow[2]);
	sendPlayerMessage(playerid, "1 кг рыбы = " +course_fish+ "$", yellow[0], yellow[1], yellow[2]);
});

function scriptInit()
{
	log( script + " Loaded!" );
    setGameModeText( "vk.com/ebmprp "+upd );
    setMapName( "Empire Bay" );
    setSummer(pogoda);

    local date = split(getDateTime(), ": ");//установка времени
    chas = date[3].tointeger();
    min = date[4].tointeger();

    //сейв в базу данных
    local stats_timer = timer( stats, 120000, -1 );//статистика сервера, сохранение в бд

    local rTimer = timer( timeserver, 1000, -1 );//инфа денег, времени и инфы бизнеса
    local rTimer = timer( timesever_pogoda, 900000, -1 );//погода и payday
    local rTimer = timer( tips_player, 300000, -1 );//подсказки
    local prisontimer = timer( zona, 1000, -1 );//тюрьма
    local rTimer = timer( search_player_cops, 10000, -1 );//поиск игрока для копов
    local engine = timer( EngineState, 500, -1 );//двигатель вкл(выкл)
	local rTimer = timer( mill, 1000, -1 );//пробег авто

	//авторынок
	local result = database.query( "SELECT COUNT() FROM carnumber_bd" );
	local carnumber_chislo = result[1]["COUNT()"];
	for (local i = 1; i <= carnumber_chislo; i++)
	{
		result = database.query( "SELECT * FROM carnumber_bd" );
		callEvent("car_spawn", result[i]["carnumber"]);
	}

	log("");
	log("[chislo_car_spawn] "+carnumber_chislo);

	//сеть бизнесов
	local result = database.query( "SELECT * FROM biznes_bd WHERE name = 'Filling_Stations'");
	fuel_price = result[1]["price"];
	fuel_tanker = result[1]["tanker"];
	fuel_ownername = result[1]["ownername"];
	fuel_money = result[1]["money"];

	local result = database.query( "SELECT * FROM biznes_bd WHERE name = 'Eda_Bar'");
	eda_price = result[1]["price"];
	eda_tanker = result[1]["tanker"];
	eda_ownername = result[1]["ownername"];
	eda_money = result[1]["money"];

	local result = database.query( "SELECT * FROM biznes_bd WHERE name = 'Repair'");
	repair_price = result[1]["price"];
	repair_tanker = result[1]["tanker"];
	repair_ownername = result[1]["ownername"];
	repair_money = result[1]["money"];

	local result = database.query( "SELECT * FROM biznes_bd WHERE name = 'Gun'");
	gun_price = result[1]["price"];
	gun_tanker = result[1]["tanker"];
	gun_ownername = result[1]["ownername"];
	gun_money = result[1]["money"];
	

	course_fuel = random(1,10);//курс
	course_eda = random(1,10);
	course_repair = random(1,10);
	course_gun = random(1,10);
	course_fish = random(1,10);
	log("");
	log("====[course]====");
	log("course_fuel = " +course_fuel);
	log("course_eda = " +course_eda);
	log("course_repair = " +course_repair);
	log("course_gun = " +course_gun);
	log("course_fish = " +course_fish);
	log("");

}
addEventHandler( "onScriptInit", scriptInit );

function nickNameChanged( playerid, newNickname, oldNickname )
{
    log("");
	log(getPlayerName(playerid)+" kick za NickName");
	log("");
	kickPlayer( playerid );
}
addEventHandler ( "onPlayerChangeNick", nickNameChanged );

function playerConnect( playerid, name, ip, serial )
{
	money[playerid] = 0;
	bank[playerid] = 0;
	driverlic[playerid] = 0;
	car_slot[playerid] = 0;
	biznes[playerid] = 0;
	gun[playerid] = 0;
	job[playerid] = 0;
	skin[playerid] = 0;
	job_p[playerid] = 0;
	job_p1[playerid] = 0;
	exp[playerid] = 0;
	can[playerid] = 0;
	weaponlic[playerid] = 0;
	bizneslic[playerid] = 0;
	aresttimer[playerid] = -1;
	crimes[playerid] = 0;
	arest[playerid] = 0;
	tips[playerid] = 0;
	car_rental_fuel[playerid] = 0;
	drugs[playerid] = 0;
	fish[playerid] = 0;
	house[playerid] = 0;
	house_x[playerid] = 0;
	house_y[playerid] = 0;
	house_z[playerid] = 0;
	house_gun[playerid] = 0;

	logged[playerid] = 0;
	dviglo[playerid] = 0;
	sead[playerid] = 0;
	stats_pass[playerid] = 0;
	car_id[playerid] = -1;
	gun_hand[playerid] = 0;
	taizer[playerid] = 0;
	probeg[playerid] = 0;
	fish_array[playerid] = 0;
	chat[playerid] = 0;

	//тест для копов
	test[playerid] = 0;
	otvet[playerid] = 0;
	ver_otvet[playerid] = 0;

	randomx[playerid] = 0;
	randomy[playerid] = 0;

	car_rental[playerid] = -1;

	log("");
	log("CONNECT");
	log("name: " +name+ " [" +playerid+ "] IP: " +ip+ " serial: " +serial);
	
	if(FileExists("banserial/"+getPlayerSerial(playerid)+".ini"))
	{
		kickPlayer( playerid );
		log("");
		log(getPlayerName( playerid )+ " KICK ZA SERIAL");
		log("");
		return;
	}

	for(local i = 0; i < no_niki_chislo; i++) 
	{
		if(getPlayerName(playerid) == no_niki[i])
		{
			kickPlayer( playerid );
			log("");
			log(getPlayerName( playerid )+ " KICK ZA NIK PLAYER");
			log("");
			return;
		}
	}

	sendPlayerMessage(playerid, "Добро пожаловать на EBMP-nonRP", turquoise[0], turquoise[1], turquoise[2]);
	sendPlayerMessage(playerid, "Чтобы узнать команды пропиши /помощь", turquoise[0], turquoise[1], turquoise[2]);
	sendPlayerMessage(playerid, "Для управления автомобилем вам необходимо купить права, это можно сделать в мерии (зеленый пятиугольник), добраться до неё можно на метро. Чтобы открыть карту нажмите М", yellow[0], yellow[1], yellow[2]);
	sendPlayerMessage(playerid, "Звезды на карте это работы.", green[0], green[1], green[2]);
	sendPlayerMessage(playerid, "Пополнить здоровье вы можете в закусочных.", 255, 100, 100);
	sendPlayerMessage(playerid, "Удачной игры.", turquoise[0], turquoise[1], turquoise[2]);
}
addEventHandler( "onPlayerConnect", playerConnect );

addCommandHandler("помощь",
function(playerid)
{
	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	if(stats_pass[playerid] == 0)
	{
		triggerClientEvent( playerid, "help", "");
		stats_pass[playerid] = 1;
	}
});

function playerDisconnect( playerid, reason )
{
	if(logged[playerid] == 1)
	{
		if(car_rental[playerid] != -1)
		{
			foreach(i, playername in getPlayers())
			{
				local carid = getPlayerVehicle(i);
				if(isPlayerInVehicle(i) && carid == car_rental[playerid])
				{
					removePlayerFromVehicle(i);
				}
			}
		}

		local rTimer = timer( delet_car_job, 1000, 1, playerid );
		
		logged[playerid] = 0;

		local myPos = getPlayerPosition(playerid);
		local playername = getPlayerName(playerid);
		local vehicleid = getPlayerVehicle(playerid);

		database.query( "UPDATE account SET money = '"+money[playerid]+"', bank = '"+bank[playerid]+"', driverlic = '"+driverlic[playerid]+"', car_slot = '"+car_slot[playerid]+"', biznes = '"+biznes[playerid]+"', last_game = '"+getDateTime()+"', heal = '"+getPlayerHealth(playerid)+"', job = '"+job[playerid]+"', skin = '"+skin[playerid]+"', job_p = '"+job_p[playerid]+"', job_p1 = '"+job_p1[playerid]+"', exp = '"+exp[playerid]+"', can = '"+can[playerid]+"', weaponlic = '"+weaponlic[playerid]+"', bizneslic = '"+bizneslic[playerid]+"', crimes = '"+crimes[playerid]+"', arest = '"+arest[playerid]+"', tips = '"+tips[playerid]+"', car_rental_fuel = '"+car_rental_fuel[playerid]+"', drugs = '"+drugs[playerid]+"', fish = '"+fish[playerid]+"', house = '"+house[playerid]+"', house_x = '"+house_x[playerid]+"', house_y = '"+house_y[playerid]+"', house_z = '"+house_z[playerid]+"', house_gun = '"+house_gun[playerid]+"', gun = '"+gun[playerid]+"', aresttimer = '"+aresttimer[playerid]+"', serial = '"+getPlayerSerial(playerid)+"', ip = '"+getPlayerIP(playerid)+"', spawnx = '"+myPos[0]+"', spawny = '"+myPos[1]+"', spawnz = '"+myPos[2]+"' WHERE name = '"+playername+"'");
	}
}
addEventHandler( "onPlayerDisconnect", playerDisconnect );

function playerSpawn( playerid )
{
	setPlayerHandModel(playerid, 2, 0);

	if(logged[playerid] == 0)
	{
		local playername = getPlayerName(playerid);

		playSoundForPlayer( playerid, "m02_ride_to_freddys_bar" );

		triggerClientEvent(playerid, "cursor", "");

		local result = database.query( "SELECT COUNT() FROM account WHERE name = '"+playername+"'" );
	    if(result[1]["COUNT()"] == 1)
	    {
			triggerClientEvent(playerid, "login_okno", "");
		}
		else
		{
			triggerClientEvent(playerid, "reg_okno", "");
		}

		setPlayerPosition( playerid, 500.0, 1000.0, 20.0 );
    	setPlayerHealth( playerid, 1000.0 );
    	setPlayerRotation( playerid, 0.0, 0.0, 180.0 );
	}
	else
	{
		if(aresttimer[playerid] >= 0)
		{
			setPlayerPosition( playerid, -1030.42,1712.74,10.3595 );
			setPlayerRotation( playerid, 0.0, 0.0, 180.0 );
			setPlayerHealth( playerid, 1000.0 );
			return;
		}

		setPlayerPosition( playerid, -393.265,905.334,-20.0026 );
		setPlayerHealth( playerid, 1000.0 );
		setPlayerRotation( playerid, 0.0, 0.0, 180.0 );
	}

}
addEventHandler( "onPlayerSpawn", playerSpawn );

function playerDeath( playerid, killerid )
{
	if( killerid != INVALID_ENTITY_ID )
	{
		if(job[killerid] != 5)
		{
			crimes[killerid] += 1;

			sendPlayerMessage(killerid, "Вы стреляли в мирного гражданина +1 к преступлениям", yellow[0], yellow[1], yellow[2]);
		}
		else
		{
			if(crimes[playerid] == 0)
			{
				exp[killerid] -= 1;

				sendPlayerMessage(killerid, "Вы стреляли в невиновного -1 exp", yellow[0], yellow[1], yellow[2]);
			}
			else
			{
				exp[killerid] += 1;

				sendPlayerMessage(killerid, "Вы стреляли в преступника +1 exp", yellow[0], yellow[1], yellow[2])

				togglePlayerControls( playerid, false );
				
				aresttimer[playerid] = crimes[playerid]*60;
				arest[playerid] = 0;

				sendPlayerMessage(playerid, "Вы преступник, вам осталось сидеть "+aresttimer[playerid]+" секунд.", yellow[0], yellow[1], yellow[2]);
			}
		}

		log("");
		log("[KILL] "+getPlayerName(killerid)+" job "+job[killerid]+" crimes "+crimes[killerid]+" ybil iz(weapon id - "+getPlayerWeapon(killerid)+") igroka "+getPlayerName(playerid));
	}

	gun[playerid] = 0;
	gun_hand[playerid] = 0;
	drugs[playerid] = 0;

	sendPlayerMessage(playerid, "Оружие и наркотики потеряны.", yellow[0], yellow[1], yellow[2]);
}
addEventHandler( "onPlayerDeath", playerDeath );

addEventHandler("onPlayerChat",
function(playerid, text) 
{
	if(logged[playerid] == 0)
	{
		return;
	}

	if(chat[playerid] == 0)
	{
		foreach(i, playername in getPlayers())
		{
			local myPos = getPlayerPosition( i );
			local pos = getPlayerPosition( playerid );
			local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], pos[0], pos[1], pos[2], me_radius );
			if(check)
			{
				sendPlayerMessage( i, "(РП чат "+me_radius+"м) Player ["+playerid+"]: " + text, 255, 255, 130 );
			}
		}

		log("");
		log("(RP chat "+me_radius+"m) "+getPlayerName( playerid )+ " [" +playerid+"]: " + text);
	}
	else if(chat[playerid] == 1)
	{
		foreach(i, playername in getPlayers())
		{
			sendPlayerMessage( i, "(НОНРП чат) "+getPlayerName( playerid )+" ["+playerid+"]: " + text, white[0], white[1], white[2] );
		}

		log("");
		log("(NONRP chat) "+getPlayerName( playerid )+ " [" +playerid+"]: " + text);
	}
});

addEventHandler("chatnumber",
function(playerid) 
{
	if(chat[playerid] == 1)
	{
		chat[playerid] = 0;
	}
	else
	{
		chat[playerid] += 1;
	}

	if(chat[playerid] == 0)
	{
		sendPlayerMessage( playerid, "Вы переключились на РП чат в радиусе 10 метров.", white[0], white[1], white[2] );
	}

	if(chat[playerid] == 1)
	{
		sendPlayerMessage( playerid, "Вы переключились на глобальный НОНРП чат.", white[0], white[1], white[2] );
	}
});

addCommandHandler( "письмо",
function( playerid, id, ...)
{
	local id = id.tointeger();

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	if(logged[id] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Игрок не в сети!", red[0], red[1], red[2] );
		return;
	}
	
	local text = "";
	for(local i = 0; i < vargv.len(); i++)
	{
		text = text + " " + vargv[i];
	}

	sendPlayerMessage( playerid, "(ПИСЬМО) К Player ["+id+"]:"+text, yellow[0], yellow[1], yellow[2] );
	sendPlayerMessage( id, "(ПИСЬМО) От Player ["+playerid+"]:"+text, yellow[0], yellow[1], yellow[2] );

	log("");
	log("(LETTER) OT "+getPlayerName( playerid )+" K "+getPlayerName(id)+":"+text);
});

addCommandHandler( "эфир",
function( playerid, ...)
{
	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	if(job[playerid] != 6)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не радиоведущий.", red[0], red[1], red[2] );
		return;
	}

	local text = "";
	for(local i = 0; i < vargv.len(); i++)
	{
		text = text + " " + vargv[i];
	}

	sendPlayerMessageToAll( "[Радио EB]"+text, green[0], green[1], green[2] );

	log("");
	log("[Radio EB] "+getPlayerName(playerid)+""+text);
});

addCommandHandler( "р",
function( playerid, ...)
{
	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	if(job[playerid] != 5)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не полицейский.", red[0], red[1], red[2] );
		return;
	}

	local text = "";
	for(local i = 0; i < vargv.len(); i++)
	{
		text = text + " " + vargv[i];
	}

	foreach(i, playername in getPlayers())
	{
		if(job[i] == 5)
		{
			sendPlayerMessage(i, "[Рация police] Player ["+playerid+"]:"+text, blue[0], blue[1], blue[2] );
		}
	}

	log("");
	log("[Raciya police] "+getPlayerName(playerid)+""+text);
});

addEventHandler( "reg",
function( playerid, cmd )
{
	if(logged[playerid] == 0)
	{
		local playername = getPlayerName(playerid);

	    local result = database.query( "SELECT COUNT() FROM account WHERE name = '"+playername+"'" );
	    if(result[1]["COUNT()"] == 0)
	    {
	        database.query( "INSERT INTO account (name, password, money, bank, spawnx, spawny, spawnz, driverlic, car_slot, biznes, last_game, reg_server, heal, job, skin, serial, ip, job_p, job_p1, exp, can, weaponlic, bizneslic, ban, aresttimer, crimes, arest, tips, car_rental_fuel, drugs, fish, house, house_x, house_y, house_z, house_gun, gun) VALUES ('"+playername+"', '"+md5(cmd)+"', '500', '0', '-575.101', '1622.8', '-15.6957', '0', '0', '0', '0', '"+getDateTime()+"', '720.0', '0', '72', '"+getPlayerSerial(playerid)+"', '"+getPlayerIP(playerid)+"', '0', '0', '0', '0', '0', '0', '0', '-1', '0', '0', '0', '20.0', '0', '0', '0', '0', '0', '0', '0', '0')" );

	        result = database.query( "SELECT * FROM account WHERE name = '"+playername+"'" );

			stopSoundForPlayer(playerid);

			logged[playerid] = 1;//если нужно указать число, то надо указывать, если 0, то при конекте и так 0 записывается
			money[playerid] = result[1]["money"];
			skin[playerid] = result[1]["skin"];
			car_rental_fuel[playerid] = result[1]["car_rental_fuel"];

			sendPlayerMessage(playerid, "Вы удачно зашли!", turquoise[0], turquoise[1], turquoise[2]);

			setPlayerModel(playerid, skin[playerid]);
			setPlayerHealth(playerid, result[1]["heal"]);
			setPlayerPosition( playerid, result[1]["spawnx"], result[1]["spawny"], result[1]["spawnz"] );

			triggerClientEvent( playerid, "reg", "");

			log("");
			log("[ACCOUNT REGISTER] "+getPlayerName(playerid));
			log("");

			if(pogoda == true)
			{
				setWeather( weather_server_true[chas][1] );
			}
			else
			{
				setWeather( weather_server_false[chas][1] );
			}
		}
		else
		{
			sendPlayerMessage(playerid, "[ERROR] Такой ник уже есть, выбери другой!", red[0], red[1], red[2]);
		}
	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] Вы уже вошли!", red[0], red[1], red[2]);
	}
});

addEventHandler( "login",
function( playerid, cmd )
{
	if(logged[playerid] == 0)
	{
		local playername = getPlayerName(playerid);

	    local result = database.query( "SELECT COUNT() FROM account WHERE name = '"+playername+"'" );
	    if(result[1]["COUNT()"] == 1)
	    {
	    	result = database.query( "SELECT * FROM account WHERE name = '"+playername+"'" );

			if(result[1]["ban"] == 1)
			{
				sendPlayerMessage(playerid, "[ERROR] Вы забанены. Напишите в группу vk.com/ebmprp", red[0], red[1], red[2]);
				log("");
				log("[BANAK] "+getPlayerName(playerid)+" pitaetcya zaiti");
				return;
			}

			if(md5(cmd) == result[1]["password"])
			{
				stopSoundForPlayer(playerid);

				logged[playerid] = 1;
				money[playerid] = result[1]["money"];
				bank[playerid] = result[1]["bank"];
				driverlic[playerid] = result[1]["driverlic"];
				car_slot[playerid] = result[1]["car_slot"];
				biznes[playerid] = result[1]["biznes"];
				gun[playerid] = result[1]["gun"];
				job[playerid] = result[1]["job"];
				skin[playerid] = result[1]["skin"];
				job_p[playerid] = result[1]["job_p"];
				job_p1[playerid] = result[1]["job_p1"];
				exp[playerid] = result[1]["exp"];
				can[playerid] = result[1]["can"];
				weaponlic[playerid] = result[1]["weaponlic"];
				bizneslic[playerid] = result[1]["bizneslic"];
				aresttimer[playerid] = result[1]["aresttimer"];
				crimes[playerid] = result[1]["crimes"];
				arest[playerid] = result[1]["arest"];
				tips[playerid] = result[1]["tips"];
				car_rental_fuel[playerid] = result[1]["car_rental_fuel"];
				drugs[playerid] = result[1]["drugs"];
				fish[playerid] = result[1]["fish"];

				house[playerid] = result[1]["house"];
				house_x[playerid] = result[1]["house_x"];
				house_y[playerid] = result[1]["house_y"];
				house_z[playerid] = result[1]["house_z"];
				house_gun[playerid] = result[1]["house_gun"];

				sendPlayerMessage(playerid, "Вы удачно зашли!", turquoise[0], turquoise[1], turquoise[2]);

				if(job[playerid] == 1)
				{
					triggerClientEvent( playerid, "box_hud", "");
					triggerClientEvent( playerid, "box", job_p1[playerid].tointeger());
				}

				if(job[playerid] == 2)
				{
					local random_car = random(1,2);
					if(random_car == 1)
					{
						callEvent("car_rental_spawn", playerid, 24, result[1]["spawnx"]-5, result[1]["spawny"], result[1]["spawnz"]+2, 0.0, 0, 0, 0, 0, 0, 0, car_rental_fuel[playerid] );
					}
					else
					{
						callEvent("car_rental_spawn", playerid, 33, result[1]["spawnx"]-5, result[1]["spawny"], result[1]["spawnz"]+2, 0.0, 0, 0, 0, 0, 0, 0, car_rental_fuel[playerid] );
					}

					job_p[playerid] = 0;
				}

				if(job[playerid] == 3)
				{
					local check = job_p[playerid];

					if(check == 0)
					{
						triggerClientEvent( playerid, "job_gps", -83.0683,1767.58);
						setPlayerHandModel(playerid, 2, 98);
					}

					if(check == 1)
					{
						triggerClientEvent( playerid, "job_gps", -100.209,1777.59);
					}
					if(check == 2)
					{
						triggerClientEvent( playerid, "job_gps", -100.209,1784.23);
					}
					if(check == 3)
					{
						triggerClientEvent( playerid, "job_gps", -100.209,1791.11);
					}
					if(check == 4)
					{
						triggerClientEvent( playerid, "job_gps", -100.209,1812.61);
					}
					if(check == 5)
					{
						triggerClientEvent( playerid, "job_gps", -100.209,1819.64);
					}
					if(check == 6)
					{
						triggerClientEvent( playerid, "job_gps", -100.209,1826.59);
					}
					if(check == 7)
					{
						triggerClientEvent( playerid, "job_gps", -74.3066,1823.29);
					}
					if(check == 8)
					{
						triggerClientEvent( playerid, "job_gps", -74.3065,1816.46);
					}
					if(check == 9)
					{
						triggerClientEvent( playerid, "job_gps", -74.3066,1809.61);
					}
					if(check == 10)
					{
						triggerClientEvent( playerid, "job_gps", -74.3065,1780.41);
					}
				}

				if(job[playerid] == 4)
				{
					callEvent("car_rental_spawn", playerid, 20, result[1]["spawnx"]-5, result[1]["spawny"], result[1]["spawnz"]+2, 0.0, 0, 0, 0, 0, 0, 0, car_rental_fuel[playerid] );

					if(job_p[playerid] == 0 || job_p[playerid] == 19)
					{
						triggerClientEvent( playerid, "job_gps", -377.247,467.86);
					}

					if(job_p[playerid] == 1)
					{
						triggerClientEvent( playerid, "job_gps", -471.443,8.72486);
					}

					if(job_p[playerid] == 2)
					{
						triggerClientEvent( playerid, "job_gps", -429.84,-299.925);
					}

					if(job_p[playerid] == 3)
					{
						triggerClientEvent( playerid, "job_gps", -139.438,-472.443);
					}

					if(job_p[playerid] == 4)
					{
						triggerClientEvent( playerid, "job_gps", 296.425,-314.303);
					}

					if(job_p[playerid] == 5)
					{
						triggerClientEvent( playerid, "job_gps", 274.915,357.74);
					}

					if(job_p[playerid] == 6)
					{
						triggerClientEvent( playerid, "job_gps", 475.727,736.809);
					}

					if(job_p[playerid] == 7)
					{
						triggerClientEvent( playerid, "job_gps", 162.779,832.845);
					}

					if(job_p[playerid] == 8)
					{
						triggerClientEvent( playerid, "job_gps", -579.48,1601.35);
					}

					if(job_p[playerid] == 9)
					{
						triggerClientEvent( playerid, "job_gps", -1150.22,1483.88);
					}

					if(job_p[playerid] == 10)
					{
						triggerClientEvent( playerid, "job_gps", -1667.73,1094.03);
					}

					if(job_p[playerid] == 11)
					{
						triggerClientEvent( playerid, "job_gps", -1599.38,-192.854);
					}

					if(job_p[playerid] == 12)
					{
						triggerClientEvent( playerid, "job_gps", -1561.77,106.105);
					}

					if(job_p[playerid] == 13)
					{
						triggerClientEvent( playerid, "job_gps", -1347.41,420.672);
					}

					if(job_p[playerid] == 14)
					{
						triggerClientEvent( playerid, "job_gps", -1615.43,995.021);
					}

					if(job_p[playerid] == 15)
					{
						triggerClientEvent( playerid, "job_gps", -1066.34,1460.33);
					}

					if(job_p[playerid] == 16)
					{
						triggerClientEvent( playerid, "job_gps", -568.908,1582.26);
					}

					if(job_p[playerid] == 17)
					{
						triggerClientEvent( playerid, "job_gps", -171.018,726.083);
					}

					if(job_p[playerid] == 18)
					{
						triggerClientEvent( playerid, "job_gps", -102.617,374.2);
					}
				}

				if(job[playerid] == 5)
				{
					local skin_random = random(75,76);

					setPlayerModel(playerid, skin_random);

					callEvent("car_rental_spawn", playerid, 42, result[1]["spawnx"]-5, result[1]["spawny"], result[1]["spawnz"]+2, 0.0, 255, 255, 255, 0, 0, 0, car_rental_fuel[playerid] );
				}
				else
				{
					setPlayerModel(playerid, skin[playerid]);
				}

				if(job[playerid] == 7)
				{
					triggerClientEvent(playerid, "job_gps", kiosk[job_p1[playerid]][0], kiosk[job_p1[playerid]][1]);

					callEvent("car_rental_spawn", playerid, 36, result[1]["spawnx"]-5, result[1]["spawny"], result[1]["spawnz"]+2, 0.0, 150, 0, 0, 200, 200, 200, car_rental_fuel[playerid] );
				}

				if(job[playerid] == 8)
				{
					callEvent("egh_coord", playerid);

					callEvent("car_rental_spawn", playerid, 42, result[1]["spawnx"]-5, result[1]["spawny"], result[1]["spawnz"]+2, 0.0, 255, 255, 255, 150, 0, 0, car_rental_fuel[playerid] );
				}

				if(gun[playerid] != 0)
				{
					givePlayerWeapon(playerid, gun[playerid], 300);
				}

				setPlayerHealth(playerid, result[1]["heal"]);
				setPlayerPosition( playerid, result[1]["spawnx"], result[1]["spawny"], result[1]["spawnz"] );

				if(arest[playerid] == 1)
				{
					aresttimer[playerid] = (crimes[playerid]+10)*60;
					arest[playerid] = 0;
				}

				if(aresttimer[playerid] >= 0)
				{
					gun[playerid] = 0;

					removePlayerWeapon(playerid, 2, 0);
					removePlayerWeapon(playerid, 3, 0);
					removePlayerWeapon(playerid, 4, 0);
					removePlayerWeapon(playerid, 5, 0);
					removePlayerWeapon(playerid, 6, 0);
					removePlayerWeapon(playerid, 8, 0);
					removePlayerWeapon(playerid, 9, 0);
					removePlayerWeapon(playerid, 10, 0);
					removePlayerWeapon(playerid, 11, 0);

					setPlayerPosition( playerid, -1030.42,1712.74,10.3595 );
					setPlayerRotation( playerid, 0.0, 0.0, 180.0 );

					sendPlayerMessage(playerid, "Вы преступник, вам осталось сидеть "+aresttimer[playerid]+" секунд.", yellow[0], yellow[1], yellow[2]);
				}

				triggerClientEvent( playerid, "login", "");

				if(pogoda == true)
				{
					setWeather( weather_server_true[chas][1] );
				}
				else
				{
					setWeather( weather_server_false[chas][1] );
				}
			}
			else
			{
				sendPlayerMessage(playerid, "[ERROR] Неверный пароль!", red[0], red[1], red[2]);
			}
		}
		else
		{
			sendPlayerMessage(playerid, "[ERROR] Вы не зарегистрировались!", red[0], red[1], red[2]);
		}
	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] Вы уже вошли!", turquoise[0], turquoise[1], turquoise[2]);
	}
});

addCommandHandler( "пароль",
function( playerid, cmd )
{
	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	local playername = getPlayerName(playerid);

	database.query( "UPDATE account SET password = '"+md5(cmd.tostring())+"' WHERE name = '"+playername+"'");

	sendPlayerMessage(playerid, "Вы поменяли пароль!", turquoise[0], turquoise[1], turquoise[2]);
});

addCommandHandler("подсказки",
function(playerid) 
{
	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	if(tips[playerid] == 1)
	{
		tips[playerid] = 0;
		sendPlayerMessage(playerid, "Подсказки включены.", yellow[0], yellow[1], yellow[2] );
	}
	else
	{
		tips[playerid] = 1;
		sendPlayerMessage(playerid, "Подсказки отключены.", yellow[0], yellow[1], yellow[2] );
	}
});

addCommandHandler("заплатить",
function(playerid, id, cash) 
{
	local id = id.tointeger();
	local cash = cash.tointeger();

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	if(logged[id] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Игрок не в сети!", red[0], red[1], red[2] );
		return;
	}
	
	local myPos = getPlayerPosition( playerid );
	local Pos = getPlayerPosition( id );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], Pos[0], Pos[1], Pos[2], 5.0 );
	if(check)
	{
		if(money[playerid] < cash)
		{
			sendPlayerMessage(playerid, "[ERROR] Недостаточно средств.", red[0], red[1], red[2] );
			return;
		}

		if ( cash < 1 )
		{
			sendPlayerMessage(playerid, "[ERROR] Введите значение больше 0", red[0], red[1], red[2]);
			return;
		}

		money[playerid] -= cash;
		money[id] += cash;

		foreach(i, playername in getPlayers()) 
		{
			local myPos = getPlayerPosition( i );
			local pos = getPlayerPosition( playerid );
			local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], pos[0], pos[1], pos[2], me_radius );
			if(check)
			{
				sendPlayerMessage( i, "Player["+playerid+"] передал Player["+id+"] " +cash+ "$", pink[0], pink[1], pink[2] );
			}
		}

		log("");
		log("[PAY] " +getPlayerName(playerid)+ " peredal " +getPlayerName(id)+ " " +cash+ "$");
		log("");
	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] Вы далеко от игрока.", red[0], red[1], red[2]);
	}

});

//банк
addEventHandler("helpbank",
function(playerid) 
{
	local myPos = getPlayerPosition( playerid );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 67.2002,-202.94,-19.2324, 10.0 );
	if(check)
	{
		sendPlayerMessage(playerid, "====[ Команды ]====", yellow[0], yellow[1], yellow[2] );
		sendPlayerMessage(playerid, "/баланс", yellow[0], yellow[1], yellow[2] );
		sendPlayerMessage(playerid, "/положить (сумма)", yellow[0], yellow[1], yellow[2] );
		sendPlayerMessage(playerid, "/снять (сумма)", yellow[0], yellow[1], yellow[2] );
		sendPlayerMessage(playerid, "/забрать (сумма)", yellow[0], yellow[1], yellow[2] );
		sendPlayerMessage(playerid, "/оплатить (номер машины)", yellow[0], yellow[1], yellow[2] );
	}
});

addCommandHandler("баланс",
function(playerid) 
{
	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	local myPos = getPlayerPosition( playerid );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 67.2002,-202.94,-19.2324, 10.0 );
	if(check)
	{
		sendPlayerMessage(playerid, "====[ GIB ]====", yellow[0], yellow[1], yellow[2] );
		sendPlayerMessage(playerid, "В банке " +bank[playerid]+ "$", yellow[0], yellow[1], yellow[2] );
	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] Вы далеко от банка.", red[0], red[1], red[2] );
	}
});

addCommandHandler("положить",
function(playerid, id) 
{
	local id = id.tointeger();

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	local myPos = getPlayerPosition( playerid );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 67.2002,-202.94,-19.2324, 10.0 );
	if(check)
	{
		if(money[playerid] < id)
		{
			sendPlayerMessage(playerid, "[ERROR] Недостаточно средств.", red[0], red[1], red[2] );
			return;
		}

		if ( id < 1 )
		{
			sendPlayerMessage(playerid, "[ERROR] Введите значение больше 0", red[0], red[1], red[2]);
			return;
		}

		money[playerid] -= id;
		bank[playerid] += id;

		sendPlayerMessage(playerid, "Вы положили в банк " +id+ "$", orange[0], orange[1], orange[2] );
	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] Вы далеко от банка.", red[0], red[1], red[2] );
	}
});

addCommandHandler("снять",
function(playerid, id) 
{
	local id = id.tointeger();

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	local myPos = getPlayerPosition( playerid );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 67.2002,-202.94,-19.2324, 10.0 );
	if(check)
	{
		if(bank[playerid] < id)
		{
			sendPlayerMessage(playerid, "[ERROR] Недостаточно средств.", red[0], red[1], red[2] );
			return;
		}

		if ( id < 1 )
		{
			sendPlayerMessage(playerid, "[ERROR] Введите значение больше 0", red[0], red[1], red[2]);
			return;
		}

		money[playerid] += id;
		bank[playerid] -= id;

		sendPlayerMessage(playerid, "Вы забрали из банка " +id+ "$", green[0], green[1], green[2] );
	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] Вы далеко от банка.", red[0], red[1], red[2] );
	}
});

addCommandHandler("забрать", 
function(playerid, id) 
{
	local id = id.tointeger();

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	local myPos = getPlayerPosition( playerid );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 67.2002,-202.94,-19.2324, 10.0 );
	if(check)
	{
		if ( id < 1 )
		{
			sendPlayerMessage(playerid, "[ERROR] Введите значение больше 0", red[0], red[1], red[2]);
			return;
		}

		if(biznes[playerid] == 1)
		{
			if(fuel_money < id)
			{
				sendPlayerMessage(playerid, "[ERROR] Недостаточно средств на счете бизнеса.", red[0], red[1], red[2] );
				return;
			}

			money[playerid] += id;
			fuel_money -= id;

			sendPlayerMessage(playerid, "Вы сняли со счета бизнеса " +id+ "$", green[0], green[1], green[2] );
			return;
		}

		if(biznes[playerid] == 2)
		{
			if(eda_money < id)
			{
				sendPlayerMessage(playerid, "[ERROR] Недостаточно средств на счете бизнеса.", red[0], red[1], red[2] );
				return;
			}

			money[playerid] += id;
			eda_money -= id;

			sendPlayerMessage(playerid, "Вы сняли со счета бизнеса " +id+ "$", green[0], green[1], green[2] );
			return;
		}

		if(biznes[playerid] == 3)
		{
			if(repair_money < id)
			{
				sendPlayerMessage(playerid, "[ERROR] Недостаточно средств на счете бизнеса.", red[0], red[1], red[2] );
				return;
			}

			money[playerid] += id;
			repair_money -= id;

			sendPlayerMessage(playerid, "Вы сняли со счета бизнеса " +id+ "$", green[0], green[1], green[2] );
			return;
		}

		if(biznes[playerid] == 4)
		{
			if(gun_money < id)
			{
				sendPlayerMessage(playerid, "[ERROR] Недостаточно средств на счете бизнеса.", red[0], red[1], red[2] );
				return;
			}

			money[playerid] += id;
			gun_money -= id;

			sendPlayerMessage(playerid, "Вы сняли со счета бизнеса " +id+ "$", green[0], green[1], green[2] );
			return;
		}

		sendPlayerMessage(playerid, "[ERROR] У вас нет бизнеса.", red[0], red[1], red[2] );
	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не у банка.", red[0], red[1], red[2] );
	}
});

addCommandHandler( "оплатить",
function( playerid, number )
{
	local number = number.tostring();

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	local myPos = getPlayerPosition( playerid );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 67.2002,-202.94,-19.2324, 10.0 );
	if(check)
	{
		if(car_slot[playerid] == 0)
		{
			sendPlayerMessage(playerid, "[ERROR] У вас нет машин.", red[0], red[1], red[2] );
			return;
		}

		local result = database.query( "SELECT COUNT() FROM carnumber_bd WHERE carnumber = '"+number+"'" );
		if(result[1]["COUNT()"] == 1)
		{
			result = database.query( "SELECT * FROM carnumber_bd WHERE carnumber = '"+number+"'" );
			
			if(result[1]["fine"] > money[playerid])
			{
				sendPlayerMessage(playerid, "[ERROR] Недостаточно средств.", red[0], red[1], red[2] );
				return;
			}

			if(result[1]["ownername"] != getPlayerName(playerid))
			{
				sendPlayerMessage(playerid, "[ERROR] Это не ваше авто.", red[0], red[1], red[2] );
				return;
			}

			if(result[1]["fine"] != 0)
			{
				money[playerid] -= result[1]["fine"];

				sendPlayerMessage(playerid, "Вы оплатили штраф на сумму "+result[1]["fine"]+"$", orange[0], orange[1], orange[2] );

				database.query( "UPDATE carnumber_bd SET fine = '0', fine_name = '0' WHERE carnumber = '"+number+"'");
			}
			else
			{
				sendPlayerMessage(playerid, "[ERROR] На этой машине нет штрафов.", red[0], red[1], red[2] );
			}
		}
		else
		{
			sendPlayerMessage(playerid, "[ERROR] Этот номер не числится в базе.", red[0], red[1], red[2] );
		}
	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не у банка.", red[0], red[1], red[2] );
	}
});

//статистика
addCommandHandler( "статка",
function( playerid )
{
	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	if(stats_pass[playerid] == 0)
	{
		triggerClientEvent( playerid, "stats_client", biznes[playerid].tostring(), job[playerid].tostring(), exp[playerid].tostring(), crimes[playerid].tostring(), house[playerid].tostring(), drugs[playerid].tostring(), fish[playerid].tostring(), money[playerid].tostring(), bank[playerid].tostring(), getPlayerName(playerid), car_slot[playerid]);
		triggerClientEvent( playerid, "open", "");
		stats_pass[playerid] = 1;
	}
});

addEventHandler("stats_close", 
function(playerid) 
{
	stats_pass[playerid] = 0;
});

addCommandHandler( "документы",
function( playerid, id )
{
	local id = id.tointeger();

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	if(logged[id] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Игрок не в сети!", red[0], red[1], red[2] );
		return;
	}
	
	local myPos = getPlayerPosition( playerid );
	local Pos = getPlayerPosition( id );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], Pos[0], Pos[1], Pos[2], 5.0 );
	if(check)
	{
		foreach(i, playername in getPlayers()) 
		{
			local myPos = getPlayerPosition( i );
			local pos = getPlayerPosition( playerid );
			local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], pos[0], pos[1], pos[2], me_radius );
			if(check)
			{
				sendPlayerMessage( i, "Player["+playerid+"] показал Player["+id+"] документы.", pink[0], pink[1], pink[2] );
			}
		}

		sendPlayerMessage(id, "====[ Документы "+getPlayerName(playerid)+" ]====", blue[0], blue[1], blue[2]);

		if(job[playerid] == 0)
		{
			sendPlayerMessage(id, "Работа: Безработный", blue[0], blue[1], blue[2]);
		}
		if(job[playerid] == 1)
		{
			sendPlayerMessage(id, "Работа: Докер", blue[0], blue[1], blue[2]);
		}
		if(job[playerid] == 2)
		{
			sendPlayerMessage(id, "Работа: Таксист", blue[0], blue[1], blue[2]);
		}
		if(job[playerid] == 3)
		{
			sendPlayerMessage(id, "Работа: Сборщик металла", blue[0], blue[1], blue[2]);
		}
		if(job[playerid] == 4)
		{
			sendPlayerMessage(id, "Работа: Водитель автобуса", blue[0], blue[1], blue[2]);
		}
		if(job[playerid] == 5)
		{
			sendPlayerMessage(id, "Работа: Полицейский", blue[0], blue[1], blue[2]);
		}
		if(job[playerid] == 6)
		{
			sendPlayerMessage(id, "Работа: Радиоведущий", blue[0], blue[1], blue[2]);
		}
		if(job[playerid] == 7)
		{
			sendPlayerMessage(id, "Работа: Развозчик сигарет", blue[0], blue[1], blue[2]);
		}
		if(job[playerid] == 8)
		{
			sendPlayerMessage(id, "Работа: Парамедик", blue[0], blue[1], blue[2]);
		}
		if(job[playerid] == 9)
		{
			sendPlayerMessage(id, "Работа: Риэлтор", blue[0], blue[1], blue[2]);
		}

		if(job[id] == 5)
		{
			sendPlayerMessage(id, "Преступлений: "+crimes[playerid], blue[0], blue[1], blue[2]);
		}

		if(house[playerid] == 0)
		{
			sendPlayerMessage(id, "Дом: Бездомный", blue[0], blue[1], blue[2]);
		}
		else
		{
			sendPlayerMessage(id, "Дом: Есть", blue[0], blue[1], blue[2]);
		}

	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] Вы далеко от игрока.", red[0], red[1], red[2]);
	}
});

addCommandHandler( "лицензии",
function( playerid, id )
{
	local id = id.tointeger();

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	if(logged[id] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Игрок не в сети!", red[0], red[1], red[2] );
		return;
	}

	local myPos = getPlayerPosition( playerid );
	local Pos = getPlayerPosition( id );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], Pos[0], Pos[1], Pos[2], 5.0 );
	if(check)
	{
		foreach(i, playername in getPlayers()) 
		{
			local myPos = getPlayerPosition( i );
			local pos = getPlayerPosition( playerid );
			local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], pos[0], pos[1], pos[2], me_radius );
			if(check)
			{
				sendPlayerMessage( i, "Player["+playerid+"] показал Player["+id+"] свои лицензии.", pink[0], pink[1], pink[2] );
			}
		}

		sendPlayerMessage(id, "====[ Лицензии " +getPlayerName(playerid)+ " ]====", blue[0], blue[1], blue[2] );

		if(driverlic[playerid] == 1)
		{
			sendPlayerMessage(id, "Водительские права: Есть", blue[0], blue[1], blue[2] );
		}
		else
		{
			sendPlayerMessage(id, "Водительские права: Нету", blue[0], blue[1], blue[2] );
		}

		if(weaponlic[playerid] == 1)
		{
			sendPlayerMessage(id, "Лицензия на оружие: Есть", blue[0], blue[1], blue[2] );
		}
		else
		{
			sendPlayerMessage(id, "Лицензия на оружие: Нету", blue[0], blue[1], blue[2] );
		}

		if(bizneslic[playerid] == 1)
		{
			sendPlayerMessage(id, "Лицензия на бизнес: Есть", blue[0], blue[1], blue[2] );
		}
		else
		{
			sendPlayerMessage(id, "Лицензия на бизнес: Нету", blue[0], blue[1], blue[2] );
		}
	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] Вы далеко от игрока.", red[0], red[1], red[2] );
	}
});

//работы
//докер
addEventHandler( "jobdocker",
function( playerid )
{
	local myPos = getPlayerPosition( playerid );
	local check1 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -350.47,-726.813,-14.4206, 2.0 );
	if(check1)
	{
		if(job[playerid] != 0)
		{
			sendPlayerMessage(playerid, "[ERROR] Увольтесь с предыдущей работы.", red[0], red[1], red[2] );
			return;
		}

		job[playerid] = 1;

		sendPlayerMessage(playerid, "Вы устроились докером, вам нужно переносить ящики на склад (следуйте за красным кружком)", yellow[0], yellow[1], yellow[2] );

		triggerClientEvent( playerid, "job_gps", -427.786,-737.652);
		triggerClientEvent( playerid, "box_hud", "");
	}

	local check2 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -427.786,-737.652,-21.7381, 5.0 );
	if(check2)
	{
		if(isPlayerInVehicle(playerid))
		{
			sendPlayerMessage(playerid, "[ERROR] Хитрый какой, ножками давай, ножками XD", red[0], red[1], red[2] );
			return;
		}
		if(job[playerid] != 1)
		{
			sendPlayerMessage(playerid, "[ERROR] Вы не докер.", red[0], red[1], red[2] );
			return;
		}
		if(job_p[playerid] != 0)
		{
			sendPlayerMessage(playerid, "[ERROR] Вы взяли ящик.", red[0], red[1], red[2] );
			return;
		}

		job_p[playerid] = 1;//ящик

		sendPlayerMessage(playerid, "Вы взяли ящик.", yellow[0], yellow[1], yellow[2] );

		setPlayerHandModel(playerid, 2, 98);
		triggerClientEvent( playerid, "removegps", "");
		triggerClientEvent( playerid, "job_gps", -411.778,-827.907);
	}

	local check3 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -411.778,-827.907,-21.7456, 5.0 );
	if(check3)
	{
		if(isPlayerInVehicle(playerid))
		{
			sendPlayerMessage(playerid, "[ERROR] Хитрый какой, ножками давай, ножками XD", red[0], red[1], red[2] );
			return;
		}
		if(job[playerid] != 1)
		{
			sendPlayerMessage(playerid, "[ERROR] Вы не докер.", red[0], red[1], red[2] );
			return;
		}
		if(job_p[playerid] != 1)
		{
			sendPlayerMessage(playerid, "[ERROR] У вас нет ящика.", red[0], red[1], red[2] );
			return;
		}

		job_p[playerid] = 0;
		job_p1[playerid] += 1;//кол-во ящиков

		sendPlayerMessage(playerid, "Вы положили ящик.", yellow[0], yellow[1], yellow[2] );

		setPlayerHandModel(playerid, 2, 0);
		triggerClientEvent( playerid, "removegps", "");
		triggerClientEvent( playerid, "job_gps", -427.786,-737.652);
		triggerClientEvent( playerid, "box", job_p1[playerid].tointeger());
	}
});

addEventHandler( "jobdocker_leave",
function( playerid )
{
	local myPos = getPlayerPosition( playerid );
	local check1 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -350.47,-726.813,-14.4206, 5.0 );
	if(check1)
	{
		if(job[playerid] != 1)
		{
			sendPlayerMessage(playerid, "[ERROR] Вы не докер.", red[0], red[1], red[2] );
			return;
		}

		job[playerid] = 0;
		job_p[playerid] = 0;
		money[playerid] += job_p1[playerid]*payday_docker;

		sendPlayerMessage(playerid, "Вы перенесли " +job_p1[playerid]+ " ящиков и заработали " +job_p1[playerid]*payday_docker+ "$", green[0], green[1], green[2] );
		job_p1[playerid] = 0;

		setPlayerHandModel(playerid, 2, 0);
		triggerClientEvent( playerid, "removegps", "");
		triggerClientEvent( playerid, "box_hud", "");
		triggerClientEvent( playerid, "box", 0);
	}
});

//работа водителя такси, сигарет
addEventHandler( "jobdriver",
function( playerid )
{
	local myPos = getPlayerPosition( playerid );
	local check1 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 763.599,802.275,-12.0161, 2.0 );
	if(check1)
	{
		if(stats_pass[playerid] == 0)
		{
			triggerClientEvent( playerid, "jobmenu", "");
			stats_pass[playerid] = 1;
		}
	}
});

addEventHandler( "jobdriver_leave",
function( playerid )
{
	local myPos = getPlayerPosition( playerid );
	local check1 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 763.599,802.275,-12.0161, 2.0 );
	if(check1)
	{
		if(job[playerid] != 2 && job[playerid] != 7)
		{
			sendPlayerMessage(playerid, "[ERROR] Вы здесь не работаете.", red[0], red[1], red[2] );
			return;
		}

		if(job[playerid] == 2)
		{
			triggerClientEvent( playerid, "job_taxi", 5000.0, 5000.0);
		}

		job[playerid] = 0;
		job_p[playerid] = 0;
		job_p1[playerid] = 0;

		sendPlayerMessage(playerid, "Вы уволились.", yellow[0], yellow[1], yellow[2] );

		triggerClientEvent( playerid, "removegps", "");

		if(car_rental[playerid] != -1)
		{
			foreach(i, playername in getPlayers())
			{
				local carid = getPlayerVehicle(i);
				if(isPlayerInVehicle(i) && carid == car_rental[playerid])
				{
					removePlayerFromVehicle(i);
				}
			}
		}

		local rTimer = timer( delet_car_job, 1000, 1, playerid );

		log("");
		log("[delet job driver] "+getPlayerName(playerid));
	}
});

//развозчик сигарет 7
addEventHandler( "jobbigbreak",
function( playerid )
{
	local myPos = getPlayerPosition( playerid );
	local check1 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 763.599,802.275,-12.0161, 2.0 );
	if(check1)
	{
		if(job[playerid] != 0)
		{
			sendPlayerMessage(playerid, "[ERROR] Увольтесь с предыдущей работы.", red[0], red[1], red[2] );
			return;
		}
		if(driverlic[playerid] == 0)
		{
			sendPlayerMessage( playerid, "[ERROR] У вас нет водительских прав.", red[0], red[1], red[2] );
			return;
		}
		if(car_rental[playerid] != -1)
		{
			sendPlayerMessage( playerid, "[ERROR] У вас есть тс.", red[0], red[1], red[2] );
			return;
		}

		job[playerid] = 7;
		job_p[playerid] = 0;
		job_p1[playerid] = 0;

		triggerClientEvent(playerid, "job_gps", kiosk[job_p1[playerid]][0], kiosk[job_p1[playerid]][1]);

		callEvent("car_rental_spawn", playerid, 36, myPos[0]-7, myPos[1], myPos[2]+1, -90.0, 150, 0, 0, 200, 200, 200, car_rental_fuel[playerid] );

		sendPlayerMessage(playerid, "Вы устроились развозчиком сигарет, езжайте на погрузку (следуйте за красным кружком), чтобы загрузиться или разгрузиться нажмите E", yellow[0], yellow[1], yellow[2] );
	
	}
});

addEventHandler( "jobbigbreak_kiosk",
function(playerid)
{
	local myPos = getPlayerPosition( playerid );
	local vehicleid = getPlayerVehicle( playerid );
	local model = getVehicleModel(vehicleid);
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -632.282,955.495,-17.7324, 10.0 );

	if(check)
	{
		if(!isPlayerInVehicle(playerid))
		{
			return;
		}

		if(model != 36)
		{
			return;
		}

		if(job[playerid] != 7)
		{
			return;
		}

		if(job_p[playerid] == 0)
		{
			local randomize = random(1,kiosk_chislo-1);

			job_p[playerid] = 100;//100 коробок сигарет
			job_p1[playerid] = randomize;//чек киоска от 1 до 41

			triggerClientEvent(playerid, "removegps", "");
			triggerClientEvent(playerid, "job_gps", kiosk[randomize][0], kiosk[randomize][1]);

			sendPlayerMessage(playerid, "Вы погрузили "+job_p[playerid]+" коробок сигарет, теперь развезите их по киоскам.", yellow[0], yellow[1], yellow[2] );
		}
		else
		{
			sendPlayerMessage(playerid, "[ERROR] Вы погрузили сигареты.", red[0], red[1], red[2] );
		}

		return;
	}

	local check_kiosk = isPointInCircle3D( myPos[0], myPos[1], myPos[2], kiosk[job_p1[playerid]][0], kiosk[job_p1[playerid]][1], kiosk[job_p1[playerid]][2], 10.0 );
	if(check_kiosk)
	{
		local randomize = random(1,kiosk_chislo-1);

		job_p[playerid] -= 10;
		job_p1[playerid] = randomize;
		money[playerid] += payday_bigbreak_driver;

		triggerClientEvent(playerid, "removegps", "");
		triggerClientEvent(playerid, "job_gps", kiosk[randomize][0], kiosk[randomize][1]);

		sendPlayerMessage(playerid, "Вы разгрузили 10 коробок, у вас осталось "+job_p[playerid]+" коробок сигарет.", yellow[0], yellow[1], yellow[2] );
		sendPlayerMessage(playerid, "Вы заработали "+payday_bigbreak_driver+"$", green[0], green[1], green[2] );

		if(job_p[playerid] == 0)
		{
			job_p1[playerid] = 0;

			triggerClientEvent(playerid, "removegps", "");
			triggerClientEvent(playerid, "job_gps", kiosk[job_p1[playerid]][0], kiosk[job_p1[playerid]][1]);

			sendPlayerMessage(playerid, "[ERROR] У вас закончились сигареты, езжайте на погрузку.", red[0], red[1], red[2] );
		}
	}
});

//такси 2
addEventHandler( "jobtaxi_random",
function(playerid)
{
	randomx[playerid] = random(-1700,800);
	randomy[playerid] = random(-500,1700);

	while(true)
	{
		if(randomx[playerid] >= -1300 && randomx[playerid] <= -700 && randomy[playerid] >= -500 && randomy[playerid] <= 1400 || randomx[playerid] >= -100 && randomx[playerid] <= 800 && randomy[playerid] >= 900 && randomy[playerid] <= 1700)
		{
			randomx[playerid] = random(-1700,800);
			randomy[playerid] = random(-500,1700);
		}
		else
		{
			triggerClientEvent( playerid, "job_gps", randomx[playerid].tofloat(), randomy[playerid].tofloat());
			triggerClientEvent( playerid, "job_taxi", randomx[playerid].tofloat(), randomy[playerid].tofloat());
		    break;
		}
	}
});

addEventHandler( "jobtaxi",
function( playerid )
{
	local myPos = getPlayerPosition( playerid );
	local check1 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 763.599,802.275,-12.0161, 2.0 );
	if(check1)
	{
		if(job[playerid] != 0)
		{
			sendPlayerMessage(playerid, "[ERROR] Увольтесь с предыдущей работы.", red[0], red[1], red[2] );
			return;
		}
		if(driverlic[playerid] == 0)
		{
			sendPlayerMessage( playerid, "[ERROR] У вас нет водительских прав.", red[0], red[1], red[2] );
			return;
		}
		if(car_rental[playerid] != -1)
		{
			sendPlayerMessage( playerid, "[ERROR] У вас есть тс.", red[0], red[1], red[2] );
			return;
		}

		job[playerid] = 2;

		local random_car = random(1,2);
		if(random_car == 1)
		{
			callEvent("car_rental_spawn", playerid, 24, myPos[0]-7, myPos[1], myPos[2]+1, -90.0, 0, 0, 0, 0, 0, 0, car_rental_fuel[playerid] );
		}
		if(random_car == 2)
		{
			callEvent("car_rental_spawn", playerid, 33, myPos[0]-7, myPos[1], myPos[2]+1, -90.0, 0, 0, 0, 0, 0, 0, car_rental_fuel[playerid] );
		}

		sendPlayerMessage(playerid, "Вы устроились таксистом, вам нужно приезжать на вызовы и сигналить, чтобы люди садились в ваше авто, далее вам нужно отвезити их по нужному адресу (следуйте за красным кружком)", yellow[0], yellow[1], yellow[2] );
		sendPlayerMessage(playerid, "Чтобы начать работу пропишите /принять вызов, а чтобы отклонить /отменить вызова.", yellow[0], yellow[1], yellow[2] );
	
	}
});

function delet_car_job(playerid)
{
	if(car_rental[playerid] != -1)
	{
		destroyVehicle(car_rental[playerid]);
		car_rental[playerid] = -1;
	}
}

addCommandHandler( "принять",
function( playerid, name )
{
	if(name.tostring() != "вызов")
	{
		return;
	}

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	if(job[playerid] != 2)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не таксист.", red[0], red[1], red[2] );
		return;
	}

	local vehicleid = getPlayerVehicle( playerid );
	local model = getVehicleModel(vehicleid);
	if(isPlayerInVehicle(playerid) && model == 24 || isPlayerInVehicle(playerid) && model == 33)
	{
		if(job_p[playerid] != 0)
		{
			sendPlayerMessage(playerid, "[ERROR] У вас есть вызов.", red[0], red[1], red[2] );
			return;
		}

		job_p[playerid] = 1;//есть вызов

		callEvent( "jobtaxi_random", playerid.tointeger());

		local prevState = getTaxiLightState(vehicleid);
		setTaxiLightState(vehicleid, !prevState);

		sendPlayerMessage(playerid, "Диспетчер, "+getPlayerName(playerid)+" вышел на линию.", yellow[0], yellow[1], yellow[2] );
	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не в рабочей машине.", red[0], red[1], red[2] );
	}
});

addCommandHandler( "отменить",
function( playerid, name )
{
	if(name.tostring() != "вызов")
	{
		return;
	}

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	if(job[playerid] != 2)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не таксист.", red[0], red[1], red[2] );
		return;
	}

	local vehicleid = getPlayerVehicle( playerid );
	local model = getVehicleModel(vehicleid);
	if(isPlayerInVehicle(playerid) && model == 24 || isPlayerInVehicle(playerid) && model == 33)
	{
		if(job_p[playerid] == 0)
		{
			sendPlayerMessage(playerid, "[ERROR] У вас нет вызова.", red[0], red[1], red[2] );
			return;
		}

		job_p[playerid] = 0;

		triggerClientEvent( playerid, "job_taxi", 5000.0, 5000.0);

		triggerClientEvent( playerid, "removegps", "");

		local prevState = getTaxiLightState(vehicleid);
		setTaxiLightState(vehicleid, !prevState);

		sendPlayerMessage(playerid, "Диспетчер, "+getPlayerName(playerid)+" закончил работу.", yellow[0], yellow[1], yellow[2] );
	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не в рабочей машине.", red[0], red[1], red[2] );
	}
});

addEventHandler( "taxi_money",
function( playerid )
{
	local myPos = getPlayerPosition( playerid );
	local vehicleid = getPlayerVehicle( playerid );
	local model = getVehicleModel(vehicleid);
	local check = isPointInCircle2D( myPos[0], myPos[1], randomx[playerid].tofloat(), randomy[playerid].tofloat(), 50.0 );
	if(check)
	{
		if(job[playerid] != 2)
		{
			return;
		}

		if(isPlayerInVehicle(playerid) && model == 24 || isPlayerInVehicle(playerid) && model == 33)
		{
			if(job_p[playerid] == 0)
			{
				return;
			}

			if(getSpeed(vehicleid).tointeger() != 0)
			{
				sendPlayerMessage(playerid, "[ERROR] Остановите машину.", red[0], red[1], red[2] );
				return;
			}

			if(job_p[playerid] == 1)
			{
				job_p[playerid] = 2;//пассажир сел

				triggerClientEvent( playerid, "removegps", "");
				callEvent( "jobtaxi_random", playerid.tointeger());

				sendPlayerMessage(playerid, "Вы посадили пассажира.", yellow[0], yellow[1], yellow[2] );
			}
			else
			{
				local payday_taxi = random(500,1000);
				job_p[playerid] = 1;
				money[playerid] += payday_taxi;

				triggerClientEvent( playerid, "removegps", "");
				callEvent( "jobtaxi_random", playerid.tointeger());

				sendPlayerMessage(playerid, "Вы высадили пассажира и заработали " +payday_taxi+ "$", green[0], green[1], green[2] );
				sendPlayerMessage(playerid, "Вам поступил вызов.", yellow[0], yellow[1], yellow[2] );
			}
		}

	}

});

//маталлоломщик 3
addEventHandler( "jobmetal",
function( playerid )
{
	local check = random(1,10);
	local metal = random(1,10);
	local money_metal = getPlayerCount();
	local smile = ":-)";

	local myPos = getPlayerPosition( playerid );
	local check1 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -80.3572,1742.86,-18.7085, 2.0 );
	local check2 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -83.0683,1767.58,-18.4006, 2.0 );
	local check3 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -79.025,1766.14,-15.8721, 2.0 );

	local sm1 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -100.209,1777.59,-18.7375, 2.0 );
	local sm2 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -100.209,1784.23,-18.7375, 2.0 );
	local sm3 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -100.209,1791.11,-18.7375, 2.0 );
	local sm4 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -100.209,1812.61,-18.7375, 2.0 );
	local sm5 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -100.209,1819.64,-18.7375, 2.0 );
	local sm6 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -100.209,1826.59,-18.7335, 2.0 );
	local sm7 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -74.3066,1823.29,-18.7367, 2.0 );
	local sm8 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -74.3065,1816.46,-18.7369, 2.0 );
	local sm9 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -74.3066,1809.61,-18.7369, 2.0 );
	local sm10 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -74.3065,1780.41,-18.7371, 2.0 );
	if(check1)
	{
		if(job[playerid] != 0)
		{
			sendPlayerMessage(playerid, "[ERROR] Увольтесь с предыдущей работы.", red[0], red[1], red[2] );
			return;
		}

		job[playerid] = 3;
		job_p[playerid] = check;//чеки холодосов

		sendPlayerMessage(playerid, "Вы устроились сборщиком металла, вам нужно собирать металл у холодильников и относить в пресс (следуйте за красным кружком)", yellow[0], yellow[1], yellow[2] );

		if(check == 1)
		{
			triggerClientEvent( playerid, "job_gps", -100.209,1777.59);
		}
		if(check == 2)
		{
			triggerClientEvent( playerid, "job_gps", -100.209,1784.23);
		}
		if(check == 3)
		{
			triggerClientEvent( playerid, "job_gps", -100.209,1791.11);
		}
		if(check == 4)
		{
			triggerClientEvent( playerid, "job_gps", -100.209,1812.61);
		}
		if(check == 5)
		{
			triggerClientEvent( playerid, "job_gps", -100.209,1819.64);
		}
		if(check == 6)
		{
			triggerClientEvent( playerid, "job_gps", -100.209,1826.59);
		}
		if(check == 7)
		{
			triggerClientEvent( playerid, "job_gps", -74.3066,1823.29);
		}
		if(check == 8)
		{
			triggerClientEvent( playerid, "job_gps", -74.3065,1816.46);
		}
		if(check == 9)
		{
			triggerClientEvent( playerid, "job_gps", -74.3066,1809.61);
		}
		if(check == 10)
		{
			triggerClientEvent( playerid, "job_gps", -74.3065,1780.41);
		}
	}

	if(check2 || sm1 || sm2 || sm3 || sm4 || sm5 || sm6 || sm7 || sm8 || sm9 || sm10)
	{
		if(isPlayerInVehicle(playerid))
		{
			sendPlayerMessage(playerid, "[ERROR] Хитрый какой, ножками давай, ножками "+smile, red[0], red[1], red[2] );
			return;
		}
		if(job[playerid] != 3)
		{
			sendPlayerMessage(playerid, "[ERROR] Вы не сборщик металла.", red[0], red[1], red[2] );
			return;
		}
	}

	if(check2)
	{
		if(job_p1[playerid] == 0)
		{
			sendPlayerMessage(playerid, "[ERROR] У вас нет металлолома.", red[0], red[1], red[2] );
			return;
		}
		if(metal_nob > 1000)
		{
			sendPlayerMessage(playerid, "[ERROR] Пресс полон, идите наверх и спресуйте металлолом.", red[0], red[1], red[2]);
			return;
		}

		metal_nob += job_p1[playerid];
		money[playerid] += job_p1[playerid]*money_metal;

		sendPlayerMessage(playerid, "Вы получили " +job_p1[playerid]*money_metal+ "$", green[0], green[1], green[2] );

		job_p1[playerid] = 0;//кол-во взятого металла
		job_p[playerid] = check;

		triggerClientEvent( playerid, "removegps", "" );
		setPlayerHandModel(playerid, 2, 0);

		if(check == 1)
		{
			triggerClientEvent( playerid, "job_gps", -100.209,1777.59);
		}
		if(check == 2)
		{
			triggerClientEvent( playerid, "job_gps", -100.209,1784.23);
		}
		if(check == 3)
		{
			triggerClientEvent( playerid, "job_gps", -100.209,1791.11);
		}
		if(check == 4)
		{
			triggerClientEvent( playerid, "job_gps", -100.209,1812.61);
		}
		if(check == 5)
		{
			triggerClientEvent( playerid, "job_gps", -100.209,1819.64);
		}
		if(check == 6)
		{
			triggerClientEvent( playerid, "job_gps", -100.209,1826.59);
		}
		if(check == 7)
		{
			triggerClientEvent( playerid, "job_gps", -74.3066,1823.29);
		}
		if(check == 8)
		{
			triggerClientEvent( playerid, "job_gps", -74.3065,1816.46);
		}
		if(check == 9)
		{
			triggerClientEvent( playerid, "job_gps", -74.3066,1809.61);
		}
		if(check == 10)
		{
			triggerClientEvent( playerid, "job_gps", -74.3065,1780.41);
		}
	}

	if(check3)
	{
		if(job[playerid] != 3)
		{
			sendPlayerMessage(playerid, "[ERROR] Вы не сборщик металла.", red[0], red[1], red[2] );
			return;
		}

		if(metal_nob < 1000)
		{
			sendPlayerMessage(playerid, "[ERROR] Пресс пуст.", red[0], red[1], red[2]);
			return;
		}

		metal_nob = 0;

		sendPlayerMessage(playerid, "Вы спрессовали металлолом.", yellow[0], yellow[1], yellow[2]);
	}

	if(sm1)
	{
		if(job_p[playerid] != 1)
		{
			sendPlayerMessage(playerid, "[ERROR] У вас другой чек поинт.", red[0], red[1], red[2] );
			return;
		}

		job_p[playerid] = 0;
		job_p1[playerid] = metal;

		triggerClientEvent( playerid, "removegps", "" );
		triggerClientEvent( playerid, "job_gps", -83.0683,1767.58);
		setPlayerHandModel(playerid, 2, 98);

		sendPlayerMessage(playerid, "Вы взяли " +metal+ " шт металла.", yellow[0], yellow[1], yellow[2] );
	}

	if(sm2)
	{
		if(job_p[playerid] != 2)
		{
			sendPlayerMessage(playerid, "[ERROR] У вас другой чек поинт.", red[0], red[1], red[2] );
			return;
		}

		job_p[playerid] = 0;
		job_p1[playerid] = metal;

		triggerClientEvent( playerid, "removegps", "" );
		triggerClientEvent( playerid, "job_gps", -83.0683,1767.58);
		setPlayerHandModel(playerid, 2, 98);

		sendPlayerMessage(playerid, "Вы взяли " +metal+ " шт металла.", yellow[0], yellow[1], yellow[2] );
	}

	if(sm3)
	{
		if(job_p[playerid] != 3)
		{
			sendPlayerMessage(playerid, "[ERROR] У вас другой чек поинт.", red[0], red[1], red[2] );
			return;
		}

		job_p[playerid] = 0;
		job_p1[playerid] = metal;

		triggerClientEvent( playerid, "removegps", "" );
		triggerClientEvent( playerid, "job_gps", -83.0683,1767.58);
		setPlayerHandModel(playerid, 2, 98);

		sendPlayerMessage(playerid, "Вы взяли " +metal+ " шт металла.", yellow[0], yellow[1], yellow[2] );
	}

	if(sm4)
	{
		if(job_p[playerid] != 4)
		{
			sendPlayerMessage(playerid, "[ERROR] У вас другой чек поинт.", red[0], red[1], red[2] );
			return;
		}

		job_p[playerid] = 0;
		job_p1[playerid] = metal;

		triggerClientEvent( playerid, "removegps", "" );
		triggerClientEvent( playerid, "job_gps", -83.0683,1767.58);
		setPlayerHandModel(playerid, 2, 98);

		sendPlayerMessage(playerid, "Вы взяли " +metal+ " шт металла.", yellow[0], yellow[1], yellow[2] );
	}

	if(sm5)
	{
		if(job_p[playerid] != 5)
		{
			sendPlayerMessage(playerid, "[ERROR] У вас другой чек поинт.", red[0], red[1], red[2] );
			return;
		}

		job_p[playerid] = 0;
		job_p1[playerid] = metal;

		triggerClientEvent( playerid, "removegps", "" );
		triggerClientEvent( playerid, "job_gps", -83.0683,1767.58);
		setPlayerHandModel(playerid, 2, 98);

		sendPlayerMessage(playerid, "Вы взяли " +metal+ " шт металла.", yellow[0], yellow[1], yellow[2] );
	}

	if(sm6)
	{
		if(job_p[playerid] != 6)
		{
			sendPlayerMessage(playerid, "[ERROR] У вас другой чек поинт.", red[0], red[1], red[2] );
			return;
		}

		job_p[playerid] = 0;
		job_p1[playerid] = metal;

		triggerClientEvent( playerid, "removegps", "" );
		triggerClientEvent( playerid, "job_gps", -83.0683,1767.58);
		setPlayerHandModel(playerid, 2, 98);

		sendPlayerMessage(playerid, "Вы взяли " +metal+ " шт металла.", yellow[0], yellow[1], yellow[2] );
	}

	if(sm7)
	{
		if(job_p[playerid] != 7)
		{
			sendPlayerMessage(playerid, "[ERROR] У вас другой чек поинт.", red[0], red[1], red[2] );
			return;
		}

		job_p[playerid] = 0;
		job_p1[playerid] = metal;

		triggerClientEvent( playerid, "removegps", "" );
		triggerClientEvent( playerid, "job_gps", -83.0683,1767.58);
		setPlayerHandModel(playerid, 2, 98);

		sendPlayerMessage(playerid, "Вы взяли " +metal+ " шт металла.", yellow[0], yellow[1], yellow[2] );
	}

	if(sm8)
	{
		if(job_p[playerid] != 8)
		{
			sendPlayerMessage(playerid, "[ERROR] У вас другой чек поинт.", red[0], red[1], red[2] );
			return;
		}

		job_p[playerid] = 0;
		job_p1[playerid] = metal;

		triggerClientEvent( playerid, "removegps", "" );
		triggerClientEvent( playerid, "job_gps", -83.0683,1767.58);
		setPlayerHandModel(playerid, 2, 98);

		sendPlayerMessage(playerid, "Вы взяли " +metal+ " шт металла.", yellow[0], yellow[1], yellow[2] );
	}

	if(sm9)
	{
		if(job_p[playerid] != 9)
		{
			sendPlayerMessage(playerid, "[ERROR] У вас другой чек поинт.", red[0], red[1], red[2] );
			return;
		}

		job_p[playerid] = 0;
		job_p1[playerid] = metal;

		triggerClientEvent( playerid, "removegps", "" );
		triggerClientEvent( playerid, "job_gps", -83.0683,1767.58);
		setPlayerHandModel(playerid, 2, 98);

		sendPlayerMessage(playerid, "Вы взяли " +metal+ " шт металла.", yellow[0], yellow[1], yellow[2] );
	}

	if(sm10)
	{
		if(job_p[playerid] != 10)
		{
			sendPlayerMessage(playerid, "[ERROR] У вас другой чек поинт.", red[0], red[1], red[2] );
			return;
		}

		job_p[playerid] = 0;
		job_p1[playerid] = metal;

		triggerClientEvent( playerid, "removegps", "" );
		triggerClientEvent( playerid, "job_gps", -83.0683,1767.58);
		setPlayerHandModel(playerid, 2, 98);

		sendPlayerMessage(playerid, "Вы взяли " +metal+ " шт металла.", yellow[0], yellow[1], yellow[2] );
	}
});

addEventHandler( "jobmetal_leave",
function( playerid )
{
	local myPos = getPlayerPosition( playerid );
	local check1 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -80.3572,1742.86,-18.7085, 2.0 );
	if(check1)
	{
		if(job[playerid] != 3)
		{
			sendPlayerMessage(playerid, "[ERROR] Вы не сборщик металла.", red[0], red[1], red[2] );
			return;
		}

		job[playerid] = 0;
		job_p[playerid] = 0;
		job_p1[playerid] = 0;

		sendPlayerMessage(playerid, "Вы уволились.", yellow[0], yellow[1], yellow[2] );

		triggerClientEvent( playerid, "removegps", "");
		setPlayerHandModel(playerid, 2, 0);
	}
});

//автобусник 4
addEventHandler( "jobbusdriver",
function( playerid )
{
	local vehicleid = getPlayerVehicle(playerid);
	local vmodel = getVehicleModel(vehicleid);
	local myPos = getPlayerPosition( playerid );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -422.731,479.451,0.1, 2.0 );
	local check1 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -377.247,467.86,-1.1542, 5.0 );
	local check2 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -471.443,8.72486,-1.25911, 5.0 );
	local check3 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -429.84,-299.925,-11.6514, 5.0 );
	local check4 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -139.438,-472.443,-15.243, 5.0 );
	local check5 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 296.425,-314.303,-20.0969, 5.0 );
	local check6 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 274.915,357.74,-21.4706, 5.0 );
	local check7 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 475.727,736.809,-21.1842, 5.0 );
	local check8 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 162.779,832.845,-19.5612, 5.0 );
	local check9 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -579.48,1601.35,-16.3978, 5.0 );
	local check10 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1150.22,1483.88,-3.32825, 5.0 );
	local check11 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1667.73,1094.03,-6.92672, 5.0 );
	local check12 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1599.38,-192.854,-20.2267, 5.0 );
	local check13 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1561.77,106.105,-13.2248, 5.0 );
	local check14 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1347.41,420.672,-23.6699, 5.0 );
	local check15 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1615.43,995.021,-5.83024, 5.0 );
	local check16 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1066.34,1460.33,-3.84283, 5.0 );
	local check17 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -568.908,1582.26,-16.3778, 5.0 );
	local check18 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -171.018,726.083,-20.4468, 5.0 );
	local check19 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -102.617,374.2,-13.9325, 5.0 );

	if(check)
	{
		if(job[playerid] != 0)
		{
			sendPlayerMessage(playerid, "[ERROR] Увольтесь с предыдущей работы.", red[0], red[1], red[2] );
			return;
		}
		if(driverlic[playerid] == 0)
		{
			sendPlayerMessage( playerid, "[ERROR] У вас нет водительских прав.", red[0], red[1], red[2] );
			return;
		}
		if(car_rental[playerid] != -1)
		{
			sendPlayerMessage( playerid, "[ERROR] У вас есть тс.", red[0], red[1], red[2] );
			return;
		}

		job[playerid] = 4;
		job_p[playerid] = 0;

		sendPlayerMessage(playerid, "Вы устроились водителем автобуса, вам нужно следовать маршруту (следуйте за красным кружком)", yellow[0], yellow[1], yellow[2] );
		sendPlayerMessage(playerid, "Чтобы взять чек поинт, нужно посигналить нажав Е", yellow[0], yellow[1], yellow[2] );

		triggerClientEvent( playerid, "job_gps", -377.247,467.86);

		callEvent("car_rental_spawn", playerid, 20, -405.057,485.34,0.524406+1, 0.0, 0, 0, 0, 0, 0, 0, car_rental_fuel[playerid] );
	}

	if(!isPlayerInVehicle(playerid))
	{
		return;
	}

	if(vmodel != 20)
	{
		return;
	}

	if(job[playerid] != 4)
	{
		return;
	}

	if(check1 || check2 || check3 || check4 || check5 || check6 || check7 || check8 || check9 || check10 || check11 || check12 || check13 || check14 || check15 || check16 || check17 || check18 || check19)
	{
		if(getSpeed(vehicleid).tointeger() != 0)
		{
			sendPlayerMessage(playerid, "[ERROR] Остановите машину.", red[0], red[1], red[2] );
			return;
		}
	}

	if(check1 && job_p[playerid] == 0)
	{
		job_p[playerid] = 1;

		triggerClientEvent( playerid, "removegps", "");
		triggerClientEvent( playerid, "job_gps", -471.443,8.72486);
	}

	if(check2 && job_p[playerid] == 1)
	{
		job_p[playerid] = 2;

		triggerClientEvent( playerid, "removegps", "");
		triggerClientEvent( playerid, "job_gps", -429.84,-299.925);
	}

	if(check3 && job_p[playerid] == 2)
	{
		job_p[playerid] = 3;

		triggerClientEvent( playerid, "removegps", "");
		triggerClientEvent( playerid, "job_gps", -139.438,-472.443);
	}

	if(check4 && job_p[playerid] == 3)
	{
		job_p[playerid] = 4;

		triggerClientEvent( playerid, "removegps", "");
		triggerClientEvent( playerid, "job_gps", 296.425,-314.303);
	}

	if(check5 && job_p[playerid] == 4)
	{
		job_p[playerid] = 5;

		triggerClientEvent( playerid, "removegps", "");
		triggerClientEvent( playerid, "job_gps", 274.915,357.74);
	}

	if(check6 && job_p[playerid] == 5)
	{
		job_p[playerid] = 6;

		triggerClientEvent( playerid, "removegps", "");
		triggerClientEvent( playerid, "job_gps", 475.727,736.809);
	}

	if(check7 && job_p[playerid] == 6)
	{
		job_p[playerid] = 7;

		triggerClientEvent( playerid, "removegps", "");
		triggerClientEvent( playerid, "job_gps", 162.779,832.845);
	}

	if(check8 && job_p[playerid] == 7)
	{
		job_p[playerid] = 8;

		triggerClientEvent( playerid, "removegps", "");
		triggerClientEvent( playerid, "job_gps", -579.48,1601.35);
	}

	if(check9 && job_p[playerid] == 8)
	{
		job_p[playerid] = 9;

		triggerClientEvent( playerid, "removegps", "");
		triggerClientEvent( playerid, "job_gps", -1150.22,1483.88);
	}

	if(check10 && job_p[playerid] == 9)
	{
		job_p[playerid] = 10;

		triggerClientEvent( playerid, "removegps", "");
		triggerClientEvent( playerid, "job_gps", -1667.73,1094.03);
	}

	if(check11 && job_p[playerid] == 10)
	{
		job_p[playerid] = 11;

		triggerClientEvent( playerid, "removegps", "");
		triggerClientEvent( playerid, "job_gps", -1599.38,-192.854);
	}

	if(check12 && job_p[playerid] == 11)
	{
		job_p[playerid] = 12;

		triggerClientEvent( playerid, "removegps", "");
		triggerClientEvent( playerid, "job_gps", -1561.77,106.105);
	}

	if(check13 && job_p[playerid] == 12)
	{
		job_p[playerid] = 13;

		triggerClientEvent( playerid, "removegps", "");
		triggerClientEvent( playerid, "job_gps", -1347.41,420.672);
	}

	if(check14 && job_p[playerid] == 13)
	{
		job_p[playerid] = 14;

		triggerClientEvent( playerid, "removegps", "");
		triggerClientEvent( playerid, "job_gps", -1615.43,995.021);
	}

	if(check15 && job_p[playerid] == 14)
	{
		job_p[playerid] = 15;

		triggerClientEvent( playerid, "removegps", "");
		triggerClientEvent( playerid, "job_gps", -1066.34,1460.33);
	}

	if(check16 && job_p[playerid] == 15)
	{
		job_p[playerid] = 16;

		triggerClientEvent( playerid, "removegps", "");
		triggerClientEvent( playerid, "job_gps", -568.908,1582.26);
	}

	if(check17 && job_p[playerid] == 16)
	{
		job_p[playerid] = 17;

		triggerClientEvent( playerid, "removegps", "");
		triggerClientEvent( playerid, "job_gps", -171.018,726.083);
	}

	if(check18 && job_p[playerid] == 17)
	{
		job_p[playerid] = 18;

		triggerClientEvent( playerid, "removegps", "");
		triggerClientEvent( playerid, "job_gps", -102.617,374.2);
	}

	if(check19 && job_p[playerid] == 18)
	{
		job_p[playerid] = 19;

		triggerClientEvent( playerid, "removegps", "");
		triggerClientEvent( playerid, "job_gps", -377.247,467.86);
	}

	if(check1 && job_p[playerid] == 19)
	{
		job_p[playerid] = 1;
		money[playerid] += payday_busdriver;

		sendPlayerMessage(playerid, "За весь рейс вы заработали "+payday_busdriver+"$", green[0], green[1], green[2] );

		triggerClientEvent( playerid, "removegps", "");
		triggerClientEvent( playerid, "job_gps", -471.443,8.72486);
	}
});

addEventHandler( "jobbusdriver_leave",
function( playerid )
{
	local myPos = getPlayerPosition( playerid );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -422.731,479.451,0.109211, 2.0 );
	if(check)
	{
		if(job[playerid] != 4)
		{
			sendPlayerMessage(playerid, "[ERROR] Вы не водитель автобуса.", red[0], red[1], red[2] );
			return;
		}

		job[playerid] = 0;
		job_p[playerid] = 0;

		sendPlayerMessage(playerid, "Вы уволились.", yellow[0], yellow[1], yellow[2] );

		triggerClientEvent( playerid, "removegps", "");

		if(car_rental[playerid] != -1)
		{
			foreach(i, playername in getPlayers())
			{
				local carid = getPlayerVehicle(i);
				if(isPlayerInVehicle(i) && carid == car_rental[playerid])
				{
					removePlayerFromVehicle(i);
				}
			}
		}

		local rTimer = timer( delet_car_job, 1000, 1, playerid );

		log("");
		log("[delet job bus] "+getPlayerName(playerid));
	}
});

//хобби
//рыбалка
function fish_timer(playerid)
{
	if(logged[playerid] == 1)
	{
		local randomize = random(0,1);
		local randomize1 = random(1,10);

		if(randomize == 1)
		{
			fish[playerid] += randomize1;

			sendPlayerMessage(playerid, "Вы поймали рыбу весом "+randomize1+" кг.", green[0], green[1], green[2] );
		}
		else
		{
			sendPlayerMessage(playerid, "Рыба сорвалась.", orange[0], orange[1], orange[2] );
		}

		setPlayerHandModel(playerid, 2, 0);

		fish_array[playerid] = 0;
	}
}
addEventHandler( "hobby_fish",
function( playerid )
{
	local myPos = getPlayerPosition( playerid );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 564.845,-555.782,-22.7021, 40.0 );
	if(check)
	{
		if(isPlayerInVehicle(playerid))
		{
			sendPlayerMessage(playerid, "[ERROR] Вы в машине.", red[0], red[1], red[2] );
			return;
		}

		if(fish_array[playerid] == 1)
		{
			sendPlayerMessage(playerid, "[ERROR] Вы рыбачите.", red[0], red[1], red[2] );
			return;
		}

		setPlayerHandModel(playerid, 2, 101);

		fish_array[playerid] = 1;

		local rTimer = timer( fish_timer, 10000, 1, playerid );

		sendPlayerMessage(playerid, "Вы закинули удочку.", yellow[0], yellow[1], yellow[2] );
	}
});

addEventHandler( "sell_fish",
function( playerid )
{
	local myPos = getPlayerPosition( playerid );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 389.846,125.266,-20.2027, 1.5 );
	if(check)
	{
		if(fish[playerid] == 0)
		{
			sendPlayerMessage(playerid, "[ERROR] У вас нет рыбы.", red[0], red[1], red[2] );
			return;
		}

		money[playerid] += fish[playerid]*course_fish;

		sendPlayerMessage(playerid, "Вы продали "+fish[playerid]+" кг рыбы за "+fish[playerid]*course_fish+"$", green[0], green[1], green[2] );

		fish[playerid] = 0;
	}
});

//фрака копов
addEventHandler( "cops",
function( playerid )
{
	local myPos = getPlayerPosition( playerid );
	local check1 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -378.987, 654.699, -11.5013, 2.0 );
	if(check1)
	{
		if(test[playerid] == 1)
		{
			sendPlayerMessage(playerid, "[ERROR] Вы проходите экзамен.", red[0], red[1], red[2] );
			return;
		}
		if(job[playerid] != 0)
		{
			sendPlayerMessage(playerid, "[ERROR] Увольтесь с предыдущей работы.", red[0], red[1], red[2] );
			return;
		}
		if(driverlic[playerid] == 0)
		{
			sendPlayerMessage(playerid, "[ERROR] У вас нет водительских прав.", red[0], red[1], red[2] );
			return;
		}
		if(weaponlic[playerid] == 0)
		{
			sendPlayerMessage(playerid, "[ERROR] У вас нет лицензии на оружие.", red[0], red[1], red[2] );
			return;
		}
		if(crimes[playerid] != 0)
		{
			sendPlayerMessage(playerid, "[ERROR] Мы не берем в полицию преступников.", red[0], red[1], red[2] );
			return;
		}
		if(car_rental[playerid] != -1)
		{
			sendPlayerMessage( playerid, "[ERROR] У вас есть тс.", red[0], red[1], red[2] );
			return;
		}

		sendPlayerMessage(playerid, "Вам необходимо пройти экзамен на знание пдд, чтобы работать в полиции. Используйте команду /ответ (номер ответа), удачи!", blue[0], blue[1], blue[2] );
		
		callEvent("vopros1", playerid);

		test[playerid] = 1;
		otvet[playerid] = 0;
		ver_otvet[playerid] = 0;
	}
});

addCommandHandler( "обыскать",
function( playerid, id )
{
	local id = id.tointeger();

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	if(logged[id] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Игрок не в сети!", red[0], red[1], red[2] );
		return;
	}

	if(job[playerid] != 5)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не полицейский.", red[0], red[1], red[2] );
		return;
	}

	if(job[id] == 5)
	{
		sendPlayerMessage(playerid, "[ERROR] Игрок полицейский.", red[0], red[1], red[2] );
		return;
	}
	
	local myPos = getPlayerPosition( playerid );
	local Pos = getPlayerPosition( id );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], Pos[0], Pos[1], Pos[2], 5.0 );
	if(check)
	{
		if(gun[id] != 0 || gun_hand[id] != 0 || drugs[id] != 0)
		{
			foreach(i, playername in getPlayers()) 
			{
				local myPos = getPlayerPosition( i );
				local pos = getPlayerPosition( playerid );
				local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], pos[0], pos[1], pos[2], me_radius );
				if(check)
				{
					sendPlayerMessage( i, "Player["+playerid+"] обыскал Player["+id+"]", pink[0], pink[1], pink[2] );
				}
			}

			gun[id] = 0;
			gun_hand[id] = 0;
			drugs[id] = 0;

			removePlayerWeapon(id, 2, 0);
			removePlayerWeapon(id, 3, 0);
			removePlayerWeapon(id, 4, 0);
			removePlayerWeapon(id, 5, 0);
			removePlayerWeapon(id, 6, 0);
			removePlayerWeapon(id, 8, 0);
			removePlayerWeapon(id, 9, 0);
			removePlayerWeapon(id, 10, 0);
			removePlayerWeapon(id, 11, 0);

			exp[playerid] += 1;

			sendPlayerMessage( playerid, "Вы забрали посторонние предметы.", blue[0], blue[1], blue[2] );

			log("");
			log("[POLICE obisk] "+getPlayerName(playerid)+" obiskal "+getPlayerName(id));
		}
		else
		{
			sendPlayerMessage( playerid, "[ERROR] Посторонних предметов не найдено.", red[0], red[1], red[2] );
		}
	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] Вы далеко от игрока.", red[0], red[1], red[2]);
	}
});

addCommandHandler( "забрать",
function( playerid, name, id )
{
	local id = id.tointeger();

	if(name.tostring() != "права")
	{
		return;
	}

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	if(logged[id] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Игрок не в сети!", red[0], red[1], red[2] );
		return;
	}

	if(job[playerid] != 5)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не полицейский.", red[0], red[1], red[2] );
		return;
	}

	if(job[id] == 5)
	{
		sendPlayerMessage(playerid, "[ERROR] Игрок полицейский.", red[0], red[1], red[2] );
		return;
	}

	local myPos = getPlayerPosition( playerid );
	local Pos = getPlayerPosition( id );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], Pos[0], Pos[1], Pos[2], 5.0 );
	if(check)
	{
		if(driverlic[id] == 1)
		{
			foreach(i, playername in getPlayers()) 
			{
				local myPos = getPlayerPosition( i );
				local pos = getPlayerPosition( playerid );
				local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], pos[0], pos[1], pos[2], me_radius );
				if(check)
				{
					sendPlayerMessage( i, "Player["+playerid+"] забрал водительские права у Player["+id+"]", pink[0], pink[1], pink[2] );
				}
			}

			driverlic[id] = 0;

			exp[playerid] += 1;

			log("");
			log("[POLICE driverlic] "+getPlayerName(playerid)+" zabral driverlic y "+getPlayerName(id));
		}
		else
		{
			sendPlayerMessage( playerid, "[ERROR] Водительских прав нет.", red[0], red[1], red[2] );
		}
	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] Вы далеко от игрока.", red[0], red[1], red[2]);
	}
});

addCommandHandler( "забрать",
function( playerid, name, id )
{
	local id = id.tointeger();

	if(name.tostring() != "лно")
	{
		return;
	}

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	if(logged[id] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Игрок не в сети!", red[0], red[1], red[2] );
		return;
	}

	if(job[playerid] != 5)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не полицейский.", red[0], red[1], red[2] );
		return;
	}

	if(job[id] == 5)
	{
		sendPlayerMessage(playerid, "[ERROR] Игрок полицейский.", red[0], red[1], red[2] );
		return;
	}

	local myPos = getPlayerPosition( playerid );
	local Pos = getPlayerPosition( id );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], Pos[0], Pos[1], Pos[2], 5.0 );
	if(check)
	{
		if(weaponlic[id] == 1)
		{
			foreach(i, playername in getPlayers()) 
			{
				local myPos = getPlayerPosition( i );
				local pos = getPlayerPosition( playerid );
				local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], pos[0], pos[1], pos[2], me_radius );
				if(check)
				{
					sendPlayerMessage( i, "Player["+playerid+"] забрал лицензию на оружие у Player["+id+"]", pink[0], pink[1], pink[2] );
				}
			}

			weaponlic[id] = 0;

			exp[playerid] += 1;

			log("");
			log("[POLICE weaponlic] "+getPlayerName(playerid)+" zabral weaponlic y "+getPlayerName(id));
		}
		else
		{
			sendPlayerMessage( playerid, "[ERROR] Лицензии на оружие нет.", red[0], red[1], red[2] );
		}
	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] Вы далеко от игрока.", red[0], red[1], red[2]);
	}
});

function tzr(playerid)
{
	if(arest[playerid] == 1)
	{
		return;
	}
	
	taizer[playerid] = 0;
	togglePlayerControls( playerid, false );
	sendPlayerMessage(playerid, "Вы можете двигаться.", yellow[0], yellow[1], yellow[2]);
}
addCommandHandler( "оглушить",
function( playerid, id )
{
	local id = id.tointeger();

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	if(logged[id] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Игрок не в сети!", red[0], red[1], red[2] );
		return;
	}

	if(job[playerid] != 5)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не полицейский.", red[0], red[1], red[2] );
		return;
	}

	if(job[id] == 5)
	{
		sendPlayerMessage(playerid, "[ERROR] Игрок полицейский.", red[0], red[1], red[2] );
		return;
	}
	
	local myPos = getPlayerPosition( playerid );
	local Pos = getPlayerPosition( id );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], Pos[0], Pos[1], Pos[2], 5.0 );
	if(check)
	{
		if(arest[id] == 1)
		{
			sendPlayerMessage(playerid, "[ERROR] Игрок в наручниках.", red[0], red[1], red[2] );
			return;
		}

		if(taizer[id] == 0)
		{
			foreach(i, playername in getPlayers()) 
			{
				local myPos = getPlayerPosition( i );
				local pos = getPlayerPosition( playerid );
				local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], pos[0], pos[1], pos[2], me_radius );
				if(check)
				{
					sendPlayerMessage( i, "Player["+playerid+"] оглушил дубинкой Player["+id+"]", pink[0], pink[1], pink[2] );
				}
			}

			taizer[id] = 1;

			togglePlayerControls( id, true );
			local rTimer = timer( tzr, 15000, 1, id );

			log("");
			log("[POLICE arest] "+getPlayerName(playerid)+" oglyshil "+getPlayerName(id));
		}
		else
		{
			sendPlayerMessage( playerid, "[ERROR] Игрок оглушен.", red[0], red[1], red[2] );
		}
	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] Вы далеко от игрока.", red[0], red[1], red[2]);
	}
});

addCommandHandler( "наручники",
function( playerid, id )
{
	local id = id.tointeger();

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	if(logged[id] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Игрок не в сети!", red[0], red[1], red[2] );
		return;
	}

	if(job[playerid] != 5)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не полицейский.", red[0], red[1], red[2] );
		return;
	}

	if(job[id] == 5)
	{
		sendPlayerMessage(playerid, "[ERROR] Игрок полицейский.", red[0], red[1], red[2] );
		return;
	}
	
	local myPos = getPlayerPosition( playerid );
	local Pos = getPlayerPosition( id );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], Pos[0], Pos[1], Pos[2], 5.0 );
	if(check)
	{
		if(arest[id] == 0)
		{
			foreach(i, playername in getPlayers()) 
			{
				local myPos = getPlayerPosition( i );
				local pos = getPlayerPosition( playerid );
				local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], pos[0], pos[1], pos[2], me_radius );
				if(check)
				{
					sendPlayerMessage( i, "Player["+playerid+"] надел наручники на Player["+id+"]", pink[0], pink[1], pink[2] );
				}
			}

			arest[id] = 1;

			togglePlayerControls( id, true );

			log("");
			log("[POLICE arest] "+getPlayerName(playerid)+" odel narychniki "+getPlayerName(id));
		}
		else
		{
			foreach(i, playername in getPlayers()) 
			{
				local myPos = getPlayerPosition( i );
				local pos = getPlayerPosition( playerid );
				local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], pos[0], pos[1], pos[2], me_radius );
				if(check)
				{
					sendPlayerMessage( i, "Player["+playerid+"] снял наручники с Player["+id+"]", pink[0], pink[1], pink[2] );
				}
			}

			arest[id] = 0;

			togglePlayerControls( id, false );

			log("");
			log("[POLICE arest] "+getPlayerName(playerid)+" snyal narychniki "+getPlayerName(id));
		}
	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] Вы далеко от игрока.", red[0], red[1], red[2]);
	}
});

addCommandHandler( "арест",
function( playerid, id )
{
	local id = id.tointeger();

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	if(logged[id] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Игрок не в сети!", red[0], red[1], red[2] );
		return;
	}

	if(job[playerid] != 5)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не полицейский.", red[0], red[1], red[2] );
		return;
	}

	if(job[id] == 5)
	{
		sendPlayerMessage(playerid, "[ERROR] Игрок полицейский.", red[0], red[1], red[2] );
		return;
	}
	
	local myPos = getPlayerPosition( playerid );
	local Pos = getPlayerPosition( id );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], Pos[0], Pos[1], Pos[2], 5.0 );
	if(check)
	{
		if(arest[id] != 1)
		{
			sendPlayerMessage(playerid, "[ERROR] Игрок не в наручниках.", red[0], red[1], red[2]);
			return;
		}
		if(isPlayerInVehicle(id))
		{
			sendPlayerMessage(playerid, "[ERROR] Игрок в машине.", red[0], red[1], red[2]);
			return; 
		}
			foreach(i, playername in getPlayers()) 
			{
				local myPos = getPlayerPosition( i );
				local pos = getPlayerPosition( playerid );
				local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], pos[0], pos[1], pos[2], me_radius );
				if(check)
				{
					sendPlayerMessage( i, "Player["+playerid+"] отправил в тюрьму Player["+id+"] на "+crimes[id]*60+" секунд.", pink[0], pink[1], pink[2] );
				}
			}

			aresttimer[id] = crimes[id]*60;
			arest[id] = 0;
			gun[id] = 0;
			gun_hand[id] = 0;

			removePlayerWeapon(id, 2, 0);
			removePlayerWeapon(id, 3, 0);
			removePlayerWeapon(id, 4, 0);
			removePlayerWeapon(id, 5, 0);
			removePlayerWeapon(id, 6, 0);
			removePlayerWeapon(id, 8, 0);
			removePlayerWeapon(id, 9, 0);
			removePlayerWeapon(id, 10, 0);
			removePlayerWeapon(id, 11, 0);

			setPlayerPosition( id, -1030.42,1712.74,10.3595 );
			setPlayerRotation( id, 0.0, 0.0, 180.0 );
			togglePlayerControls( id, false );

			if(crimes[id] == 0)
			{
				exp[playerid] -= 1;
			}
			else
			{
				exp[playerid] += 1;
			}

			log("");
			log("[POLICE prison] "+getPlayerName(playerid)+" posadil "+getPlayerName(id));
	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] Вы далеко от игрока.", red[0], red[1], red[2]);
	}
});

addCommandHandler( "сдаться",
function( playerid )
{
	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}
	
	local myPos = getPlayerPosition( playerid );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -378.987, 654.699, -11.5013, 2.0 );
	if(check)
	{
		if(isPlayerInVehicle(playerid))
		{
			sendPlayerMessage(playerid, "[ERROR] Вы в машине.", red[0], red[1], red[2]);
			return; 
		}

		if(crimes[playerid] == 0)
		{
			sendPlayerMessage(playerid, "[ERROR] Вы не преступленик.", red[0], red[1], red[2]);
			return;
		}
			aresttimer[playerid] = crimes[playerid]*30;
			arest[playerid] = 0;
			gun[playerid] = 0;
			gun_hand[playerid] = 0;

			removePlayerWeapon(playerid, 2, 0);
			removePlayerWeapon(playerid, 3, 0);
			removePlayerWeapon(playerid, 4, 0);
			removePlayerWeapon(playerid, 5, 0);
			removePlayerWeapon(playerid, 6, 0);
			removePlayerWeapon(playerid, 8, 0);
			removePlayerWeapon(playerid, 9, 0);
			removePlayerWeapon(playerid, 10, 0);
			removePlayerWeapon(playerid, 11, 0);

			setPlayerPosition( playerid, -1030.42,1712.74,10.3595 );
			setPlayerRotation( playerid, 0.0, 0.0, 180.0 );
			togglePlayerControls( playerid, false );

			sendPlayerMessage(playerid, "Вам сидеть "+aresttimer[playerid]+" секунд.", yellow[0], yellow[1], yellow[2]);

			log("");
			log("[POLICE prison] "+getPlayerName(playerid)+" sel sam");
	}
});

addCommandHandler( "владелец",
function( playerid, number )
{
	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	local number = number.tostring();

	local myPos = getPlayerPosition( playerid );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -378.987, 654.699, -11.5013, 2.0 );
	if(check)
	{
		local vehicleid = getPlayerVehicle(playerid);
		local model = getVehicleModel(vehicleid);

			local result = database.query( "SELECT COUNT() FROM carnumber_bd WHERE carnumber = '"+number+"'" );
			if(result[1]["COUNT()"] == 1)
			{
				result = database.query( "SELECT * FROM carnumber_bd WHERE carnumber = '"+number+"'" );

				sendPlayerMessage(playerid, "(Диспетчер) Владелец: "+result[1]["ownername"]+" | Ключ: "+result[1]["ownername_key"], blue[0], blue[1], blue[2] );
				sendPlayerMessage(playerid, "Штраф: "+result[1]["fine"]+" | Кто выписал: "+result[1]["fine_name"], blue[0], blue[1], blue[2] );
			}
			else
			{
				sendPlayerMessage(playerid, "[ERROR] Этот номер не числится в базе.", red[0], red[1], red[2] );
			}
	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] Вы далеко от EBPD.", red[0], red[1], red[2] );
	}
});

addCommandHandler( "поиск",
function( playerid, number )
{
	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	local number = number.tostring();

		local vehicleid = getPlayerVehicle(playerid);
		local model = getVehicleModel(vehicleid);

			local result = database.query( "SELECT COUNT() FROM carnumber_bd WHERE carnumber = '"+number+"'" );
			if(result[1]["COUNT()"] == 1)
			{
				result = database.query( "SELECT * FROM carnumber_bd WHERE carnumber = '"+number+"'" );

				if(result[1]["ownername"] != getPlayerName(playerid))
				{
					sendPlayerMessage(playerid, "[ERROR] Это не ваше авто.", red[0], red[1], red[2] );
					return;
				}

				triggerClientEvent( playerid, "search_car", result[1]["spawnx"], result[1]["spawny"]);
			}
			else
			{
				sendPlayerMessage(playerid, "[ERROR] Этот номер не числится в базе.", red[0], red[1], red[2] );
			}
});

addCommandHandler( "штраф",
function( playerid, cash )
{
	local cash = cash.tointeger();
	local finecar = 5000;
	local playername = getPlayerName(playerid);

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	if(job[playerid] != 5)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не полицейский.", red[0], red[1], red[2] );
		return;
	}
		local vehicleid = getPlayerVehicle(playerid);
		local number = getVehiclePlateText(vehicleid);

		if(isPlayerInVehicle(playerid))
		{
			if(cash > finecar)
			{
				sendPlayerMessage(playerid, "[ERROR] Максимальная сумма штрафа "+finecar+"$", red[0], red[1], red[2] );
				return;
			}

			if ( cash < 1 )
			{
				sendPlayerMessage(playerid, "[ERROR] Введите значение больше 0", red[0], red[1], red[2]);
				return;
			}

			local result = database.query( "SELECT COUNT() FROM carnumber_bd WHERE carnumber = '"+number+"'" );
		    if(result[1]["COUNT()"] == 1)
		    {
				result = database.query( "SELECT * FROM carnumber_bd WHERE carnumber = '"+number+"'" );

				if(result[1]["fine"] > 0)
				{
					sendPlayerMessage(playerid, "[ERROR] Этот автомобиль оштрафован.", red[0], red[1], red[2]);
					return;
				}
				if(result[1]["sale"] > 0)
				{
					return;
				}
				
				database.query( "UPDATE carnumber_bd SET fine = '"+cash+"', fine_name = '"+playername+"' WHERE carnumber = '"+number+"'");

				exp[playerid] += 1;

				foreach(i, playername in getPlayers())
				{
					local myPos = getPlayerPosition( i );
					local pos = getPlayerPosition( playerid );
					local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], pos[0], pos[1], pos[2], me_radius );
					if(check)
					{
						sendPlayerMessage( i, "Player["+playerid+"] выписал штраф на "+cash+"$", pink[0], pink[1], pink[2] );
					}
				}

				log("");
				log("[POLICE fine] "+getPlayerName(playerid)+" vipisal fine "+number+" vladelec: "+result[1]["ownername"]+" "+cash+"$");
			}
			else
			{
				sendPlayerMessage(playerid, "[ERROR] Этот автомобиль нельзя оштрафовать.", red[0], red[1], red[2]);
			}
		}
		else
		{
			sendPlayerMessage(playerid, "[ERROR] Вы должны сидеть в машине на которую выписываете штраф.", red[0], red[1], red[2]);
			return; 
		}
});

addCommandHandler( "розыск",
function( playerid, id )
{
	local id = id.tointeger();

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	if(!isPlayerConnected(id))
	{
		sendPlayerMessage(playerid, "[ERROR] Игрок не в сети!", red[0], red[1], red[2] );
		return;
	}

	if(job[playerid] != 5)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не полицейский.", red[0], red[1], red[2] );
		return;
	}

	if(job[id] == 5)
	{
		sendPlayerMessage(playerid, "[ERROR] Игрок полицейский.", red[0], red[1], red[2] );
		return;
	}

	player_id_cops = getPlayerName( id );

	sendPlayerMessage(playerid, "Вы объявили в розыск "+player_id_cops, blue[0], blue[1], blue[2] );

	log("");
	log("[POLICE search] "+getPlayerName(playerid)+" search "+player_id_cops);
});

addCommandHandler( "отменить",
function( playerid, name )
{
	if(name.tostring() != "розыск")
	{
		return;
	}

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	if(job[playerid] != 5)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не полицейский.", red[0], red[1], red[2] );
		return;
	}

	player_id_cops = "0";

	foreach (i, playername in getPlayers())
	{
		if(logged[i] == 1 && job[i] == 5)
		{
			triggerClientEvent(i, "removegps", "");
		}
	}

	sendPlayerMessage(playerid, "Розыск отменен.", blue[0], blue[1], blue[2] );

	log("");
	log("[POLICE cancel search] "+getPlayerName(playerid)+" cancel search");
});

addCommandHandler( "тюрьма",
function( playerid )
{
	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	if(aresttimer[playerid] == -1)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не в тюрьме.", red[0], red[1], red[2] );
		return;
	}

	sendPlayerMessage(playerid, "Вам сидеть в тюрьме "+aresttimer[playerid]+" секунд.", yellow[0], yellow[1], yellow[2]);
});

//вопросы для копов
addCommandHandler( "ответ",
function( playerid, id )
{
	local id = id.tointeger();

	local myPos = getPlayerPosition( playerid );
	local check1 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -378.987, 654.699, -11.5013, 2.0 );
	if(check1)
	{
		if(isPlayerInVehicle(playerid))
		{
			sendPlayerMessage(playerid, "[ERROR] Вы в машине.", red[0], red[1], red[2] );
			return;
		}
		if(job[playerid] != 0)
		{
			sendPlayerMessage(playerid, "[ERROR] Увольтесь с предыдущей работы.", red[0], red[1], red[2] );
			return;
		}
		if(driverlic[playerid] == 0)
		{
			sendPlayerMessage(playerid, "[ERROR] У вас нет водительских прав.", red[0], red[1], red[2] );
			return;
		}
		if(weaponlic[playerid] == 0)
		{
			sendPlayerMessage(playerid, "[ERROR] У вас нет лицензии на оружие.", red[0], red[1], red[2] );
			return;
		}
		if(test[playerid] == 0)
		{
			sendPlayerMessage(playerid, "[ERROR] Вы не начали проходить экзамен.", red[0], red[1], red[2] );
			return;
		}

		if(id >=1 && id <= 3)
		{


		if(otvet[playerid] == 0)//ответ на 1 вопрос
		{
			if(id == 2)
			{
				ver_otvet[playerid] += 1;
			}

			callEvent("vopros2", playerid);

			otvet[playerid] += 1;
			log("");
			log("otvet["+getPlayerName(playerid)+"] "+otvet[playerid]);
			log("ver_otvet["+getPlayerName(playerid)+"] "+ver_otvet[playerid]);
			return;
		}

		if(otvet[playerid] == 1)//ответ на 2 вопрос
		{
			if(id == 3)
			{
				ver_otvet[playerid] += 1;
			}
			callEvent("vopros3", playerid);

			otvet[playerid] += 1;
			log("");
			log("otvet["+getPlayerName(playerid)+"] "+otvet[playerid]);
			log("ver_otvet["+getPlayerName(playerid)+"] "+ver_otvet[playerid]);
			return;
		}

		if(otvet[playerid] == 2)//ответ на 3 вопрос
		{
			if(id == 2)
			{
				ver_otvet[playerid] += 1;
			}
			callEvent("vopros4", playerid);

			otvet[playerid] += 1;
			log("");
			log("otvet["+getPlayerName(playerid)+"] "+otvet[playerid]);
			log("ver_otvet["+getPlayerName(playerid)+"] "+ver_otvet[playerid]);
			return;
		}

		if(otvet[playerid] == 3)//ответ на 4 вопрос
		{
			if(id == 1)
			{
				ver_otvet[playerid] += 1;
			}
			callEvent("vopros5", playerid);

			otvet[playerid] += 1;
			log("");
			log("otvet["+getPlayerName(playerid)+"] "+otvet[playerid]);
			log("ver_otvet["+getPlayerName(playerid)+"] "+ver_otvet[playerid]);
			return;
		}

		if(otvet[playerid] == 4)//ответ на 5 вопрос
		{
			if(id == 3)
			{
				ver_otvet[playerid] += 1;
			}
			callEvent("vopros6", playerid);

			otvet[playerid] += 1;
			log("");
			log("otvet["+getPlayerName(playerid)+"] "+otvet[playerid]);
			log("ver_otvet["+getPlayerName(playerid)+"] "+ver_otvet[playerid]);
			return;
		}

		if(otvet[playerid] == 5)//ответ на 6 вопрос
		{
			if(id == 1)
			{
				ver_otvet[playerid] += 1;
			}
			callEvent("vopros7", playerid);

			otvet[playerid] += 1;
			log("");
			log("otvet["+getPlayerName(playerid)+"] "+otvet[playerid]);
			log("ver_otvet["+getPlayerName(playerid)+"] "+ver_otvet[playerid]);
			return;
		}

		if(otvet[playerid] == 6)//ответ на 7 вопрос
		{
			if(id == 3)
			{
				ver_otvet[playerid] += 1;
			}
			callEvent("vopros8", playerid);

			otvet[playerid] += 1;
			log("");
			log("otvet["+getPlayerName(playerid)+"] "+otvet[playerid]);
			log("ver_otvet["+getPlayerName(playerid)+"] "+ver_otvet[playerid]);
			return;
		}

		if(otvet[playerid] == 7)//ответ на 8 вопрос
		{
			if(id == 3)
			{
				ver_otvet[playerid] += 1;
			}
			callEvent("vopros9", playerid);

			otvet[playerid] += 1;
			log("");
			log("otvet["+getPlayerName(playerid)+"] "+otvet[playerid]);
			log("ver_otvet["+getPlayerName(playerid)+"] "+ver_otvet[playerid]);
			return;
		}

		if(otvet[playerid] == 8)//ответ на 9 вопрос
		{
			if(id == 1)
			{
				ver_otvet[playerid] += 1;
			}
			callEvent("vopros10", playerid);

			otvet[playerid] += 1;
			log("");
			log("otvet["+getPlayerName(playerid)+"] "+otvet[playerid]);
			log("ver_otvet["+getPlayerName(playerid)+"] "+ver_otvet[playerid]);
			return;
		}

		if(otvet[playerid] == 9)//ответ на 10 вопрос
		{
			if(id == 2)
			{
				ver_otvet[playerid] += 1;
			}

			otvet[playerid] += 1;
			log("");
			log("otvet["+getPlayerName(playerid)+"] "+otvet[playerid]);
			log("ver_otvet["+getPlayerName(playerid)+"] "+ver_otvet[playerid]);
		}

		if(otvet[playerid] == 10)
		{
			if(ver_otvet[playerid] == 10)
			{
				job[playerid] = 5;

				local skin_random = random(75,76);

				setPlayerModel(playerid, skin_random);

				sendPlayerMessage(playerid, "Вы сдали экзамен, добро пожаловать в полицию кадет, садитесь в полицейскую машину и патрулируйте город :-)", blue[0], blue[1], blue[2] );
				sendPlayerMessage(playerid, "Езжайте в магазин оружия и возьмите себе табельный пистолет.", blue[0], blue[1], blue[2] );

				callEvent("car_rental_spawn", playerid, 42, -377.817,646.011,-11.2599+2, 0.0, 255, 255, 255, 0, 0, 0, car_rental_fuel[playerid] );

				log("");
				log("ZDAL TEST ["+getPlayerName(playerid)+"] SKIN " +skin_random);
			}
			else
			{
				sendPlayerMessage(playerid, "Вы ответили правильно на "+ver_otvet[playerid]+" вопросов из 10", blue[0], blue[1], blue[2] );
				sendPlayerMessage(playerid, "Увы, но вы не сдали экзамен, поробуйте ещё раз :-(", blue[0], blue[1], blue[2] );

				log("");
				log("NE ZDAL TEST ["+getPlayerName(playerid)+"]");
			}

			test[playerid] = 0;
			otvet[playerid] = 0;
			ver_otvet[playerid] = 0;
		}


		}
		else
		{
			sendPlayerMessage(playerid, "[ERROR] От 1 до 3", red[0], red[1], red[2] );
		}

	}
});

//медики EB
addEventHandler( "egh",
function( playerid )
{
	local myPos = getPlayerPosition( playerid );
	local check1 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -393.394,913.983,-20.0026, 2.0 );
	if(check1)
	{
		if(job[playerid] != 0)
		{
			sendPlayerMessage(playerid, "[ERROR] Увольтесь с предыдущей работы.", red[0], red[1], red[2] );
			return;
		}
		if(driverlic[playerid] == 0)
		{
			sendPlayerMessage(playerid, "[ERROR] У вас нет водительских прав.", red[0], red[1], red[2] );
			return;
		}
		if(crimes[playerid] != 0)
		{
			sendPlayerMessage(playerid, "[ERROR] Мы не берем на работу преступников.", red[0], red[1], red[2] );
			return;
		}
		if(car_rental[playerid] != -1)
		{
			sendPlayerMessage( playerid, "[ERROR] У вас есть тс.", red[0], red[1], red[2] );
			return;
		}

		job[playerid] = 8;

		sendPlayerMessage(playerid, "Вы устроились парамедиком в Госпиталь Эмпайр-Бэй, чтобы оказать помощь пострадавшему нажмите Е (следуйте за красным кружком)", yellow[0], yellow[1], yellow[2] );

		callEvent("car_rental_spawn", playerid, 42, -412.618,899.441,-19.0+2, 136.0, 255, 255, 255, 150, 0, 0, car_rental_fuel[playerid] );

		callEvent("egh_coord", playerid);
	}
});

addEventHandler( "egh_coord",
function(playerid)
{
	if(job[playerid] == 8)
	{
		local randomize = random(0,coord_paramedic_chislo-1);

		test[playerid] = randomize;//координаты проишествия

		triggerClientEvent(playerid, "job_gps", coord_paramedic[randomize][0], coord_paramedic[randomize][1]);
	}
});

addEventHandler( "egh_paramedic",
function( playerid )
{
	if(job[playerid] != 8)
	{
		return;
	}

	local myPos = getPlayerPosition( playerid );
	local check1 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], coord_paramedic[test[playerid]][0], coord_paramedic[test[playerid]][1], coord_paramedic[test[playerid]][2], 5.0 );
	if(check1)
	{
		if(isPlayerInVehicle(playerid))
		{
			sendPlayerMessage(playerid, "[ERROR] Выйдите из машины.", red[0], red[1], red[2] );
			return;
		}
		if(otvet[playerid] != 0)
		{
			sendPlayerMessage(playerid, "[ERROR] Ответьте на вопрос.", red[0], red[1], red[2] );
			return;
		}

		local randomize = random(1,10);

		otvet[playerid] = randomize;//номер вопроса

		if(randomize == 1)
		{
			callEvent("paramedic_vopros1", playerid);
		}
		if(randomize == 2)
		{
			callEvent("paramedic_vopros2", playerid);
		}
		if(randomize == 3)
		{
			callEvent("paramedic_vopros3", playerid);
		}
		if(randomize == 4)
		{
			callEvent("paramedic_vopros4", playerid);
		}
		if(randomize == 5)
		{
			callEvent("paramedic_vopros5", playerid);
		}
		if(randomize == 6)
		{
			callEvent("paramedic_vopros6", playerid);
		}
		if(randomize == 7)
		{
			callEvent("paramedic_vopros7", playerid);
		}
		if(randomize == 8)
		{
			callEvent("paramedic_vopros8", playerid);
		}
		if(randomize == 9)
		{
			callEvent("paramedic_vopros9", playerid);
		}
		if(randomize == 10)
		{
			callEvent("paramedic_vopros10", playerid);
		}

		sendPlayerMessage(playerid, "Чтобы помочь пострадавшему пропишите /вариант и номер правильного ответа", yellow[0], yellow[1], yellow[2] );
	}
});

function text_true(playerid) 
{
	exp[playerid] += 1;

	sendPlayerMessage(playerid, "Вы ответили верно +1 EXP, езжайте на следующий вызов.", yellow[0], yellow[1], yellow[2] );
}

function text_false(playerid) 
{
	exp[playerid] -= 1;
	crimes[playerid] += 1;

	sendPlayerMessage(playerid, "Пациент умер -1 EXP, количество преступлений повысилось. Тебе нужно собраться, иначе нам придется попрощаться :-(", blue[0], blue[1], blue[2] );
}

addCommandHandler( "вариант",
function( playerid, id )
{
	local id = id.tointeger();

	if(job[playerid] != 8)
	{
		return;
	}

	local myPos = getPlayerPosition( playerid );
	local check1 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], coord_paramedic[test[playerid]][0], coord_paramedic[test[playerid]][1], coord_paramedic[test[playerid]][2], 5.0 );
	if(check1)
	{
		if(isPlayerInVehicle(playerid))
		{
			sendPlayerMessage(playerid, "[ERROR] Выйдите из машины.", red[0], red[1], red[2] );
			return;
		}
		if(otvet[playerid] == 0)
		{
			sendPlayerMessage(playerid, "[ERROR] Нажмите Е", red[0], red[1], red[2] );
			return;
		}

		if(otvet[playerid] == 1)
		{
			if(id == 3)
			{
				text_true(playerid);
			}
			else
			{
				text_false(playerid);
			}
		}
		if(otvet[playerid] == 2)
		{
			if(id == 1)
			{
				text_true(playerid);
			}
			else
			{
				text_false(playerid);
			}
		}
		if(otvet[playerid] == 3)
		{
			if(id == 3)
			{
				text_true(playerid);
			}
			else
			{
				text_false(playerid);
			}
		}
		if(otvet[playerid] == 4)
		{
			if(id == 2)
			{
				text_true(playerid);
			}
			else
			{
				text_false(playerid);
			}
		}
		if(otvet[playerid] == 5)
		{
			if(id == 1)
			{
				text_true(playerid);
			}
			else
			{
				text_false(playerid);
			}
		}
		if(otvet[playerid] == 6)
		{
			if(id == 2)
			{
				text_true(playerid);
			}
			else
			{
				text_false(playerid);
			}
		}
		if(otvet[playerid] == 7)
		{
			if(id == 1)
			{
				text_true(playerid);
			}
			else
			{
				text_false(playerid);
			}
		}
		if(otvet[playerid] == 8)
		{
			if(id == 2)
			{
				text_true(playerid);
			}
			else
			{
				text_false(playerid);
			}
		}
		if(otvet[playerid] == 9)
		{
			if(id == 3)
			{
				text_true(playerid);
			}
			else
			{
				text_false(playerid);
			}
		}
		if(otvet[playerid] == 10)
		{
			if(id == 3)
			{
				text_true(playerid);
			}
			else
			{
				text_false(playerid);
			}
		}

		otvet[playerid] = 0;

		triggerClientEvent(playerid, "removegps", "");

		callEvent("egh_coord", playerid);
	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] Вы далеко от места проишествия.", red[0], red[1], red[2] );
	}
});

//перевозка наркотиков
local narko = 0;
function narkotime()
{
	narko = 0;
}
addEventHandler( "buydrugs",
function( playerid )
{
	local myPos = getPlayerPosition( playerid );
	local check1 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 426.998,78.4652,-21.249, 5.0 );//триада
	local check2 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -122.825,1753.56,-18.7074, 3.0 );//место на свалке бруски

	local randomize = random(1,1000);
	local ratio1 = 10;
	local ratio2 = 20;

	if(check1)
	{
		if(job[playerid] == 5)
		{
			sendPlayerMessage(playerid, "[ERROR] Вы полицейский.", red[0], red[1], red[2] );
			return;
		}

		if(money[playerid] < ratio1)
		{
			return;
		}

		if(drugs[playerid] != 0)
		{
			sendPlayerMessage(playerid, "[ERROR] У вас есть наркотики.", red[0], red[1], red[2] );
			return;
		}

		if(narko == 1)
		{
			sendPlayerMessage(playerid, "[ERROR] Перевозка наркотиков доступно один раз в 30 мин.", red[0], red[1], red[2]);
			return;
		}

		while(true)
		{
			if(money[playerid] < randomize*ratio1)
			{
				randomize = random(1,1000);
			}
			else
			{
				crimes[playerid] += 5;
		    	money[playerid] -= randomize*ratio1;
		    	drugs[playerid] = randomize;
		    	break;
			}
		}

    	foreach(i, playername in getPlayers())
		{
			if(job[i] == 5)
			{
				sendPlayerMessage(i, "(ДИСПЕТЧЕР) Внимание, наш информатор сообщил о сделке, "+getPlayerName(playerid)+" купил наркотики, объявлен план перехват!", blue[0], blue[1], blue[2]);	
			}
		}

    	sendPlayerMessage(playerid, "Вы купили "+randomize+" граммов наркотиков за "+randomize*ratio1+"$, езжайте на свалку бруски и покладите пакет в здании с тремя гаражами, если вы умрете, то наркотики пропадут.", orange[0], orange[1], orange[2]);

    	log("");
		log("[BUY DRUGS] "+getPlayerName(playerid)+" drugs "+randomize+" money "+randomize*ratio1);

		narko = 1;

		local rTimer = timer( narkotime, 1800000, 1 );
	}

	if(check2)
	{
		if(job[playerid] == 5)
		{
			sendPlayerMessage(playerid, "[ERROR] Вы полицейский.", red[0], red[1], red[2] );
			return;
		}

		if(drugs[playerid] == 0)
		{
			sendPlayerMessage(playerid, "[ERROR] У вас нет наркотиков.", red[0], red[1], red[2] );
			return;
		}

    	money[playerid] += drugs[playerid]*ratio2;

    	sendPlayerMessage(playerid, "Вы продали наркотики за "+drugs[playerid]*ratio2+"$", green[0], green[1], green[2]);

    	log("");
		log("[SELL DRUGS] "+getPlayerName(playerid)+" money "+drugs[playerid]*ratio2);

		drugs[playerid] = 0;
	}
});

//ограбление ювелирки и магазинов одежды
local ograblenie = 0;
function grab()
{
	ograblenie = 0;
}
addEventHandler( "robbery",
function( playerid )
{
	local randomize = random(0,1);
	local randomize1 = random(5000,10000);
	local randomize2 = random(1,5000);

	local myPos = getPlayerPosition( playerid );
    local uvelirka = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -534.975,-42.5656,1.03805, 5.0 );

    local odejda1 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1292.83,1706.43,10.5592, 5.0 );//кингстон1
    local odejda2 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1425.29,1299.52,-13.7195, 5.0 );//кингстон2
    local odejda3 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1377.39,389.123,-23.7368, 5.0 );//хантерс-пойнт
    local odejda4 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1530.26,3.44592,-17.8468, 5.0 );//сэнд-айленд
    local odejda5 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -374.002,-448.638,-17.2661, 5.0 );//сауспорт
    local odejda6 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 347.46,41.2144,-24.1478, 5.0 );//ойстер-бэй1
    local odejda7 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 429.424,305.764,-20.1786, 5.0 );//китайский квартал
    local odejda8 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -38.9963,389.568,-13.9963, 5.0 );//ист-сайд
    local odejda9 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -2.71507,560.705,-19.4068, 5.0 );//маленькая италия1
    local odejda10 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 274.712,775.562,-21.2439, 5.0 );//маленькая италия2
    local odejda11 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -518.197,874.753,-19.3224, 5.0 );//аптаун
    local odejda12 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -624.275,291.753,-0.267097, 5.0 );//вест-сайд
    local odejda13 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 415.433,-290.474,-20.1622, 5.0 );//ойстер-бэй2

	if(uvelirka || odejda1 || odejda2 || odejda3 || odejda4 || odejda5 || odejda6 || odejda7 || odejda8 || odejda9 || odejda10 || odejda11 || odejda12 || odejda13)
    {
		if(ograblenie == 1)
		{
			sendPlayerMessage(playerid, "[ERROR] Ограбление доступно один раз в 10 мин.", red[0], red[1], red[2]);
			return;
		}

		if(job[playerid] == 5)
		{
			sendPlayerMessage(playerid, "[ERROR] Вы полицейский.", red[0], red[1], red[2] );
			return;
		}
		
		if(randomize == 1)
		{
			ograblenie = 1;

			local rTimer = timer( grab, 600000, 1 );
		}
		else
		{
			sendPlayerMessage(playerid, "Вам не удалось ограбить.", yellow[0], yellow[1], yellow[2]);

			ograblenie = 1;

			local rTimer = timer( grab, 600000, 1 );

			log("");
			log("[NO_OGRABLENIE] "+getPlayerName(playerid));

			return;
		}
	}	

	if(uvelirka)
    {
    	crimes[playerid] += 10;
    	money[playerid] += randomize1;

    	foreach(i, playername in getPlayers())
		{
			if(job[i] == 5)
			{
				sendPlayerMessage(i, "(ДИСПЕТЧЕР) Внимание, ограбление в ювелирке, подозреваемый возможно вооружен, всем машинам проследовать на вызов!", blue[0], blue[1], blue[2]);	
			}
		}

    	sendPlayerMessage(playerid, "Вам удалось ограбить ювелирку и унести украшений на сумму "+randomize1+"$", green[0], green[1], green[2]);

    	log("");
		log("[OGRABLENIE] "+getPlayerName(playerid)+" money "+randomize1);
    }

    if(odejda1 || odejda2 || odejda3 || odejda4 || odejda5 || odejda6 || odejda7 || odejda8 || odejda10 || odejda11 || odejda12 || odejda13)
    {
    	crimes[playerid] += 5;
    	money[playerid] += randomize2;

    	foreach(i, playername in getPlayers())
		{
			if(job[i] == 5)
			{	
				if(odejda1 || odejda2)
				{
					sendPlayerMessage(i, "(ДИСПЕТЧЕР) Внимание, ограбление магазина одежды в районе: кингстон, подозреваемый возможно вооружен, всем машинам проследовать на вызов!", blue[0], blue[1], blue[2]);
				}
				if(odejda3)
				{
					sendPlayerMessage(i, "(ДИСПЕТЧЕР) Внимание, ограбление магазина одежды в районе: хантерс-пойнт, подозреваемый возможно вооружен, всем машинам проследовать на вызов!", blue[0], blue[1], blue[2]);
				}
				if(odejda4)
				{
					sendPlayerMessage(i, "(ДИСПЕТЧЕР) Внимание, ограбление магазина одежды в районе: сэнд-айленд, подозреваемый возможно вооружен, всем машинам проследовать на вызов!", blue[0], blue[1], blue[2]);
				}
				if(odejda5)
				{
					sendPlayerMessage(i, "(ДИСПЕТЧЕР) Внимание, ограбление магазина одежды в районе: сауспорт, подозреваемый возможно вооружен, всем машинам проследовать на вызов!", blue[0], blue[1], blue[2]);
				}
				if(odejda6 || odejda13)
				{
					sendPlayerMessage(i, "(ДИСПЕТЧЕР) Внимание, ограбление магазина одежды в районе: ойстер-бэй, подозреваемый возможно вооружен, всем машинам проследовать на вызов!", blue[0], blue[1], blue[2]);
				}
				if(odejda7)
				{
					sendPlayerMessage(i, "(ДИСПЕТЧЕР) Внимание, ограбление магазина одежды в районе: китайский квартал, подозреваемый возможно вооружен, всем машинам проследовать на вызов!", blue[0], blue[1], blue[2]);
				}
				if(odejda8)
				{
					sendPlayerMessage(i, "(ДИСПЕТЧЕР) Внимание, ограбление магазина одежды в районе: ист-сайд, подозреваемый возможно вооружен, всем машинам проследовать на вызов!", blue[0], blue[1], blue[2]);
				}
				if(odejda9 || odejda10)
				{
					sendPlayerMessage(i, "(ДИСПЕТЧЕР) Внимание, ограбление магазина одежды в районе: маленькая италия, подозреваемый возможно вооружен, всем машинам проследовать на вызов!", blue[0], blue[1], blue[2]);
				}
				if(odejda11)
				{
					sendPlayerMessage(i, "(ДИСПЕТЧЕР) Внимание, ограбление магазина одежды в районе: аптаун, подозреваемый возможно вооружен, всем машинам проследовать на вызов!", blue[0], blue[1], blue[2]);
				}
				if(odejda12)
				{
					sendPlayerMessage(i, "(ДИСПЕТЧЕР) Внимание, ограбление магазина одежды в районе: вест-сайд, подозреваемый возможно вооружен, всем машинам проследовать на вызов!", blue[0], blue[1], blue[2]);
				}
			}
		}

    	sendPlayerMessage(playerid, "Вам удалось ограбить магазин одежды и обчистить кассу на сумму "+randomize2+"$", green[0], green[1], green[2]);

    	log("");
		log("[OGRABLENIE] "+getPlayerName(playerid)+" money "+randomize2);
    }
});

//мерия
addEventHandler( "hmeria",
function ( playerid )
{
	local myPos = getPlayerPosition( playerid );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -115.11,-63.1035,-11.041, 10.0 );
	if(check)
	{
		sendPlayerMessage(playerid, "====[ Команды ]====", yellow[0], yellow[1], yellow[2] );
		sendPlayerMessage(playerid, "/купить права", yellow[0], yellow[1], yellow[2] );
		sendPlayerMessage(playerid, "/купить лно (лицензию на оружие)", yellow[0], yellow[1], yellow[2] );
		sendPlayerMessage(playerid, "/купить лнб (лицензию на бизнес)", yellow[0], yellow[1], yellow[2] );
	}
});

addCommandHandler("купить",
function(playerid, name) 
{
	if(name.tostring() != "права")
	{
		return;
	}

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	local myPos = getPlayerPosition( playerid );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -115.11,-63.1035,-11.041, 10.0 );
	if(!check)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не у мерии (зеленый значек на карте)", red[0], red[1], red[2] );
		return;
	}
	
	if(money[playerid] < prava_price)
	{
		sendPlayerMessage(playerid, "[ERROR] Недостаточно средств, необходимо "+prava_price+"$", red[0], red[1], red[2] );
		return;
	}

	if(driverlic[playerid] == 1)
	{
		sendPlayerMessage(playerid, "[ERROR] У вас уже есть права.", red[0], red[1], red[2] );
		return;
	}

	driverlic[playerid] = 1;
	money[playerid] -= prava_price;

	sendPlayerMessage(playerid, "Вы купили права за "+prava_price+"$", orange[0], orange[1], orange[2] );
	
});

addCommandHandler("купить",
function(playerid, name1) 
{
	if(name1.tostring() != "лно")
	{
		return;
	}

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	local myPos = getPlayerPosition( playerid );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -115.11,-63.1035,-11.041, 10.0 );
	if(!check)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не у мерии (зеленый значек на карте)", red[0], red[1], red[2] );
		return;
	}
	
	if(money[playerid] < weapon_price)
	{
		sendPlayerMessage(playerid, "[ERROR] Недостаточно средств, необходимо "+weapon_price+"$", red[0], red[1], red[2] );
		return;
	}

	if(weaponlic[playerid] == 1)
	{
		sendPlayerMessage(playerid, "[ERROR] У вас уже есть лицензия на оружие.", red[0], red[1], red[2] );
		return;
	}

	weaponlic[playerid] = 1;
	money[playerid] -= weapon_price;

	sendPlayerMessage(playerid, "Вы купили лицензию на оружие за "+weapon_price+"$", orange[0], orange[1], orange[2] );
});

addCommandHandler("купить",
function(playerid, name1) 
{
	if(name1.tostring() != "лнб")
	{
		return;
	}

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	local myPos = getPlayerPosition( playerid );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -115.11,-63.1035,-11.041, 10.0 );
	if(!check)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не у мерии (зеленый значек на карте)", red[0], red[1], red[2] );
		return;
	}
	
	if(money[playerid] < biznes_price)
	{
		sendPlayerMessage(playerid, "[ERROR] Недостаточно средств, необходимо "+biznes_price+"$", red[0], red[1], red[2] );
		return;
	}

	if(bizneslic[playerid] == 1)
	{
		sendPlayerMessage(playerid, "[ERROR] У вас уже есть лицензия на бизнес.", red[0], red[1], red[2] );
		return;
	}

	bizneslic[playerid] = 1;
	money[playerid] -= biznes_price;

	sendPlayerMessage(playerid, "Вы купили лицензию на бизнес за "+biznes_price+"$", orange[0], orange[1], orange[2] );
});

//метро
addEventHandler( "subway_menu",
function( playerid)
{
	local myPos = getPlayerPosition( playerid );
	local subway1 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -554.36,1592.92,-21.8639, 5.0 );
	local subway2 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1119.15,1376.71,-19.7724, 5.0 );
	local subway3 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1535.55,-231.03,-13.5892, 5.0 );
	local subway4 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -511.412,20.1703,-5.7096, 5.0 );
	local subway5 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -113.792,-481.71,-8.92243, 5.0 );
	local subway6 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 234.395,380.914,-9.41271, 5.0 );
	local subway7 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -293.069,568.25,-2.27367, 5.0 );
	
	if( subway1 || subway2 || subway3 || subway4 || subway5 || subway6 || subway7)
	{
		sendPlayerMessage(playerid, "====[ Команды ]====", yellow[0], yellow[1], yellow[2] );
		sendPlayerMessage(playerid, "Цена проезда "+subway_price+"$", green[0], green[1], green[2] );
		sendPlayerMessage(playerid, "/метро 1 - ЖД Вокзал", yellow[0], yellow[1], yellow[2] );
		sendPlayerMessage(playerid, "/метро 2 - Авторынок", yellow[0], yellow[1], yellow[2] );
		sendPlayerMessage(playerid, "/метро 3 - Склад", yellow[0], yellow[1], yellow[2] );
		sendPlayerMessage(playerid, "/метро 4 - Мерия", yellow[0], yellow[1], yellow[2] );
		sendPlayerMessage(playerid, "/метро 5 - Городской Порт", yellow[0], yellow[1], yellow[2] );
		sendPlayerMessage(playerid, "/метро 6 - Китайский Квартал", yellow[0], yellow[1], yellow[2] );
		sendPlayerMessage(playerid, "/метро 7 - Полицейский Департамент ЭБ", yellow[0], yellow[1], yellow[2] );
	}
});

addCommandHandler( "метро",
function( playerid, id)
{
	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	local id = id.tointeger();

	local myPos = getPlayerPosition( playerid );
	local subway1 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -554.36,1592.92,-21.8639, 5.0 );
	local subway2 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1119.15,1376.71,-19.7724, 5.0 );
	local subway3 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1535.55,-231.03,-13.5892, 5.0 );
	local subway4 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -511.412,20.1703,-5.7096, 5.0 );
	local subway5 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -113.792,-481.71,-8.92243, 5.0 );
	local subway6 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 234.395,380.914,-9.41271, 5.0 );
	local subway7 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -293.069,568.25,-2.27367, 5.0 );
	
	if(subway1 || subway2 || subway3 || subway4 || subway5 || subway6 || subway7)
	{
		if(money[playerid] < subway_price)
		{
			sendPlayerMessage(playerid, "[ERROR] Недостаточно средств.", red[0], red[1], red[2] );
			return;
		}

		if(!subway1 && id == 1)
		{
			money[playerid] -= subway_price;

			setPlayerPosition(playerid, -554.36,1592.92,-21.8639);

			sendPlayerMessage(playerid, "Вы вышли на станции ЖД Вокзал.", yellow[0], yellow[1], yellow[2] );					
		}	
	
		if(!subway2 && id == 2)
		{
			money[playerid] -= subway_price;

			setPlayerPosition(playerid, -1118.99,1376.44,-18.5);
			
			sendPlayerMessage(playerid, "Вы вышли на станции Авторынок.", yellow[0], yellow[1], yellow[2] );
				
		}
	
		if(!subway3 && id == 3)
		{
			money[playerid] -= subway_price;

			setPlayerPosition(playerid, -1535.55,-231.03,-13.5892);

			sendPlayerMessage(playerid, "Вы вышли на станции Склад.", yellow[0], yellow[1], yellow[2] );					
		}
	
		if(!subway4 && id == 4)
		{
			money[playerid] -= subway_price;

			setPlayerPosition(playerid, -511.412,20.1703,-5.7096);
				
			sendPlayerMessage(playerid, "Вы вышли на станции Мерия.", yellow[0], yellow[1], yellow[2] );			
		}
	
		if(!subway5 && id == 5)
		{
			money[playerid] -= subway_price;

			setPlayerPosition(playerid, -113.792,-481.71,-8.92243);

			sendPlayerMessage(playerid, "Вы вышли на станции Городской Порт.", yellow[0], yellow[1], yellow[2] );				
		}
	
		if(!subway6 && id == 6)
		{
			money[playerid] -= subway_price;
		
			setPlayerPosition(playerid, 234.395,380.914,-9.41271);

			sendPlayerMessage(playerid, "Вы вышли на станции Китайский Квартал.", yellow[0], yellow[1], yellow[2] );	
		}
	
		if(!subway7 && id == 7)
		{
			money[playerid] -= subway_price;
			
			setPlayerPosition(playerid, -293.069,568.25,-2.27367);

			sendPlayerMessage(playerid, "Вы вышли на станции Полицейский Департамент ЭБ.", yellow[0], yellow[1], yellow[2] );				
		}	
	}
});

//дома
addCommandHandler( "продать",
function( playerid, name1, id)
{
	if(name1.tostring() != "дом")
	{
		return;
	}

	local id = id.tointeger();

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	if(job[playerid] != 9)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не риэлтор.", red[0], red[1], red[2] );
		return;
	}

	if(house[id] == 1)
	{
		sendPlayerMessage(playerid, "[ERROR] У игрока есть дом.", red[0], red[1], red[2] );
		return;
	}

	local myPos = getPlayerPosition( playerid );

	house[id] = 1;
	house_x[id] = myPos[0];
	house_y[id] = myPos[1];
	house_z[id] = myPos[2];

	sendPlayerMessage(playerid, "Вы продали дом для "+getPlayerName(id)+" x = "+house_x[id]+" y = "+house_y[id]+" z = "+house_z[id], lyme[0], lyme[1], lyme[2] );
	sendPlayerMessage(id, "У вас появился дом.", lyme[0], lyme[1], lyme[2] );
});

addCommandHandler("передать", 
function(playerid, name, id) 
{
	if(name.tostring() != "дом")
	{
		return;
	}

	local id = id.tointeger();

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	if(logged[id] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Игрок не в сети!", red[0], red[1], red[2] );
		return;
	}

	if(house[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] У вас нет дома.", red[0], red[1], red[2]);
		return;
	}

	if(house[id] != 0)
	{
		sendPlayerMessage(playerid, "[ERROR] У игрока есть дом.", red[0], red[1], red[2]);
		return;
	}

	local myPos = getPlayerPosition( playerid );
	local Pos = getPlayerPosition( id );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], Pos[0], Pos[1], Pos[2], 5.0 );
	if(check)
	{
		log("");
		log("[SELLHOUSE] " +getPlayerName(playerid)+ " peredal " +getPlayerName(id)+ " documents na house x = "+house_x[playerid]+" y = "+house_y[playerid]+" z = "+house_z[playerid]);

		house[id] = house[playerid];
		house_x[id] = house_x[playerid];
		house_y[id] = house_y[playerid];
		house_z[id] = house_z[playerid];
		house_gun[id] = 0;

		house[playerid] = 0;
		house_x[playerid] = 0;
		house_y[playerid] = 0;
		house_z[playerid] = 0;
		house_gun[playerid] = 0;

		foreach(i, playername in getPlayers()) 
		{
			local myPos = getPlayerPosition( i );
			local pos = getPlayerPosition( playerid );
			local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], pos[0], pos[1], pos[2], me_radius );
			if(check)
			{
				sendPlayerMessage( i, "Player["+playerid+"] передал Player["+id+"] документы на дом.", pink[0], pink[1], pink[2] );
			}
		}
	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] Вы далеко от игрока.", red[0], red[1], red[2] );
	}
});

addEventHandler( "seif",
function( playerid )
{
	removePlayerWeapon( playerid, 2, 0 );
	removePlayerWeapon( playerid, 3, 0 );
	removePlayerWeapon( playerid, 4, 0 );
	removePlayerWeapon( playerid, 5, 0 );
	removePlayerWeapon( playerid, 6, 0 );
});

addCommandHandler( "сейф",
function( playerid )
{
	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	if(house[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] У вас нет дома.", red[0], red[1], red[2]);
		return;
	}

	local myPos = getPlayerPosition( playerid );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], house_x[playerid].tofloat(), house_y[playerid].tofloat(), house_z[playerid].tofloat(), 2.0 );

	if(check)
	{
		if(house_gun[playerid] == 0)
		{
			if(gun[playerid] == 0)
			{
				sendPlayerMessage(playerid, "[ERROR] У вас нет оружия.", red[0], red[1], red[2] );
				return;
			}

			house_gun[playerid] = gun[playerid];

			removePlayerWeapon(playerid, gun[playerid], 0);

			gun[playerid] = 0;

			sendPlayerMessage(playerid, "Вы положили оружие в сейф.", yellow[0], yellow[1], yellow[2] );
		}
		else
		{
			gun[playerid] = house_gun[playerid];

			callEvent("seif", playerid);

			givePlayerWeapon(playerid, gun[playerid], 300);

			house_gun[playerid] = 0;

			sendPlayerMessage(playerid, "Вы забрали оружие из сейфа.", yellow[0], yellow[1], yellow[2] );
		}
	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] Вы далеко от дома.", red[0], red[1], red[2] );
	}
});

addEventHandler( "pokyshat",
function( playerid )
{
	if(getPlayerHealth(playerid) > 200)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не голодны.", red[0], red[1], red[2] );
		return;
	}

	setPlayerHealth(playerid, 1000.0);

	sendPlayerMessage(playerid, "Вы покушали.", yellow[0], yellow[1], yellow[2] );
});

addCommandHandler( "покушать",
function( playerid )
{
	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	if(house[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] У вас нет дома.", red[0], red[1], red[2]);
		return;
	}

	local myPos = getPlayerPosition( playerid );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], house_x[playerid].tofloat(), house_y[playerid].tofloat(), house_z[playerid].tofloat(), 2.0 );

	if(check)
	{
		callEvent("pokyshat", playerid);
	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] Вы далеко от дома.", red[0], red[1], red[2] );
	}
});

addCommandHandler( "показать",
function( playerid, name, id)
{
	local id = id.tointeger();

	if(name.tostring() != "дом")
	{
		return;
	}

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	if(logged[id] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Игрок не в сети!", red[0], red[1], red[2] );
		return;
	}

	if(house[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] У вас нет дома.", red[0], red[1], red[2]);
		return;
	}

	local myPos = getPlayerPosition( playerid );
	local Pos = getPlayerPosition( id );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], Pos[0], Pos[1], Pos[2], 5.0 );
	if(check)
	{
		sendPlayerMessage(playerid, "Вы показали дом игроку.", yellow[0], yellow[1], yellow[2] );

		triggerClientEvent( id, "search_house", house_x[playerid], house_y[playerid]);
	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] Вы далеко от игрока.", red[0], red[1], red[2] );
	}
});

//магазин одежды
addEventHandler( "buyskin",
function( playerid )
{
	local myPos = getPlayerPosition( playerid );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -252.324,-79.688,-11.458, 5.0 );
	if(check)
	{
		sendPlayerMessage(playerid, "====[ Команды ]====", yellow[0], yellow[1], yellow[2] );
		sendPlayerMessage(playerid, "Доступные скины находятся в группе vk.com/ebmprp", yellow[0], yellow[1], yellow[2] );
		sendPlayerMessage(playerid, "/одежда и указать ид скина от 0 до 171", yellow[0], yellow[1], yellow[2] );
	}
});

addCommandHandler( "одежда",
function( playerid, id)
{
	local id = id.tointeger();

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}
	if(job[playerid] == 5)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы полицейский.", red[0], red[1], red[2] );
		return;
	}

	local myPos = getPlayerPosition( playerid );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -252.324,-79.688,-11.458, 5.0 );
	if(check)
	{

	for(local i = 0; i < no_skin_chislo; i++)
	{
		if(id == no_skin[i])
		{
			sendPlayerMessage(playerid, "[ERROR] Эта одежда недоступна.", red[0], red[1], red[2] );
			return;
		}
	}

	if(id >= 0 && id <= 171)
	{
		if(money[playerid] < odejda_price)
		{
			sendPlayerMessage(playerid, "[ERROR] Недостаточно средств, необходимо "+odejda_price+"$", red[0], red[1], red[2] );
			return;
		}

		money[playerid] -= odejda_price;
		skin[playerid] = id;

		setPlayerModel(playerid, id);

		sendPlayerMessage(playerid, "Вы купили одежду под номером "+id+" за "+odejda_price+"$", orange[0], orange[1], orange[2] );
	}

	}
});

//автосалон
addEventHandler( "buycardm",
function( playerid )
{
	local myPos = getPlayerPosition( playerid );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -199.473,838.605,-21.2431, 10.0 );
	if(check)
	{
		sendPlayerMessage(playerid, "====[ Команды ]====", yellow[0], yellow[1], yellow[2] );
		sendPlayerMessage(playerid, "Доступные автомобили находятся в группе vk.com/ebmprp", yellow[0], yellow[1], yellow[2] );
		sendPlayerMessage(playerid, "/автосалон и указать ид машины от 0 до 53", yellow[0], yellow[1], yellow[2] );
	}
});

//автосалон
addCommandHandler( "автосалон",
function( playerid, id)
{
	local id = id.tointeger();
	local number = "eb-"+random(0,999);

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	local myPos = getPlayerPosition( playerid );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -199.473,838.605,-21.2431, 10.0 );
	if(check)
	{


	if(driverlic[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] У вас нет водительских прав.", red[0], red[1], red[2] );
		return;
	}

	local result = database.query( "SELECT COUNT() FROM carnumber_bd WHERE carnumber = '"+number+"'" );
    if(result[1]["COUNT()"] == 1)
    {
		sendPlayerMessage(playerid, "[ERROR] Этот номер числится в базе автомобилей, пожалуйста повторите попытку снова.", red[0], red[1], red[2] );
		return;
	}

	if(car_slot[playerid] == 5)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не можете купить больше 5 машин.", red[0], red[1], red[2] );
		return;
	}

	if(id >= 0 && id <= 53)
	{
		if(motor_show[id][1] == 0)
		{
			sendPlayerMessage(playerid, "[ERROR] Этот автомобиль недоступен.", red[0], red[1], red[2] );
			return;
		}

		if(money[playerid] < motor_show[id][1])
		{
			sendPlayerMessage(playerid, "[ERROR] Недостаточно средств, необходимо " +motor_show[id][1]+ "$", red[0], red[1], red[2] );
			return;
		}

		money[playerid] -= motor_show[id][1];
		sendPlayerMessage(playerid, "Вы купили машину за " +motor_show[id][1]+ "$ с номером "+number, orange[0], orange[1], orange[2] );

	car_slot[playerid] += 1;

	local vehicleid = createVehicle( id, -205.534, 835.04, -20.9558, 160.0, 0.0, 0.0 );
	local color = getVehicleColour(vehicleid);
	local carcolor0 = fromRGB(color[0], color[1], color[2]);
	local carcolor1 = fromRGB(color[3], color[4], color[5]);
	local playername = getPlayerName(playerid);

	setVehiclePlateText(vehicleid, number);
	setVehicleFuel(vehicleid, 20.0);
	setVehicleWheelTexture(vehicleid, 0, 0);
	setVehicleWheelTexture(vehicleid, 1, 0);

	database.query( "INSERT INTO carnumber_bd (ownername, ownername_key, carmodel, carnumber, tune, fuel, color0, color1, spawnx, spawny, spawnz, rot, sale, dirtlvl, wheel0, wheel1, fine, fine_name, probeg) VALUES ('"+playername+"', '0', '"+id+"', '"+number+"', '0', '20.0', '"+carcolor0+"', '"+carcolor1+"', '-205.534', '835.04', '-20.9558', '160.0', '0', '0', '0', '0', '0', '0', '0')" );

	database.query( "UPDATE account SET money = '"+money[playerid]+"', car_slot = '"+car_slot[playerid]+"' WHERE name = '"+playername+"'");
	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] От 0 до 53", red[0], red[1], red[2] );
	}


	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] Вы далеко от автосалона.", red[0], red[1], red[2] );
	}

});

local ratio3 = 0.6;//процент от полной стоимости авто
addCommandHandler( "продать",
function( playerid, name, id)
{
	if(name.tostring() != "машину")
	{
		return;
	}

	local id = id.tointeger();
	local playername = getPlayerName(playerid);

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	local myPos = getPlayerPosition( playerid );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1300.01,1306.43,-13.5724, 100.0 );
	if(check)
	{
		if(!isPlayerInVehicle(playerid))
		{
			sendPlayerMessage(playerid, "[ERROR] Вы не в машине.", red[0], red[1], red[2] );
			return;
		}

		if(dviglo[playerid] == 1)
		{
			sendPlayerMessage(playerid, "[ERROR] Заглушите двигатель.", red[0], red[1], red[2] );
			return;
		}

		if(id < 1)
		{
			sendPlayerMessage(playerid, "[ERROR] Введите значение больше 0", red[0], red[1], red[2] );
			return;
		}

		local vehicleid = getPlayerVehicle(playerid);
		local number = getVehiclePlateText(vehicleid);
		local vmodel = getVehicleModel(vehicleid);

		if(id > motor_show[vmodel][1]*ratio3)
		{
			sendPlayerMessage(playerid, "[ERROR] Максимальная цена продажи " +motor_show[vmodel][1]*ratio3+ "$", red[0], red[1], red[2] );
			return;
		}

		local result = database.query( "SELECT COUNT() FROM carnumber_bd WHERE carnumber = '"+number+"'" );
		if(result[1]["COUNT()"] == 1)
		{
			result = database.query( "SELECT * FROM carnumber_bd WHERE carnumber = '"+number+"'" );

			if(result[1]["fine"] > 0)
			{
				sendPlayerMessage(playerid, "[ERROR] Этот автомобиль оштрафован.", red[0], red[1], red[2]);
				return;
			}

			if(result[1]["ownername"] == getPlayerName(playerid))
			{
				local carpos = getVehiclePosition(vehicleid);
				local carrot = getVehicleRotation(vehicleid);
				local color = getVehicleColour(vehicleid);

				money[playerid] += id;
				car_slot[playerid] -= 1;

				database.query( "UPDATE account SET money = '"+money[playerid]+"', car_slot = '"+car_slot[playerid]+"' WHERE name = '"+playername+"'");

				database.query( "UPDATE carnumber_bd SET sale = '"+id+"', ownername = '0', ownername_key = '0', fuel = '"+getVehicleFuel(vehicleid)+"', spawnx = '"+carpos[0]+"', spawny = '"+carpos[1]+"', spawnz = '"+carpos[2]+"', rot = '"+carrot[0]+"', dirtlvl = '"+getVehicleDirtLevel(vehicleid)+"', probeg = '"+probeg[playerid]+"', tune = '"+getVehicleTuningTable(vehicleid)+"', color0 = '"+fromRGB(color[0], color[1], color[2])+"', color1 = '"+fromRGB(color[3], color[4], color[5])+"' WHERE carnumber = '"+number+"'");

				sendPlayerMessage(playerid, "Вы продали машину за " +id+ "$", green[0], green[1], green[2] );
			}
			else
			{
				sendPlayerMessage(playerid, "[ERROR] Вы пытаетесь продать чужую машину.", red[0], red[1], red[2] );
			}
		}
		else
		{
			sendPlayerMessage(playerid, "[ERROR] Этот транспорт нельзя продать.", red[0], red[1], red[2] );	
		}
	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] Вы далеко от авторынка.", red[0], red[1], red[2] );
	}

});

addEventHandler( "avtorinok",
function( playerid )
{
	local myPos = getPlayerPosition( playerid );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1300.01,1306.43,-13.5724, 100.0 );
	if(check)
	{
		sendPlayerMessage(playerid, "====[ Команды ]====", yellow[0], yellow[1], yellow[2] );
		sendPlayerMessage(playerid, "/продать машину и указать цену", yellow[0], yellow[1], yellow[2] );
	}
});

addCommandHandler( "авторынок",
function( playerid )
{
	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	if(!isPlayerInVehicle(playerid))
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не в машине.", red[0], red[1], red[2] );
		return;
	}

	if(driverlic[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] У вас нет водительских прав.", red[0], red[1], red[2] );
		return;
	}

	if(car_slot[playerid] == 5)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не можете купить больше 5 машин.", red[0], red[1], red[2] );
		return;
	}
	
	local vehicleid = getPlayerVehicle(playerid);
	local number = getVehiclePlateText(vehicleid);
	local playername = getPlayerName(playerid);

	local myPos = getPlayerPosition( playerid );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1300.01,1306.43,-13.5724, 100.0 );
	if(check)
	{
		local result = database.query( "SELECT COUNT() FROM carnumber_bd WHERE carnumber = '"+number+"'" );
		if(result[1]["COUNT()"] == 1)
		{
			result = database.query( "SELECT * FROM carnumber_bd WHERE carnumber = '"+number+"'" );

			if(money[playerid] < result[1]["sale"])
			{
				sendPlayerMessage(playerid, "[ERROR] Недостаточно средств.", red[0], red[1], red[2] );
				return;
			}

			if(result[1]["sale"] != 0)
			{
				money[playerid] -= result[1]["sale"];

				sendPlayerMessage(playerid, "Вы купили этот автомобиль.", orange[0], orange[1], orange[2] );

				car_slot[playerid] += 1;

				database.query( "UPDATE account SET money = '"+money[playerid]+"', car_slot = '"+car_slot[playerid]+"', WHERE name = '"+playername+"'");

				database.query( "UPDATE carnumber_bd SET sale = '0', ownername = '"+playername+"' WHERE carnumber = '"+number+"'");
			}
			else
			{
				sendPlayerMessage(playerid, "[ERROR] Этот транспорт не продается.", red[0], red[1], red[2] );	
			}
		}
		else
		{
			sendPlayerMessage(playerid, "[ERROR] Этот транспорт не продается.", red[0], red[1], red[2] );	
		}
	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] Вы далеко от авторынка.", red[0], red[1], red[2] );
	}
});

addCommandHandler( "ключ",
function( playerid, player, number)
{
	local player = player.tointeger();
	local number = number.tostring();
	local result;

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	if(logged[player] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Игрок не в сети!", red[0], red[1], red[2] );
		return;
	}

	local myPos = getPlayerPosition( playerid );
	local Pos = getPlayerPosition( player );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], Pos[0], Pos[1], Pos[2], 5.0 );
	if(check)
	{
		if(car_slot[playerid] == 0)
		{
			sendPlayerMessage(playerid, "[ERROR] У вас нет машин.", red[0], red[1], red[2] );
			return;
		}

		local result = database.query( "SELECT COUNT() FROM carnumber_bd WHERE carnumber = '"+number+"'" );
		if(result[1]["COUNT()"] == 1)
		{

			result = database.query( "SELECT * FROM carnumber_bd WHERE carnumber = '"+number+"'" );
			database.query( "UPDATE carnumber_bd SET ownername_key = '"+getPlayerName(player)+"' WHERE carnumber = '"+number+"'");

				foreach(i, playername in getPlayers()) 
				{
					local myPos = getPlayerPosition( i );
					local pos = getPlayerPosition( playerid );
					local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], pos[0], pos[1], pos[2], me_radius );
					if(check)
					{
						sendPlayerMessage( i, "Player["+playerid+"] передал Player["+player+"] ключ от " +id+ " машины.", pink[0], pink[1], pink[2] );
					}
				}
		}
		else
		{
			sendPlayerMessage(playerid, "[ERROR] Этот номер не числится в базе.", red[0], red[1], red[2] );
		}

	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] Вы далеко от игрока.", red[0], red[1], red[2]);
	}

});

//сесть в тачку
function playerEnteredVehicle( playerid, vehicleid, seat )
{
	sead[playerid] = seat;
	car_id[playerid] = vehicleid;

	probeg[playerid] = 0;

	if(sead[playerid] == 0)
	{
		sendPlayerMessage( playerid, "Чтобы завести (заглушить) двигатель нажмите Q", yellow[0], yellow[1], yellow[2] );
		sendPlayerMessage(playerid, "Пропишите /парковка, чтобы сохранить местоположение своего авто.", yellow[0], yellow[1], yellow[2] );
	}

	local plate = getVehiclePlateText(vehicleid);
	local result = database.query( "SELECT COUNT() FROM carnumber_bd WHERE carnumber = '"+plate+"'" );
	if(result[1]["COUNT()"] == 1)
	{
		result = database.query( "SELECT * FROM carnumber_bd WHERE carnumber = '"+plate+"'" );

		setVehicleFuel(vehicleid, result[1]["fuel"]);

		probeg[playerid] = result[1]["probeg"];

		if(result[1]["sale"] != 0)
		{
			sendPlayerMessage( playerid, "Этот автомобиль продается за "+result[1]["sale"]+"$", orange[0], orange[1], orange[2] );
			sendPlayerMessage( playerid, "Пропишите /авторынок, чтобы купить.", orange[0], orange[1], orange[2] );
		}

		if(result[1]["fine"] != 0)
		{
			sendPlayerMessage( playerid, "Автомобиль оштрафован офицером полиции "+result[1]["fine_name"]+" на "+result[1]["fine"]+"$", blue[0], blue[1], blue[2] );
			sendPlayerMessage( playerid, "Оплатите штраф в банке.", blue[0], blue[1], blue[2] );
		}

	}

	dviglo[playerid] = 0;

	triggerClientEvent( playerid, "mileage", probeg[playerid].tofloat());
}
addEventHandler ("onPlayerVehicleEnter", playerEnteredVehicle);

addEventHandler("onPlayerVehicleExit",
function(playerid, vehicleid, seat)
{
	dviglo[playerid] = 0;
});

addEventHandler( "en",//отвечает за включение или отключение двигателя
function(playerid)
{
	if( !isPlayerInVehicle(playerid) ) 
	{
		return;
	}

	if(driverlic[playerid] == 0)
	{
		sendPlayerMessage( playerid, "[ERROR] У вас нет водительских прав.", red[0], red[1], red[2] );
		return;
	}

	if(sead[playerid] == 1)
	{
		sendPlayerMessage( playerid, "[ERROR] Не мешай водителю.", red[0], red[1], red[2] );
		return;
	}

	if(dviglo[playerid] == 0)
	{
		local vehicleid = getPlayerVehicle(playerid);
		local plate = getVehiclePlateText(vehicleid);
		local result = database.query( "SELECT COUNT() FROM carnumber_bd WHERE carnumber = '"+plate+"'" );
		if(result[1]["COUNT()"] == 1)
		{
			result = database.query( "SELECT * FROM carnumber_bd WHERE carnumber = '"+plate+"'" );

			if(result[1]["ownername"] != getPlayerName( playerid ) && result[1]["ownername_key"] != getPlayerName( playerid ) )
			{
				sendPlayerMessage( playerid, "[ERROR] Это чужая машина.", red[0], red[1], red[2] );
				return;
			}

			if(result[1]["fine"] != 0)
			{
				sendPlayerMessage( playerid, "[ERROR] Оплатите штраф в банке.", red[0], red[1], red[2] );
				return;
			}

			foreach(i, playername in getPlayers())
			{
				local myPos = getPlayerPosition( i );
				local pos = getPlayerPosition( playerid );
				local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], pos[0], pos[1], pos[2], me_radius );
				if(check)
				{
					sendPlayerMessage( i, "Player["+playerid+"] завел двигатель.", pink[0], pink[1], pink[2] );
				}
			}
	
			setVehicleEngineState( vehicleid, true );
			dviglo[playerid] = 1;
		}
		else
		{
			if(car_rental[playerid] != vehicleid && plate != "gonka")
			{
				sendPlayerMessage( playerid, "[ERROR] Это чужая машина.", red[0], red[1], red[2] );
				return;
			}

			foreach(i, playername in getPlayers()) 
			{
				local myPos = getPlayerPosition( i );
				local pos = getPlayerPosition( playerid );
				local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], pos[0], pos[1], pos[2], me_radius );
				if(check)
				{
					sendPlayerMessage( i, "Player["+playerid+"] завел двигатель.", pink[0], pink[1], pink[2] );
				}
			}
	
			setVehicleEngineState( vehicleid, true );
			dviglo[playerid] = 1;
		}
	}
	else
	{
		foreach(i, playername in getPlayers()) 
		{
			local myPos = getPlayerPosition( i );
			local pos = getPlayerPosition( playerid );
			local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], pos[0], pos[1], pos[2], me_radius );
			if(check)
			{
				sendPlayerMessage( i, "Player["+playerid+"] заглушил двигатель.", pink[0], pink[1], pink[2] );
			}
		}

		dviglo[playerid] = 0;
	}
});

//покупка бизнесов
addCommandHandler("приобрести", 
function(playerid, name) 
{
	if(name.tostring() != "бизнес")
	{
		return;
	}

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	if(bizneslic[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] У вас нет лицензии на бизнес.", red[0], red[1], red[2] );
		return;
	}

	if(biznes[playerid] > 0)
	{
		sendPlayerMessage(playerid, "[ERROR] У вас есть бизнес.", red[0], red[1], red[2]);
		return;
	}

	local myPos = getPlayerPosition( playerid );
    local fuel1 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 338.758,875.07,-20.1312, 5.0 );
	local fuel2 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -710.287,1762.62,-14.8309, 5.0 );
	local fuel3 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1592.31,942.639,-4.02328, 5.0 );
	local fuel4 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1679.5,-232.035,-19.1619, 5.0 );
	local fuel5 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -629.5,-48.7479,2.22843, 5.0 );
	local fuel6 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -150.096,610.258,-18.9558, 5.0 );
	local fuel7 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 112.687,181.302,-18.7977, 5.0 );
	local fuel8 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 547.921,2.62598,-17.0294, 5.0 );

	if(fuel1 || fuel2 || fuel3 || fuel4 || fuel5 || fuel6 || fuel7 || fuel8)
	{
		if(fuel_ownername == "0")
		{
			if(money[playerid] < fuel_buybiznes)
			{
				sendPlayerMessage(playerid, "[ERROR] Недостаточно средств.", red[0], red[1], red[2]);
				return;
			}

			money[playerid] -= fuel_buybiznes;
			biznes[playerid] = 1;
			fuel_ownername = getPlayerName(playerid);

			sendPlayerMessage(playerid, "Вы купили сеть заправок.", orange[0], orange[1], orange[2] );
		}
		else
		{
			sendPlayerMessage(playerid, "[ERROR] Сеть заправок куплена.", red[0], red[1], red[2]);
		}
		return;
	}

	local ed1 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -561.204,428.753,1.02075, 5.0 );
	local ed2 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -771.518,-377.324,-20.4072, 5.0 );
	local ed3 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 142.323,-429.708,-19.429, 5.0 );
	local ed4 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 240.014,709.032,-24.0321, 5.0 );
	local ed5 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -645.378,1296.42,3.94464, 5.0 );
	local ed6 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1582.64,1603.77,-5.22507, 5.0 );
	local ed7 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1420.38,961.175,-12.7543, 5.0 );
	local ed8 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1588.62,177.321,-12.4393, 5.0 );
	local ed9 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1559.15,-165.144,-19.6113, 5.0 );
	local ed10 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1384.92,470.174,-22.1321, 5.0 );
	local ed11 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 627.621,897.018,-12.0138, 2.0 );
	local ed12 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -51.0424,737.98,-21.9009, 5.0 );
	local ed13 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -639.003,349.621,1.34485, 5.0 );
	local ed14 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 21.2379,-76.4079,-15.595, 5.0 );
	local ed15 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1148.88,1589.7,6.25566, 5.0 );

	if( ed1 || ed2 || ed3 || ed4 || ed5 || ed6 || ed7 || ed8 || ed9 || ed10 || ed11 || ed12 || ed13 || ed14 || ed15 )
	{
		if(eda_ownername == "0")
		{
			if(money[playerid] < eda_buybiznes)
			{
				sendPlayerMessage(playerid, "[ERROR] Недостаточно средств.", red[0], red[1], red[2]);
				return;
			}

			money[playerid] -= eda_buybiznes;
			biznes[playerid] = 2;
			eda_ownername = getPlayerName(playerid);

			sendPlayerMessage(playerid, "Вы купили сеть закусочных.", orange[0], orange[1], orange[2] );
		}
		else
		{
			sendPlayerMessage(playerid, "[ERROR] Сеть закусочных куплена.", red[0], red[1], red[2]);
		}
		return;
	}

	local rep1 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1583.81,68.6026,-13.1081, 5.0 );
	local rep2 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1438.92,1379.93,-13.3927, 5.0 );
	local rep3 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -375.957,1735.39,-22.8601, 5.0 );
	local rep4 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 425.711,780.516,-21.0679, 5.0 );
	local rep5 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -120.967,529.571,-20.0687, 5.0 );
	local rep6 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -282.268,701.517,-19.7763, 5.0 );
	local rep7 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -687.197,188.526,1.18315, 5.0 );
	local rep8 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -69.189,203.758,-14.3089, 5.0 );
	local rep9 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 285.353,296.706,-21.3649, 5.0 );
	local rep10 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 553.497,-122.346,-20.1382, 5.0 );
	local rep11 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 719.397,-446.142,-19.9979, 5.0 );
	local rep12 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 49.0399,-405.637,-19.9942, 5.0 );

	if(rep1 || rep2 || rep3 || rep4 || rep5 || rep6 || rep7 || rep8 || rep9 || rep10 || rep11 || rep12)
	{
		if(repair_ownername == "0")
		{
			if(money[playerid] < repair_buybiznes)
			{
				sendPlayerMessage(playerid, "[ERROR] Недостаточно средств.", red[0], red[1], red[2]);
				return;
			}

			money[playerid] -= repair_buybiznes;
			biznes[playerid] = 3;
			repair_ownername = getPlayerName(playerid);

			sendPlayerMessage(playerid, "Вы купили сеть автомастерских.", orange[0], orange[1], orange[2] );
		}
		else
		{
			sendPlayerMessage(playerid, "[ERROR] Сеть автомастерских куплена.", red[0], red[1], red[2]);
		}
		return;
	}

	local gans1 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -592.593,500.991,1.02277, 4.0 );
	local gans2 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -567.724,310.701,0.16808, 4.0 );
	local gans3 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -10.54,739.379,-22.0582, 4.0 );
	local gans4 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 404.657,603.754,-24.9746, 4.0 );
	local gans5 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 68.0516,139.778,-14.4583, 4.0 );
	local gans6 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 279.78,-118.507,-12.2741, 4.0 );
	local gans7 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 273.826,-454.45,-20.1636, 4.0 );
	local gans8 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -323.407,-589.106,-20.1043, 4.0 );
	local gans9 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1394.73,-32.7772,-17.8468, 4.0 );
	local gans10 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1183.09,1706.26,11.0941, 4.0 );
	local gans11 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -288.036,1627.6,-23.0758, 4.0 );

	if(gans1 || gans2 || gans3 || gans4 || gans5 || gans6 || gans7 || gans8 || gans9 || gans10 || gans11)
	{
		if(gun_ownername == "0")
		{
			if(money[playerid] < gun_buybiznes)
			{
				sendPlayerMessage(playerid, "[ERROR] Недостаточно средств.", red[0], red[1], red[2]);
				return;
			}

			money[playerid] -= gun_buybiznes;
			biznes[playerid] = 4;
			gun_ownername = getPlayerName(playerid);

			sendPlayerMessage(playerid, "Вы купили сеть оружейных магазинов.", orange[0], orange[1], orange[2] );
		}
		else
		{
			sendPlayerMessage(playerid, "[ERROR] Сеть оружейных магазинов куплена.", red[0], red[1], red[2]);
		}
		return;
	}

	sendPlayerMessage(playerid, "[ERROR] Вы должны находится у бизнеса.", red[0], red[1], red[2]);
});

addCommandHandler("продать", 
function(playerid, name, id) 
{
	if(name.tostring() != "бизнес")
	{
		return;
	}

	local id = id.tointeger();

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	if(logged[id] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Игрок не в сети!", red[0], red[1], red[2] );
		return;
	}

	if(biznes[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] У вас нет бизнеса.", red[0], red[1], red[2]);
		return;
	}

	if(biznes[id] != 0)
	{
		sendPlayerMessage(playerid, "[ERROR] У игрока есть бизнес.", red[0], red[1], red[2]);
		return;
	}

	local myPos = getPlayerPosition( playerid );
	local Pos = getPlayerPosition( id );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], Pos[0], Pos[1], Pos[2], 5.0 );
	if(check)
	{
		if(biznes[playerid] == 1)
		{
			fuel_ownername = getPlayerName(id);
		}

		if(biznes[playerid] == 2)
		{
			eda_ownername = getPlayerName(id);
		}

		if(biznes[playerid] == 3)
		{
			repair_ownername = getPlayerName(id);
		}

		if(biznes[playerid] == 4)
		{
			gun_ownername = getPlayerName(id);
		}

		log("");
		log("[SELLBIZ] " +getPlayerName(playerid)+ " peredal " +getPlayerName(id)+ " documents na biznes "+biznes[playerid]);

		biznes[id] = biznes[playerid];

		biznes[playerid] = 0;

		foreach(i, playername in getPlayers()) 
		{
			local myPos = getPlayerPosition( i );
			local pos = getPlayerPosition( playerid );
			local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], pos[0], pos[1], pos[2], me_radius );
			if(check)
			{
				sendPlayerMessage( i, "Player["+playerid+"] передал Player["+id+"] документы на бизнес.", pink[0], pink[1], pink[2] );
			}
		}
	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] Вы далеко от игрока.", red[0], red[1], red[2] );
	}
});

//установка цен в бизнесе
addCommandHandler("цена", 
function(playerid, id) 
{
	local id = id.tointeger();

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	if(biznes[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] У вас нет бизнеса.", red[0], red[1], red[2]);
		return;
	}

	if ( id < 1 )
	{
		sendPlayerMessage(playerid, "[ERROR] Введите значение больше 0", red[0], red[1], red[2]);
		return;
	}

	if(biznes[playerid] == 1)
	{
		fuel_price = id;
		
		sendPlayerMessage(playerid, "Вы установили цену за топливо в размере " +id+ "$", yellow[0], yellow[1], yellow[2]);
		return;
	}

	if(biznes[playerid] == 2)
	{
		eda_price = id;
		
		sendPlayerMessage(playerid, "Вы установили цену за продукт в размере " +id+ "$", yellow[0], yellow[1], yellow[2]);
		return;
	}

	if(biznes[playerid] == 3)
	{
		repair_price = id;
		
		sendPlayerMessage(playerid, "Вы установили цену за ремонт в размере " +id+ "$", yellow[0], yellow[1], yellow[2]);
		return;
	}

	if(biznes[playerid] == 4)
	{
		gun_price = id;
		
		sendPlayerMessage(playerid, "Вы установили цену за боеприпас в размере " +id+ "$", yellow[0], yellow[1], yellow[2]);
		return;
	}

});

//покупка товаров для бизнесов
addCommandHandler("продукты",
function(playerid, id) 
{

	local id = id.tointeger();

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	if(biznes[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] У вас нет бизнеса.", red[0], red[1], red[2]);
		return;
	}

	if ( id < 1 )
	{
		sendPlayerMessage(playerid, "[ERROR] Введите значение больше 0", red[0], red[1], red[2]);
		return;
	}

	if(biznes[playerid] == 1)
	{
		if(money[playerid] < course_fuel*id)
		{
			sendPlayerMessage(playerid, "[ERROR] Недостаточно средств.", red[0], red[1], red[2]);
			return;
		}

		if(50000 < fuel_tanker+id)
		{
			sendPlayerMessage(playerid, "[ERROR] Столько галлонов не влезет в танкер.", red[0], red[1], red[2]);
			return;
		}

		money[playerid] -= course_fuel*id;
		fuel_tanker += id;
		
		sendPlayerMessage(playerid, "Вы купили " +id+ " галлонов топлива за " +course_fuel*id+ "$", orange[0], orange[1], orange[2]);
		return;
	}

	if(biznes[playerid] == 2)
	{
		if(money[playerid] < course_eda*id)
		{
			sendPlayerMessage(playerid, "[ERROR] Недостаточно средств.", red[0], red[1], red[2]);
			return;
		}

		if(50000 < eda_tanker+id)
		{
			sendPlayerMessage(playerid, "[ERROR] Столько продуктов не влезет на склад.", red[0], red[1], red[2]);
			return;
		}

		money[playerid] -= course_eda*id;
		eda_tanker += id;
		
		sendPlayerMessage(playerid, "Вы купили " +id+ " продуктов за " +course_eda*id+ "$", orange[0], orange[1], orange[2]);
		return;
	}

	if(biznes[playerid] == 3)
	{
		if(money[playerid] < course_repair*id)
		{
			sendPlayerMessage(playerid, "[ERROR] Недостаточно средств.", red[0], red[1], red[2]);
			return;
		}

		if(50000 < repair_tanker+id)
		{
			sendPlayerMessage(playerid, "[ERROR] Столько запчастей не влезет на склад.", red[0], red[1], red[2]);
			return;
		}

		money[playerid] -= course_repair*id;
		repair_tanker += id;
		
		sendPlayerMessage(playerid, "Вы купили " +id+ " запчастей за " +course_repair*id+ "$", orange[0], orange[1], orange[2]);
		return;
	}

	if(biznes[playerid] == 4)
	{
		if(money[playerid] < course_gun*id)
		{
			sendPlayerMessage(playerid, "[ERROR] Недостаточно средств.", red[0], red[1], red[2]);
			return;
		}

		if(50000 < gun_tanker+id)
		{
			sendPlayerMessage(playerid, "[ERROR] Столько боеприпасов не влезет на склад.", red[0], red[1], red[2]);
			return;
		}

		money[playerid] -= course_gun*id;
		gun_tanker += id;
		
		sendPlayerMessage(playerid, "Вы купили " +id+ " боеприпасов за " +course_gun*id+ "$", orange[0], orange[1], orange[2]);
		return;
	}

});

//оружейки
addEventHandler("helpgun",
function(playerid) 
{
	local myPos = getPlayerPosition( playerid );
	local gans1 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -592.593,500.991,1.02277, 4.0 );
	local gans2 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -567.724,310.701,0.16808, 4.0 );
	local gans3 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -10.54,739.379,-22.0582, 4.0 );
	local gans4 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 404.657,603.754,-24.9746, 4.0 );
	local gans5 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 68.0516,139.778,-14.4583, 4.0 );
	local gans6 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 279.78,-118.507,-12.2741, 4.0 );
	local gans7 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 273.826,-454.45,-20.1636, 4.0 );
	local gans8 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -323.407,-589.106,-20.1043, 4.0 );
	local gans9 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1394.73,-32.7772,-17.8468, 4.0 );
	local gans10 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1183.09,1706.26,11.0941, 4.0 );
	local gans11 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -288.036,1627.6,-23.0758, 4.0 );
	
	if(gans1 || gans2 || gans3 || gans4 || gans5 || gans6 || gans7 || gans8 || gans9 || gans10 || gans11)
	{
		sendPlayerMessage(playerid, "====[ Команды ]====", yellow[0], yellow[1], yellow[2] );
		sendPlayerMessage(playerid, "/купить (револьвер, маузер, кольт, спец.кольт, магнум, дробовик, пп, мп40, томпсон)", yellow[0], yellow[1], yellow[2] );
	}
});

function remove_gun(playerid) {
	removePlayerWeapon( playerid, 2, 0 );
	removePlayerWeapon( playerid, 3, 0 );
	removePlayerWeapon( playerid, 4, 0 );
	removePlayerWeapon( playerid, 5, 0 );
	removePlayerWeapon( playerid, 6, 0 );
}

function remove_gun_hand(playerid) {
	removePlayerWeapon( playerid, 8, 0 );
	removePlayerWeapon( playerid, 9, 0 );
	removePlayerWeapon( playerid, 10, 0 );
	removePlayerWeapon( playerid, 11, 0 );
}

addCommandHandler("купить", 
function(playerid, name) 
{
	local name = name.tostring();

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	local myPos = getPlayerPosition( playerid );
	local gans1 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -592.593,500.991,1.02277, 4.0 );
	local gans2 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -567.724,310.701,0.16808, 4.0 );
	local gans3 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -10.54,739.379,-22.0582, 4.0 );
	local gans4 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 404.657,603.754,-24.9746, 4.0 );
	local gans5 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 68.0516,139.778,-14.4583, 4.0 );
	local gans6 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 279.78,-118.507,-12.2741, 4.0 );
	local gans7 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 273.826,-454.45,-20.1636, 4.0 );
	local gans8 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -323.407,-589.106,-20.1043, 4.0 );
	local gans9 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1394.73,-32.7772,-17.8468, 4.0 );
	local gans10 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1183.09,1706.26,11.0941, 4.0 );
	local gans11 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -288.036,1627.6,-23.0758, 4.0 );
	
	if(gans1 || gans2 || gans3 || gans4 || gans5 || gans6 || gans7 || gans8 || gans9 || gans10 || gans11)
	{
		if(gun_ownername == "0" || gun_tanker < 200)
		{
			sendPlayerMessage(playerid, "[ERROR] Магазин оружия не работает.", red[0], red[1], red[2]);
			return;
		}

		if(weaponlic[playerid] == 0)
		{
			sendPlayerMessage(playerid, "[ERROR] У вас нет лицензии на оружие.", red[0], red[1], red[2] );
			return;
		}

		if(name == "револьвер")
		{
			if(job[playerid] == 5)
			{
				sendPlayerMessage(playerid, "Вы взяли револьвер.", orange[0], orange[1], orange[2]);
			}
			else
			{
				if(money[playerid] < gun_price*42)
				{
					sendPlayerMessage(playerid, "[ERROR] Недостаточно средств.", red[0], red[1], red[2]);
					return;
				}

				money[playerid] -= gun_price*42;

				sendPlayerMessage(playerid, "Вы купили револьвер за "+gun_price*42+"$", orange[0], orange[1], orange[2]);
			}

			gun_money += gun_price*42;
			gun_tanker -= 42;
			remove_gun(playerid);
			givePlayerWeapon(playerid, 2, 300);
			gun[playerid] = 2;

			log("");
			log("[BUYGUNS] "+getPlayerName(playerid)+" kypil weapon 2");
			return;
		}

		if(name == "маузер")
		{
			if(job[playerid] == 5)
			{
				sendPlayerMessage(playerid, "Вы взяли маузер.", orange[0], orange[1], orange[2]);
			}
			else
			{
				if(money[playerid] < gun_price*60)
				{
					sendPlayerMessage(playerid, "[ERROR] Недостаточно средств.", red[0], red[1], red[2]);
					return;
				}

				money[playerid] -= gun_price*60;

				sendPlayerMessage(playerid, "Вы купили маузер за "+gun_price*60+"$", orange[0], orange[1], orange[2]);
			}

			gun_money += gun_price*60;
			gun_tanker -= 60;
			remove_gun(playerid);
			givePlayerWeapon(playerid, 3, 300);
			gun[playerid] = 3;

			log("");
			log("[BUYGUNS] "+getPlayerName(playerid)+" kypil weapon 3");
			return;
		}

		if(name == "кольт")
		{
			if(job[playerid] == 5)
			{
				sendPlayerMessage(playerid, "Вы взяли кольт.", orange[0], orange[1], orange[2]);
			}
			else
			{
				if(money[playerid] < gun_price*56)
				{
					sendPlayerMessage(playerid, "[ERROR] Недостаточно средств.", red[0], red[1], red[2]);
					return;
				}

				money[playerid] -= gun_price*56;

				sendPlayerMessage(playerid, "Вы купили кольт за "+gun_price*56+"$", orange[0], orange[1], orange[2]);
			}

			gun_money += gun_price*56;
			gun_tanker -= 56;
			remove_gun(playerid);
			givePlayerWeapon(playerid, 4, 300);
			gun[playerid] = 4;

			log("");
			log("[BUYGUNS] "+getPlayerName(playerid)+" kypil weapon 4");
			return;
		}

		if(name == "спец.кольт")
		{
			if(job[playerid] == 5)
			{
				sendPlayerMessage(playerid, "Вы взяли специальный кольт.", orange[0], orange[1], orange[2]);	
			}
			else
			{
				if(money[playerid] < gun_price*92)
				{
					sendPlayerMessage(playerid, "[ERROR] Недостаточно средств.", red[0], red[1], red[2]);
					return;
				}

				money[playerid] -= gun_price*92;

				sendPlayerMessage(playerid, "Вы купили специальный кольт за "+gun_price*92+"$", orange[0], orange[1], orange[2]);
			}

			gun_money += gun_price*92;
			gun_tanker -= 92;
			remove_gun(playerid);
			givePlayerWeapon(playerid, 5, 300);
			gun[playerid] = 5;

			log("");
			log("[BUYGUNS] "+getPlayerName(playerid)+" kypil weapon 5");
			return;
		}

		if(name == "магнум")
		{
			if(job[playerid] == 5)
			{
				sendPlayerMessage(playerid, "Вы взяли магнум.", orange[0], orange[1], orange[2]);	
			}
			else
			{
				if(money[playerid] < gun_price*42)
				{
					sendPlayerMessage(playerid, "[ERROR] Недостаточно средств.", red[0], red[1], red[2]);
					return;
				}

				money[playerid] -= gun_price*42;

				sendPlayerMessage(playerid, "Вы купили магнум за "+gun_price*42+"$", orange[0], orange[1], orange[2]);
			}

			gun_money += gun_price*42;
			gun_tanker -= 42;
			remove_gun(playerid);
			givePlayerWeapon(playerid, 6, 300);
			gun[playerid] = 6;

			log("");
			log("[BUYGUNS] "+getPlayerName(playerid)+" kypil weapon 6");
			return;
		}

		if(name == "дробовик")
		{
			if(job[playerid] == 5)
			{
				sendPlayerMessage(playerid, "Вы взяли дробовик.", orange[0], orange[1], orange[2]);				
			}
			else
			{
				if(money[playerid] < gun_price*56)
				{
					sendPlayerMessage(playerid, "[ERROR] Недостаточно средств.", red[0], red[1], red[2]);
					return;
				}

				money[playerid] -= gun_price*56;

				sendPlayerMessage(playerid, "Вы купили дробовик за "+gun_price*56+"$", orange[0], orange[1], orange[2]);
			}

			gun_money += gun_price*56;
			gun_tanker -= 56;
			remove_gun_hand(playerid);
			givePlayerWeapon(playerid, 8, 300);
			gun_hand[playerid] = 8;

			log("");
			log("[BUYGUNS] "+getPlayerName(playerid)+" kypil weapon 8");
			return;
		}

		if(name == "пп")
		{
			if(job[playerid] == 5)
			{
				sendPlayerMessage(playerid, "Вы взяли пп.", orange[0], orange[1], orange[2]);				
			}
			else
			{
				if(money[playerid] < gun_price*120)
				{
					sendPlayerMessage(playerid, "[ERROR] Недостаточно средств.", red[0], red[1], red[2]);
					return;
				}

				money[playerid] -= gun_price*120;

				sendPlayerMessage(playerid, "Вы купили пп за "+gun_price*120+"$", orange[0], orange[1], orange[2]);
			}

			gun_money += gun_price*120;
			gun_tanker -= 120;
			remove_gun_hand(playerid);
			givePlayerWeapon(playerid, 9, 300);
			gun_hand[playerid] = 9;

			log("");
			log("[BUYGUNS] "+getPlayerName(playerid)+" kypil weapon 9");
			return;
		}

		if(name == "мп40")
		{
			if(job[playerid] == 5)
			{
				sendPlayerMessage(playerid, "Вы взяли мп40.", orange[0], orange[1], orange[2]);				
			}
			else
			{
				if(money[playerid] < gun_price*128)
				{
					sendPlayerMessage(playerid, "[ERROR] Недостаточно средств.", red[0], red[1], red[2]);
					return;
				}

				money[playerid] -= gun_price*128;

				sendPlayerMessage(playerid, "Вы купили мп40 за "+gun_price*128+"$", orange[0], orange[1], orange[2]);
			}

			gun_money += gun_price*128;
			gun_tanker -= 128;
			remove_gun_hand(playerid);
			givePlayerWeapon(playerid, 10, 300);
			gun_hand[playerid] = 10;

			log("");
			log("[BUYGUNS] "+getPlayerName(playerid)+" kypil weapon 10");
			return;
		}

		if(name == "томпсон")
		{
			if(job[playerid] == 5)
			{
				sendPlayerMessage(playerid, "Вы взяли томпсон.", orange[0], orange[1], orange[2]);				
			}
			else
			{
				if(money[playerid] < gun_price*200)
				{
					sendPlayerMessage(playerid, "[ERROR] Недостаточно средств.", red[0], red[1], red[2]);
					return;
				}

				money[playerid] -= gun_price*200;

				sendPlayerMessage(playerid, "Вы купили томпсон за "+gun_price*200+"$", orange[0], orange[1], orange[2]);
			}

			gun_money += gun_price*200;
			gun_tanker -= 200;
			remove_gun_hand(playerid);
			givePlayerWeapon(playerid, 11, 300);
			gun_hand[playerid] = 11;
			
			log("");
			log("[BUYGUNS] "+getPlayerName(playerid)+" kypil weapon 11");
			return;
		}

	}

});

//чинилка
addEventHandler("helprep",
function(playerid) 
{
	local myPos = getPlayerPosition( playerid );
	local rep1 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1583.81,68.6026,-13.1081, 5.0 );
	local rep2 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1438.92,1379.93,-13.3927, 5.0 );
	local rep3 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -375.957,1735.39,-22.8601, 5.0 );
	local rep4 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 425.711,780.516,-21.0679, 5.0 );
	local rep5 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -120.967,529.571,-20.0687, 5.0 );
	local rep6 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -282.268,701.517,-19.7763, 5.0 );
	local rep7 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -687.197,188.526,1.18315, 5.0 );
	local rep8 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -69.189,203.758,-14.3089, 5.0 );
	local rep9 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 285.353,296.706,-21.3649, 5.0 );
	local rep10 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 553.497,-122.346,-20.1382, 5.0 );
	local rep11 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 719.397,-446.142,-19.9979, 5.0 );
	local rep12 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 49.0399,-405.637,-19.9942, 5.0 );
	
	if(rep1 || rep2 || rep3 || rep4 || rep5 || rep6 || rep7 || rep8 || rep9 || rep10 || rep11 || rep12)
	{
		sendPlayerMessage(playerid, "====[ Команды ]====", yellow[0], yellow[1], yellow[2] );
		sendPlayerMessage(playerid, "/починить", yellow[0], yellow[1], yellow[2] );
		sendPlayerMessage(playerid, "/покрасить (6 раз указать число от 0 до 255)", yellow[0], yellow[1], yellow[2] );
		sendPlayerMessage(playerid, "/колеса (2 раза указать число от 0 до 15)", yellow[0], yellow[1], yellow[2] );
		sendPlayerMessage(playerid, "/тюнинг", yellow[0], yellow[1], yellow[2] );
	}
});

addCommandHandler("починить", 
function(playerid) 
{
	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	local myPos = getPlayerPosition( playerid );
	local rep1 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1583.81,68.6026,-13.1081, 5.0 );
	local rep2 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1438.92,1379.93,-13.3927, 5.0 );
	local rep3 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -375.957,1735.39,-22.8601, 5.0 );
	local rep4 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 425.711,780.516,-21.0679, 5.0 );
	local rep5 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -120.967,529.571,-20.0687, 5.0 );
	local rep6 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -282.268,701.517,-19.7763, 5.0 );
	local rep7 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -687.197,188.526,1.18315, 5.0 );
	local rep8 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -69.189,203.758,-14.3089, 5.0 );
	local rep9 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 285.353,296.706,-21.3649, 5.0 );
	local rep10 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 553.497,-122.346,-20.1382, 5.0 );
	local rep11 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 719.397,-446.142,-19.9979, 5.0 );
	local rep12 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 49.0399,-405.637,-19.9942, 5.0 );
	
	if(rep1 || rep2 || rep3 || rep4 || rep5 || rep6 || rep7 || rep8 || rep9 || rep10 || rep11 || rep12)
	{
		if(repair_ownername == "0" || repair_tanker == 0)
		{
			sendPlayerMessage(playerid, "[ERROR] Автомастерская не работает.", red[0], red[1], red[2]);
			return;
		}

		if( !isPlayerInVehicle(playerid) ) 
		{
			sendPlayerMessage(playerid, "[ERROR] Вы не в машине.", red[0], red[1], red[2] );
			return;
		}

		if(money[playerid] < repair_price)
		{
			sendPlayerMessage(playerid, "[ERROR] Недостаточно средств.", red[0], red[1], red[2]);
			return;
		}

		money[playerid] -= repair_price;
		repair_money += repair_price;

		repair_tanker -= 1;

		local vehicleid = getPlayerVehicle( playerid );
		repairVehicle( vehicleid );

		sendPlayerMessage(playerid, "Вы починили автомобиль за "+repair_price+"$", orange[0], orange[1], orange[2]);
	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не у автомастерской.", red[0], red[1], red[2]);
	}
});

addCommandHandler("покрасить", 
function(playerid, q, w, e, r, t, y) 
{
	local q = q.tointeger();
	local w = w.tointeger();
	local e = e.tointeger();
	local r = r.tointeger();
	local t = t.tointeger();
	local y = y.tointeger();

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	local myPos = getPlayerPosition( playerid );
	local rep1 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1583.81,68.6026,-13.1081, 5.0 );
	local rep2 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1438.92,1379.93,-13.3927, 5.0 );
	local rep3 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -375.957,1735.39,-22.8601, 5.0 );
	local rep4 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 425.711,780.516,-21.0679, 5.0 );
	local rep5 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -120.967,529.571,-20.0687, 5.0 );
	local rep6 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -282.268,701.517,-19.7763, 5.0 );
	local rep7 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -687.197,188.526,1.18315, 5.0 );
	local rep8 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -69.189,203.758,-14.3089, 5.0 );
	local rep9 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 285.353,296.706,-21.3649, 5.0 );
	local rep10 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 553.497,-122.346,-20.1382, 5.0 );
	local rep11 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 719.397,-446.142,-19.9979, 5.0 );
	local rep12 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 49.0399,-405.637,-19.9942, 5.0 );
	
	if(rep1 || rep2 || rep3 || rep4 || rep5 || rep6 || rep7 || rep8 || rep9 || rep10 || rep11 || rep12)
	{
		if(repair_ownername == "0" || repair_tanker < 5)
		{
			sendPlayerMessage(playerid, "[ERROR] Автомастерская не работает.", red[0], red[1], red[2]);
			return;
		}

		if( !isPlayerInVehicle(playerid) ) 
		{
			sendPlayerMessage(playerid, "[ERROR] Вы не в машине.", red[0], red[1], red[2] );
			return;
		}

		if(money[playerid] < repair_price*5)
		{
			sendPlayerMessage(playerid, "[ERROR] Недостаточно средств.", red[0], red[1], red[2]);
			return;
		}

		if( q >= 0 && q <= 255 && w >= 0 && w <= 255 && e >= 0 && e <= 255 && r >= 0 && r <= 255 && t >= 0 && t <= 255 && y >= 0 && y <= 255) 
		{
			local vehicleid = getPlayerVehicle(playerid);
			local plate = getVehiclePlateText(vehicleid);
			local result = database.query( "SELECT COUNT() FROM carnumber_bd WHERE carnumber = '"+plate+"'" );
		    if(result[1]["COUNT()"] == 1)
		    {
				result = database.query( "SELECT * FROM carnumber_bd WHERE carnumber = '"+plate+"'" );

				if(result[1]["ownername"] != getPlayerName( playerid ))
				{
					sendPlayerMessage( playerid, "[ERROR] Это чужая машина.", red[0], red[1], red[2] );
					return;
				}

				money[playerid] -= repair_price*5;
				repair_money += repair_price*5;

				repair_tanker -= 5;

        		setVehicleColour(vehicleid, q,w,e,r,t,y);

				sendPlayerMessage(playerid, "Вы покрасили автомобиль за "+repair_price*5+"$", orange[0], orange[1], orange[2]);
			}
			else
			{
				sendPlayerMessage(playerid, "[ERROR] Мы не обслуживаем такой автомобиль.", red[0], red[1], red[2]);
			}
		}
		else
		{
			sendPlayerMessage(playerid, "[ERROR] Указывайте значения от 0 до 255", red[0], red[1], red[2]);
		}
	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не у автомастерской.", red[0], red[1], red[2]);
	}
});

addCommandHandler("колеса", 
function(playerid, q, w)
{
	local q = q.tointeger();
	local w = w.tointeger();

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	local myPos = getPlayerPosition( playerid );
	local rep1 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1583.81,68.6026,-13.1081, 5.0 );
	local rep2 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1438.92,1379.93,-13.3927, 5.0 );
	local rep3 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -375.957,1735.39,-22.8601, 5.0 );
	local rep4 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 425.711,780.516,-21.0679, 5.0 );
	local rep5 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -120.967,529.571,-20.0687, 5.0 );
	local rep6 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -282.268,701.517,-19.7763, 5.0 );
	local rep7 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -687.197,188.526,1.18315, 5.0 );
	local rep8 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -69.189,203.758,-14.3089, 5.0 );
	local rep9 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 285.353,296.706,-21.3649, 5.0 );
	local rep10 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 553.497,-122.346,-20.1382, 5.0 );
	local rep11 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 719.397,-446.142,-19.9979, 5.0 );
	local rep12 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 49.0399,-405.637,-19.9942, 5.0 );
	
	if(rep1 || rep2 || rep3 || rep4 || rep5 || rep6 || rep7 || rep8 || rep9 || rep10 || rep11 || rep12)
	{
		if(repair_ownername == "0" || repair_tanker < 5)
		{
			sendPlayerMessage(playerid, "[ERROR] Автомастерская не работает.", red[0], red[1], red[2]);
			return;
		}

		if( !isPlayerInVehicle(playerid) ) 
		{
			sendPlayerMessage(playerid, "[ERROR] Вы не в машине.", red[0], red[1], red[2] );
			return;
		}

		if(dviglo[playerid] == 1)
		{
			sendPlayerMessage(playerid, "[ERROR] Заглушите двигатель.", red[0], red[1], red[2] );
			return;
		}

		if(money[playerid] < repair_price*5)
		{
			sendPlayerMessage(playerid, "[ERROR] Недостаточно средств.", red[0], red[1], red[2]);
			return;
		}

		if( q >= 0 && q <= 15 && w >= 0 && w <= 15) 
		{
			local vehicleid = getPlayerVehicle(playerid);
			local plate = getVehiclePlateText(vehicleid);
			local result = database.query( "SELECT COUNT() FROM carnumber_bd WHERE carnumber = '"+plate+"'" );
		    if(result[1]["COUNT()"] == 1)
		    {
				result = database.query( "SELECT * FROM carnumber_bd WHERE carnumber = '"+plate+"'" );

				if(result[1]["ownername"] != getPlayerName( playerid ))
				{
					sendPlayerMessage( playerid, "[ERROR] Это чужая машина.", red[0], red[1], red[2] );
					return;
				}

				database.query( "UPDATE carnumber_bd SET wheel0 = '"+q+"', wheel1 = '"+w+"' WHERE carnumber = '"+plate+"'");

				money[playerid] -= repair_price*5;
				repair_money += repair_price*5;

				repair_tanker -= 5;

				setVehicleWheelTexture( vehicleid, 0, q );
				setVehicleWheelTexture( vehicleid, 1, w );	

				sendPlayerMessage(playerid, "Вы сменили колеса автомобиля за "+repair_price*5+"$", orange[0], orange[1], orange[2]);
			}
			else
			{
				sendPlayerMessage(playerid, "[ERROR] Мы не обслуживаем такой автомобиль.", red[0], red[1], red[2]);
			}
		}
		else
		{
			sendPlayerMessage(playerid, "[ERROR] Указывайте значения от 0 до 15", red[0], red[1], red[2]);
		}
	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не у автомастерской.", red[0], red[1], red[2]);
	}
});

addCommandHandler("тюнинг", 
function(playerid) 
{
	local vehicleid = getPlayerVehicle( playerid );
	local tune;

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	local myPos = getPlayerPosition( playerid );
	local rep1 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1583.81,68.6026,-13.1081, 5.0 );
	local rep2 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1438.92,1379.93,-13.3927, 5.0 );
	local rep3 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -375.957,1735.39,-22.8601, 5.0 );
	local rep4 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 425.711,780.516,-21.0679, 5.0 );
	local rep5 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -120.967,529.571,-20.0687, 5.0 );
	local rep6 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -282.268,701.517,-19.7763, 5.0 );
	local rep7 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -687.197,188.526,1.18315, 5.0 );
	local rep8 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -69.189,203.758,-14.3089, 5.0 );
	local rep9 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 285.353,296.706,-21.3649, 5.0 );
	local rep10 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 553.497,-122.346,-20.1382, 5.0 );
	local rep11 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 719.397,-446.142,-19.9979, 5.0 );
	local rep12 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 49.0399,-405.637,-19.9942, 5.0 );
	
	if(rep1 || rep2 || rep3 || rep4 || rep5 || rep6 || rep7 || rep8 || rep9 || rep10 || rep11 || rep12)
	{
		if(repair_ownername == "0" || repair_tanker < 30)
		{
			sendPlayerMessage(playerid, "[ERROR] Автомастерская не работает.", red[0], red[1], red[2]);
			return;
		}

		if( !isPlayerInVehicle(playerid) ) 
		{
			sendPlayerMessage(playerid, "[ERROR] Вы не в машине.", red[0], red[1], red[2] );
			return;
		}

		local plate = getVehiclePlateText(vehicleid);
		local result = database.query( "SELECT COUNT() FROM carnumber_bd WHERE carnumber = '"+plate+"'" );
	    if(result[1]["COUNT()"] == 1)
	    {
			result = database.query( "SELECT * FROM carnumber_bd WHERE carnumber = '"+plate+"'" );

			if(result[1]["ownername"] != getPlayerName( playerid ))
			{
				sendPlayerMessage( playerid, "[ERROR] Это чужая машина.", red[0], red[1], red[2] );
				return;
			}

			tune = getVehicleTuningTable(vehicleid);
		}
		else
		{
			sendPlayerMessage(playerid, "[ERROR] Мы не обслуживаем такой автомобиль.", red[0], red[1], red[2]);
			return;
		}

		if(tune == -2)
		{
			if(money[playerid] < repair_price*10)
			{
				sendPlayerMessage(playerid, "[ERROR] Недостаточно средств.", red[0], red[1], red[2]);
				return;
			}

			money[playerid] -= repair_price*10;
			repair_money += repair_price*10;

			repair_tanker -= 10;

			setVehicleTuningTable( vehicleid, 1 );

			sendPlayerMessage(playerid, "Вы поставили 1-ый уровень тюнинга за "+repair_price*10+"$", orange[0], orange[1], orange[2]);
			return;
		}

		if(tune == 1)
		{
			if(money[playerid] < repair_price*20)
			{
				sendPlayerMessage(playerid, "[ERROR] Недостаточно средств.", red[0], red[1], red[2]);
				return;
			}

			money[playerid] -= repair_price*20;
			repair_money += repair_price*20;

			repair_tanker -= 20;

			setVehicleTuningTable( vehicleid, 2 );

			sendPlayerMessage(playerid, "Вы поставили 2-ой уровень тюнинга за "+repair_price*20+"$", orange[0], orange[1], orange[2]);
			return;
		}

		if(tune == 2)
		{
			if(money[playerid] < repair_price*30)
			{
				sendPlayerMessage(playerid, "[ERROR] Недостаточно средств.", red[0], red[1], red[2]);
				return;
			}

			money[playerid] -= repair_price*30;
			repair_money += repair_price*30;

			repair_tanker -= 30;

			setVehicleTuningTable( vehicleid, 3 );

			sendPlayerMessage(playerid, "Вы поставили 3-ий уровень тюнинга за "+repair_price*30+"$", orange[0], orange[1], orange[2]);
			return;
		}

		sendPlayerMessage(playerid, "[ERROR] Автомобиль полностью прокачен.", red[0], red[1], red[2]);

	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не у автомастерской.", red[0], red[1], red[2]);
	}
});

//закусочные
addEventHandler("eat", 
function(playerid) 
{
	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	local myPos = getPlayerPosition( playerid );
	local ed1 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -561.204,428.753,1.02075, 2.0 );
	local ed2 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -771.518,-377.324,-20.4072, 2.0 );
	local ed3 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 142.323,-429.708,-19.429, 2.0 );
	local ed4 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 240.014,709.032,-24.0321, 2.0 );
	local ed5 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -645.378,1296.42,3.94464, 2.0 );
	local ed6 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1582.64,1603.77,-5.22507, 2.0 );
	local ed7 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1420.38,961.175,-12.7543, 2.0 );
	local ed8 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1588.62,177.321,-12.4393, 2.0 );
	local ed9 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1559.15,-165.144,-19.6113, 2.0 );
	local ed10 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1384.92,470.174,-22.1321, 2.0 );
	local ed11 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 627.621,897.018,-12.0138, 2.0 );
	local ed12 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -51.0424,737.98,-21.9009, 2.0 );
	local ed13 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -639.003,349.621,1.34485, 2.0 );
	local ed14 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 21.2379,-76.4079,-15.595, 2.0 );
	local ed15 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1148.88,1589.7,6.25566, 2.0 );

	if( ed1 || ed2 || ed3 || ed4 || ed5 || ed6 || ed7 || ed8 || ed9 || ed10 || ed11 || ed12 || ed13 || ed14 || ed15 )
	{
		if(eda_ownername == "0" || eda_tanker == 0)
		{
			sendPlayerMessage(playerid, "[ERROR] Закусочная не работает.", red[0], red[1], red[2]);
			return;
		}

		if(money[playerid] < eda_price)
		{
			sendPlayerMessage(playerid, "[ERROR] Недостаточно средств.", red[0], red[1], red[2]);
			return;
		}

		money[playerid] -= eda_price;
		eda_money += eda_price;

		eda_tanker -= 1;

		setPlayerHealth(playerid, getPlayerHealth(playerid)+100);

		sendPlayerMessage(playerid, "Вы покушали и пополнили здоровье на 100 хп.", yellow[0], yellow[1], yellow[2]);
	}

});

//заправки
addEventHandler("helpfuel",
function(playerid) 
{
	local myPos = getPlayerPosition( playerid );
	local fuel1 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 338.758,875.07,-20.1312, 5.0 );
	local fuel2 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -710.287,1762.62,-14.8309, 5.0 );
	local fuel3 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1592.31,942.639,-4.02328, 5.0 );
	local fuel4 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1679.5,-232.035,-19.1619, 5.0 );
	local fuel5 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -629.5,-48.7479,2.22843, 5.0 );
	local fuel6 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -150.096,610.258,-18.9558, 5.0 );
	local fuel7 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 112.687,181.302,-18.7977, 5.0 );
	local fuel8 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 547.921,2.62598,-17.0294, 5.0 );
	
	if(fuel1 || fuel2 || fuel3 || fuel4 || fuel5 || fuel6 || fuel7 || fuel8)
	{
		sendPlayerMessage(playerid, "====[ Команды ]====", yellow[0], yellow[1], yellow[2] );
		sendPlayerMessage(playerid, "/заправить и указать число от 1 до 200", yellow[0], yellow[1], yellow[2] );
		sendPlayerMessage(playerid, "/купить канистру", yellow[0], yellow[1], yellow[2] );
	}
});

addCommandHandler("купить",
function(playerid, name) 
{
	if(name.tostring() != "канистру")
	{
		return;
	}

	local id = 20;

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	local myPos = getPlayerPosition( playerid );
    local fuel1 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 338.758,875.07,-20.1312, 5.0 );
	local fuel2 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -710.287,1762.62,-14.8309, 5.0 );
	local fuel3 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1592.31,942.639,-4.02328, 5.0 );
	local fuel4 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1679.5,-232.035,-19.1619, 5.0 );
	local fuel5 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -629.5,-48.7479,2.22843, 5.0 );
	local fuel6 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -150.096,610.258,-18.9558, 5.0 );
	local fuel7 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 112.687,181.302,-18.7977, 5.0 );
	local fuel8 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 547.921,2.62598,-17.0294, 5.0 );

	if(fuel1 || fuel2 || fuel3 || fuel4 || fuel5 || fuel6 || fuel7 || fuel8)
	{
		if(fuel_ownername == "0" || fuel_tanker < id)
		{
			sendPlayerMessage(playerid, "[ERROR] Заправка не работает.", red[0], red[1], red[2]);
			return;
		}

		if(money[playerid] < fuel_price*id)
		{
			sendPlayerMessage(playerid, "[ERROR] Недостаточно средств.", red[0], red[1], red[2]);
			return;
		}

		if(can[playerid] == 1)
		{
			sendPlayerMessage(playerid, "[ERROR] У вас куплена канистра с топливом.", red[0], red[1], red[2]);
			return;
		}

		can[playerid] = 1;
		money[playerid] -= fuel_price*id;
		fuel_money += fuel_price*id;

		fuel_tanker -= id;

		sendPlayerMessage(playerid, "Вы купили канистру с "+id+" галлонами топлива за "+fuel_price*id+"$", orange[0], orange[1], orange[2]);
	}
});

addCommandHandler("использовать",
function(playerid, name) 
{
	if(name.tostring() != "канистру")
	{
		return;
	}

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	if( isPlayerInVehicle(playerid) ) 
	{
		sendPlayerMessage(playerid, "[ERROR] Выйдите из машины.", red[0], red[1], red[2] );
        return;
    }

    if(can[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] У вас не куплена канистра с топливом.", red[0], red[1], red[2]);
		return;
	}

	if(car_id[playerid] == -1)
	{
		sendPlayerMessage(playerid, "[ERROR] Чтобы заправить машину из канистры вам надо сесть и выйти из неё, а потом заправлять.", red[0], red[1], red[2] );
		return;
	}

	local myPos = getPlayerPosition( playerid );
	local vehicleid = car_id[playerid];
	local car = getVehiclePosition(vehicleid);
	local dist = getDistanceBetweenPoints3D(myPos[0], myPos[1], myPos[2], car[0], car[1], car[2]);
	local gas = getVehicleFuel(vehicleid);
	local plate = getVehiclePlateText( vehicleid );
	
	if(dist < 5)
	{
		can[playerid] = 0;
			
		setVehicleFuel(vehicleid, gas+20);

		sendPlayerMessage(playerid, "Вы заправили машину на 20 галлонов.", yellow[0], yellow[1], yellow[2] );
		
		local result = database.query( "SELECT COUNT() FROM carnumber_bd WHERE carnumber = '"+plate+"'" );
		if(result[1]["COUNT()"] == 1)
		{
			database.query( "UPDATE carnumber_bd SET fuel = fuel + 20 WHERE carnumber = '"+plate+"'");
		}
	}
	else
	{
		sendPlayerMessage(playerid, "Вы находитесь далеко от машины.", red[0], red[1], red[2] );
	}

});

addCommandHandler("заправить",
function(playerid, id) 
{
	local id = id.tointeger();

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

    if( !isPlayerInVehicle(playerid) ) 
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не в машине.", red[0], red[1], red[2] );
        return;
    }

	local myPos = getPlayerPosition( playerid );
    local fuel1 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 338.758,875.07,-20.1312, 5.0 );
	local fuel2 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -710.287,1762.62,-14.8309, 5.0 );
	local fuel3 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1592.31,942.639,-4.02328, 5.0 );
	local fuel4 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1679.5,-232.035,-19.1619, 5.0 );
	local fuel5 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -629.5,-48.7479,2.22843, 5.0 );
	local fuel6 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -150.096,610.258,-18.9558, 5.0 );
	local fuel7 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 112.687,181.302,-18.7977, 5.0 );
	local fuel8 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 547.921,2.62598,-17.0294, 5.0 );

    local vehicleid = getPlayerVehicle( playerid );
	local vm = getVehicleModel(vehicleid);
	local gas = getVehicleFuel(vehicleid);
	local plate = getVehiclePlateText( vehicleid );

	if(fuel1 || fuel2 || fuel3 || fuel4 || fuel5 || fuel6 || fuel7 || fuel8)
	{
		if(fuel_ownername == "0" || fuel_tanker < id)
		{
			sendPlayerMessage(playerid, "[ERROR] Заправка не работает.", red[0], red[1], red[2]);
			return;
		}

		if(dviglo[playerid] == 1)
		{
			sendPlayerMessage(playerid, "[ERROR] Заглушите двигатель.", red[0], red[1], red[2] );
			return;
		}

		if(money[playerid] < fuel_price*id)
		{
			sendPlayerMessage(playerid, "[ERROR] Недостаточно средств.", red[0], red[1], red[2]);
			return;
		}

		if ( id < 1 )
		{
			sendPlayerMessage(playerid, "[ERROR] Введите значение больше 0", red[0], red[1], red[2]);
			return;
		}

		if(motor_show[vm][2] == 0)
		{
			sendPlayerMessage(playerid, "[ERROR] Мы не обслуживаем такой автомобиль.", red[0], red[1], red[2]);
			return;
		}

		if(gas+id <= motor_show[vm][2])
		{
			money[playerid] -= fuel_price*id;
			fuel_money += fuel_price*id;

			fuel_tanker -= id;

			sendPlayerMessage(playerid, "Машина вымыта и заправлена на "+id+" галлонов за " +fuel_price*id+ "$", orange[0], orange[1], orange[2]);

			setVehicleFuel(vehicleid, gas+id);
			setVehicleDirtLevel( vehicleid, 0.0 );

			local result = database.query( "SELECT COUNT() FROM carnumber_bd WHERE carnumber = '"+plate+"'" );
		    if(result[1]["COUNT()"] == 1)
		    {
				database.query( "UPDATE carnumber_bd SET fuel = fuel + "+id+" WHERE carnumber = '"+plate+"'");
			}
		}
		else
		{
			sendPlayerMessage(playerid, "[ERROR] Максимальная вместимость бака "+motor_show[vm][2]+" галлонов.", red[0], red[1], red[2]);
		}
	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не на заправке.", red[0], red[1], red[2]);
	}
});


//казино
addEventHandler( "helpcasino",
function(playerid)
{
	local myPos = getPlayerPosition( playerid );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -539.082,-91.9283,0.436483, 5.0 );
	
	if(check)
	{
		sendPlayerMessage(playerid, "====[ Команды ]====", yellow[0], yellow[1], yellow[2] );
		sendPlayerMessage(playerid, "/рулетка выбрать режим игры (красное, черное, четное, нечетное, 1-18, 19-36, 1-12, 2-12, 3-12, 2-1, 2-2, 2-3) и указать сумму - сыграть в рулетку (например: /рулетка 1-18 200)", yellow[0], yellow[1], yellow[2] );
		sendPlayerMessage(playerid, "/слоты и указать сумму - сыграть в слоты", yellow[0], yellow[1], yellow[2] );
	}
});

// [1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36]
// [2,4,6,8,10,11,13,15,17,20,22,24,26,28,29,31,33,35]

local chislo = 18;
local red = [1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36];
local black = [2,4,6,8,10,11,13,15,17,20,22,24,26,28,29,31,33,35];

local chislo_to = 12;
local to1 = [1,4,7,10,13,16,19,22,25,28,31,34];
local to2 = [2,5,8,11,14,17,20,23,26,29,32,35];
local to3 = [3,6,9,12,15,18,21,24,27,30,33,36];

function roulette(playerid, randomize)
{
	for (local i = 0; i < chislo; i++)
	{
	    if(randomize == red[i])
		{
			sendPlayerMessage(playerid, "====[ Казино Иллюзия ]====", yellow[0], yellow[1], yellow[2]);
			sendPlayerMessage(playerid, "Выпало "+randomize+" красное", yellow[0], yellow[1], yellow[2]);
		}

		if(randomize == black[i])
		{
		    sendPlayerMessage(playerid, "====[ Казино Иллюзия ]====", yellow[0], yellow[1], yellow[2]);
		    sendPlayerMessage(playerid, "Выпало "+randomize+" черное", yellow[0], yellow[1], yellow[2]);
		}
	}

	if(randomize == 0)
	{
		sendPlayerMessage(playerid, "====[ Казино Иллюзия ]====", yellow[0], yellow[1], yellow[2]);
		sendPlayerMessage(playerid, "Выпало ZERO", yellow[0], yellow[1], yellow[2]);
	}
}

function win_roulette(playerid, cash, ratio)
{
	sendPlayerMessage(playerid, "Вы заработали "+cash*ratio+"$ X"+ratio, green[0], green[1], green[2]);

	money[playerid] += cash*ratio;

	log("");
	log("[WIN] "+getPlayerName(playerid)+" cash "+cash*ratio+" X"+ratio+" money "+money[playerid]);
}

addCommandHandler("рулетка",
function(playerid, id, cash)
{
    local id = id.tostring();
    local cash = cash.tointeger();
    local randomize = random(0,36);

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	local myPos = getPlayerPosition( playerid );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -539.082,-91.9283,0.436483, 5.0 );
	
	if(check)
	{
		if( cash < 1 )
		{
			sendPlayerMessage(playerid, "[ERROR] Введите значение больше 0", red[0], red[1], red[2]);
			return;
		}
		if(money[playerid] < cash)
	    {
	    	sendPlayerMessage(playerid, "[ERROR] Недостаточно средств.", red[0], red[1], red[2]);
	    	return;
	    }

	    if(id == "красное" || id == "черное" || id == "четное" || id == "нечетное" || id == "1-18" || id == "19-36" || id == "1-12" || id == "2-12" || id == "3-12" || id == "2-1" || id == "2-2" || id == "2-3")
	    {
	    	roulette(playerid, randomize);

	    	money[playerid] -= cash;

		    	if(id == "красное" || id == "черное" )
			    {
			    	for (local i = 0; i < chislo; i++)
			    	{
				        if(id == "красное" && randomize == red[i] )
				        {
				            win_roulette(playerid, cash, 2);
				        }

				       	if(id == "черное" && randomize == black[i])
				        {
				            win_roulette(playerid, cash, 2);
				        }
			    	}
		    	}

	    		if(id == "четное" && randomize%2 == 0 )
		        {
		            win_roulette(playerid, cash, 2);
		        }

		       	if(id == "нечетное" && randomize%2 == 1)
		        {
		            win_roulette(playerid, cash, 2);
		        }

		        if(id == "1-18" && randomize >= 1 && randomize <= 18 )
		        {
		            win_roulette(playerid, cash, 2);
		        }

		       	if(id == "19-36" && randomize >= 19 && randomize <= 36 )
		        {
		            win_roulette(playerid, cash, 2);
		        }

		        if(id == "1-12" && randomize >= 1 && randomize <= 12 )
		        {
		            win_roulette(playerid, cash, 3);
		        }

		        if(id == "2-12" && randomize >= 13 && randomize <= 24 )
		        {
		            win_roulette(playerid, cash, 3);
		        }

		        if(id == "3-12" && randomize >= 25 && randomize <= 36 )
		        {
		            win_roulette(playerid, cash, 3);
		        }

				if(id == "2-1" || id == "2-2" || id == "2-3")
			    {
			    	for (local i = 0; i < chislo_to; i++)
			    	{
				        if(id == "2-1" && randomize == to1[i] )
				        {
				            win_roulette(playerid, cash, 3);
				        }

				       	if(id == "2-2" && randomize == to2[i])
				        {
				            win_roulette(playerid, cash, 3);
				        }

				        if(id == "2-3" && randomize == to3[i])
				        {
				            win_roulette(playerid, cash, 3);
				        }
			    	}
		    	}
	    }
	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] Езжайте в казино(кубок на карте)", red[0], red[1], red[2]);
	}
});


addCommandHandler("слоты",
function(playerid, cash)
{
	local cash = cash.tointeger();
	local randomize1 = random(1,5);
	local randomize2 = random(1,5);
	local randomize3 = random(1,5);
	local ratio1 = 5;

	local myPos = getPlayerPosition( playerid );
	local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -539.082,-91.9283,0.436483, 5.0 );

	if(check)
    {
		if(money[playerid] < cash)
    	{
    		sendPlayerMessage(playerid, "[ERROR] Недостаточно средств.", red[0], red[1], red[2]);
    		return;
    	}

    	if( cash < 1 )
		{
			sendPlayerMessage(playerid, "[ERROR] Введите значение больше 0", red[0], red[1], red[2]);
			return;
		}

    	sendPlayerMessage(playerid, "====[ Казино Иллюзия ]====", yellow[0], yellow[1], yellow[2]);
		sendPlayerMessage(playerid, "Выпало: "+randomize1+" - "+randomize2+" - "+randomize3, yellow[0], yellow[1], yellow[2]);

		money[playerid] -= cash;

		if(randomize1 == randomize2 && randomize1 == randomize3)
		{
			money[playerid] += cash*ratio1;

			sendPlayerMessage(playerid, "Вы выиграли "+cash*ratio1+"$ :-)", green[0], green[1], green[2]);

			log("");
            log("[SLOT WIN] "+getPlayerName(playerid)+" cash "+cash*ratio1+" money "+money[playerid]);
			return;
		}
		
		sendPlayerMessage(playerid, "Вы проиграли "+cash+"$ :-(", orange[0], orange[1], orange[2]);
	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] Езжайте в казино(кубок на карте)", red[0], red[1], red[2]);
	}
});

//админские команды
addCommandHandler("скин",
function(playerid, id) 
{
	for (local i = 0; i < developer_chislo; i++) 
	{
		if(getPlayerName(playerid) != developer[i])
		{
			return;
		}
	}

	skin[playerid] = id.tointeger();
	setPlayerModel(playerid, id.tointeger());
});

addCommandHandler("+бабло",
function(playerid, id) 
{
	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	for (local i = 0; i < developer_chislo; i++) 
	{
		if(getPlayerName(playerid) != developer[i])
		{
			return;
		}
	}

	local id = id.tointeger();
	money[playerid] += id;
	sendPlayerMessage( playerid, "Вы выдали себе " +id+ "$", lyme[0], lyme[1], lyme[2] );
});

addCommandHandler("-бабло",
function(playerid, id) 
{
	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	for (local i = 0; i < developer_chislo; i++) 
	{
		if(getPlayerName(playerid) != developer[i])
		{
			return;
		}
	}

	local id = id.tointeger();
	money[playerid] -= id;
	sendPlayerMessage( playerid, "Вы забрали у себя " +id+ "$", lyme[0], lyme[1], lyme[2] );
});

addCommandHandler("филкар",
function(playerid) 
{
	for (local i = 0; i < developer_chislo; i++) 
	{
		if(getPlayerName(playerid) != developer[i])
		{
			return;
		}
	}

	local vehicleid = getPlayerVehicle(playerid);
	setVehicleFuel(vehicleid, 40.0);
	sendPlayerMessage(playerid, "Вы заправили машину.", lyme[0], lyme[1], lyme[2]);
});

addCommandHandler("фил",
function(playerid, id) 
{
	for (local i = 0; i < developer_chislo; i++) 
	{
		if(getPlayerName(playerid) != developer[i])
		{
			return;
		}
	}

	local vehicleid = getPlayerVehicle(playerid);
	setVehicleFuel(vehicleid, id.tofloat());
});

addCommandHandler("в",
function(playerid, id) 
{
	for (local i = 0; i < developer_chislo; i++) 
	{
		if(getPlayerName(playerid) != developer[i])
		{
			return;
		}
	}

	local pos = getPlayerPosition( playerid );
	local vehicleid = createVehicle( id.tointeger(), pos[0] + 2.0, pos[1], pos[2] + 1.0, 0.0, 0.0, 0.0 );
	setVehiclePlateText(vehicleid, "gonka");
});

addCommandHandler( "а",
function( playerid, ...)
{
	for (local i = 0; i < developer_chislo; i++) 
	{
		if(getPlayerName(playerid) != developer[i])
		{
			return;
		}
	}

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	local text = "";
	for(local i = 0; i < vargv.len(); i++)
	{
		text = text + " " + vargv[i];
	}

	sendPlayerMessageToAll( "[АДМИН]"+text, lyme[0], lyme[1], lyme[2] );
	log("");
	log("[ADMIN]"+text);
});

addCommandHandler("инфо",//узнать ип игрока
function(playerid, id) 
{
	local id = id.tointeger();
	
	for (local i = 0; i < developer_chislo; i++) 
	{
		if(getPlayerName(playerid) != developer[i])
		{
			return;
		}
	}

	if(logged[id] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Игрок не в сети!", red[0], red[1], red[2] );
		return;
	}

	if(stats_pass[playerid] == 0)
	{
		sendPlayerMessage(playerid, "====[ PlayerInfo "+getPlayerName(id)+" ]====", lyme[0], lyme[1], lyme[2]);
		sendPlayerMessage(playerid, "IP: " +getPlayerIP(id) );
		sendPlayerMessage(playerid, "Serial: " +getPlayerSerial(id) );
		sendPlayerMessage(playerid, "Здоровье: " +getPlayerHealth(id) );

		triggerClientEvent( playerid, "stats_client", biznes[id].tostring(), job[id].tostring(), exp[id].tostring(), crimes[id].tostring(), house[id].tostring(), drugs[id].tostring(), fish[id].tostring(), money[id].tostring(), bank[id].tostring(), getPlayerName(id), car_slot[id]);
		triggerClientEvent( playerid, "open", "");
		stats_pass[playerid] = 1;
	}
});

addCommandHandler("фрак",
function(playerid, id, name) 
{
	local id = id.tointeger();
	local name = name.tointeger();

	if(logged[playerid] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Вы не вошли!", red[0], red[1], red[2] );
		return;
	}

	if(logged[id] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Игрок не в сети!", red[0], red[1], red[2] );
		return;
	}

	for (local i = 0; i < developer_chislo; i++) 
	{
		if(getPlayerName(playerid) != developer[i])
		{
			return;
		}
	}

	job[id] = name;

	sendPlayerMessage( playerid, "Вы назначили "+getPlayerName(id)+" на работу "+name, lyme[0], lyme[1], lyme[2] );
});

addCommandHandler( "банак",
function( playerid, id, reason)
{
	local id = id.tointeger();
	local reason = reason.tostring();

	for (local i = 0; i < developer_chislo; i++) 
	{
		if(getPlayerName(playerid) != developer[i])
		{
			return;
		}
	}

	if(logged[id] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Игрок не в сети!", red[0], red[1], red[2] );
		return;
	}

	local playername = getPlayerName(id);

	database.query( "UPDATE account SET ban = '1' WHERE name = '"+playername+"'");

	sendPlayerMessage(playerid, "Вы забанили "+getPlayerName(id)+" "+reason, lyme[0], lyme[1], lyme[2] );

	log("");
	log("[BANAK] "+getPlayerName(playerid)+" ban by "+getPlayerName(id)+" "+reason);

	kickPlayer( id );
});

addCommandHandler( "банс",
function( playerid, id, reason)
{
	local id = id.tointeger();
	local reason = reason.tostring();

	for (local i = 0; i < developer_chislo; i++) 
	{
		if(getPlayerName(playerid) != developer[i])
		{
			return;
		}
	}

	if(logged[id] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Игрок не в сети!", red[0], red[1], red[2] );
		return;
	}

	local ini = EasyINI("banserial/"+getPlayerSerial(id)+".ini");
	ini.saveData();

	sendPlayerMessage(playerid, "Вы забанили серийник "+getPlayerName(id)+" "+reason, lyme[0], lyme[1], lyme[2] );

	log("");
	log("[BANSERIAL] "+getPlayerName(playerid)+" ban by "+getPlayerName(id)+" "+reason);

	kickPlayer( id );
});

addCommandHandler( "кик",
function( playerid, id)
{
	local id = id.tointeger();

	for (local i = 0; i < developer_chislo; i++) 
	{
		if(getPlayerName(playerid) != developer[i])
		{
			return;
		}
	}

	if(logged[id] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Игрок не в сети!", red[0], red[1], red[2] );
		return;
	}

	sendPlayerMessage(playerid, "Вы кикнули "+getPlayerName(id), lyme[0], lyme[1], lyme[2] );

	kickPlayer( id );
});

addCommandHandler("п", 
function(playerid, r, g, b, r1, g1, b1) 
{
	for (local i = 0; i < developer_chislo; i++) 
	{
		if(getPlayerName(playerid) != developer[i])
		{
			return;
		}
	}

    if(isPlayerInVehicle(playerid)) 
	{
        local vehicleid = getPlayerVehicle(playerid);
        setVehicleColour(vehicleid, r.tointeger(), g.tointeger(), b.tointeger(), r1.tointeger(), g1.tointeger(), b1.tointeger());
    }
});

addCommandHandler( "дие",
function( playerid )
{
	for (local i = 0; i < developer_chislo; i++) 
	{
		if(getPlayerName(playerid) != developer[i])
		{
			return;
		}
	}

	setPlayerHealth( playerid, 0.0 );
});

addCommandHandler( "гото",
function( playerid, q, w, e )
{
	for (local i = 0; i < developer_chislo; i++) 
	{
		if(getPlayerName(playerid) != developer[i])
		{
			return;
		}
	}

	if(!isPlayerInVehicle(playerid))
	{
		setPlayerPosition( playerid, q.tofloat(), w.tofloat(), e.tofloat() );
	}
	else
	{
		local vehicleid = getPlayerVehicle(playerid);
		setVehiclePosition( vehicleid, q.tofloat(), w.tofloat(), e.tofloat() );
	}
});

addCommandHandler( "поз",
function( playerid )
{
	for (local i = 0; i < developer_chislo; i++) 
	{
		if(getPlayerName(playerid) != developer[i])
		{
			return;
		}
	}

	local pos = getPlayerPosition( playerid );
	sendPlayerMessage(playerid, "Ваши координаты x= "+pos[0] + ", " + "y= "+pos[1] + ", " + "z= "+pos[2], lyme[0], lyme[1], lyme[2]);
	log("");
	log("[COORD] x= "+pos[0]+ ", " + "y= "+pos[1]+ ", " + "z= "+pos[2]);
});

addCommandHandler( "тп",
function( playerid, id, id1 )
{
	local id = id.tointeger();

	for (local i = 0; i < developer_chislo; i++) 
	{
		if(getPlayerName(playerid) != developer[i])
		{
			return;
		}
	}

	if(logged[id] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Игрок не в сети!", red[0], red[1], red[2] );
		return;
	}

	local myPos = getPlayerPosition(id);
    setPlayerPosition(playerid, myPos[0], myPos[1], myPos[2]+id1.tointeger());
});

addCommandHandler( "тпигрок",
function( playerid, id )
{
	local id = id.tointeger();

	for (local i = 0; i < developer_chislo; i++) 
	{
		if(getPlayerName(playerid) != developer[i])
		{
			return;
		}
	}

	if(logged[id] == 0)
	{
		sendPlayerMessage(playerid, "[ERROR] Игрок не в сети!", red[0], red[1], red[2] );
		return;
	}

	local myPos = getPlayerPosition(playerid);
    setPlayerPosition(id, myPos[0], myPos[1], myPos[2]+2);
});

addCommandHandler( "сет",
function(playerid, id, model)
{
	for (local i = 0; i < developer_chislo; i++) 
	{
		if(getPlayerName(playerid) != developer[i])
		{
			return;
		}
	}

	local id = id.tointeger();
	local model = model.tointeger();
	setPlayerHandModel(playerid, id, model);
});

addCommandHandler( "выдатьоружие",
function( playerid, id )
{
	for (local i = 0; i < developer_chislo; i++) 
	{
		if(getPlayerName(playerid) != developer[i])
		{
			return;
		}
	}

	local id = id.tointeger();

	givePlayerWeapon( id, 2, 42 ); //револьвер копов(6)
	givePlayerWeapon( id, 3, 60 ); //пистолет с96(10)
	givePlayerWeapon( id, 4, 56 ); //кольт 1911(7)
	givePlayerWeapon( id, 5, 92 ); //кольт 1911 (23)
	givePlayerWeapon( id, 6, 42 ); //магнум (6)
	givePlayerWeapon( id, 8, 56 ); //дробовик копов(8)
	givePlayerWeapon( id, 9, 120 ); //пп (30)
	givePlayerWeapon( id, 10, 128 ); //мп40 (32)
	givePlayerWeapon( id, 11, 200 ); //пп томпсон(50)

	sendPlayerMessage(playerid, "Вы выдали оружие "+getPlayerName(id), lyme[0], lyme[1], lyme[2]);
});

addCommandHandler( "забратьоружие",
function( playerid, id )
{
	for (local i = 0; i < developer_chislo; i++) 
	{
		if(getPlayerName(playerid) != developer[i])
		{
			return;
		}
	}

	local id = id.tointeger();

	removePlayerWeapon( id, 2, 0 ); //револьвер копов(6)
	removePlayerWeapon( id, 3, 0 ); //пистолет с96(10)
	removePlayerWeapon( id, 4, 0 ); //кольт 1911(7)
	removePlayerWeapon( id, 5, 0 ); //кольт 1911 (23)
	removePlayerWeapon( id, 6, 0 ); //магнум (6)
	removePlayerWeapon( id, 8, 0 ); //дробовик копов(8)
	removePlayerWeapon( id, 9, 0 ); //пп (30)
	removePlayerWeapon( id, 10, 0 ); //мп40 (32)
	removePlayerWeapon( id, 11, 0 ); //пп томпсон(50)

	sendPlayerMessage(playerid, "Вы забрали оружие "+getPlayerName(id), lyme[0], lyme[1], lyme[2]);
});

//количество игроков
addCommandHandler( "список",
function( playerid )
{
	for (local i = 0; i < developer_chislo; i++) 
	{
		if(getPlayerName(playerid) != developer[i])
		{
			return;
		}
	}

    local list = "";
 
    foreach(i, playername in getPlayers())
	{
		list += " " +playername+ "(" +i+ ")["+getPlayerPing(i)+"], ";
    }
 	
	sendPlayerMessage( playerid,"Всего игроков:"+list, lyme[0], lyme[1], lyme[2]);
});

addEventHandler( "testcar",
function( playerid, id1, id2, id3, id4 )
{
	log("");
	log("car model ["+id1+"] tune ["+id2+"] speed "+id3+" km/h = "+id4);
});

addCommandHandler("пос", 
function(playerid, ...) 
{
	for (local i = 0; i < developer_chislo; i++) 
	{
		if(getPlayerName(playerid) != developer[i])
		{
			return;
		}
	}

    // for info about reading modes check out
    // http://www.cplusplus.com/reference/cstdio/fopen/
    local posfile = file("positions.txt", "a");
    local pos;

    if (isPlayerInVehicle(playerid)) 
    {
        pos = getVehiclePosition( getPlayerVehicle(playerid) );
    } else 
    {
        pos = getPlayerPosition( playerid );
    }

    // read rest of the input string (if there any)
    // concat it, and push to the pos array
    if (vargv.len() > 0) 
    {
        pos.push(vargv.reduce(function(a, b) 
        {
            return a + " " + b;
        }));
    }

    // iterate over px,y,z]
    foreach (idx, value in pos) 
    {

        // convert value to string,
        // and iterate over each char
        local coord = value.tostring();
        for (local i = 0; i < coord.len(); i++) 
        {
            posfile.writen(coord[i], 'b');
        }

        // also write whitespace after the number
        posfile.writen(',', 'b');
    }

    // and dont forget push newline before closing
    posfile.writen('\n', 'b');
    posfile.close();

    sendPlayerMessage(playerid, "Позиция сохранена; Посмотреть её можете в файле positions.txt", lyme[0], lyme[1], lyme[2]);
});

addEventHandler( "avar",
    function( playerid )
    {
    if ( !isPlayerInVehicle(playerid) ) {
        return;
    }

    if(sead[playerid] == 1)
	{
		sendPlayerMessage( playerid, "[ERROR] Не мешай водителю.", red[0], red[1], red[2] );
		return;
	}
 
    local vehicleid = getPlayerVehicle(playerid);
    local prevState = getIndicatorLightState(vehicleid, INDICATOR_LEFT);
	local prevState = getIndicatorLightState(vehicleid, INDICATOR_RIGHT);
 
    setIndicatorLightState(vehicleid, INDICATOR_LEFT, !prevState);
	setIndicatorLightState(vehicleid, INDICATOR_RIGHT, !prevState);
    }
);
addEventHandler("left", 
function(playerid) 
{
    if ( !isPlayerInVehicle(playerid) ) {
        return;
    }
 
    if(sead[playerid] == 1)
	{
		sendPlayerMessage( playerid, "[ERROR] Не мешай водителю.", red[0], red[1], red[2] );
		return;
	}

    local vehicleid = getPlayerVehicle(playerid);
    local prevState = getIndicatorLightState(vehicleid, INDICATOR_LEFT);
 
    setIndicatorLightState(vehicleid, INDICATOR_LEFT, !prevState);
});
addEventHandler("right", 
function(playerid) 
{
    if ( !isPlayerInVehicle(playerid) ) {
        return;
    }

    if(sead[playerid] == 1)
	{
		sendPlayerMessage( playerid, "[ERROR] Не мешай водителю.", red[0], red[1], red[2] );
		return;
	}
 
    local vehicleid = getPlayerVehicle(playerid);
    local prevState = getIndicatorLightState(vehicleid, INDICATOR_RIGHT);
 
    setIndicatorLightState(vehicleid, INDICATOR_RIGHT, !prevState);
});

addCommandHandler( "очистить",
function( playerid )
{
	for (local i = 0; i < 15; i++)
	{
		sendPlayerMessage( playerid, "" );
	}
});

function consoleInput( command, params )
{
	log("");
  	log( "Commands - " +command );

  	if(command == "list")
  	{
  		local list = "";
 
    	foreach(i, playername in getPlayers())
		{
			list += " " +playername+ "(" +i+ ")["+getPlayerPing(i)+"], ";
    	}

    	log("Online:" + list);
		return;
	}


    log("");
}
addEventHandler( "onConsoleInput", consoleInput );
