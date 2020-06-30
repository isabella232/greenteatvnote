package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class LikeState extends FlxState {
    
    var a_guifonstatic:Array<FlxSprite>=new Array(); // для картинок под кнопками и возможно яркости
    var a_guifonlike:Array<FlxSprite>=new Array(); // для картинок под кнопками и возможно яркости like block
    var a_guisymstatic:Array<FlxSprite>=new Array(); //надписи на фонах
    var a_guisymlike:Array<FlxSprite>=new Array(); //надписи на фонах
    var a_guibtnstatic:Array<FlxButton>=new Array(); //надписи на фонах
    var a_guibtnlike:Array<FlxButton>=new Array(); //надписи на фонах
    var help:FlxSprite;
    var page:Int=1;
    var maxpage:Int=1;
    
    function guifon_maker():Void{
        // static gui block
        var ax:Array<Int>=new Array(); //координаты спрайтов
        var ay:Array<Int>=new Array(); //координаты спрайтов
        var aa:Array<String>=new Array(); //assets
        aa.push("assets/images/r8080.png");
        aa.push("assets/images/b56080.png");
        aa.push("assets/images/r8080.png");
        aa.push("assets/images/b80160.png");//down bar
        aa.push("assets/images/b80160.png");
        aa.push("assets/images/b160160.png");
        aa.push("assets/images/b160160.png");
        var d:Int = 80;
        ax=[d*0,d*1,d*8,d*0,d*4,d*5,d*7];
        ay=[d*2,d*2,d*2,d*14,d*14,d*14,d*14];
        for (i in 0...7){
            a_guifonstatic.push(new FlxSprite(ax[i],ay[i],aa[i]));
            add(a_guifonstatic[i]);
        }
        // like gui block rowleft then row right
        ax=[for (i in 0...10) 0].concat([for (i in 0...10) d*7]).concat([for (i in 0...10) d*8]); // like10x minus10x plus10x
        ay=[for (i in 4...14) d*i].concat([for (i in 4...14) d*i]).concat([for (i in 4...14) d*i]);
        aa=[for (i in 0...30) "assets/images/b8080.png"]; //box8080 fon sprite
        for (i in 0...30){
            a_guifonlike.push(new FlxSprite(ax[i],ay[i],aa[i]));
            add(a_guifonlike[i]);
        }
    }
    
    function guisym_maker():Void{
        // static gui block
        var ax:Array<Int>=new Array(); //координаты спрайтов
        var ay:Array<Int>=new Array(); //координаты спрайтов
        var aa:Array<String>=new Array();
        aa.push("assets/images/help8080.png");
        aa.push("assets/images/gt8080.png");
        aa.push("assets/images/page80160.png");//down bar first need mirror 
        aa.push("assets/images/page80160.png");
        aa.push("assets/images/back160160.png");
        aa.push("assets/images/new160160.png");
        var d:Int = 80;
        ax=[d*0,d*8,d*0,d*4,d*5,d*7]; // ? fulllist gt < > back new
        ay=[d*2,d*2,d*14,d*14,d*14,d*14];
        for (i in 0...6){
            a_guisymstatic.push(new FlxSprite(ax[i],ay[i],aa[i]));
            add(a_guisymstatic[i]);
        }
        a_guisymstatic[2].flipX=true;
        // like gui block rowleft then row right
        ax=[for (i in 0...10) 0].concat([for (i in 0...10) d*7]).concat([for (i in 0...10) d*8]); // like10x minus10x plus10x
        ay=[for (i in 4...14) d*i].concat([for (i in 4...14) d*i]).concat([for (i in 4...14) d*i]);
        aa=[for (i in 0...10) "assets/images/del8080.png"].concat([for (i in 0...10) "assets/images/minus8080.png"]).concat([for (i in 0...10) "assets/images/plus8080.png"]);
        for (i in 0...30){
            a_guisymlike.push(new FlxSprite(ax[i],ay[i],aa[i]));
            add(a_guisymlike[i]);
        }
        
    }
    
    //btn callback blok
    
    function maxpage_counter():Void{
        maxpage=Std.int(Math.fceil(Main.likehref.length/10));
        if (maxpage==0){page=1;}
        else if (page>maxpage) {page=maxpage;}
    }
    
    function text_done_devide_ok(n):String{ // просмотрено / готово
        return Std.string(Main.likedone[n])+"/"+Std.string(Main.likeok[n]);
    }
    
    function refresh_screen_text():Void{
        if (maxpage==0){ a_text[1].text="список пустой. сначала добавьте в избраное"; }
        var x:Int=10*(page-1);
        for (i in 2...12){ //индексы текстовых полей на экране в масиве
            if(i+x-2 < Main.likehref.length){
                a_text[i].text=Main.likename[i+x-2].substr(0,90)+"...";
                a_text[i+10].text=text_done_devide_ok(i+x-2);
            }else{
                a_text[i].text="";
                a_text[i+10].text="";
            }
        }
        a_text[22].text=Std.string(page)+"/"+Std.string(maxpage);
    }
    
    function refresh_screen_sym():Void{
        var x:Int=10*(page-1);
        for (i in 0...10){ //индексы символов кнопок на экране в масиве
            if(i+x < Main.likehref.length){
                a_guisymlike[i].color=FlxColor.WHITE;
                a_guisymlike[i+10].color=FlxColor.WHITE;
                a_guisymlike[i+20].color=FlxColor.WHITE;
            }else{
                a_guisymlike[i].color=FlxColor.BLACK;
                a_guisymlike[i+10].color=FlxColor.BLACK;
                a_guisymlike[i+20].color=FlxColor.BLACK;
            }
        }
    }
    
    function refresh_screen_fon():Void{
        var x:Int=10*(page-1);
        for (i in 0...10){ //индексы фонов кнопок на экране в масиве
            if(i+x < Main.likehref.length){
                a_guifonlike[i].color=FlxColor.WHITE;
                a_guifonlike[i+10].color=FlxColor.WHITE;
                a_guifonlike[i+20].color=FlxColor.WHITE;
            }else{
                a_guifonlike[i].color=FlxColor.BLACK;
                a_guifonlike[i+10].color=FlxColor.BLACK;
                a_guifonlike[i+20].color=FlxColor.BLACK;
            }
        }
    }
    
    function refresh_screen_btn():Void{
        var x:Int=10*(page-1);
        for (i in 0...10){ //индексы кнопок на экране в масиве
            if(i+x < Main.likehref.length){
                a_guibtnlike[i].color=FlxColor.WHITE;
                a_guibtnlike[i+10].color=FlxColor.WHITE;
                a_guibtnlike[i+20].color=FlxColor.WHITE;
                a_guibtnlike[i+30].color=FlxColor.WHITE;
            }else{
                a_guibtnlike[i].color=FlxColor.BLACK;
                a_guibtnlike[i+10].color=FlxColor.BLACK;
                a_guibtnlike[i+20].color=FlxColor.BLACK;
                a_guibtnlike[i+30].color=FlxColor.BLACK;
            }
        }
    }
    
    function refresh_screen():Void{
        maxpage_counter();
        refresh_screen_text();
        refresh_screen_sym();
        refresh_screen_fon();
        refresh_screen_btn();
    }
    
    function new_btn_callback():Void{
        var situation:String=Main.refresh_web_data_maker("full");
        if(situation=="ok"){
            a_text[1].text="получены новые даные о релизах";
            Main.saveall();
        }else if (situation=="pause"){
            a_text[1].text="рано. бережем трафик сайта. пауза 1/4 часа.";
        }else if (situation=="error"){
            a_text[1].text="ошибка даных. проверьте доступность сайта.";
        }else{
            a_text[1].text="неизвестная ошибка. сообщите разработчикам.";
        }
        refresh_screen();
    }
    
    function help_btn_callback():Void{
        if(help.visible){help.visible=false;help.kill();}
        else{help.visible=true;add(help);help.reset(0,160);}
    }
    
    function pageminus_btn_callback():Void{
        if (page>1) {page-=1;}else{page=maxpage;}
        refresh_screen();
    }
    
    function pageplus_btn_callback():Void{
        if (page<maxpage) {page+=1;}else{page=1;}
        refresh_screen();
    }
    
    function is_del_btn(name:String):Int{
        var names:Array<String>=[for (i in 1...11) "del"+Std.string(i)];
        for (i in 0...10){
            if (name==names[i]) return i;
        }
        return -1;
    }
    
    function is_last(x:Int):Bool{
        if (Main.likehref[x]==Main.likehref[Main.likehref.length-1]) return true;
        return false;
    }
    
    function del_btn_callback(n:Int):Void{
        if (a_guibtnlike[n].color==FlxColor.WHITE){
            var x:Int=10*(page-1)+n;
            if (is_last(x)){
                Main.likedone.splice(x,1);
                Main.likeok.splice(x,1);
                Main.likename.splice(x,1);
                Main.likehref.splice(x,1);
                a_text[1].text="удалено из избраного";
            }else{
                Main.likedone.push(Main.likedone.splice(x,1)[0]);
                Main.likeok.push(Main.likeok.splice(x,1)[0]);
                Main.likename.push(Main.likename.splice(x,1)[0]);
                Main.likehref.push(Main.likehref.splice(x,1)[0]);
                a_text[1].text="перемещено в конец списка";
            }
            refresh_screen();
        }
    }
    
    function is_plus_btn(name:String):Int{
        var names:Array<String>=[for (i in 1...11) "plus"+Std.string(i)];
        for (i in 0...10){if (name==names[i]) return i;}
        return -1;
    }
    
    function plus_btn_callback(n:Int):Void{
        if (a_guibtnlike[n].color==FlxColor.WHITE){
            var x:Int=10*(page-1)+n;
            Main.likedone[x]+=1;
            var ok:Int=Main.likeok[x];
            var done:Int=Main.likedone[x];
            a_text[1].text="готово: "+Std.string(ok)+"  просмотрено: "+Std.string(done)+"  новых: "+Std.string(ok-done);
            refresh_screen();
        }
    }
    
    function is_minus_btn(name:String):Int{
        var names:Array<String>=[for (i in 1...11) "minus"+Std.string(i)];
        for (i in 0...10){if (name==names[i]) return i;}
        return -1;
    }
    
    function minus_btn_callback(n:Int):Void{
        if (a_guibtnlike[n].color==FlxColor.WHITE){
            var x:Int=10*(page-1)+n;
            if (Main.likedone[x]>0) Main.likedone[x]-=1;
            var ok:Int=Main.likeok[x];
            var done:Int=Main.likedone[x];
            a_text[1].text="готово: "+Std.string(ok)+"  просмотрено: "+Std.string(done)+"  новых: "+Std.string(ok-done);
            refresh_screen();
        }
    }
    
    function is_info_btn(name):Int{
        var names:Array<String>=[for (i in 1...11) "info"+Std.string(i)];
        for (i in 0...10){ if (name==names[i]){return i;} }
        return -1;
    }
    
    function info_btn_callback(n:Int):Void{
        if (a_guibtnlike[n].color==FlxColor.WHITE){
            var x:Int=10*(page-1)+n;
            FlxG.openURL(Main.likehref[x],"_blank");
        }
    }
    
    function guibtn_callback(name:String):Void{
        if (Main.cantouch){
            Main.cantouch=false;
            var is_del:Int=is_del_btn(name);
            var is_plus:Int=is_plus_btn(name);
            var is_minus:Int=is_minus_btn(name);
            var is_info:Int=is_info_btn(name);
            if (name=="new") new_btn_callback();
            else if (name=="page<") pageminus_btn_callback();
            else if (name=="page>") pageplus_btn_callback();
            else if (is_del>-1) del_btn_callback(is_del);
            else if (is_plus>-1) plus_btn_callback(is_plus);
            else if (is_minus>-1) minus_btn_callback(is_minus);
            else if (is_info>-1) info_btn_callback(is_info);
            else if (name=="gthome") FlxG.openURL(Main.www,"_blank");
            // else if (name=="back") {Main.ads.hidebanner(); FlxG.switchState(new FreshState());}
            else if (name=="back") {FlxG.switchState(new FreshState());}
            // else if (name=="full") {Main.ads.hidebanner(); FlxG.switchState(new FullState());}
            else if (name=="full") {FlxG.switchState(new FullState());}
            else if (name=="help") help_btn_callback();
            else{trace(name);}
            if (is_plus>-1 || is_minus>-1 || is_del>-1) Main.saveall();
        }
        Main.cantouch=true;
    }
    
    function guibtn_maker():Void{
        // static gui block
        var ax:Array<Int>=new Array(); //координаты спрайтов
        var ay:Array<Int>=new Array(); //координаты спрайтов
        var aa:Array<String>=new Array(); //png link
        var an:Array<String>=new Array(); //btn name
        
        aa.push("assets/images/g8080.png");
        aa.push("assets/images/g56080.png");
        aa.push("assets/images/g8080.png");
        aa.push("assets/images/g200160.png");//down bar first need mirror 
        aa.push("assets/images/g200160.png");
        aa.push("assets/images/g160160.png");
        aa.push("assets/images/g160160.png");
        
        an.push("help");
        an.push("full");
        an.push("gthome");
        an.push("page<");
        an.push("page>");
        an.push("back");
        an.push("new");
        
        
        var d:Int = 80;
        ax=[d*0,d*1,d*8,d*0,200,d*5,d*7];
        ay=[d*2,d*2,d*2,d*14,d*14,d*14,d*14];
        for (i in 0...7){
            a_guibtnstatic.push(new FlxButton(ax[i],ay[i],"",function():Void{guibtn_callback(an[i]);}));
            switch(i){
                case 1:a_guibtnstatic[i].loadGraphic(aa[i],true,560,80);
                case 5,6:a_guibtnstatic[i].loadGraphic(aa[i],true,160,160);
                case 3,4:a_guibtnstatic[i].loadGraphic(aa[i],true,200,160);
                default:a_guibtnstatic[i].loadGraphic(aa[i],true,80,80);
            }
            add(a_guibtnstatic[i]);
        }
        
        // like gui block columnleft then column right
        ax=[for (i in 0...10) 0].concat([for (i in 0...10) d*1]).concat([for (i in 0...10) d*7]).concat([for (i in 0...10) d*8]); // del10x gt10x minus10x plus10x
        ay=[for (i in 4...14) d*i].concat([for (i in 4...14) d*i]).concat([for (i in 4...14) d*i]).concat([for (i in 4...14) d*i]);
        // aa=[for (i in 0...30) "assets/images/g8080.png"];
        aa=[for (i in 0...10) "assets/images/g8080.png"].concat([for (i in 0...10) "assets/images/g48080.png"]).concat([for (i in 0...20) "assets/images/g8080.png"]);
        
        var lan:Array<String>=new Array();
        for (i in 1...11){
            lan.push("del"+Std.string(i));
        }
        for (i in 1...11){
            lan.push("info"+Std.string(i));
        }
        for (i in 1...11){
            lan.push("minus"+Std.string(i));
        }
        for (i in 1...11){
            lan.push("plus"+Std.string(i));
        }
        
        for (i in 0...40){
            a_guibtnlike.push(new FlxButton(ax[i],ay[i],"",function():Void{guibtn_callback(lan[i]);}));
            if (i<10 || i>=20) a_guibtnlike[i].loadGraphic(aa[i],true,80,80);
            else a_guibtnlike[i].loadGraphic(aa[i],true,480,80);
            // a_guibtnlike[i].loadGraphic(aa[i],true,80,80);
            add(a_guibtnlike[i]);
        }
        
    }
    
    var a_text:Array<FlxText>=new Array();
    
    function textstylemaker(t:FlxText,font:String,fsize:Int,color:FlxColor,tfw:Int,text:String):Void
	{
		var style:FlxTextBorderStyle = FlxTextBorderStyle.OUTLINE;
		var afont:String="";
        if(font=="merri_bi"){afont="Merriweather-BoldItalic.ttf";}
        else{afont="guicompress.ttf";}
        t.setFormat("assets/data/"+afont, fsize, color);
		t.fieldWidth=tfw;
        t.text=text;
		t.alignment = CENTER;
		add(t);
	}
    function guitext_maker():Void{
        var ax:Array<Int>=new Array();
        var ay:Array<Int>=new Array();
        var at:Array<String>=new Array(); //default text
        var aw:Array<Int>=new Array(); //field width
        var as:Array<Int>=new Array(); //font size
        var an:Array<String>=new Array(); //font name roboto,vertasti
        ax=[80,0].concat([for (i in 0...10) 80]).concat([for (i in 0...10) 560]).concat([80]); //full, info , films x10, ready x10, pages
        ay=[160,240].concat([for (i in 4...14) i*80]).concat([for (i in 4...14) i*80]).concat([1160]);
        at=["загрузить полный список 700+","дополнительная информация"].concat([for (i in 0...10) "название релиза"]).concat([for (i in 0...10) "00"]).concat(["1/1"]);
        aw=[560,720].concat([for (i in 0...10) 480]).concat([for (i in 0...10) 160]).concat([240]);
        as=[30,30].concat([for (i in 0...10) 30]).concat([for (i in 0...10) 60]).concat([60]);
        an=["merri_bi","merri_bi"].concat([for (i in 0...10) "merri_bi"]).concat([for (i in 0...10) "guicompress"]).concat(["guicompress"]);
        for (i in 0...23){
            a_text.push(new FlxText(ax[i],ay[i]));
            textstylemaker(a_text[i],an[i],as[i],FlxColor.WHITE,aw[i],at[i]);
        }
    }
    
    function help_maker():Void{
        help=new FlxSprite(0,160,"assets/images/likehelp1.png");
        help.visible=false;
    }
    
    function sun_btn_callback(alp:Float):Void{
        for (i in a_guifonlike){i.alpha=alp;}
        for (i in a_guifonstatic){i.alpha=alp;}
        for (i in a_guisymstatic){i.alpha=alp;}
        for (i in a_guisymlike){i.alpha=alp;}
        for (i in a_text){i.alpha=alp;}
    }
    
    public override function create():Void {
        super.create();
        Main.loadall();
        guifon_maker();
        guisym_maker();
        guitext_maker();
        guibtn_maker();
        help_maker();
        new_btn_callback();
        sun_btn_callback(Main.sun);
        // Main.ads.showbanner();
    }

    public override function update(elapsed:Float):Void {
        super.update(elapsed);

    }
}