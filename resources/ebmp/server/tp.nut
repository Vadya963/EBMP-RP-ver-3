addEventHandler( "vopros1",
function( playerid )
{
	sendPlayerMessage(playerid, "====[ Вопрос 1 ]====", 255, 255, 0 );
	sendPlayerMessage(playerid, "Какая допустимая скорость движения в городе?", 255, 255, 0 );//2
	sendPlayerMessage(playerid, "1. 60 м/ч", 255, 255, 0 );
	sendPlayerMessage(playerid, "2. 40 м/ч", 255, 255, 0 );
	sendPlayerMessage(playerid, "3. 20 м/ч", 255, 255, 0 );
});

addEventHandler( "vopros2",
function( playerid )
{
	sendPlayerMessage(playerid, "====[ Вопрос 2 ]====", 255, 255, 0 );
	sendPlayerMessage(playerid, "Какая допустимая скорость движения вне города?", 255, 255, 0 );//3
	sendPlayerMessage(playerid, "1. 80 м/ч", 255, 255, 0 );
	sendPlayerMessage(playerid, "2. 100 м/ч", 255, 255, 0 );
	sendPlayerMessage(playerid, "3. 70 м/ч", 255, 255, 0 );	
});

addEventHandler( "vopros3",
function( playerid )
{
	sendPlayerMessage(playerid, "====[ Вопрос 3 ]====", 255, 255, 0 );
	sendPlayerMessage(playerid, "При отсутствии знаков, обозначающих главную дорогу, дорога с твердым покрытием по отношению к грунтовой является...", 255, 255, 0 );//2
	sendPlayerMessage(playerid, "1. Второстепенной", 255, 255, 0 );
	sendPlayerMessage(playerid, "2. Главной", 255, 255, 0 );
	sendPlayerMessage(playerid, "3. Примыкающей", 255, 255, 0 );	
});

addEventHandler( "vopros4",
function( playerid )
{
	sendPlayerMessage(playerid, "====[ Вопрос 4 ]====", 255, 255, 0 );
	sendPlayerMessage(playerid, "Что означает знак STOP", 255, 255, 0 );//1
	sendPlayerMessage(playerid, "1. Движение без остановки запрещено", 255, 255, 0 );
	sendPlayerMessage(playerid, "2. Движение без остановки разрешено", 255, 255, 0 );
	sendPlayerMessage(playerid, "3. Движение с остановкой запрещено", 255, 255, 0 );
});

addEventHandler( "vopros5",
function( playerid )
{
	sendPlayerMessage(playerid, "====[ Вопрос 5 ]====", 255, 255, 0 );
	sendPlayerMessage(playerid, "Являются ли тротуары и обочины частью дороги?", 255, 255, 0 );//3
	sendPlayerMessage(playerid, "1. Не являются", 255, 255, 0 );
	sendPlayerMessage(playerid, "2. Являются только обочины", 255, 255, 0 );
	sendPlayerMessage(playerid, "3. Являются", 255, 255, 0 );
});

addEventHandler( "vopros6",
function( playerid )
{
	sendPlayerMessage(playerid, "====[ Вопрос 6 ]====", 255, 255, 0 );
	sendPlayerMessage(playerid, "Что означает термин «Недостаточная видимость»?", 255, 255, 0 );//1
	sendPlayerMessage(playerid, "1. Видимость дороги менее 300 м в условиях тумана, дождя, снегопада и т.п., а также в сумерки", 255, 255, 0 );
	sendPlayerMessage(playerid, "2. Видимость дороги менее 100 м вблизи опасных поворотов и переломов продольного профиля дороги", 255, 255, 0 );
	sendPlayerMessage(playerid, "3. Видимость дороги менее 150 м в ночное время", 255, 255, 0 );
});

addEventHandler( "vopros7",
function( playerid )
{
	sendPlayerMessage(playerid, "====[ Вопрос 7 ]====", 255, 255, 0 );
	sendPlayerMessage(playerid, "В каком случае водитель совершит вынужденную остановку?", 255, 255, 0 );//3
	sendPlayerMessage(playerid, "1. Остановившись непосредственно перед пешеходным переходом, чтобы уступить дорогу пешеходу", 255, 255, 0 );
	sendPlayerMessage(playerid, "2. В обоих перечисленных случаях", 255, 255, 0 );
	sendPlayerMessage(playerid, "3. Остановившись на проезжей части из-за технической неисправности транспортного средства", 255, 255, 0 );
});

addEventHandler( "vopros8",
function( playerid )
{
	sendPlayerMessage(playerid, "====[ Вопрос 8 ]====", 255, 255, 0 );
	sendPlayerMessage(playerid, "Аварийная сигнализация должна быть включена:", 255, 255, 0 );//3
	sendPlayerMessage(playerid, "1. При дорожно-транспортном происшествии", 255, 255, 0 );
	sendPlayerMessage(playerid, "2. При ослеплении водителя светом фар", 255, 255, 0 );
	sendPlayerMessage(playerid, "3. В обоих перечисленных случаях", 255, 255, 0 );
});

