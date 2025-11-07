local component = require("component")
local term = require("term")
local event = require("event")

-- Component proxies
local MeController = component.me_controller

-- Targets with item IDs
local TARGETS = {
    ["miscutils:crushedRareEarthI"] = 10783 ,
    ["miscutils:crushedRareEarthII"] = 10792 ,
    ["miscutils:crushedRareEarthIII"] = 10801 
}

-- Helper Function: returns true if item exists, false or nil otherwise
local function attemptAmountById(id)
    local itemTable = MeController.getItemsInNetworkById({id})[1]
    if itemTable ~= nil then
    	return true
    else
    	return false
    end
end

-- Main Loop
local function requestNextRareEarth()
	term.clear()
    term.setCursor(1, 1)

    print("Current Stockpile:")
    print(" Crushed Rare Earth (I) ore:",MeController.getItemsInNetworkById({10783})[1].size)
    print(" Crushed Rare Earth (II) ore:",MeController.getItemsInNetworkById({10792})[1].size)
    print(" Crushed Rare Earth (III) ore:",MeController.getItemsInNetworkById({10801})[1].size)
    print("-----------------------------------")

    local nextCraft = "micutils:crushedRareEarthI"
    local amountInSystem = math.huge  -- start with very large number


    for target, id in pairs(TARGETS) do
    	local amount = 0
        if attemptAmountById(id) then
        	amount = MeController.getItemsInNetworkById({id})[1].size
        	if amount < amountInSystem then
                amountInSystem = amount
                nextCraft = target
            end            
        else
            amountInSystem = 0
            nextCraft = target
        end
    end

    for i, craftable in ipairs(component.me_controller.getCraftables()) do
		local stack = craftable.getItemStack()
		if stack.name == nextCraft then
			local startTime = os.clock()
			print("Requesting: 16 ",stack.label," starting at ", startTime)
			local status = craftable.request(16,false,"")
			print("Crafting in progress")

			while not status.isDone() and not status.isCanceled() do
				local elapsedTime = os.clock() - startTime
				term.setCursor(1, 8)
				print(string.format("Time passed: %f.2 minutes", elapsedTime))
			  	event.pull(0.1, "timer")
			end
		end
	end

    return nextCraft
end

-- Main execution
while true do
	requestNextRareEarth()
end
