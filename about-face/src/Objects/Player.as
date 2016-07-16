package Objects 
{
	import Areas.Map;
	import Areas.Tile;
	import flash.events.Event;
	import Objects.Checkpoint;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import Setup.SaveFile;
	import Sound.SoundManager;
	/**
	 * ...
	 * @author Peltast
	 */
	public class Player extends AnimatedObject
	{
		
		private var currentMap:Areas.Map;
		
		private var grounded:Boolean;
		private var jumpCharges:int;
		
		private var invertEnabled:Boolean;
		private var maxJumpCharges:int;
		
		private var xAcc:Number;
		private var yAcc:Number;
		private var targetXVel:int;
		private var targetYVel:int;
		private var xVel:Number;
		private var yVel:Number;
		private var jumpVel:Number;
		private var gravity:Number;
		private var maxSpeedX:int;
		private var maxSpeedY:int;
		private var playerSize:int;
		
		private var deathTimer:int;
		private var playerFrozen:Boolean;
		private var endCinematic:Boolean;
		private var physicsDisabled:Boolean;
		
		public function Player(saveFile:SaveFile) 
		{
			Main.getSingleton().stage.addEventListener(KeyboardEvent.KEY_UP, checkKeysUp);
			Main.getSingleton().stage.addEventListener(KeyboardEvent.KEY_DOWN, checkKeysDown);
			
			initPlayer(saveFile);
			
			maxSpeedX = 3;
			maxSpeedY = 8;
			xAcc = 0.2;
			yAcc = 0.05;
			xVel = 0;
			yVel = 0;
			jumpVel = 7; //7.8;
			gravity = 6.3; //7.5;
			playerSize = 16;
			deathTimer = 0;
			
			var normalIdle:Animation = new Animation
				("Idle", 0, new Point(0, 0), playerSize, playerSize, [new Point(0, 0)]);
			var leftWalk:Animation = new Animation
				("LeftWalk", 2, new Point(2 * playerSize, playerSize), playerSize, playerSize,
				[new Point(), new Point(1, 0), new Point(2, 0), new Point(3, 0), new Point(4, 0)]);
			var rightWalk:Animation = new Animation
				("RightWalk", 2, new Point(2 * playerSize, 0), playerSize, playerSize,
				[new Point(), new Point(1, 0), new Point(2, 0), new Point(3, 0), new Point(4, 0)]);
			var jump:Animation = new Animation
				("Jump", 0, new Point(0, playerSize), playerSize, playerSize, [new Point()]);
			
			var invertIdle:Animation = new Animation
				("Idle", 0, new Point(0, 2 * playerSize), playerSize, playerSize, [new Point(0, 0)]);
			var invertLeftWalk:Animation = new Animation
				("LeftWalk", 4, new Point(2 * playerSize, 3 * playerSize), playerSize, playerSize,
				[new Point(), new Point(1, 0), new Point(2, 0), new Point(3, 0), new Point(4, 0)]);
			var invertRightWalk:Animation = new Animation
				("RightWalk", 4, new Point(2 * playerSize, 2 * playerSize), playerSize, playerSize,
				[new Point(), new Point(1, 0), new Point(2, 0), new Point(3, 0), new Point(4, 0)]);
			var invertJump:Animation = new Animation
				("Jump", 0, new Point(0, 3 * playerSize), playerSize, playerSize, [new Point()]);
			
			
			super(this, new GameLoader.Player() as Bitmap, 1, false);
			
			normalAnimations[normalIdle.getName()] = normalIdle;
			normalAnimations[leftWalk.getName()] = leftWalk;
			normalAnimations[rightWalk.getName()] = rightWalk;
			normalAnimations[jump.getName()] = jump;
			
			invertAnimations[invertIdle.getName()] = invertIdle;
			invertAnimations[invertLeftWalk.getName()] = invertLeftWalk;
			invertAnimations[invertRightWalk.getName()] = invertRightWalk;
			invertAnimations[invertJump.getName()] = invertJump;
			
			
			currentAnimation = normalIdle;
			animatedBmp = getAnimationBmp(normalIdle, this.animationSheet);
			this.addChild(animatedBmp);
		}
		
		private function initPlayer(saveFile:SaveFile):void {
			if (saveFile == null) {
				invertEnabled = false;
				maxJumpCharges = 1;
			}
			else {
				
				if (saveFile.loadData("invertEnabled") == "true")
					invertEnabled = true;
				else 
					invertEnabled = false;
				maxJumpCharges = parseInt(saveFile.loadData("jumpCharges") + "");
			}
		}
		public function savePlayer(saveFile:SaveFile):void {
			if (invertEnabled)
				saveFile.saveData("invertEnabled", "true");
			else
				saveFile.saveData("invertEnabled", "false");
			saveFile.saveData("jumpCharges", maxJumpCharges);
		}
		
		public function pickupTakeEffect(pickup:Pickup):void {
			if (pickup.getType() == 1)
				invertEnabled = true;
			else if (pickup.getType() == 2)
				maxJumpCharges = 2;
			else if (pickup.getType() == 3)
				maxJumpCharges += 1;
		}
		
		
		public function pausePlayer():void {
			Main.getSingleton().stage.removeEventListener(KeyboardEvent.KEY_UP, checkKeysUp);
			Main.getSingleton().stage.removeEventListener(KeyboardEvent.KEY_DOWN, checkKeysDown);
			freezePlayer();
		}
		public function resumePlayer():void {
			if (playerFrozen)
				return;
			Main.getSingleton().stage.addEventListener(KeyboardEvent.KEY_UP, checkKeysUp);
			Main.getSingleton().stage.addEventListener(KeyboardEvent.KEY_DOWN, checkKeysDown);	
		}
			
		public function updatePlayer(deltaTime:Number):void {
			var relativeTime:Number = ((deltaTime / 1000) * Main.frameRate);
			//trace("=======" + relativeTime);
			currentAnimation.updateAnimation();
			removeBmp();
			addAnimationBmp(currentAnimation);
			
			centerScreen();
			if (!physicsDisabled) {	
				updateVelocity(relativeTime);
				moveXAxis(relativeTime);
				moveYAxis(relativeTime);
			}
			
			currentMap.updateCheckpoints(this);
			currentMap.updateEndPortal(this);
			
			if (y > currentMap.getMapHeight())
				killPlayer();
		}
		
		private function centerScreen():void {
			
			var screenHeight:Number = Main.stageHeight;
			var screenWidth:Number = Main.stageWidth;
			var scale:int = Main.stageScale;
			screenHeight = screenHeight / scale;
			screenWidth = screenWidth / scale;
			
			var mapWidth:int = currentMap.getMapWidth();
			var mapHeight:int = currentMap.getMapHeight();
			mapWidth = mapWidth * scale;
			mapHeight = mapHeight * scale;
			
			// If the map is narrower than the screen, just center X-axis around the map.
			if (mapWidth < screenWidth * scale)
				currentMap.x = ((screenWidth * scale) / 2 - (mapWidth) / 2) / scale;
			
			else {
				// Otherwise, center it around the player.
				currentMap.x = screenWidth / 2 - this.x;
				
				if (currentMap.x > 0)	// Don't go beyond the map's left border.
					currentMap.x = 0;
				else if (this.x + screenWidth / 2 > mapWidth / scale)  // And don't go beyond the map's right border.
					currentMap.x = screenWidth - (mapWidth / scale);
			}
			
			// If the map is shorter than the screen, just center Y-axis around the map.
			if (mapHeight < screenHeight * scale)
				currentMap.y = ((screenHeight * scale) / 2 - mapHeight / 2) / scale;
			
			else {
				// Otherwise, center it around the player.
				currentMap.y = screenHeight / 2 - this.y;
				
				if (currentMap.y > 0)	// Don't go beyond the map's top border.
					currentMap.y = 0;
				else if (this.y + screenHeight / 2 > mapHeight / scale)	// And don't go beyond the map's lower border.
					currentMap.y = screenHeight - (mapHeight / scale);
				
			}
			
	}
		
		private function updateVelocity(relativeTime:Number):void {
			
			xVel = (targetXVel * xAcc * relativeTime) + ((1 - xAcc) * xVel);
			if (xVel > maxSpeedX)
				xVel = maxSpeedX;
			else if (xVel < -maxSpeedX)
				xVel = -maxSpeedX;
			
			yVel = (targetYVel * yAcc * relativeTime) + ((1 - yAcc) * yVel);
			if (yVel > maxSpeedY)
				yVel = maxSpeedY;
			else if (yVel < -maxSpeedY)
				yVel = -maxSpeedY;
			
			targetYVel = gravity;
		}
		private function moveXAxis(relativeTime:Number):void {
			if (deathTimer != 0) return;
			
			var deltaX:int = Math.round(xVel * relativeTime);
			if (deltaX > 8) deltaX = 8;
			this.x += deltaX;
			
			var collisions:Vector.<InversionObject> = currentMap.checkCollisions(this);
			if (checkDeath(collisions, true))
				return;
			
			var largestDistance:int = getCollisionLargestDistance(collisions, true);
			
			if (largestDistance != 0)
				this.x -= largestDistance;
		}
		private function moveYAxis(relativeTime:Number):void {
			if (deathTimer != 0) return;
			
			var deltaY:int = Math.round(yVel * relativeTime);
			if (deltaY > 8) deltaY = 8;
			this.y += deltaY;
			
			var collisions:Vector.<InversionObject> = currentMap.checkCollisions(this);
			if (checkDeath(collisions, false))
				return;
			
			var largestDistance:int = getCollisionLargestDistance(collisions, false);
			
			if (largestDistance != 0)
				this.y -= largestDistance;
			if (largestDistance > 0)
				setGrounded();
		}
		public function freezePlayer():void {
			yVel = 0;
			xVel = 0;
			targetXVel = 0;
			targetYVel = 0;
			currentAnimation = getAnimation("Idle");
		}
		public function permafreezePlayer():void {
			physicsDisabled = true;
		}
		public function setInCinematic(b:Boolean):void { playerFrozen = b; }
		public function isInEndCinematic():Boolean { return endCinematic; }
		public function setInEndCinematic(b:Boolean):void { endCinematic = b; }
		public function stopPlayerInput():void {
			Main.getSingleton().stage.removeEventListener(KeyboardEvent.KEY_UP, checkKeysUp);
			Main.getSingleton().stage.removeEventListener(KeyboardEvent.KEY_DOWN, checkKeysDown);
		}
		public function resumePlayerInput():void {
			if (playerFrozen) 
				return;
			Main.getSingleton().stage.addEventListener(KeyboardEvent.KEY_UP, checkKeysUp);
			Main.getSingleton().stage.addEventListener(KeyboardEvent.KEY_DOWN, checkKeysDown);
		}
		
		private function checkDeath(collisions:Vector.<InversionObject>, horizontal:Boolean):Boolean {
			
			if (checkFatalTiles(collisions, horizontal)) {
				killPlayer();
				return true;
			}
			else if (currentMap.checkEnemies(this).length >= 1) {
				killPlayer();
				return true;
			}
			return false;
		}
		
		private function checkFatalTiles(collisionList:Vector.<InversionObject>, xAxis:Boolean):Boolean {
			
			for (var i:int = 0; i < collisionList.length; i++) {
				if (collisionList[i] is Areas.Tile) {
					
					var tempTile:Areas.Tile = collisionList[i] as Areas.Tile;
					if (tempTile.checkFatal(this, xAxis))
						return true;
				}
			}
			return false;
		}
		
		private function getCollisionLargestDistance(collisionList:Vector.<InversionObject>, xAxis:Boolean):int {
			var largestDistance:int = 0;
			var largestIndex:int = -1;
			var tempDistance:int;
			
			for (var i:int = 0; i < collisionList.length; i++) {
				if (!collisionList[i].getPassable()) continue;
				
				tempDistance = getCollisionDistance(collisionList[i], xAxis);
				if (Math.abs(tempDistance) > Math.abs(largestDistance)) {
					largestDistance = tempDistance;
					largestIndex = i;
				}
			}
			
			return largestDistance;
		}
		
		private function setGrounded():void {
			
			if (!grounded) {
				
				if (currentMap.getMapName() == "Stage26" || currentMap.getMapName() == "Stage27")
					SoundManager.getSingleton().playSound("Fall2", .2);
				else
					SoundManager.getSingleton().playSound("Fall", .2);	
				currentAnimation = getAnimation("Idle");
			}
			if (targetXVel > 0)
				currentAnimation = getAnimation("RightWalk");
			else if (targetXVel < 0)
				currentAnimation = getAnimation("LeftWalk");
			grounded = true;
			jumpCharges = maxJumpCharges;
		}
		
		private var deathSpawn:Checkpoint;
		private function killPlayer():void {
			
			var checkpoint:Checkpoint = currentMap.getCurrentCheckpoint();
			if (checkpoint == null) return;
			
			deathSpawn = checkpoint;
			freezePlayer();
			
			if (deathTimer == 0) {
				SoundManager.getSingleton().playSound("Death", .6);
				deathTimer = 1;
			}
			Main.getSingleton().addEventListener(Event.ENTER_FRAME, updateDeath);
		}
		
		private function updateDeath(event:Event):void {
			
			if (deathTimer <= 30) {
				deathTimer += 1;
				if (deathTimer % 5 == 0) {	
					this.invertObject();
				}
				return;
			}
			
			deathTimer = 0;
			this.x = deathSpawn.x;
			this.y = deathSpawn.y;
			
			currentMap.mapRespawn(deathSpawn);
			Main.getSingleton().removeEventListener(Event.ENTER_FRAME, updateDeath);
		}
		
		public function getCurrentMap():Areas.Map { return currentMap; }
		public function setCurrentMap(map:Areas.Map):void { currentMap = map; }
		
		private var spacebarHeld:Boolean = false;
		private function checkKeysDown(key:KeyboardEvent):void {
			
			if (key.keyCode == 65 || key.keyCode == 37)
				goLeft();
			else if (key.keyCode == 68 || key.keyCode == 39)
				goRight();
			
			if (key.keyCode == 32 && !spacebarHeld) {
				spacebarHeld = true;
				jump();
			}
			
		}
		private function checkKeysUp(key:KeyboardEvent):void {
			
			if (key.keyCode == 65 || key.keyCode == 37)
				stopLeft();
			else if(key.keyCode == 68 || key.keyCode == 39)
				stopRight();
			
			if (key.keyCode == 32)
				spacebarHeld = false;
		}
		
		private function goLeft():void {
			targetXVel = -5;
			if (currentAnimation.getName() != "LeftWalk" && grounded)
				currentAnimation = getAnimation("LeftWalk");
		}
		private function goRight():void {
			targetXVel = 5;
			if (currentAnimation.getName() != "RightWalk" && grounded)
				currentAnimation = getAnimation("RightWalk");
		}
		private function stopLeft():void {
			if (targetXVel < 0) {
				xVel = xVel / 2;
				targetXVel = 0;
				if (grounded)
					currentAnimation = getAnimation("Idle");
			}
		}
		private function stopRight():void {
			if (targetXVel > 0) {
				xVel = xVel / 2;
				targetXVel = 0;
				if (grounded)
					currentAnimation = getAnimation("Idle");
			}
		}
		private function jump():void {
			if (jumpCharges == 0) return;
			
			jumpCharges -= 1;
			grounded = false;
			currentAnimation = getAnimation("Jump");
			yVel = -jumpVel;
			
			if (currentMap.getMapName() == "Stage26" || currentMap.getMapName() == "Stage27")
				SoundManager.getSingleton().playSound("Jump2", .5);
			else
				SoundManager.getSingleton().playSound("Jump", .5);
			
			if (invertEnabled)
				invertMap();
		}
		private function invertMap():void {
			
			if (currentMap == null) 
				return;
			else {
				
				currentMap.invertMap();
			}
		}
		
	}

}