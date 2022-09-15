function requireFuel(requiredFuel)
    if requiredFuel > turtle.getFuelLevel() then
        for slot=1,16
        do
            local item = turtle.getItemDetail(slot)
            if item and item.name == "minecraft:coal" then
                local originalSlot = turtle.getSelectedSlot()
                turtle.select(slot)
                turtle.refuel()
                turtle.select(originalSlot)
            end
        end
    end
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
            for slot=1,16
            do
                local item = turtle.getItemDetail(slot)
                if item and item.name == "minecraft:torch" then
                    turtle.turnLeft()
                    local originalSlot = turtle.getSelectedSlot()
                    turtle.select(slot)
                    turtle.placeUp()
                    turtle.select(originalSlot)
                end
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
