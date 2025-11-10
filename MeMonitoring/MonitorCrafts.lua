local component = require("component")
local term = require("term")
local event = require("event")

-- Component proxies
local MeController = component.me_controller
local Gpu = component.gpu

-- Main Loop
local function monitorCrafts()
	local LinesToClear = 30
    term.setCursor(1, 3)

    for i, Cpu in pairs(MeController.getCpus()) do
        if Cpu.busy == true then
            local finalOutputTable = Cpu.cpu.finalOutput()
            if finalOutputTable ~= nil then
				LinesToClear=LinesToClear-3
				term.clearLine()
                print("Item:   ",finalOutputTable.label)
				term.clearLine()
                print("Amount: ",finalOutputTable.size)
                print("--------------------------------------------------")
            end
        end
    end

	for i = 0, LinesToClear do print("                                                  ") end
end

-- Main execution
term.clear()

print("Items beeing Crafted:")
print("##################################################")
Gpu.setResolution(50,50)

while true do
	monitorCrafts()
	event.pull(1, "timer")
end

