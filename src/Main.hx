package ;

import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
#if html5
import openfl._internal.renderer.canvas.CanvasTextField;
#end
import openfl.display.DisplayObject;
import openfl.display.Shape;
import openfl.events.KeyboardEvent;
import openfl.geom.Point;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.ui.Keyboard;

/**
 * ...
 * @author 
 */

class Main extends Sprite 
{
	var inited:Bool;
	var tfs:Array<TextField>;
	var asTimeLimit = 40;
	var asTimeCur = 0;
	var asTimeDir = 1;
	
	// Circle motion.
	// Why Actuate doesnt have a simple way to create circular motion? Where is chain method like in eaze-tween as3 lib?
	var p1:Point;
	var p1mark:Shape;
	var r1 = 45.0;
	var a1 = 1.0;
	var w1 = 0.012;
	
	var p2:Point;
	var p2mark:Shape;
	var r2 = 160.0;
	var r3 = 40.0;
	var a2 = -1.0;
	
	/* ENTRY POINT */
	
	function resize(e) 
	{
		if (!inited) init();
		// else (resize or orientation change)
	}
	
	function init() 
	{
		if (inited) return;
		inited = true;

		// (your code here)
		
		// Stage:
		// stage.stageWidth x stage.stageHeight @ stage.dpiScale
		
		// Assets:
		// nme.Assets.getBitmapData("img/assetname.jpg");
		
		tfs = new Array();
		
		autoSizeSection();				// 0 - 3
		staticAutoSizeSection();		// 4 - 7
		wordWrapNoAutoSizeSection();	// 8
		nullSizesFieldSection();		// 9 - 15
		wordWrapAutoSizeSection();		// 16
		otherAutoSizeSection();			// 17 - 18
		cmplxFormatSection();			// 19 - 22
		
		stage.addEventListener(Event.ENTER_FRAME, onFrame);
		stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		
		//stringReplaceTest();
	}
	
	private function stringReplaceTest():Void
	{
		#if js
		var str = "abc\rabc\rabc";
		var time:Int;
		
		// split-join
		// replace
		time = Lib.getTimer();
		
		for (i in 0...90000)
		{
			str = str.split('\r').join('\n');
			
			str = "abc\rabc\rabc";
		}
		
		trace('split-join time: ' + (Lib.getTimer() - time));
		
		time = Lib.getTimer();
		// replace
		for (i in 0...90000)
		{
			str = untyped __js__("str.replace(new RegExp('\\r', 'g'), '\\n')");
			
			str = "abc\rabc\rabc";
		}
		
		trace('replace time: ' + (Lib.getTimer() - time));
		
		#end
	}
	
	private function cmplxFormatSection():Void
	{	
		var htmlText1 = 'This text field has <font face="Arial" size="14px" color="#22AA20">html text</font> and wordWrap = false and autoSize = NONE';
		var htmlText2 = 'This text field has <font face="Arial" size="14px" color="#22AA20">html text</font> and wordWrap = false and autoSize = LEFT';
		var htmlText3 = 'This text field has <font face="Arial" size="14px" color="#22AA20">html text</font> and wordWrap = true and autoSize = LEFT';
		var htmlText4 = 'This text field has <font face="Arial" size="14px" color="#22AA20">html text</font> and wordWrap = true and autoSize = NONE';
		
		createTextField("", new Point(430, 30), new Point(360, 50), TextFieldAutoSize.NONE, TextFormatAlign.LEFT, false);
		createTextField("", new Point(0, 0), new Point(360, 90), TextFieldAutoSize.LEFT, TextFormatAlign.LEFT, false);
		createTextField("", new Point(410, 0), new Point(360, 112), TextFieldAutoSize.LEFT, TextFormatAlign.LEFT, true);
		createTextField("", new Point(410, 40), new Point(360, 150), TextFieldAutoSize.NONE, TextFormatAlign.LEFT, true);
		
		tfs[19].htmlText = htmlText1;
		tfs[20].htmlText = htmlText2;
		tfs[21].htmlText = htmlText3;
		tfs[22].htmlText = htmlText4;
	}
	