addEventHandler( "vopros9",
function( playerid )
{
	sendPlayerMessage(playerid, "====[ Вопрос 9 ]====", 255, 255, 0 );
	sendPlayerMessage(playerid, "Если во время движения по сухой дороге с асфальтобетонным покрытием начал моросить дождь, водителю следует:", 255, 255, 0 );//1
	sendPlayerMessage(playerid, "1. Уменьшить скорость и быть особенно осторожным", 255, 255, 0 );
	sendPlayerMessage(playerid, "2. Не изменяя скорости продолжить движение", 255, 255, 0 );
	sendPlayerMessage(playerid, "3. Увеличить скорость и попытаться проехать как можно большее расстояние, пока не начался сильный дождь", 255, 255, 0 );
});

addEventHandler( "vopros10",
function( playerid )
{
	sendPlayerMessage(playerid, "====[ Вопрос 10 ]====", 255, 255, 0 );
	sendPlayerMessage(playerid, "Допускается ли пересекать сплошную линию разметки, обозначающую край проезжей части?", 255, 255, 0 );//2
	sendPlayerMessage(playerid, "1. Запрещается", 255, 255, 0 );
	sendPlayerMessage(playerid, "2. Допускается для остановки на обочине и при выезде с нее только в местах, где разрешена остановка или стоянка", 255, 255, 0 );
	sendPlayerMessage(playerid, "3. Допускается для остановки на обочине и при выезде с нее", 255, 255, 0 );
});

//парамедики
addEventHandler( "paramedic_vopros1",//1
function( playerid )
{
	sendPlayerMessage(playerid, "", 255, 255, 0 );
	sendPlayerMessage(playerid, "Первая медицинская помощь при открытом переломе?", 255, 255, 0 );//3
	sendPlayerMessage(playerid, "1. Концы сломанных костей совместить", 255, 255, 0 );
	sendPlayerMessage(playerid, "2. Убрать осколки костей и наложить на рану пузырь со льдом", 255, 255, 0 );
	sendPlayerMessage(playerid, "3. Наложить стерильную повязку на рану, осуществить иммобилизацию конечности и дать покой больному", 255, 255, 0 );
	sendPlayerMessage(playerid, "", 255, 255, 0 );
});

addEventHandler( "paramedic_vopros2",//9
function( playerid )
{
	sendPlayerMessage(playerid, "", 255, 255, 0 );
	sendPlayerMessage(playerid, "Что необходимо сделать при потере сознания?", 255, 255, 0 );//1
	sendPlayerMessage(playerid, "1. Искусственное дыхание", 255, 255, 0 );
	sendPlayerMessage(playerid, "2. Массаж сердца", 255, 255, 0 );
	sendPlayerMessage(playerid, "3. Освободить (санировать) дыхательные пути от инородных тел и рвотных масс", 255, 255, 0 );
	sendPlayerMessage(playerid, "", 255, 255, 0 );
});

addEventHandler( "paramedic_vopros3",//3
function( playerid )
{
	sendPlayerMessage(playerid, "", 255, 255, 0 );
	sendPlayerMessage(playerid, "Чем характеризуется капиллярное кровотечение?", 255, 255, 0 );//3
	sendPlayerMessage(playerid, "1. Кровь из раны вытекает пульсирующей струей, имеет ярко-алую окраску", 255, 255, 0 );
	sendPlayerMessage(playerid, "2. Кровь из раны вытекает непрерывно, сплошной струей темно-красного цвета", 255, 255, 0 );
	sendPlayerMessage(playerid, "3. Кровь из раны вытекает редкими каплями или медленно расплывающимся пятном", 255, 255, 0 );
	sendPlayerMessage(playerid, "", 255, 255, 0 );
});

addEventHandler( "paramedic_vopros4",//4
function( playerid )
{
	sendPlayerMessage(playerid, "", 255, 255, 0 );
	sendPlayerMessage(playerid, "Чем характеризуется венозное кровотечение?", 255, 255, 0 );//2
	sendPlayerMessage(playerid, "1. Кровь из раны вытекает пульсирующей струей, имеет ярко-алую окраску", 255, 255, 0 );
	sendPlayerMessage(playerid, "2. Кровь из раны вытекает непрерывно, сплошной струей темно-красного цвета", 255, 255, 0 );
	sendPlayerMessage(playerid, "3. Кровь из раны вытекает редкими каплями или медленно расплывающимся пятном", 255, 255, 0 );
	sendPlayerMessage(playerid, "", 255, 255, 0 );
});

addEventHandler( "paramedic_vopros5",//5
function( playerid )
{
	sendPlayerMessage(playerid, "", 255, 255, 0 );
	sendPlayerMessage(playerid, "Чем характеризуется артериальное кровотечение?", 255, 255, 0 );//1
	sendPlayerMessage(playerid, "1. Кровь из раны вытекает пульсирующей струей, имеет ярко-алую окраску", 255, 255, 0 );
	sendPlayerMessage(playerid, "2. Кровь из раны вытекает непрерывно, сплошной струей темно-красного цвета", 255, 255, 0 );
	sendPlayerMessage(playerid, "3. Кровь из раны вытекает редкими каплями или медленно расплывающимся пятном", 255, 255, 0 );
	sendPlayerMessage(playerid, "", 255, 255, 0 );
});

