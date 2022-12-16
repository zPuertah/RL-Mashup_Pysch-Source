package;

import Sys.sleep;
import discord_rpc.DiscordRpc;
import Random.Random;

#if LUA_ALLOWED
import llua.Lua;
import llua.State;
#end

using StringTools;




class DiscordClient
{
	public static var isInitialized:Bool = false;
	public function new()
	{
		trace("Discord RL Client starting...");
		DiscordRpc.start({
			clientID: "1052104865939210270",
			onReady: onReady,
			onError: onError,
			onDisconnected: onDisconnected
		});
		trace("Discord RL Client started.");

		while (true)
		{
			DiscordRpc.process();
			sleep(2);
			//trace("Discord Client Update");
		}

		DiscordRpc.shutdown();
	}
	
	public static function shutdown()
	{
		DiscordRpc.shutdown();
	}
	
	static function onReady()
	{
		DiscordRpc.presence({
			details: "Playing the RL Mashup",
			state: Random.fromArray(["Cobalea Payaso", "MIL-granillos", "Socorrooooooo(joda)", "Raxzo nos explota(joda)", "A FOLLARNOSLO", "Ingrith I Love You <3", "Follar es Follar", "ZAPATOS UNA COSITA", "¿Donde esta Timmy?", "SUS", "CENCIA!", "Sherf pesao XD", "PORROS!", "No se que hago con mi vida."]),
			largeImageKey: 'logo',
			largeImageText: "RL Mashup",
			smallImageKey: "nothing"
		});
	}

	static function onError(_code:Int, _message:String)
	{
		trace('Error! $_code : $_message');
	}

	static function onDisconnected(_code:Int, _message:String)
	{
		trace('Disconnected! $_code : $_message');
	}

	public static function initialize()
	{
		var DiscordDaemon = sys.thread.Thread.create(() ->
		{
			new DiscordClient();
		});
		trace("Discord Client initialized");
		isInitialized = true;
	}

	public static function changePresence(details:String, state:Null<String>, ?smallImageKey : String, ?hasStartTimestamp : Bool, ?endTimestamp: Float)
	{
		var startTimestamp:Float = if(hasStartTimestamp) Date.now().getTime() else 0;

		if (endTimestamp > 0)
		{
			endTimestamp = startTimestamp + endTimestamp;
		}

		DiscordRpc.presence({
			details: details,
			state: state,
			largeImageKey: 'icon',
			largeImageText: "Mod Version: " + MainMenuState.psychEngineVersion,
			smallImageKey : smallImageKey,
			// Obtained times are in milliseconds so they are divided so Discord can use it
			startTimestamp : Std.int(startTimestamp / 1000),
            endTimestamp : Std.int(endTimestamp / 1000)
		});

		//trace('Discord RPC Updated. Arguments: $details, $state, $smallImageKey, $hasStartTimestamp, $endTimestamp');
	}

	#if LUA_ALLOWED
	public static function addLuaCallbacks(lua:State) {
		Lua_helper.add_callback(lua, "changePresence", function(details:String, state:Null<String>, ?smallImageKey:String, ?hasStartTimestamp:Bool, ?endTimestamp:Float) {
			changePresence(details, state, smallImageKey, hasStartTimestamp, endTimestamp);
		});
	}
	#end
}
