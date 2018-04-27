local screen = getScreenSize( );

//заправки
local fuel_price;
local fuel_tanker;
local fuel_ownername;
local fuel_money;

//закусочные + бары
local eda_price;
local eda_tanker;
local eda_ownername;
local eda_money;

//автомастерские
local repair_price;
local repair_tanker;
local repair_ownername;
local repair_money;

//оружейки
local gun_price;
local gun_tanker;
local gun_ownername;
local gun_money;

addEventHandler( "biznes_fuel",
function( id1, id2, id3, id4 )
{
	fuel_price = id1;
	fuel_tanker = id2;
	fuel_ownername = id3;
	fuel_money = id4;
});

addEventHandler( "biznes_eda",
function( id1, id2, id3, id4 )
{
	eda_price = id1;
	eda_tanker = id2;
	eda_ownername = id3;
	eda_money = id4;
});

addEventHandler( "biznes_repair",
function( id1, id2, id3, id4 )
{
	repair_price = id1;
	repair_tanker = id2;
	repair_ownername = id3;
	repair_money = id4;
});

addEventHandler( "biznes_gun",
function( id1, id2, id3, id4 )
{
	gun_price = id1;
	gun_tanker = id2;
	gun_ownername = id3;
	gun_money = id4;
});

addEventHandler( "onClientFrameRender", 
function(post)
{
	local myPos = getPlayerPosition( getLocalPlayer() );
	
	local mesto1 = getScreenFromWorld( -252.324,-79.688,-10.458 );
	local check1 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -252.324,-79.688,-11.458, 5.0 );
	if( check1 )
	{
		dxDrawText( "Магазин одежды (Нажмите Е)", mesto1[0], mesto1[1], fromRGB( 255, 255, 0 ), true, "tahoma-bold", 1.0 );
	}
	
	local mesto2 = getScreenFromWorld( -37.4106,1158.15,69.3648 );
	local check2 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -37.4106,1158.15,68.3648, 10.0 );
	if( check2 )
	{
		
	}
	
	local mesto3 = getScreenFromWorld( 13.7068,1254.02,67.3859 );
	local check3 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 13.7068,1254.02,66.3859, 10.0 );
	if( check3 )
	{
		
	}

	local mesto9 = getScreenFromWorld( 67.2002,-202.94,-19.2324 );
	local check4 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 67.2002,-202.94,-19.2324, 10.0 );
	if( check4 )
	{
		dxDrawText( "Банк (Нажмите Е)", mesto9[0], mesto9[1], fromRGB( 0, 255, 0 ), true, "tahoma-bold", 1.0 );
	}

	local mesto10 = getScreenFromWorld( -199.473,838.605,-20.2431 );
	local check5 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -199.473,838.605,-20.2431, 10.0 );
	if( check5 )
	{
		dxDrawText( "Автосалон (Нажмите Е)", mesto10[0], mesto10[1], fromRGB( 0, 255, 255 ), true, "tahoma-bold", 1.0 );
	}

	local mesto26 = getScreenFromWorld( -350.47,-726.813,-14.4206 );
	local mesto27 = getScreenFromWorld( -350.47,-726.813,-14.5206 );
	local check6 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -350.47,-726.813,-14.4206, 2.0 );
	if( check6 )
	{
		dxDrawText( "(Работа) Докер (Нажмите Е)", mesto26[0], mesto26[1], fromRGB( 0, 255, 255 ), true, "tahoma-bold", 1.0 );
		dxDrawText( "Уволиться (Нажмите Q)", mesto27[0], mesto27[1], fromRGB( 150, 150, 150 ), true, "tahoma-bold", 1.0 );
	}

	local mesto28 = getScreenFromWorld( -427.786,-737.652,-20.7381 );
	local check7 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -427.786,-737.652,-21.7381, 5.0 );
	if( check7 )
	{
		dxDrawText( "Взять ящик (Нажмите Е)", mesto28[0], mesto28[1], fromRGB( 0, 255, 255 ), true, "tahoma-bold", 1.0 );
	}

	local mesto29 = getScreenFromWorld( -411.778,-827.907,-20.7456 );
	local check8 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -411.778,-827.907,-21.7456, 5.0 );
	if( check8 )
	{
		dxDrawText( "Положить ящик (Нажмите Е)", mesto29[0], mesto29[1], fromRGB( 0, 255, 255 ), true, "tahoma-bold", 1.0 );
	}

	local mesto30 = getScreenFromWorld( 763.599,802.275,-11.0161 );
	local mesto31 = getScreenFromWorld( 763.599,802.275,-11.1161 );
	local check9 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 763.599,802.275,-12.0161, 2.0 );
	if( check9 )
	{
		dxDrawText( "(Работа) Водитель (Нажмите Е)", mesto30[0], mesto30[1], fromRGB( 0, 255, 255 ), true, "tahoma-bold", 1.0 );
		dxDrawText( "Уволиться (Нажмите Q)", mesto31[0], mesto31[1], fromRGB( 150, 150, 150 ), true, "tahoma-bold", 1.0 );
	}

	local mesto32 = getScreenFromWorld( -80.3572,1742.86,-17.6085 );
	local mesto33 = getScreenFromWorld( -80.3572,1742.86,-17.7085 );
	local check10 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -80.3572,1742.86,-18.7085, 2.0 );
	if( check10 )
	{
		dxDrawText( "(Работа) Сборщик металла (Нажмите Е)", mesto32[0], mesto32[1], fromRGB( 0, 255, 255 ), true, "tahoma-bold", 1.0 );
		dxDrawText( "Уволиться (Нажмите Q)", mesto33[0], mesto33[1], fromRGB( 150, 150, 150 ), true, "tahoma-bold", 1.0 );
	}

	local mesto34 = getScreenFromWorld( -115.11,-63.1035,-11.041 );
	local check11 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -115.11,-63.1035,-11.041, 10.0 );
	if( check11 )
	{
		dxDrawText( "Мерия (Нажмите Е)", mesto34[0], mesto34[1], fromRGB( 0, 255, 255 ), true, "tahoma-bold", 1.0 );
	}

	local mesto35 = getScreenFromWorld( -378.987,654.699,-10.5013 );
	local check12 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -378.987,654.699,-10.5013, 2.0 );
	if( check12 )
	{
		dxDrawText( "Полицейский департамент (Нажмите Е)", mesto35[0], mesto35[1], fromRGB( 0, 255, 255 ), true, "tahoma-bold", 1.0 );
	}

	local mesto36 = getScreenFromWorld( -422.731,479.451,1.1 );
	local mesto37 = getScreenFromWorld( -422.731,479.451,1.0 );
	local check13 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -422.731,479.451,0.1, 2.0 );
	if( check13 )
	{
		dxDrawText( "(Работа) Водитель автобуса (Нажмите Е)", mesto36[0], mesto36[1], fromRGB( 0, 255, 255 ), true, "tahoma-bold", 1.0 );
		dxDrawText( "Уволиться (Нажмите Q)", mesto37[0], mesto37[1], fromRGB( 150, 150, 150 ), true, "tahoma-bold", 1.0 );
	}

	local mesto38 = getScreenFromWorld( -393.394,913.983,-19.0026 );
	local check14 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -393.394,913.983,-20.0026, 2.0 );
	if( check14 )
	{
		dxDrawText( "Госпиталь Эмпайр-Бэй (Нажмите Е)", mesto38[0], mesto38[1], fromRGB( 0, 255, 255 ), true, "tahoma-bold", 1.0 );
	}

	local mesto4 = getScreenFromWorld(  myPos[0], myPos[1], myPos[2]+1.4 );
	local mesto5 = getScreenFromWorld(  myPos[0], myPos[1], myPos[2]+1.3 );
	local mesto7 = getScreenFromWorld(  myPos[0], myPos[1], myPos[2]+1.2 );
	local mesto6 = getScreenFromWorld(  myPos[0], myPos[1], myPos[2]+1.1 );
	local mesto8 = getScreenFromWorld(  myPos[0], myPos[1], myPos[2]+1 );
	local fuel1 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 338.758,875.07, -20.0312, 5.0 );
	local fuel2 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -710.287,1762.62,-13.7309, 5.0 );
	local fuel3 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1592.31,942.639,-4.02328, 5.0 );
	local fuel4 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1679.5,-232.035,-19.1619, 5.0 );
	local fuel5 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -629.5,-48.7479,2.22843, 5.0 );
	local fuel6 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -150.096,610.258,-18.9558, 5.0 );
	local fuel7 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 112.687,181.302,-18.7977, 5.0 );
	local fuel8 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 547.921,2.62598,-17.0294, 5.0 );
	if( fuel1 || fuel2 || fuel3 || fuel4 || fuel5 || fuel6 || fuel7 || fuel8 )
	{
		dxDrawText( "Сеть Заправок", mesto4[0], mesto4[1], fromRGB( 255, 255, 255 ), true, "tahoma-bold", 1.0 );
		dxDrawText( "Стоимость топлива: 1 галлон = " +fuel_price+ "$", mesto5[0], mesto5[1], fromRGB( 255, 100, 0 ), true, "tahoma-bold", 1.0 );

		if(fuel_ownername == "0")
		{
			dxDrawText( "Владелец: Продается за 200000$", mesto7[0], mesto7[1], fromRGB( 255, 255, 0 ), true, "tahoma-bold", 1.0 );
		}
		else
		{
			dxDrawText( "Владелец: " +fuel_ownername, mesto7[0], mesto7[1], fromRGB( 255, 255, 0 ), true, "tahoma-bold", 1.0 );
		}

		if( fuel_ownername == getPlayerName(getLocalPlayer()) )
		{
			dxDrawText( "Хранилище: " +fuel_tanker+ " | 50000", mesto6[0], mesto6[1], fromRGB( 255, 255, 0 ), true, "tahoma-bold", 1.0 );
			dxDrawText( "Деньги: " +fuel_money+ "$", mesto8[0], mesto8[1], fromRGB( 0, 255, 0 ), true, "tahoma-bold", 1.0 );
		}

		dxDrawText( "Показать команды (Нажмите Е)", 0.0, (screen[1]-40), fromRGB( 255, 255, 255 ), true, "tahoma-bold", 2.0 );
	}


	local mesto11 = getScreenFromWorld(  myPos[0], myPos[1], myPos[2]+1.4 );
	local mesto12 = getScreenFromWorld(  myPos[0], myPos[1], myPos[2]+1.3 );
	local mesto13 = getScreenFromWorld(  myPos[0], myPos[1], myPos[2]+1.2 );
	local mesto14 = getScreenFromWorld(  myPos[0], myPos[1], myPos[2]+1.1 );
	local mesto15 = getScreenFromWorld(  myPos[0], myPos[1], myPos[2]+1 );
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
		dxDrawText( "Сеть Закусочных", mesto11[0], mesto11[1], fromRGB( 255, 255, 255 ), true, "tahoma-bold", 1.0 );
		dxDrawText( "Стоимость продукта: 1 шт = " +eda_price+ "$", mesto12[0], mesto12[1], fromRGB( 255, 100, 0 ), true, "tahoma-bold", 1.0 );

		if(eda_ownername == "0")
		{
			dxDrawText( "Владелец: Продается за 200000$", mesto13[0], mesto13[1], fromRGB( 255, 255, 0 ), true, "tahoma-bold", 1.0 );
		}
		else
		{
			dxDrawText( "Владелец: " +eda_ownername, mesto13[0], mesto13[1], fromRGB( 255, 255, 0 ), true, "tahoma-bold", 1.0 );
		}

		if( eda_ownername == getPlayerName(getLocalPlayer()) )
		{
			dxDrawText( "Хранилище: " +eda_tanker+ " | 50000", mesto14[0], mesto14[1], fromRGB( 255, 255, 0 ), true, "tahoma-bold", 1.0 );
			dxDrawText( "Деньги: " +eda_money+ "$", mesto15[0], mesto15[1], fromRGB( 0, 255, 0 ), true, "tahoma-bold", 1.0 );
		}

		dxDrawText( "Чтобы покушать (Нажмите Q)", 0.0, (screen[1]-40), fromRGB( 255, 255, 255 ), true, "tahoma-bold", 2.0 );
	}

	local mesto16 = getScreenFromWorld(  myPos[0], myPos[1], myPos[2]+1.4 );
	local mesto17 = getScreenFromWorld(  myPos[0], myPos[1], myPos[2]+1.3 );
	local mesto18 = getScreenFromWorld(  myPos[0], myPos[1], myPos[2]+1.2 );
	local mesto19 = getScreenFromWorld(  myPos[0], myPos[1], myPos[2]+1.1 );
	local mesto20 = getScreenFromWorld(  myPos[0], myPos[1], myPos[2]+1 );
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
		dxDrawText( "Сеть Автомастерских", mesto16[0], mesto16[1], fromRGB( 255, 255, 255 ), true, "tahoma-bold", 1.0 );
		dxDrawText( "Стоимость запчастей: 1 запчасть = " +repair_price+ "$", mesto17[0], mesto17[1], fromRGB( 255, 100, 0 ), true, "tahoma-bold", 1.0 );

		if(repair_ownername == "0")
		{
			dxDrawText( "Владелец: Продается за 200000$", mesto18[0], mesto18[1], fromRGB( 255, 255, 0 ), true, "tahoma-bold", 1.0 );
		}
		else
		{
			dxDrawText( "Владелец: " +repair_ownername, mesto18[0], mesto18[1], fromRGB( 255, 255, 0 ), true, "tahoma-bold", 1.0 );
		}

		if( repair_ownername == getPlayerName(getLocalPlayer()) )
		{
			dxDrawText( "Хранилище: " +repair_tanker+ " | 50000", mesto19[0], mesto19[1], fromRGB( 255, 255, 0 ), true, "tahoma-bold", 1.0 );
			dxDrawText( "Деньги: " +repair_money+ "$", mesto20[0], mesto20[1], fromRGB( 0, 255, 0 ), true, "tahoma-bold", 1.0 );
		}

		dxDrawText( "Показать команды (Нажмите Е)", 0.0, (screen[1]-40), fromRGB( 255, 255, 255 ), true, "tahoma-bold", 2.0 );
	}

	local mesto21 = getScreenFromWorld(  myPos[0], myPos[1], myPos[2]+1.4 );
	local mesto22 = getScreenFromWorld(  myPos[0], myPos[1], myPos[2]+1.3 );
	local mesto23 = getScreenFromWorld(  myPos[0], myPos[1], myPos[2]+1.2 );
	local mesto24 = getScreenFromWorld(  myPos[0], myPos[1], myPos[2]+1.1 );
	local mesto25 = getScreenFromWorld(  myPos[0], myPos[1], myPos[2]+1 );
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
		dxDrawText( "Сеть Оружеек", mesto21[0], mesto21[1], fromRGB( 255, 255, 255 ), true, "tahoma-bold", 1.0 );
		dxDrawText( "Стоимость боеприпаса : 1 боеприпас = " +gun_price+ "$", mesto22[0], mesto22[1], fromRGB( 255, 100, 0 ), true, "tahoma-bold", 1.0 );

		if(gun_ownername == "0")
		{
			dxDrawText( "Владелец: Продается за 200000$", mesto23[0], mesto23[1], fromRGB( 255, 255, 0 ), true, "tahoma-bold", 1.0 );
		}
		else
		{
			dxDrawText( "Владелец: " +gun_ownername, mesto23[0], mesto23[1], fromRGB( 255, 255, 0 ), true, "tahoma-bold", 1.0 );
		}

		if( gun_ownername == getPlayerName(getLocalPlayer()) )
		{
			dxDrawText( "Хранилище: " +gun_tanker+ " | 50000", mesto24[0], mesto24[1], fromRGB( 255, 255, 0 ), true, "tahoma-bold", 1.0 );
			dxDrawText( "Деньги: " +gun_money+ "$", mesto25[0], mesto25[1], fromRGB( 0, 255, 0 ), true, "tahoma-bold", 1.0 );
		}

		dxDrawText( "Показать команды (Нажмите Е)", 0.0, (screen[1]-40), fromRGB( 255, 255, 255 ), true, "tahoma-bold", 2.0 );
	}

});

