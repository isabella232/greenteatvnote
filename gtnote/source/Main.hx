package;

import flixel.FlxGame;
import openfl.Lib;
import openfl.display.Sprite;
import flixel.FlxG;
import flixel.util.FlxSave;
import haxe.Http;

class Main extends Sprite
{
	public static var fullhref:Array<String>=[]; // full list href
	public static var fullname:Array<String>=[]; // full list name
	public static var fullok:Array<Int>=[]; // full list number of episodes ready
	
	public static var freshhref:Array<String>=[]; // fresh list href
	public static var freshname:Array<String>=[]; // fresh list name
	public static var freshok:Array<Int>=[]; // fresh list number of episodes ready
	
	public static var likehref:Array<String>=[]; // like list href
	public static var likename:Array<String>=[]; // like list name
	public static var likeok:Array<Int>=[]; // like list number of ready episodes
	public static var likedone:Array<Int>=[]; // like list number of watched episodes
	
	// public static var ads:Ads;
	public static var game:FlxGame;
	public static var ss:FlxSave;
	public static var testserver:Bool=true;
	public static var fulllasttry:Float=0; //2 секунды удерживает сообщение, для вычисления сообщения на табло во время нажатия обновить
	public static var fulllastrefresh:Float=0; // последнее обновление, для предложения обновить через update
	public static var freshlasttry:Float=0;
	public static var freshlastrefresh:Float=0;
	public static var cantouch:Bool=true;
	public static var sun:Float=1;
	public static var www:String = "http://green-teatv.com";
	
	public static function saveall():Void{
		ss=FlxG.save;
		ss.data.fullhref=fullhref;
		ss.data.fullname=fullname;
		ss.data.fullok=fullok;
		
		ss.data.freshhref=freshhref;
		ss.data.freshname=freshname;
		ss.data.freshok=freshok;
		
		ss.data.likehref=likehref;
		ss.data.likename=likename;
		ss.data.likeok=likeok;
		ss.data.likedone=likedone;
		
		ss.data.sun=sun;
		ss.data.www=www;
		ss.flush();
	}
	
	public static function loadall():Void{
		ss=FlxG.save;
		if (ss.data.fullhref!=null){
			fullhref=ss.data.fullhref;
			fullname=ss.data.fullname;
			fullok=ss.data.fullok;
			
			freshhref=ss.data.freshhref;
			freshname=ss.data.freshname;
			freshok=ss.data.freshok;
			
			likehref=ss.data.likehref;
			likename=ss.data.likename;
			likeok=ss.data.likeok;
			likedone=ss.data.likedone;
			
			sun=ss.data.sun;
		}
		if (ss.data.www != null){ www=ss.data.www; }
		/*patch for server data injection, that not fail with old data, in time of first run after update*/
	}
	
	public static function refreshwww(){
		var serverlink:String;
        serverlink="http://stts.pythonanywhere.com/gtnotewww/";
        var req:Http = new Http(serverlink);
        // req.setParameter("kurs1", Main.namekurs[1]);
        req.request( true );
        var s:String=req.responseData;
		if(s != null && s != "" && s != " "){www = s;}
		saveall();
	}
	
	public static function getserverdata(s:String):String{
		var serverlink:String;
        serverlink=www+"/spisok-relizov.html";
        var req:Http = new Http(serverlink);
        // req.setParameter("kurs1", Main.namekurs[1]);
        req.request( true );
		var s:String=req.responseData;
		return s;
	}
	
	public static function splitreleasedata(s:String):Array<String>{
		var href:String=s.split("|||")[0];
		var name:String=s.split("|||")[1].split("||")[0];
		var done:String=s.split("|||")[1].split("||")[1];
		var as:Array<String>=[href,name,done];
		return as;
	}
	
	public static function ok_counter(li:String):String{
		var ok:String="0";
		try{
			if (li.indexOf(">Фильм</a>")>-1){ok="1";}
			else if (li.indexOf(">Сериал</a>")>-1){ok=li.split(">Сериал</a> -")[1].split("из")[0]; StringTools.trim(ok);}
			if (Type.typeof(Std.parseInt(ok))!=Type.ValueType.TInt){ok="0";}
		}catch(e:Dynamic){ok="0";}
		return ok;
	}
	