	private function otherAutoSizeSection():Void
	{
		var xPos = 50.0;
		var yPos = 50;
		
		createTextField("One-line text with autoSize = " + autoSizeToStr(TextFieldAutoSize.LEFT), new Point(0, 0), new Point(xPos, yPos), TextFieldAutoSize.LEFT, TextFormatAlign.RIGHT, false);
		createTextField("Multi-line text with autoSize = " + autoSizeToStr(TextFieldAutoSize.LEFT) + "\n and left text align.", new Point(0, 0), new Point(xPos, yPos+tfs[17].height+5), TextFieldAutoSize.LEFT, TextFormatAlign.LEFT, false);
	}
	
	private function wordWrapAutoSizeSection() 
	{
		var w = 150;
		var h = 1;
		
		var text = "This text field has LEFT auto size and has wordWrap = true.\n\nSOME_BIG_TEXT_IN_ONE_LINE_THAT_MORE_THEN_FIELD_WIDTH\nLorem ipsum dolor sit amet, consectetur-adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
		
		var f = createTextField(text, new Point(w, h), new Point(360, 200), TextFieldAutoSize.LEFT, TextFormatAlign.RIGHT, true);
		
		p2 = new Point(f.x + f.width, f.y + f.height);
		
		p2mark = new Shape();
		p2mark.x = f.x + f.width;
		p2mark.y = f.y + f.height;
		p2mark.graphics.beginFill(0xFF00);
		p2mark.graphics.drawCircle(0, 0, 3);
		
		this.addChild(p2mark);
	}
	
	private function nullSizesFieldSection():Void
	{
		var xPos = 10.0;
		var yPos = xPos;
		
		
		createTextField("", new Point(0,0), new Point(xPos, yPos), TextFieldAutoSize.NONE, TextFormatAlign.LEFT, false, true, 0, true, 0xFF0000, false);
		createTextField("", new Point(0,0), new Point(xPos, yPos+2), TextFieldAutoSize.NONE, TextFormatAlign.LEFT, true, true, 0, true, 0xFF0000, false);
		createTextField("", new Point(0,0), new Point(xPos, yPos+8), TextFieldAutoSize.LEFT, TextFormatAlign.LEFT, false, true, 0, true, 0xFFFFFF, false, 0xFF0000);
		createTextField("", new Point(0,0), new Point(xPos, yPos+14), TextFieldAutoSize.LEFT, TextFormatAlign.LEFT, false, true, 0, true, 0xFF00FF, false);
		createTextField("", new Point(0,0), new Point(xPos, yPos+20), TextFieldAutoSize.RIGHT, TextFormatAlign.RIGHT, false, true, 0, true, 0xFF00FF, false);
		createTextField("", new Point(0, 0), new Point(xPos, yPos + 26), TextFieldAutoSize.CENTER, TextFormatAlign.CENTER, false, true, 0, true, 0xFF00FF, false);
		createTextField("", new Point(0, 0), new Point(xPos, yPos + 32), TextFieldAutoSize.LEFT, TextFormatAlign.LEFT, true, true, 0, true, 0xFFFFFF, false);
	}
	
	private function wordWrapNoAutoSizeSection():Void
	{
		var w = 250;
		var h = 120;
		
		var text = "This text field has no auto size and has wordWrap = true.\n\nSOME_BIG_TEXT_IN_ONE_LINE_THAT_MORE_THEN_FIELD_WIDTH\nLorem ipsum dolor sit amet, consectetur-adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
		var htmlText = 'This text field has <font face="Arial" size="14px" color="#000000"><b>no auto size</b></font> and has <font face="Arial" size="14px" color="#000000"><b>wordWrap = true</b></font>.\n\nSOME_BIG_TEXT_IN_ONE_LINE_THAT_MORE_THEN_FIELD_WIDTH\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.';
		
		var f = createTextField(text, new Point(w, h), new Point(50, 200), TextFieldAutoSize.NONE, TextFormatAlign.LEFT, true, true);
		//f.htmlText = htmlText;
		
		p1 = new Point(f.x + f.width, f.y + f.height);
		
		p1mark = new Shape();
		p1mark.x = f.x + f.width;
		p1mark.y = f.y + f.height;
		p1mark.graphics.beginFill(0xFF00);
		p1mark.graphics.drawCircle(0, 0, 3);
		
		this.addChild(p1mark);
		
	}
	
