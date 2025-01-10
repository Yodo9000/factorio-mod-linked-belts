local function draw_blocked(entity)
	return rendering.draw_sprite{
		target=entity,
		sprite="utility/crafting_machine_recipe_not_unlocked",
		surface=entity.surface,
		forces={entity.force.name},
		only_in_alt_mode=true,
		x_scale=0.6, y_scale=0.6
	}
end

local function mark_lbn_for_deconstruction(event) -- By heinwintoe
	--game.print(event.name) -- event id
    local entity = event.entity
    if entity and entity.valid then
        if entity.type == "linked-belt" then
            local lbn = entity.linked_belt_neighbour
            if lbn then
                --Mark linked belt neighbour for deconstruction
                lbn.order_deconstruction(lbn.force, event.player_index)
			else
				draw_blocked(entity) --might be superfluous
			end
        end
    end
end

script.on_init(function(data)
	storage.players = {} --for storing mod data per player
end)


script.on_event(defines.events.on_built_entity, function(event)
	local entity = event.entity
	local player_index = event.player_index
	if entity.type == "linked-belt" then
		
		local name = entity.name
		
		if not storage.players[player_index] then
			storage.players[player_index] = {}
		end
		if not storage.players[player_index][name] then
			storage.players[player_index][name] = {}
		end
		
		local handler = storage.players[player_index][name] -- unique for player and linked belt tier
		
		if handler.last_belt and handler.last_belt.valid and not entity.linked_belt_neighbour then -- sometimes already linked 0_o
			-- second linked belt
			handler.last_belt.linked_belt_type = "input"
			entity.linked_belt_type = "output"
			entity.connect_linked_belts(handler.last_belt)
			handler.render_obj.destroy() -- destroy the warning that the linked-belt is not linked yet.
			if entity.surface == handler.last_belt.surface then
				rendering.draw_line{
					color={1,1,1},
					width=1,
					from=handler.last_belt,
					to=entity,
					surface=entity.surface,
					time_to_live=600,
					forces={entity.force.name},
					only_in_alt_mode=true
				}
			end
			handler.last_belt=nil
			handler.render_obj=nil
		elseif not entity.linked_belt_neighbour then
			-- first linked belt
			entity.linked_belt_type = "input"
			handler.last_belt = entity
			handler.render_obj = rendering.draw_sprite{
				target=entity,
				sprite="utility/crafting_machine_recipe_not_unlocked",
				surface=entity.surface,
				forces={entity.force.name},
				only_in_alt_mode=true,
				x_scale=0.6, y_scale=0.6,
				tint = {b=1} -- to mark that it is ready to link
			}
		else --[[ fast replace or upgrade or instant-blueprint-building
			game.print('fast replace or upgrade or paste')
			game.print(entity.name)
			game.print(entity.linked_belt_neighbour.name)
			local link_entity = entity.linked_belt_neighbour
			if link_entity.name ~= entity.name then
				game.print(link_entity.surface.create_entity{name=entity.name, position=link_entity.position, direction=link_entity.direction, fast_replaceable=true, player=player_index}) -- works for paste, but not if entity has been upgraded
			end]]
		end
	end
end)

script.on_event(defines.events.on_selected_entity_changed, function(event)
--Called after the selected entity changes for a given player.

--Contains
--player_index :: uint: The player whose selected entity changed.
--last_entity :: LuaEntity (optional): The last selected entity if it still exists and there was one.
	local player_index = event.player_index
	local player = game.players[player_index]
	local entity = player.selected
	if entity and entity.valid then
		if entity.type == "linked-belt" then
			local lbn = entity.linked_belt_neighbour
			if lbn and lbn.surface == entity.surface then
				rendering.draw_line{
					color={1,1,1},
					width=1,
					from=entity,
					to=lbn,
					surface=entity.surface,
					time_to_live=600,
					forces={entity.force.name},
					only_in_alt_mode=true
				}
			end
		end
	end
end)

script.on_event(defines.events.on_player_mined_entity, mark_lbn_for_deconstruction) -- doesn't undo properly
script.on_event(defines.events.on_marked_for_deconstruction, mark_lbn_for_deconstruction)
script.on_event(defines.events.on_robot_mined_entity, mark_lbn_for_deconstruction) -- doesn't undo properly, no player involved!
 -- should also be called for .on_space_platform_mined_entity ?

script.on_event(defines.events.on_cancelled_deconstruction, function(event) 
	local entity = event.entity
	if entity and entity.valid then
        if entity.type == "linked-belt" then
            local lbn = entity.linked_belt_neighbour
            if lbn then
                lbn.cancel_deconstruction(lbn.force, event.player_index)
			else
				draw_blocked(entity)
            end
        end
    end
end)

--[[
local upgrade_locks = {tick=nil, locked_entities={}}
script.on_event(defines.events.on_marked_for_upgrade, function(event)
	local entity = event.entity
	if entity and entity.valid then
        if entity.type == "linked-belt" then
            local lbn = entity.linked_belt_neighbour
            if lbn then
				local lbn_upgrade_target, lbn_upgrade_qual = lbn.get_upgrade_target()
				local is_lbn_marked_for_upgrade = lbn.is_registered_for_upgrade()
				local is_lbn_marked_for_upgrade = lbn.to_be_upgraded()
				lbn_upgrade_target =  not is_lbn_marked_for_upgrade or lbn_upgrade_target.name -- will change to true if nil, but I don't think this matters
				lbn_upgrade_qual   =  not is_lbn_marked_for_upgrade or lbn_upgrade_qual.name   -- will change to true if nil, but I don't think this matters
				if lbn_upgrade_target ~= event.target.name and lbn_upgrade_qual ~= event.quality.name then
            	    lbn.order_upgrade{target=event.target, force=lbn.force, player=event.player_index}
				end
            end
        end
    end
end)

script.on_event(defines.events.on_cancelled_upgrade , function(event)
	local entity = event.entity
	if entity and entity.valid then
        if entity.type == "linked-belt" then
            local lbn = entity.linked_belt_neighbour
            if lbn and lbn.name == entity.name and lbn.quality == entity.quality then
                lbn.cancel_upgrade(lbn.force, event.player_index)
			else
				lbn.order_upgrade{target=entity, force=lbn.force, player=event.player_index, item_index=0} -- in cases where lbn already been upgraded, order a downgrade
			end
        end
    end
end)]]