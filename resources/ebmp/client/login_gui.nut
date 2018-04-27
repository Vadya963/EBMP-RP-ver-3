local screen = getScreenSize( );

local logged;
local edit;
local button;

local register;
local edit1;
local button1;

addEventHandler( "onGuiElementClick",
function( element )
{
	if( element == button ) 
	{
		local text = guiGetText ( edit );
		triggerServerEvent( "login", text );
		return;
	}

	if( element == button1 ) 
	{
		local text = guiGetText ( edit1 );
		triggerServerEvent( "reg", text );
		return;
	}
});

local width = 220.0;
local height = 115.0;

addEventHandler( "reg_okno",
function( playerid )
{
	register = guiCreateElement( 0, "Регистрация", (screen[0]/2)-(width/2), (screen[1]/2)-(height/2), width, height );
	local label1 = guiCreateElement( 6, "Введите пароль", 73.0, 20.0, 200.0, 25.0, false, register );
	edit1 = guiCreateElement( 1, "", 10.0, 50.0, 200.0, 25.0, false, register );
	button1 = guiCreateElement( 2, "Войти", 10.0, 80.0, width-20.0, 25.0, false, register );
	guiSetAlpha( register, 1.0 );
});
addEventHandler( "reg",
function( playerid )
{
	showCursor( false );
	guiDestroyElement( register );
});

addEventHandler( "login_okno",
function( playerid )
{
	logged = guiCreateElement( 0, "Авторизация", (screen[0]/2)-(width/2), (screen[1]/2)-(height/2), width, height );
	local label = guiCreateElement( 6, "Введите пароль", 73.0, 20.0, 200.0, 25.0, false, logged );
	edit = guiCreateElement( 1, "", 10.0, 50.0, 200.0, 25.0, false, logged );
	button = guiCreateElement( 2, "Войти", 10.0, 80.0, width-20.0, 25.0, false, logged );
	guiSetAlpha( logged, 1.0 );
});
addEventHandler( "login",
function( playerid )
{
	showCursor( false );
	guiDestroyElement( logged );
});

addEventHandler( "cursor",
function( playerid )
{
	showCursor( true );
});
