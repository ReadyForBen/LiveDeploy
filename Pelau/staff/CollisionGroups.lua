local Players = game:GetService("Players")
local PhysicsService = game:GetService("PhysicsService")

local groupID = 34384814
local minRank = 4 -- Junior Server

local staffGroup = "Staff"
local defaultGroup = "Default"

-- Set up collision groups
PhysicsService:CollisionGroupSetCollidable(staffGroup, staffGroup, false)
PhysicsService:CollisionGroupSetCollidable(defaultGroup, defaultGroup, false)

local function setCollisionGroup(character, groupName)
	local function applyCollisionGroup(part)
		if part:IsA("BasePart") then
			PhysicsService:SetPartCollisionGroup(part, groupName)
		end
	end

	for _, part in ipairs(character:GetChildren()) do
		applyCollisionGroup(part)
	end

	character.ChildAdded:Connect(applyCollisionGroup)
end

local function handleCharacter(character, player)
	local rank = player:GetRankInGroup(groupID)
	if rank >= minRank then
		setCollisionGroup(character, staffGroup)
	else
		setCollisionGroup(character, defaultGroup)
		print("Player is not staff, using Default collision group.")
	end
end

local function onCharacterAdded(player)
	local function onCharacter(character)
		handleCharacter(character, player)
	end

	player.CharacterAdded:Connect(onCharacter)

	if player.Character then
		onCharacter(player.Character)
	end
end

local function onPlayerAdded(player)
	onCharacterAdded(player)
end

for _, player in ipairs(Players:GetPlayers()) do
	onPlayerAdded(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)
