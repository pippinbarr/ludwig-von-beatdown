package
{
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.*;
	import flash.system.fscommand;

	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;

	
	public class PrototypeState extends FlxState
	{				
//		private const P1KEYS:Array = new Array("LEFT","RIGHT","UP","DOWN","SPACE");
//		private const P2KEYS:Array = new Array("A", "D", "W", "S", "F");
		private const P1KEYS:Array = new Array("LEFT","RIGHT","UP","DOWN","Z");
		private const P2KEYS:Array = new Array("A", "D", "W", "S", "N");
		
		private var players:FlxGroup;
		
		private var bg:FlxSprite;

		
		private var slowFurElise:FlxSound;
		private var fastFurElise:FlxSound;
		private var tempoTimer:FlxTimer = new FlxTimer();
		
		private var activationTimer:FlxTimer = new FlxTimer();
		private var nextPlayerToActivate:uint = 0;
		
		private var gameOverText:TextField;
		private var gameOverTextFormat:TextFormat = new TextFormat("COMMODORE",44,0xEEEEEE,null,null,null,null,null,"center");
		private var restartText:TextField;
		private var restartTextFormat:TextFormat = new TextFormat("COMMODORE",24,0xEEEEEE,null,null,null,null,null,"center");

		
		private var showKeys:Boolean = true;
		private var gameOver:Boolean = false;
		
		private var keys:TextField;
		private var keysFormat:TextFormat = new TextFormat("COMMODORE",18,0xEEEEEE,null,null,null,null,null,"left");
		private var keysBG:FlxSprite;

		
		public function PrototypeState()
		{
		}
		
		
		override public function create():void
		{
			super.create();
			

			FlxG.bgColor = 0xFF000000;
					
			keys = Helpers.makeTextField(50,50,FlxG.width - 100,200,"",keysFormat);
			keys.visible = true;
			FlxG.stage.addChild(keys);

			keys.appendText("TRY TO JOSTLE YOUR OPPONENTS' CONTROLLERS WHILE PROTECTING YOUR OWN!\n\n\n");


			if (Globals.NUM_PLAYERS == 0)
			{
				
			}
			else
			{
				if (Globals.NUM_PLAYERS == 1)
				{
					//keys.appendText("PLAYER 1:\n");
					//keys.appendText("USE [ARROW KEYS] TO MOVE\n");
					//keys.appendText("AND [SPACE] TO SPRINT\n\n\n");
					keys.appendText("USE [LEFT JOYSTICK] TO MOVE\n");
					keys.appendText("AND [A] BUTTON TO SPRINT\n\n\n");

				}
				else if (Globals.NUM_PLAYERS == 2)
				{
					//keys.appendText("PLAYER 1:\n");
//					keys.appendText("USE [ARROW KEYS] TO MOVE\n");
//					keys.appendText("AND [SPACE] TO SPRINT\n\n");
					keys.appendText("USE [JOYSTICK] TO MOVE\n");
					keys.appendText("AND [A] BUTTON TO SPRINT\n\n\n");
//					keys.appendText("PLAYER 2:\n");
//					keys.appendText("USE [W,A,S,D] TO MOVE\n");
//					keys.appendText("AND [F] TO SPRINT\n\n\n");
//					keys.appendText("USE [RIGHT JOYSTICK] TO MOVE\n");
//					keys.appendText("AND [BUTTON] TO SPRINT\n\n\n");
//					keys.appendText("BOTH PRESS [A] BUTTON TO BEGIN!");

				}
			}
			
//			keys.appendText("PRESS [START] TO BEGIN!");
			keys.appendText("PRESS BOTH [A] BUTTONS TO BEGIN!");

			bg = new FlxSprite(0,0);
			bg.loadGraphic(Globals.LOCATIONS[Math.floor(Math.random() * Globals.LOCATIONS.length)],false,false,320,240,true);
			add(bg);
			
			players = new FlxGroup();
			
			Globals.LIGHT_COLOURS.sort(randomSort);
			Globals.PLAYER_COLOURS.sort(randomSort);
			
			Globals.PLAYER_COLOURS_INDEX = 0;
			Globals.LIGHT_COLOURS_INDEX = 0;
			
			
			var top:FlxPoint = new FlxPoint(FlxG.width/2 - Globals.PLAYER_WIDTH/2,Globals.PLAY_AREA_TOP - Globals.PLAYER_HEIGHT);
			var bottom:FlxPoint = new FlxPoint(FlxG.width/2 - Globals.PLAYER_WIDTH/2,FlxG.height - Globals.PLAYER_HEIGHT);
			var right:FlxPoint = new FlxPoint(FlxG.width - Globals.PLAYER_WIDTH - 10,Globals.PLAY_AREA_TOP + Globals.PLAY_AREA_HEIGHT/2 - Globals.PLAYER_HEIGHT);
			var left:FlxPoint = new FlxPoint(10,Globals.PLAY_AREA_TOP + Globals.PLAY_AREA_HEIGHT/2 - Globals.PLAYER_HEIGHT);
			
			var locations:Array = new Array(top,bottom,left,right);
			locations.sort(randomSort);
			
			if (Globals.NUM_PLAYERS == 0)
			{
				Globals.PLAYERS.push(new AIPlayer(1,"AI 1",1,locations[0].x,locations[0].y));
				Globals.PLAYERS.push(new AIPlayer(2,"AI 2",0.1,locations[1].x,locations[1].y));
				Globals.PLAYERS.push(new AIPlayer(3,"AI 3",0.5,locations[2].x,locations[2].y));
				Globals.PLAYERS.push(new AIPlayer(4,"AI 4",0.7,locations[3].x,locations[3].y));
				
			}
			else if (Globals.NUM_PLAYERS == 1)
			{
				Globals.PLAYERS.push(new HumanPlayer(0,"PLAYER 1",locations[0].x,locations[0].y,P1KEYS));
				Globals.PLAYERS.push(new AIPlayer(1,"AI 1",1,locations[1].x,locations[1].y));
				Globals.PLAYERS.push(new AIPlayer(2,"AI 2",0.1,locations[2].x,locations[2].y));
				Globals.PLAYERS.push(new AIPlayer(3,"AI 3",0.5,locations[3].x,locations[3].y));
			}
			else if (Globals.NUM_PLAYERS == 2)
			{
				Globals.PLAYERS.push(new HumanPlayer(0,"PLAYER 1",locations[0].x,locations[0].y,P1KEYS));
				Globals.PLAYERS.push(new AIPlayer(1,"AI 1",1,locations[1].x,locations[1].y));
				Globals.PLAYERS.push(new AIPlayer(2,"AI 2",0.1,locations[2].x,locations[2].y));
				Globals.PLAYERS.push(new HumanPlayer(3,"PLAYER 2",locations[3].x,locations[3].y,P2KEYS));
			}
			
			Globals.PLAYERS.sort(randomSort);
			
			Globals.LIVING_PLAYERS = 0;			
			for (var i:uint = 0; i < Globals.PLAYERS.length; i++)
			{
				if (Globals.PLAYERS[i].x > FlxG.width/2 || Globals.PLAYERS[i].y == FlxG.height - Globals.PLAYER_HEIGHT)
				{
					Globals.PLAYERS[i].face(FlxObject.LEFT);
				}
				players.add(Globals.PLAYERS[i]);
				Globals.LIVING_PLAYERS++;
			}	
			
			
			add(players);
			
			// MUSIC //
			
			slowFurElise = new FlxSound();
			slowFurElise.loadEmbedded(Assets.SLOW_FUR_ELISE_MP3,true);
			fastFurElise = new FlxSound();
			fastFurElise.loadEmbedded(Assets.FAST_FUR_ELISE_MP3,true);
			
			
			gameOverText = Helpers.makeTextField(0,FlxG.height/6,FlxG.width,200,"",gameOverTextFormat);
			gameOverText.visible = false;			
			FlxG.stage.addChild(gameOverText);
			
//			restartText = Helpers.makeTextField(0,FlxG.height/6 + 60,FlxG.width,200,"[R] TO RESTART\n[ESCAPE] TO RETURN TO MENU",restartTextFormat);
			restartText = Helpers.makeTextField(20,FlxG.height/6 + 60,FlxG.width - 40,200,"PRESS BOTH [A] BUTTONS TO RESTART\n\nPRESS BOTH [B] BUTTONS TO RETURN TO MENU",restartTextFormat);

			restartText.visible = false;			
			FlxG.stage.addChild(restartText);			
			
			keysBG = new FlxSprite(0,0);
			keysBG.makeGraphic(FlxG.width,FlxG.height,0x44000000);
			add(keysBG);
			
			if (Globals.NUM_PLAYERS == 0)
			{
				keys.visible = false;
				keysBG.visible = false;
			}
			else
			{
				keysBG.visible = true;
			}


		}		
		
		
		override public function update():void
		{
			super.update();
			

			if (showKeys)
			{
//				if (FlxG.keys.ENTER)
				if ((FlxG.keys.Z && FlxG.keys.N) || Globals.NUM_PLAYERS == 0)
				{
					showKeys = false;
					keys.visible = false;
					keysBG.visible = false;
					beginRound();
					return;
				}
				else
				{
					return;
				}
			}
			
			trace("Living players: " + Globals.LIVING_PLAYERS);
			
			if (Globals.LIVING_PLAYERS == 1)
			{
				for (var i:int = 0; i < players.members.length; i++)
				{
					if (players.members[i].alive)
					{
						gameOverText.text = "GAME OVER!\n" + players.members[i].name + " WINS!";
						break;
					}
				}
				gameOverText.visible = true;
				restartText.visible = true;
				gameOver = true;
			}
			else if (Globals.LIVING_PLAYERS == 0)
			{
				gameOverText.text = "GAME OVER!\nNO ONE WINS!";
				gameOverText.visible = true;
				restartText.visible = true;
				gameOver = true;
			}
			
//			if (FlxG.keys.ESCAPE)
			if (gameOver && FlxG.keys.X && FlxG.keys.M)
			{
				FlxG.switchState(new MenuState);
			}
//			else if (gameOver && FlxG.keys.R)
			else if (gameOver && FlxG.keys.Z && FlxG.keys.N)
			{
				FlxG.switchState(new PrototypeState);
			}
						
			handleCollisions();
			
			players.sort();
		}
		
		
		
		private function beginRound():void
		{
			activationTimer.start(1,1,activatePlayer);
		}
		
		
		private function activatePlayer(t:FlxTimer):void
		{
			
			if (nextPlayerToActivate >= players.members.length)
			{
				activationTimer.start(0.5,1,startPlay);
			}
			else
			{
				players.members[nextPlayerToActivate].showName();
				players.members[nextPlayerToActivate].light.play("normal");
				FlxG.play(Assets.ACTIVATION_MP3,0.5);
				
				nextPlayerToActivate++;
				activationTimer.start(0.5,1,activatePlayer);
			}
	
		}
		
		
		private function startPlay(t:FlxTimer):void
		{
			for (var i:uint = 0; i < players.members.length; i++)
			{
				players.members[i].hideName();
				players.members[i].start();
			}
			
			tempoTimer.start(Globals.TEMPO_TIME_MIN + Math.random() * Globals.TEMPO_TIME_RANGE,1,changeTempo);
			slowFurElise.play();

		}
		
		
		private function handleCollisions():void
		{
			for (var i:uint = 0; i < Globals.PLAYERS.length; i++)
			{
				if (!Globals.PLAYERS[i].alive)
					continue;
				
				handleWalls(Globals.PLAYERS[i]);
				
				for (var j:uint = 0; j < Globals.PLAYERS.length; j++)
				{
					if (!Globals.PLAYERS[j].alive || i == j)
						continue;
					
					if (FlxCollision.pixelPerfectCheck(Globals.PLAYERS[i].handmap,Globals.PLAYERS[j].bodymap))
					{
						handCollision(Globals.PLAYERS[i],Globals.PLAYERS[j]);
					}
					
					if (j >= i+1)
					{
						if (FlxCollision.pixelPerfectCheck(Globals.PLAYERS[i].bodymap,Globals.PLAYERS[j].bodymap))
						{
							bodyCollision(Globals.PLAYERS[i],Globals.PLAYERS[j]);
						}
					}
				}
			}
		}
		
		
		private function handleWalls(P:Player):void
		{
			if (P.x < 0)
				P.x = 0;
			if (P.x + P.width > FlxG.width)
				P.x = FlxG.width - P.width;
			if (P.y + P.height < Globals.PLAY_AREA_TOP)
				P.y = Globals.PLAY_AREA_TOP - P.height ;
			if (P.y + P.height > FlxG.height)
				P.y = FlxG.height - P.height;
		}
		
		
		private function handCollision(P1:Player, P2:Player):void
		{		
			if ((P2.vx > 0 && P2.x > P1.x && P1.vx == 0) ||
				(P2.vx < 0 && P2.x < P1.x && P1.vx == 0))
				return;
			
			if (!P1.alive || !P2.alive)
				return;
			
			trace("handCollision between " + P1.name + " and " + P2.name);
			
			if (FlxCollision.pixelPerfectCheck(P2.handmap,P1.bodymap))
			{
				trace("DEATH BY HAND COLLISION FOR " + P1.name);
				P1.die();		
			}
			else
			{
				P1.hit();
			}
			trace("DEATH BY HAND COLLISION FOR " + P2.name);
			P2.die();
			
			FlxG.play(Assets.HIT_MP3);
		}
		
		
		private function bodyCollision(P1:Player, P2:Player):void
		{			
			
			if (!P1.alive || !P2.alive)
				return;

			while(FlxCollision.pixelPerfectCheck(P1.bodymap,P2.bodymap))
			{
				if (Math.abs(P1.x - P2.x) >= Math.abs(P1.y - P2.y) && P1.vy == 0 && P2.vy == 0)
				{					
					if (P1.x < P2.x)
					{
						P1.x -= 10;
						P2.x += 10;
					}
					else
					{
						P1.x += 10;
						P2.x -= 10;
					}
				}
				else
				{
					if (P1.y < P2.y)
					{
						P1.y -= 10;
						P2.y += 10;
					}
					else
					{
						P1.y += 10;
						P2.y -= 10;
					}
				}
			}
			
			P1.bodyCollision();
			P2.bodyCollision();
			
			FlxG.play(Assets.HIT_MP3);
		}
		
		
		private function changeTempo(t:FlxTimer):void
		{			
			if (Globals.TEMPO == Globals.SLOW_TEMPO)
			{
				Globals.TEMPO = Globals.FAST_TEMPO;
				slowFurElise.stop();
				speedUp();
				fastFurElise.play(false, Math.random() * 80000);	
			}
			else if (Globals.TEMPO == Globals.FAST_TEMPO)
			{
				Globals.TEMPO = Globals.SLOW_TEMPO;
				fastFurElise.stop();
				slowDown();
				slowFurElise.play(false, Math.random() * 250000);			
			}
			
			tempoTimer.start(Globals.TEMPO_TIME_MIN + Math.random() * Globals.TEMPO_TIME_RANGE,1,changeTempo);
		}
		
		
		private function speedUp():void
		{
			Globals.PLAYER_EXTENDED_SPEED = Globals.PLAYER_EXTENDED_HISPEED;
			Globals.PLAYER_RETRACTED_SPEED = Globals.PLAYER_RETRACTED_HISPEED;
		}
		
		
		private function slowDown():void
		{
			Globals.PLAYER_EXTENDED_SPEED = Globals.PLAYER_EXTENDED_NORMALSPEED;
			Globals.PLAYER_RETRACTED_SPEED = Globals.PLAYER_RETRACTED_NORMALSPEED;
		}
		
		
		private function randomSort(a:*, b:*):Number    //* means any kind of input
		{
			if (Math.random() < 0.5) return -1;
			else return 1;
		}
		
		
		override public function destroy():void
		{
			for (var i:uint = 0; i < Globals.PLAYERS.length; i++)
			{
				Globals.PLAYERS[i].destroy();
			}
			Globals.PLAYERS = new Array();

			players.destroy();
			
			bg.destroy();
			
			slowFurElise.destroy();
			fastFurElise.destroy();
			
			if (gameOverText != null && FlxG.stage.contains(gameOverText)) FlxG.stage.removeChild(this.gameOverText);
			if (restartText != null && FlxG.stage.contains(restartText)) FlxG.stage.removeChild(this.restartText);

			tempoTimer.destroy();
			
			if (keys != null && FlxG.stage.contains(keys)) FlxG.stage.removeChild(this.keys);
			keysBG.destroy();
			
			super.destroy();
		}
	}
}