//входы и выходы
local coord_len = 104;
local coord = [
	[-85.0722,1736.67,-18.7004],//bryski_vh1
	[-84.403,1736.8,-18.7167],
	[-549.544,-51.2645,1.03809],//arkadia_vh1
	[-549.436,-50.3488,1.03805],
	[41.5553,1784.44,-17.8668],//clemente_vh
	[41.5922,1785.13,-17.8401],
	[-165.166,519.097,-19.9438],//jyzepe_vh1
	[-165.09,519.746,-19.9191],
	[-166.527,520.78,-16.0193],//jyzepe_vh2
	[-167.196,521.024,-16.0193],
	[-1292.64,1608.65,4.30491],//armyn_vh
	[-1293.31,1608.94,4.33968],
	[-164.907,-582.803,-20.1767],//bryno_vh
	[-165.077,-583.508,-20.1767],
	[-348.263,-731.353,-15.3389],//port_vh
	[-347.96,-730.686,-15.4208],
	[136.28,-433.722,-19.4657],//zak_vh1
	[136.41,-433.043,-19.429],
	[-638.118,1294.83,3.90784],//zak_vh2
	[-638.707,1294.46,3.94464],
	[-1588.77,1599.75,-5.26265],//zak_vh3
	[-1588.57,1600.43,-5.22507],
	[-1416.36,954.948,-12.7921],//zak_vh4
	[-1417.04,955.09,-12.7543],
	[-1584.61,171.068,-12.4761],//zak_vh5
	[-1585.29,171.234,-12.4393],
	[-1552.83,-169.192,-19.624],//zak_vh6
	[-1553.17,-168.589,-19.6113],
	[-1392.27,476.369,-22.0811],//zak_vh7
	[-1391.62,476.218,-22.0779],
	[-1381.67,480.863,-23.182],//zak_vh8
	[-1381.79,480.215,-23.182],
	[-1379.62,471.347,-22.1031],//zak_vh9
	[-1380.27,471.405,-22.1247],
	[629.515,894.428,-12.0137],//zak_vh10
	[629.661,895.129,-12.0138],
	[631.031,900.294,-12.0137],//zak_vh11
	[630.932,899.661,-12.0138],
	[-48.3979,728.282,-21.9681],//zak_vh12
	[-48.9059,728.721,-21.9009],
	[-642.92,357.472,1.34699],//zak_vh13
	[-642.544,356.902,1.34888],
	[-632.733,345.808,1.26277],//zak_vh14
	[-633.402,345.78,1.34485],
	[29.2695,-66.4476,-16.1665],//zak_vh15
	[28.1576,-66.223,-16.193],
	[26.6142,-68.1314,-16.1945],//zak_vh16
	[26.5849,-68.9184,-16.1942],
	[-1151.57,1580.17,6.27222],//zak_vh17
	[-1151.64,1580.82,6.25985],
	[-1158.3,1599.33,6.28698],//zak_vh18
	[-1157.66,1599.45,6.25566],
	[-592.761,506.872,1.02469],//gans_vh1
	[-592.858,506.173,1.02277],
	[-561.842,310.851,0.186179],//gans_vh2
	[-562.541,311.033,0.171005],
	[-4.65856,739.782,-22.02],//gans_vh3
	[-5.35775,739.878,-22.0582],
	[404.501,609.636,-24.8944],//gans_vh4
	[404.353,608.936,-24.9746],
	[62.1702,139.456,-14.4132],//gans_vh5
	[62.8693,139.56,-14.4583],
	[273.899,-118.779,-12.1976],//gans_vh6
	[274.598,-118.851,-12.2741],
	[279.707,-454.18,-20.1616],//gans_vh7
	[279.008,-453.951,-20.1636],
	[-323.112,-594.988,-20.1043],//gans_vh8
	[-322.908,-594.289,-20.1043],
	[-1395.09,-26.8958,-17.8468],//gans_vh9
	[-1395.2,-27.595,-17.8468],
	[-1182.76,1700.38,11.1808],//gans_vh10
	[-1182.71,1701.08,11.0941],
	[-287.76,1621.72,-23.0972],//gans_vh11
	[-287.537,1622.42,-23.0758],
	[-254.572,-52.452,-11.458],//od_vh1
	[-254.7,-53.11,-11.458],
	[-254.268,-88.6935,-11.458],//od_vh2
	[-254.219,-88.0354,-11.458],
	[-1297.07,1698.45,10.6935],//biz_od_vh1
	[-1297.07,1699.08,10.5593],
	[-1417.31,1295.32,-13.7058],//biz_od_vh2
	[-1417.94,1295.37,-13.7194],
	[-1369.41,384.852,-23.7208],//biz_od_vh3
	[-1370.04,385.049,-23.7367],
	[-1534.5,-4.532,-17.8467],//biz_od_vh4
	[-1534.47,-3.90287,-17.8467],
	[-378.296,-456.616,-17.2628],//biz_od_vh5
	[-378.203,-455.987,-17.266],
	[343.258,33.2364,-24.1097],//biz_od_vh6
	[343.295,33.8655,-24.1477],
	[437.402,301.501,-20.1634],//biz_od_vh7
	[436.773,301.723,-20.1785],
	[-43.1751,381.59,-13.9932],//biz_od_vh8
	[-43.203,382.219,-13.9962],
	[-6.97312,552.727,-19.3915],//biz_od_vh9
	[-6.83882,553.356,-19.4066],
	[270.501,767.584,-21.2438],//biz_od_vh10
	[270.555,768.213,-21.2438],
	[-510.848,870.694,-19.3222],//biz_od_vh11
	[-510.219,870.426,-19.2883],
	[-628.501,283.775,-0.248379],//biz_od_vh12
	[-628.386,284.404,-0.266979],
	[411.157,-298.452,-20.1621],//biz_od_vh13
	[411.092,-297.823,-20.1621]
];

