function findFirstItemSlot(name)
    for slot=1,16
    do
        local item = turtle.getItemDetail(slot)
        if item and item.name == name then
            return slot
        end
    end
    return nil
end

function requireFuel(requiredFuel)
    while requiredFuel > turtle.getFuelLevel()
    do
        local slot = nil
        repeat
            slot = findFirstItemSlot("minecraft:coal")
            if not slot then
                print("Couldn't find any coal")
                sleep(5)
            end
        until slot
        local originalSlot = turtle.getSelectedSlot()
        turtle.select(slot)
        turtle.refuel()
        turtle.select(originalSlot)
    end
end

function requireTorches(requiredTorches)
    local totalTorches = nil
    repeat
        totalTorches = 0
        for slot=1,16
        do
            local item = turtle.getItemDetail(slot)
            if item and item.name == "minecraft:torch" then
                totalTorches = totalTorches + turtle.getItemCount(slot)
            end
        end
        if requiredTorches <= totalTorches then
            print("I only have " + totalTorches + " available")
            sleep(5)
        end
    until requiredTorches <= totalTorches
end

function tunnel(length, callback)
    for i=0,length
    do
        if turtle.detect() then
            turtle.dig()
        end
        turtle.forward()
        if turtle.detectUp() then
            turtle.digUp()
        end
        if callback then callback(i) end
    end
end

function branch()
    local desiredTunnelLength = 12*11
    local function placeTorch(position)
        if position % 11 == 0 then
            turtle.turnLeft()
            requireTorches(1)
            local slot = findFirstItemSlot("minecraft:torch")
            if slot  then
                local originalSlot = turtle.getSelectedSlot()
                turtle.select(slot)
                if not turtle.placeUp() then
                    print("Couldn't place torch")
                end
                turtle.select(originalSlot)
            end
            turtle.turnRight()
        end
    end
    tunnel(desiredTunnelLength, placeTorch)
    for i=desiredTunnelLength,0,-1
    do
        turtle.back()
    end
end

while (true)
do
    tunnel(3, function(position)
        if position % 3 == 0 then
            turtle.turnRight()
            branch()
            turtle.turnLeft()
            turtle.turnLeft()
            branch()
            turtle.turnRight()
        end
    end)
end