	private function staticAutoSizeSection() 
	{
		var wPos = 200.0;
		var x1Pos = wPos/4;
		var y1Pos = 450.0;
		var x2Pos = x1Pos + wPos;
		
		createTextField(autoSizeToStr(TextFieldAutoSize.NONE), new Point(wPos, 30), new Point(x1Pos, y1Pos), TextFieldAutoSize.NONE, TextFormatAlign.LEFT, false, true);
		createTextField(autoSizeToStr(TextFieldAutoSize.LEFT), new Point(wPos, 30), new Point(x1Pos, tfs[0].y+50), TextFieldAutoSize.LEFT, TextFormatAlign.LEFT, false,true);
		createTextField(autoSizeToStr(TextFieldAutoSize.CENTER), new Point(wPos, 30), new Point(x1Pos, tfs[1].y+35), TextFieldAutoSize.CENTER, TextFormatAlign.CENTER, false,true);
		createTextField(autoSizeToStr(TextFieldAutoSize.RIGHT), new Point(wPos, 30), new Point(x1Pos,  tfs[2].y + 35), TextFieldAutoSize.RIGHT, TextFormatAlign.RIGHT, false, true);
		
		createTextField("Press 'A' key for add char\nPress 'S' key for remove char.", new Point(wPos, 1), new Point(x1Pos, tfs[4].y-tfs[4].height-7), TextFieldAutoSize.LEFT, TextFormatAlign.LEFT, true, true, 0x4444ee, true, 0x22EE22, true, 0xe7e7e7, true);
		
		this.graphics.lineStyle(1, 0x9999EE);
		this.graphics.moveTo(x1Pos, y1Pos);
		this.graphics.lineTo(x1Pos, y1Pos + 150);
		this.graphics.moveTo(x2Pos, y1Pos);
		this.graphics.lineTo(x2Pos, y1Pos +150);
		this.graphics.endFill();
	}
	
	private function autoSizeToStr(param:Dynamic):String
	{
		#if flash
		untyped return "TextFieldAutoSize." + param.toString().toUpperCase();
		#else
		return "TextFieldAutoSize." + Type.enumConstructor(param);
		#end
	}
	
	private function autoSizeSection():Void
	{
		var wPos = 200.0;
		var x1Pos = stage.stageWidth - wPos - wPos/4;
		var y1Pos = 450.0;
		var x2Pos = x1Pos + wPos;
		
		createTextField(autoSizeToStr(TextFieldAutoSize.NONE), new Point(wPos, 30), new Point(x1Pos, y1Pos), TextFieldAutoSize.NONE, TextFormatAlign.LEFT, false, true);
		createTextField(autoSizeToStr(TextFieldAutoSize.LEFT), new Point(wPos, 30), new Point(x1Pos, tfs[0].y+50), TextFieldAutoSize.LEFT, TextFormatAlign.LEFT, false,true);
		createTextField(autoSizeToStr(TextFieldAutoSize.CENTER), new Point(wPos, 30), new Point(x1Pos, tfs[1].y+35), TextFieldAutoSize.CENTER, TextFormatAlign.CENTER, false,true);
		createTextField(autoSizeToStr(TextFieldAutoSize.RIGHT), new Point(wPos, 30), new Point(x1Pos,  tfs[2].y + 35), TextFieldAutoSize.RIGHT, TextFormatAlign.RIGHT, false, true);
		
		this.graphics.lineStyle(1, 0x9999EE);
		this.graphics.moveTo(x1Pos, y1Pos);
		this.graphics.lineTo(x1Pos, y1Pos + 150);
		this.graphics.moveTo(x2Pos, y1Pos);
		this.graphics.lineTo(x2Pos, y1Pos +150);
		this.graphics.endFill();
	}
	
