/* ************************************************************************ */
/*																			*/
/*  Tora - Neko Application Server											*/
/*  Copyright (c)2008 Motion-Twin											*/
/*																			*/
/* This library is free software; you can redistribute it and/or			*/
/* modify it under the terms of the GNU Lesser General Public				*/
/* License as published by the Free Software Foundation; either				*/
/* version 2.1 of the License, or (at your option) any later version.		*/
/*																			*/
/* This library is distributed in the hope that it will be useful,			*/
/* but WITHOUT ANY WARRANTY; without even the implied warranty of			*/
/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU		*/
/* Lesser General Public License or the LICENSE file for more details.		*/
/*																			*/
/* ************************************************************************ */

class Admin {

	static function w(str) {
		neko.Lib.println(str);
	}

	static function f( v : Float ) {
		return Math.round(v * 10) / 10;
	}

	static function main() {
		neko.Web.setHeader("Content-Type","text/plain");
		var command : String -> String -> Void = neko.Lib.load("mod_neko","tora_command",2);
		var params = neko.Web.getParams();
		if( params.exists("command") )
			command(params.get("command"),params.get("p"));
		var mem = neko.vm.Gc.stats();
		var infos : Infos = neko.Lib.load("mod_neko","tora_infos",0)();
		var busy = 0;
		var cacheHits = 0;
		for( t in infos.threads )
			if( t.file != null )
				busy++;
		for( c in infos.cache )
			cacheHits += c.hits;
		w("--- Tora Admin ---");
		w("Memory : "+Std.int((mem.heap - mem.free)/1024)+" / "+Std.int(mem.heap/1024)+" KB");
		w("Total hits : "+infos.hits+" ("+f(infos.hits/infos.upTime)+"/sec)");
		w("Cache hits : "+cacheHits+" ("+f(cacheHits*100/infos.hits)+"%)");
		w("Queue size : "+infos.queue);
		w("Threads : "+busy+" / "+infos.threads.length);
		w("Uptime : "+f(infos.upTime)+"s");
		w("");
		w("--- Cache ---");
		for( c in infos.cache )
			w(c.file+"\t\t"+c.hits+" hits\t"+c.count+" inst");
		w("");
		w("--- Threads ---");
		var count = 1;
		for( t in infos.threads ) {
			neko.Lib.print((count++)+"\t"+StringTools.lpad(Std.string(t.hits)," ",6)+" hits"+"\t\t");
			if( t.file == null )
				w("idle since "+f(t.time)+"s");
			else
				w("running "+t.url+" since "+f(t.time)+"s");
		}
	}

}