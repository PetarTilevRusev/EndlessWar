--AI parameter constants
AI_THINK_INTERVAL = 1 -- The interval in seconds between two think ticks

--AI state constants
AI_STATE_IDLE = 0
AI_STATE_AGGRESSIVE = 1
AI_STATE_RETURNING = 2
AI_STATE_WALKING = 3

--Define the UndeadKingAI class
UndeadKingAI = {}
UndeadKingAI.__index = UndeadKingAI

--[[ Create an instance of the UndeadKingAI class for some unit 
  with some parameters. ]]
function UndeadKingAI:MakeInstance( unit, params )
	--Construct an instance of the UndeadKingAI class
	setmetatable( self, UndeadKingAI )

	--Set the core fields for this AI
	self.unit = unit --The unit this AI is controlling
	self.state = AI_STATE_IDLE --The initial state
	self.stateThinks = { --Add thinking functions for each state
		[AI_STATE_IDLE] = Dynamic_Wrap(UndeadKingAI, 'IdleThink'),
		[AI_STATE_AGGRESSIVE] = Dynamic_Wrap(UndeadKingAI, 'AggressiveThink'),
		[AI_STATE_RETURNING] = Dynamic_Wrap(UndeadKingAI, 'ReturningThink')
	}

	--Set parameters values as fields for later use
	self.spawnPos = params.spawnPos
	self.aggroRange = params.aggroRange
	self.leashRange = params.leashRange

	--Start thinking
	Timers:CreateTimer(function()
		return self:GlobalThink()
	end)

	--Return the constructed instance
	return self
end

--[[ The high-level thinker this AI will do every tick, selects the correct
  state-specific think function and executes it. ]]
function UndeadKingAI:GlobalThink()
	--If the unit is dead, stop thinking
	if not self.unit:IsAlive() then
		return nil
	end

	--Execute the think function that belongs to the current state
	self.stateThinks[ self.state ]( self )

	--Reschedule this thinker to be called again after a short duration
	return AI_THINK_INTERVAL
end

--[[ Think function for the 'Idle' state. ]]
function UndeadKingAI:IdleThink()
	--Find any enemy units around the AI unit inside the aggroRange
	local units = FindUnitsInRadius( self.unit:GetTeam(), self.unit:GetAbsOrigin(), nil,
		self.aggroRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_ANY_ORDER, false )

	--If one or more units were found, start attacking the first one
	if #units > 0 then
		self.unit:MoveToTargetToAttack( units[1] ) --Start attacking
		self.aggroTarget = units[1]
		self.state = AI_STATE_AGGRESSIVE --State transition
		return true
	end

	--State behavior
	--Whistle a tune
end

--[[ Think function for the 'Aggressive' state. ]]
function UndeadKingAI:AggressiveThink()
	--Check if the unit has walked outside its leash range
	if ( self.spawnPos - self.unit:GetAbsOrigin() ):Length() > self.leashRange then
		self.unit:MoveToPosition( self.spawnPos ) --Move back to the spawnpoint
		self.state = AI_STATE_RETURNING --Transition the state to the 'Returning' state(!)
		return true --Return to make sure no other code is executed in this state
	end

	--Check if the unit's target is still alive (self.aggroTarget will have to be set when transitioning into this state)
	if not self.aggroTarget:IsAlive() then
		self.unit:MoveToPosition( self.spawnPos ) --Move back to the spawnpoint
		self.state = AI_STATE_RETURNING --Transition the state to the 'Returning' state(!)
		return true --Return to make sure no other code is executed in this state
	end

	--State behavior
	--Here we can just do any behaviour you want to repeat in this state
end

--[[ Think function for the 'Returning' state. ]]
function UndeadKingAI:ReturningThink()
	--Check if the AI unit has reached its spawn location yet
	if (self.spawnPos - self.unit:GetAbsOrigin()):Length() < 10 then
		--Go into the idle state
		self.state = AI_STATE_IDLE
		return true
	end

	local orderMoveToSpawnPosition = { 
                    UnitIndex = self.unit:GetEntityIndex(), 
                    OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE, 
                    Position = self.spawnPos, 
                    Queue = true 
                }
    ExecuteOrderFromTable(orderMoveToSpawnPosition)
end