	private function createTextField(text:String, size:Point, pos:Point, autosize:TextFieldAutoSize, align, wordWrap:Bool, addChild = true, tColor = 0x4444EE, b = true, bColor = 0xFF0000, bg = true, bgColor = 0xDDDDDD, noAdd = false):TextField
	{	
		var f:TextFormat = new TextFormat("Arial", 12, 0, false);
		f.align = align;
		f.color = tColor;
		
		var tf:TextField = new TextField();
		tf.defaultTextFormat = f;
		tf.text = text;
		tf.x = pos.x;
		tf.y = pos.y;
		tf.selectable = false;
		tf.width = size.x;
		tf.height = size.y;
		tf.autoSize = autosize;
		tf.wordWrap = wordWrap;
		tf.border = b;
		tf.borderColor = bColor;
		tf.background = bg;
		tf.backgroundColor = bgColor;
		
		if (!noAdd ) tfs.push(tf);
		
		if (addChild) this.addChild(tf);
		
		return tf;
	}
	
	private function dynamicAutoSizeAnimation():Void
	{
		if (asTimeCur >= asTimeLimit && asTimeDir > 0)
		{
			asTimeCur = asTimeLimit;
			asTimeDir *= -1;
		} else if (asTimeCur <= 0 && asTimeDir < 0)
		{
			asTimeCur = 0;
			asTimeDir *= -1;
		} else if (asTimeCur <= asTimeLimit && asTimeDir == 1)
		{
			asTimeCur += asTimeDir;
			
			var ch = ".";
			
			tfs[0].text += ch;
			tfs[1].text += ch;
			tfs[2].text += ch;
			tfs[3].text += ch;
			
		}else if (asTimeCur >= 0 && asTimeDir == -1)
		{
			asTimeCur += asTimeDir;
			
			tfs[0].text = tfs[0].text.substr(0, tfs[0].text.length-1);
			tfs[1].text = tfs[1].text.substr(0, tfs[1].text.length-1);
			tfs[2].text = tfs[2].text.substr(0, tfs[2].text.length-1);
			tfs[3].text = tfs[3].text.substr(0, tfs[3].text.length-1);
		}
	}
	
	private function circularMotionAnimation(angle:Float, r1:Float, r2:Float, w:Float, center:Point, mark:DisplayObject, tf:TextField):Float
	{
		mark.x = Math.sin(angle) * r1 + center.x;
		mark.y = Math.cos(angle) * r2 + center.y;
		
		tf.width = mark.x - tf.x;
		tf.height = mark.y - tf.y;
		
		return angle + w;
	}
	
	private function onFrame(e:Event):Void 
	{
		var a = 0;
		
		dynamicAutoSizeAnimation();
		
		a1 = circularMotionAnimation(a1, r1, r1, w1, p1, p1mark, tfs[8]);
		
		a2 = circularMotionAnimation(a2, r2, r3, -w1, p2, p2mark, tfs[16]);
	}
	
	private function onKeyUp(e:KeyboardEvent):Void 
	{
		
		if (e.keyCode == Keyboard.A)
		{	
			#if !windows
			if (tfs[6].length > 50) return;
			#else
			if (tfs[6].text.length > 50) return;
			#end
			
			var ch = ".";
			
			tfs[4].text += ch;
			tfs[5].text += ch;
			tfs[6].text += ch;
			tfs[7].text += ch;
			
		} else if (e.keyCode == Keyboard.S)
		{
			tfs[4].text = tfs[4].text.substr(0, tfs[4].text.length-1);
			tfs[5].text = tfs[5].text.substr(0, tfs[5].text.length-1);
			tfs[6].text = tfs[6].text.substr(0, tfs[6].text.length-1);
			tfs[7].text = tfs[7].text.substr(0, tfs[7].text.length-1);
		}
	}

	/* SETUP */

	public function new() 
	{
		super();	
		addEventListener(Event.ADDED_TO_STAGE, added);
	}

	function added(e) 
	{
		removeEventListener(Event.ADDED_TO_STAGE, added);
		stage.addEventListener(Event.RESIZE, resize);
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
	}
	
	public static function main() 
	{
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}
}
