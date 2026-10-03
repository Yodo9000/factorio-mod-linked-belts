-- other mods may still change belt speeds in data-final-fixes, keep the linked
-- belts in sync and make sure no upgrade target points at a missing prototype

local linked_belts = data.raw["linked-belt"]

for _, prototype in pairs(linked_belts) do
  local source_name = prototype.linked_belts_source
  local source = source_name and data.raw["underground-belt"][source_name]
  if source then -- skips the vanilla linked belt, it has no source
    prototype.speed = source.speed
  end
end

for name, prototype in pairs(linked_belts) do
  if prototype.next_upgrade then
    local target = linked_belts[prototype.next_upgrade]
    if not target or prototype.next_upgrade == name or target.speed <= prototype.speed then
      prototype.next_upgrade = nil
    end
  end
end