addEventHandler( "paramedic_vopros6",//6
function( playerid )
{
	sendPlayerMessage(playerid, "", 255, 255, 0 );
	sendPlayerMessage(playerid, "Правильный способ остановки капиллярного кровотечения?", 255, 255, 0 );//2
	sendPlayerMessage(playerid, "1. Наложение на рану давящей повязки", 255, 255, 0 );
	sendPlayerMessage(playerid, "2. Наложение на конечность жгута", 255, 255, 0 );
	sendPlayerMessage(playerid, "3. Резкое сгибание конечности в суставе", 255, 255, 0 );
	sendPlayerMessage(playerid, "", 255, 255, 0 );
});

addEventHandler( "paramedic_vopros7",//8
function( playerid )
{
	sendPlayerMessage(playerid, "", 255, 255, 0 );
	sendPlayerMessage(playerid, "Правильный способ остановки артериального кровотечения?", 255, 255, 0 );//1
	sendPlayerMessage(playerid, "1. Наложение на рану давящей повязки", 255, 255, 0 );
	sendPlayerMessage(playerid, "2. Наложение жгута или резкое сгибание конечности в суставе", 255, 255, 0 );
	sendPlayerMessage(playerid, "", 255, 255, 0 );
});

addEventHandler( "paramedic_vopros8",//13
function( playerid )
{
	sendPlayerMessage(playerid, "", 255, 255, 0 );
	sendPlayerMessage(playerid, "Какие признаки закрытого перелома костей конечностей?", 255, 255, 0 );//2
	sendPlayerMessage(playerid, "1. Сильная боль, припухлость мягких тканей и деформация конечности", 255, 255, 0 );
	sendPlayerMessage(playerid, "2. Конечность искажена, поврежден кожный покров, видны осколки костей", 255, 255, 0 );
	sendPlayerMessage(playerid, "3. Синяки, ссадины на коже", 255, 255, 0 );
	sendPlayerMessage(playerid, "", 255, 255, 0 );
});

addEventHandler( "paramedic_vopros9",//10
function( playerid )
{
	sendPlayerMessage(playerid, "", 255, 255, 0 );
	sendPlayerMessage(playerid, "По каким признакам судят о наличии внутреннего кровотечения?", 255, 255, 0 );//3
	sendPlayerMessage(playerid, "1. Цвет кожных покровов, уровень артериального давления, сознание", 255, 255, 0 );
	sendPlayerMessage(playerid, "2. Пульс, высокая температура, судороги", 255, 255, 0 );
	sendPlayerMessage(playerid, "3. Резкая боль, появление припухлости, потеря сознания", 255, 255, 0 );
	sendPlayerMessage(playerid, "", 255, 255, 0 );
});

addEventHandler( "paramedic_vopros10",//24
function( playerid )
{
	sendPlayerMessage(playerid, "", 255, 255, 0 );
	sendPlayerMessage(playerid, "Какой материал может быть использован в качестве шины?", 255, 255, 0 );//3
	sendPlayerMessage(playerid, "1. Ткань", 255, 255, 0 );
	sendPlayerMessage(playerid, "2. Бинт, вата", 255, 255, 0 );
	sendPlayerMessage(playerid, "3. Кусок доски", 255, 255, 0 );
	sendPlayerMessage(playerid, "", 255, 255, 0 );
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

addEventHandler( "entrance_and_exit",
function( playerid ) 
{
	if(isPlayerInVehicle(playerid))
	{
		return;
	}

	for(local i = 0; i < coord_len; i++) 
	{
		local myPos = getPlayerPosition( playerid );
		local rot = getPlayerRotation( playerid );
		local check = isPointInCircle3D( myPos[0], myPos[1], myPos[2], coord[i][0], coord[i][1], coord[i][2], 0.5 );

		if(check)
		{
			if(rot[0] >= -60 && rot[0] <= 60)//вперед 0
			{
				setPlayerPosition( playerid, coord[i][0], coord[i][1]+1, coord[i][2] );
			}
			else if(rot[0] >= 70 && rot[0] <= 150)//вправо 90
			{
				setPlayerPosition( playerid, coord[i][0]+1, coord[i][1], coord[i][2] );
			}
			else if(rot[0] >= -150 && rot[0] <= -70)//влево -90
			{
				setPlayerPosition( playerid, coord[i][0]-1, coord[i][1], coord[i][2] );
			}
			else if(rot[0] >= 160 && rot[0] <= 179 || rot[0] >= -179 && rot[0] <= -160)//назад 180
			{
				setPlayerPosition( playerid, coord[i][0], coord[i][1]-1, coord[i][2] );
			}
			else
			{
				sendPlayerMessage(playerid, "[ERROR] Встаньте лицом к двери.", 255, 0, 0 );
			}
		}
	}
});