//магазины одежды
local coord_len_odejda = 13;
local coord_odejda = [
	[-1292.83,1706.43,10.5592],
	[-1425.29,1299.52,-13.7195],
	[-1377.39,389.123,-23.7368],
	[-1530.26,3.44592,-17.8468],
	[-374.002,-448.638,-17.2661],
	[347.46,41.2144,-24.1478],
	[429.424,305.764,-20.1786],
	[-38.9963,389.568,-13.9963],
	[-2.71507,560.705,-19.4068],
	[274.712,775.562,-21.2439],
	[-518.197,874.753,-19.3224],
	[-624.275,291.753,-0.267097],
	[415.433,-290.474,-20.1622]
];

//метро
local coord_len_subway = 7;
local coord_subway = [
	[-554.36,1592.92,-21.8639],
	[-1119.15,1376.71,-19.7724],
	[-1535.55,-231.03,-13.5892],
	[-511.412,20.1703,-5.7096],
	[-113.792,-481.71,-8.92243],
	[234.395,380.914,-9.41271],
	[-293.069,568.25,-2.27367]
];

//холодосы
local coord_len_sm = 10;
local coord_sm = [
	[-100.209,1777.59,-18.7375],
	[-100.209,1784.23,-18.7375],
	[-100.209,1791.11,-18.7375],
	[-100.209,1812.61,-18.7375],
	[-100.209,1819.64,-18.7375],
	[-100.209,1826.59,-18.7335],
	[-74.3066,1823.29,-18.7367],
	[-74.3065,1816.46,-18.7369],
	[-74.3066,1809.61,-18.7369],
	[-74.3065,1780.41,-18.7371],
];

