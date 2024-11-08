
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
		
		local handler = storage.players[player_index][name] -- unique for player and linked belt
		
		if (handler.last_belt and handler.last_belt.valid) 
			and not (entity.linked_belt_neighbour) -- sometimes already linked 0_o
			then
			
			-- second linked belt
			handler.last_belt.linked_belt_type = "input"
			entity.linked_belt_type = "output"
			entity.connect_linked_belts(handler.last_belt)
			--rendering.destroy(handler.rid) -- I'm not sure what this is supposed to do, destroy a LuaRendering/LuaRenderObject before creating any? So I removed it.
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
			handler.rid=nil
		elseif not (entity.linked_belt_neighbour) then
			-- first linked belt
			entity.linked_belt_type = "input"
			handler.last_belt = entity
			handler.rid = rendering.draw_sprite{
				target=entity,
				sprite="utility/crafting_machine_recipe_not_unlocked",
				surface=entity.surface,
				forces={entity.force.name},
				only_in_alt_mode=true,
				x_scale=0.6, y_scale=0.6
			}
		else -- fast replace
			game.print ('fast replace')
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