	public static function splitwebdata(s:String):Array<Array<String>>{
		var aas:Array<Array<String>>=new Array(); //для результата
		var href:String="";var name:String="";var ok:String=""; var li:String="";
		s=s.split("<div id='dle-content'>")[1].split("</div>")[0]; //выделен блок со списком
		var sp:Array<String>=s.split("<li").slice(1);
		for (i in 0...sp.length){
			li=sp[i].substring(sp[i].indexOf(">")+1);
			href=li.split("href=\"")[1].split("\"")[0];
			name=li.split(">")[1].split("/")[0];// StringTools.trim(name);
			ok=ok_counter(li);
			aas.push([href,name,ok]);
		}
		return aas;
		
		//old code, impossible because pythonanywhere.com free account have whitelist of sites can be parsed
		sp=s.split("||||");//array of releases
		sp=sp.slice(1);
		for (i in 0...sp.length){
			aas[i]=splitreleasedata(sp[i]);
		}
		return aas;
	}
	
	public static function web_data_arrays_cleaner(s:String):Void{
		if (s=="full"){
			fullhref=[]; fullname=[]; fullok=[];
			freshhref=[]; freshname=[]; freshok=[];
		}else if (s=="fresh"){
			freshhref=[]; freshname=[]; freshok=[];
		}
		// likehref=[]; likename=[]; likeok=[];
	}
	
	public static function full_and_fresh_maker(s:String,aas:Array<Array<String>>):Void{
		web_data_arrays_cleaner(s);
		if (s=="fresh"){
			// for (i in 0...10){freshhref.push(aas[i][0]); freshname.push(aas[i][1]); freshok.push(Std.parseInt(aas[i][2]));} //now no need... server not used
			for (i in 0...aas.length){
				fullhref.push(aas[i][0]); fullname.push(aas[i][1]); fullok.push(Std.parseInt(aas[i][2]));
				if (i<10){freshhref.push(aas[i][0]); freshname.push(aas[i][1]); freshok.push(Std.parseInt(aas[i][2]));}
			}
		}else if (s=="full"){
			for (i in 0...aas.length){
				fullhref.push(aas[i][0]); fullname.push(aas[i][1]); fullok.push(Std.parseInt(aas[i][2]));
				if (i<10){freshhref.push(aas[i][0]); freshname.push(aas[i][1]); freshok.push(Std.parseInt(aas[i][2]));}
			}
		}
	}
	
	/**
	 *  try to refresh data from web if time pause is complete. If something was wrong then return false else return true
	 *  @param s - variant of refreshing data "fresh" fresh10 request "full" full700+ request | now always 700+ because free acc pythonanywhere.com whitelist
	 *  @return Bool
	 */
	public static function refresh_web_data_maker(s:String):String{
		var canrefresh:Bool=false; //660000 = 11 minutes
		var dngt:Float=Date.now().getTime();
		if (s=="fresh" && dngt-freshlastrefresh>660000){canrefresh=true;}
		else if (s=="full" && dngt-fulllastrefresh>660000){canrefresh=true;}
		var t:String="";
		try{
			if (canrefresh){
				t = getserverdata(s); // s = fresh or full
				var aas:Array<Array<String>>=splitwebdata(t);
				full_and_fresh_maker(s,aas);
				if(Main.fullname[0]==null) {return "error";}
				else{
					if (s=="fresh"){freshlastrefresh=dngt;}
					else if (s=="full"){fulllastrefresh=dngt;}
				}
			}else{return "pause";}
		}catch(e:Dynamic){
			trace("error try block in refresh_web_data_maker(s)");
			return "error";
		}
		return "ok";
	}
	
	public function new()
	{
		super();
		// ads=new Ads("ca-app-pub-**","",30,0,"up",false);//true тестовая реклама
		game=new FlxGame(720, 1280, MenuState,true);
		addChild(game);
	}
}
