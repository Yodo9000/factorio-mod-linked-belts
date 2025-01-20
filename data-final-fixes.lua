for _, prototype in pairs(data.raw["linked-belt"]) do
    ug_prototype = data.raw["underground-belt"][string.sub(prototype.name, 8, -1)]
    if ug_prototype then -- skip the vanilla linked belt
        prototype.speed = ug_prototype.speed -- check if speed is still the same as the normal underground (some mods update the speed)
        if ug_prototype.next_upgrade then
            prototype.next_upgrade = "linked-"..ug_prototype.next_upgrade --some mods add the upgrade later for some reason; can cause a loading error if this entity was not added due to matching speed
        end
    end
end