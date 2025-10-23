local component = require("component")
local sides = require("sides")
local term = require("term")
local event = require("event")

-- ANSI color codes
local COLOR_GREEN = "\27[32m"
local COLOR_YELLOW = "\27[33m"
local COLOR_RED = "\27[31m"
local COLOR_RESET = "\27[0m"

-- Component proxies
local MeController = component.me_controller
local RedstoneIO = component.redstone

-- Define the redstone output level
local REDSTONE_ON = 16 -- 16 for Redstone 255 for Project Red cables
local REDSTONE_OFF = 0

-- Targets
local TARGETS = {
    ["acetone"]={ 
		["amount"]=32768000, -- 32_768_000
		["side"]=sides.south},
	["ethylene"]={
		["amount"]=32768000, -- 32_768_000
		["side"]=sides.east},
	["woodvinegar"]={
		["amount"]=32768000, -- 32_768_000
		["side"]=sides.west},
	["woodgas"]={
		["amount"]=32768000, -- 32_768_000
		["side"]=sides.west}
}

-- Map sides to their current required redstone state
local requiredRedstoneState = {
	[sides.north] = REDSTONE_OFF,
	[sides.east] = REDSTONE_OFF,
    [sides.south] = REDSTONE_OFF,
    [sides.west] = REDSTONE_OFF
}

-- Main loop
local function checkFluids()
    -- Reset state for the current check
    local allFluidsInStock = true
    requiredRedstoneState[sides.north] = REDSTONE_OFF
    requiredRedstoneState[sides.east] = REDSTONE_OFF
    requiredRedstoneState[sides.south] = REDSTONE_OFF
    requiredRedstoneState[sides.west] = REDSTONE_OFF
    local consoleOut = {} -- Use a table for string concatenation

    local fluidsInNetwork = MeController.getFluidsInNetwork()
    
    -- Create a lookup table for fluids currently in the network by name
    local fluidsLookup = {}
    for _, fluid in ipairs(fluidsInNetwork) do
        fluidsLookup[fluid.name] = fluid
    end

    -- Iterate over all targets to track and log even missing ones
    for targetName, target in pairs(TARGETS) do
	    local fluid = fluidsLookup[targetName]
	    local statusString = ""
	    local colorCode = COLOR_RESET
	    local label = targetName  -- fallback if fluid nil
	    local storedAmount = 0
	    local relative = 0

	    if fluid then
	        label = fluid.label or targetName
	        storedAmount = fluid.amount or 0
	        relative = (fluid.amount / target.amount)*100
	        if target.amount > fluid.amount then -- Partial
	            allFluidsInStock = false
	            requiredRedstoneState[target.side] = REDSTONE_ON
	            statusString = "Fluid partially Stocked: "
	            colorCode = COLOR_YELLOW
	        else -- Threshold fulfilled 
	            statusString = "Fluid in stock: "
	            colorCode = COLOR_GREEN
	        end
	    else
	        -- fully missing
	        allFluidsInStock = false
	        statusString = "Fluid missing: "
	        requiredRedstoneState[target.side] = REDSTONE_ON
	        colorCode = COLOR_RED
	        -- storedAmount and relative remain 0
	    end

	    table.insert(
	        consoleOut, 
	        string.format("%s%s%s%s\n--Target: %d\n--Stored: %d\n--Relative: %.2f %%\n",
	            colorCode,
	            statusString,
	            label,
	            COLOR_RESET,
	            target.amount,
	            storedAmount,
	            relative)
	    )
	end

    if allFluidsInStock then
        table.insert(consoleOut, "All Requested Fluids are in Stock\n")
    end

    -- Update redstone outputs and log their state
    for side, level in pairs(requiredRedstoneState) do
        RedstoneIO.setOutput(side, level)
        local stateText = (level == REDSTONE_ON) and "on" or "off"
        table.insert(consoleOut, string.format("%s - %s\n", sides[side], stateText))
    end

    -- Clear and print to terminal
    term.clear()
    term.setCursor(1, 1)
    print(table.concat(consoleOut, "")) -- Concatenate the table for final output
end

-- Main execution loop
while true do
    checkFluids()
    event.pull(1, "timer") 
end