addEventHandler( "onClientFrameRender", 
function(post)
{
	local myPos = getPlayerPosition( getLocalPlayer() );
	local rot = getPlayerRotation( getLocalPlayer() );
	
	local check1 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -1300.01,1306.43,-13.5724, 100.0 );//рынок
	local check2 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -534.975,-42.5656,1.03805, 5.0 );//ювелирка
	local check3 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 564.845,-555.782,-22.7021, 40.0 );//рыбалка
	local check4 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 389.846,125.266,-20.2027, 1.5 );//рыбзавод
	local check5 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], 426.998,78.4652,-21.249, 5.0 );//триада
	local check6 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -122.825,1753.56,-18.7074, 3.0 );//свалка бруски
	local check7 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -539.082,-91.9283,0.436483, 5.0 );//казино
	
	local press1 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -83.0683,1767.58,-18.4006, 2.0 );
	local press2 = isPointInCircle3D( myPos[0], myPos[1], myPos[2], -79.025,1766.14,-15.8721, 2.0 );
	
	if( check1 )
	{
		dxDrawText( "Авторынок (Нажмите Е)", 0.0, (screen[1]-40), fromRGB( 255, 255, 255 ), true, "tahoma-bold", 2.0 );
	}
	
	if( check2 )
	{
		dxDrawText( "Ограбить ювелирку (Нажмите Е)", 0.0, (screen[1]-40), fromRGB( 255, 255, 255 ), true, "tahoma-bold", 2.0 );
	}
	
	if( check3 )
	{
		dxDrawText( "Зона рыбалки (Нажмите Е)", 0.0, (screen[1]-40), fromRGB( 255, 255, 255 ), true, "tahoma-bold", 2.0 );
	}
	
	if( check4 )
	{
		dxDrawText( "Зона продажи рыбы (Нажмите Е)", 0.0, (screen[1]-40), fromRGB( 255, 255, 255 ), true, "tahoma-bold", 2.0 );
	}
	
	if( check5 || check6 )
	{
		dxDrawText( "Заключить сделку (Нажмите Е)", 0.0, (screen[1]-40), fromRGB( 255, 255, 255 ), true, "tahoma-bold", 2.0 );
	}
	
	if( check7 )
	{
		dxDrawText( "Казино Иллюзия (Нажмите Е)", 0.0, (screen[1]-40), fromRGB( 255, 255, 255 ), true, "tahoma-bold", 2.0 );
	}
	
	if( press1 )
	{
		dxDrawText( "Положить металл (Нажмите Е)", 0.0, (screen[1]-40), fromRGB( 255, 255, 255 ), true, "tahoma-bold", 2.0 );
	}
	if( press2 )
	{
		dxDrawText( "Спрессовать металлолом (Нажмите Е)", 0.0, (screen[1]-40), fromRGB( 255, 255, 255 ), true, "tahoma-bold", 2.0 );
	}
	
	
	for(local i = 0; i < coord_len; i++) 
	{
		local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], coord[i][0], coord[i][1], coord[i][2], 0.5 );

		if(check)
		{
			dxDrawText( "Вход(Выход) (Нажмите Е)", 0.0, (screen[1]-40), fromRGB( 255, 255, 255 ), true, "tahoma-bold", 2.0 );
			break;
		}
	}
	
	for(local i = 0; i < coord_len_odejda; i++) 
	{
		local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], coord_odejda[i][0], coord_odejda[i][1], coord_odejda[i][2], 2.0 );

		if(check)
		{
			dxDrawText( "Ограбить (Нажмите Е)", 0.0, (screen[1]-40), fromRGB( 255, 255, 255 ), true, "tahoma-bold", 2.0 );
			break;
		}
	}
	
	for(local i = 0; i < coord_len_subway; i++)
	{
		local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], coord_subway[i][0], coord_subway[i][1], coord_subway[i][2], 4.0 );

		if(check)
		{
			dxDrawText( "Метро (Нажмите Е)", 0.0, (screen[1]-40), fromRGB( 255, 255, 255 ), true, "tahoma-bold", 2.0 );
			break;
		}
	}
	
	for(local i = 0; i < coord_len_sm; i++) 
	{
		local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], coord_sm[i][0], coord_sm[i][1], coord_sm[i][2], 2.0 );

		if(check)
		{
			dxDrawText( "Взять металл (Нажмите Е)", 0.0, (screen[1]-40), fromRGB( 255, 255, 255 ), true, "tahoma-bold", 2.0 );
			break;
		}
	}
});