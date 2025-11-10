local component = require("component")
local term = require("term")
local event = require("event")

-- Component proxies
local MeController = component.me_controller

-- Main Loop
local function monitorCrafts()
	term.clear()
    term.setCursor(1, 1)
    print("Items beeing Crafted:")
    print("###############################")

    for i, Cpu in pairs(MeController.getCpus()) do
        if Cpu.busy == true then
            local finalOutputTable = Cpu.cpu.finalOutput()
            if finalOutputTable ~= nil then
                print("Item:   ",finalOutputTable.label)
                print("Amount: ",finalOutputTable.size)
                print("-------------------------------")
            end
        end
    end
end

-- Main execution
while true do
	monitorCrafts()
	event.pull(1, "timer")
end

