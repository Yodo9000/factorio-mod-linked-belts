for _, prototype in pairs(data.raw["linked-belt"]) do
    ug_prototype = data.raw["underground-belt"][string.sub(prototype.name, 8, -1)]
    if ug_prototype then -- skip the vanilla linked belt
        prototype.speed = ug_prototype.speed -- check if speed is still the same as the normal underground (some mods update the speed)
    end
end