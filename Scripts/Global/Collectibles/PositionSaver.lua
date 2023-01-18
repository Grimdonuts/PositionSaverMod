--PositionSaver.lua

--Standard class constructor
function PositionSaver(Ob)
	if ( not Ob ) then
		Ob = CreateObject("Global.Props.HeldObject"); --Inherit from Global.Props.HeldObject

		Ob.meshName = 'GlobalModels/objects/heldobjects/raz_bacon.plb'

		--HeldObject specific values
		--The base game's Global/Props/HeldObject.lua has fairly good documentation of these already

		Ob.displayName = "/GLPOSSAVE/" --Controls the name that appears ingame. See Localization/Global.json!
										--For level-specific items, the localisation token should not be global

		Ob.pickupSpriteName = 'Bacon' --The name of the sprite to use for the item's icon, relative to Textures/icons/InventoryItems/

		Ob.clutchAnim = 'Anims/DartNew/BodyParts/Hold_FistLoosePalmIn_ArmLf.jan' --This is the animation Raz uses to hold the item

		Ob.collSphereRadius = 30 --Used if the object is placed in the world for Raz to pick up

		Ob.bAutoSelect = 1 --Set to 1 to make Raz automatically equip the item on acquiring it

		Ob.bPutAwayOnMelee = 0 --When set to 1, Raz will unequip the item if he uses a melee attack

		--Controls which levels this item is available in
		--When set to 'all', Raz will take the item with him in every level after picking it up
		--When set to 'real', Raz will not be able to take the item into mental worlds
		--When set to 'mental', Raz will have the item in every mental world
		--The default is 'prefixBased', which will lock the item to only the level it was picked up in. (E.G picking up this item in BBA1 means it'll be available in any BB level)
		Ob.level = 'all'

		--These variables allow you to manually tweak the positioning of the held object in Raz's hand.
		--Ideally, you'd just make sure it lines up right, but sometimes this is needed
		--In this case, the bacon model is already set up correctly.
		Ob.HeldPosX = 0
		Ob.HeldPosY = 0
		Ob.HeldPosZ = 0
		Ob.HeldRotX = 0
		Ob.HeldRotY = 0
		Ob.HeldRotZ = 0

		--If this is set, then the game will not attempt to use the item *on* things, and will only activate it normally.
		Ob.bUseOnly = 1;

		Ob.emitter = nil
	end

	function Ob:onBeginLevel()
		%Ob.Parent.onBeginLevel(self); --Make sure you always call the parent function unless you're positive you know you want to override all the inherited functionality!
		
		--This is probably bad practice but it works - we set this stuff up in the level script so that it can be shared between the loader and saver
		Global.levelScript.savedPosition = {}
		Global.levelScript.savedPosition.saved = 0
		Global.levelScript.savedPosition.x = 0
		Global.levelScript.savedPosition.y = 0
		Global.levelScript.savedPosition.z = 0
		Global.levelScript.savedPosition.rx = 0
		Global.levelScript.savedPosition.ry = 0
		Global.levelScript.savedPosition.rz = 0

		Global.levelScript.savedPosition.emitter = SpawnScript('Global.Effects.InterestFX')
		self.emitter = Global.levelScript.savedPosition.emitter
		self.emitter:hide()
	end
	
	function Ob:savePosition()
		local x,y,z = Global.player:getPosition()
		local rx,ry,rz = Global.player:getOrientation()

		Global.levelScript.savedPosition.x,Global.levelScript.savedPosition.y,Global.levelScript.savedPosition.z = x,y,z;
		Global.levelScript.savedPosition.rx,Global.levelScript.savedPosition.ry,Global.levelScript.savedPosition.rz = rx,ry,rz;
		Global.levelScript.savedPosition.saved = 1

		self.emitter:run()
		self.emitter:show()
		self.emitter:setPosition(x,y+kfRAZ_HEIGHT/2,z)

		PrintMessage("Position saved!");
	end

	--This message is sent when the item is activated. Since bUseOnly, it is called regardless of if the item is being activated on a specific object or not.
	function Ob:onActivateFromInventory()
		self:savePosition();
	end

	return Ob; --MUST return Ob!
end