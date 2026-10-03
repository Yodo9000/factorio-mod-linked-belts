local function is_linked_belt_or_ghost(entity)
	if not (entity and entity.valid) then
		return false
	end
	-- entity.status is sometimes nil for ghosts, so check the ghost type instead
	return entity.type == "linked-belt"
		or (entity.name == "entity-ghost" and entity.ghost_type == "linked-belt")
end

-- key of the handler that stores the belt waiting for a partner.
-- ghosts all share the name "entity-ghost", so use the ghost name and keep
-- ghosts in a separate namespace, otherwise different tiers get mixed up.
local function get_handler_key(entity)
	if entity.name == "entity-ghost" then
		return "ghost:" .. entity.ghost_name
	end
	return entity.name
end

local function draw_blocked(entity)
	return rendering.draw_sprite{
		target = entity,
		sprite = "utility/crafting_machine_recipe_not_unlocked",
		surface = entity.surface,
		forces = {entity.force.name},
		only_in_alt_mode = true,
		time_to_live = 600, -- without this the sprite would stay forever and stack up
		x_scale = 0.6, y_scale = 0.6
	}
end

local function draw_link(from_entity, to_entity)
	if from_entity.surface ~= to_entity.surface then
		return
	end
	rendering.draw_line{
		color = {1, 1, 1},
		width = 1,
		from = from_entity,
		to = to_entity,
		surface = to_entity.surface,
		time_to_live = 600,
		forces = {to_entity.force.name},
		only_in_alt_mode = true
	}
end

-- suggestion of Dragonchampion and darkfrei:
-- https://mods.factorio.com/mod/LinkedBelts/discussion/67819aa3bbf12593d52a5a1b
-- returns nil when the pair is allowed, or the reason why it is not
local function link_refused(first_belt, second_belt)
	if first_belt.surface ~= second_belt.surface then
		if settings.global["lb-same-surface-only"].value then
			return "other-surface"
		end
		return nil -- different surfaces have no distance between them
	end

	local max_distance = settings.global["lb-max-distance"].value
	if max_distance <= 0 then
		return nil -- no limit, the way the mod always worked
	end

	local dx = first_belt.position.x - second_belt.position.x
	local dy = first_belt.position.y - second_belt.position.y
	if (dx * dx + dy * dy) > (max_distance * max_distance) then
		return "too-far"
	end
	return nil
end


local function tell(player_index, entity, reason)
	local player = game.get_player(player_index)
	if player then
		player.create_local_flying_text{text = {"linked-belts." .. reason}, position = entity.position}
	end
end


local function get_handler(player_index, key)
	storage.players = storage.players or {}
	local player_data = storage.players[player_index]
	if not player_data then
		player_data = {}
		storage.players[player_index] = player_data
	end
	local handler = player_data[key]
	if not handler then
		handler = {}
		player_data[key] = handler
	end
	return handler
end

local function init_storage()
	storage.players = storage.players or {}
end

script.on_init(init_storage)
script.on_configuration_changed(init_storage)

script.on_event(defines.events.on_built_entity, function(event)
	local entity = event.entity
	if not is_linked_belt_or_ghost(entity) then
		return
	end

	local handler = get_handler(event.player_index, get_handler_key(entity))

	local refused = nil
	if handler.last_belt and handler.last_belt.valid then
		refused = link_refused(handler.last_belt, entity)
	end

	if refused then
		-- out of range: drop the waiting belt and let this one wait instead, so the
		-- player is not stuck with a partner they can never reach
		tell(event.player_index, entity, refused)
		if handler.render_obj and handler.render_obj.valid then
			handler.render_obj.destroy()
		end
		handler.last_belt = nil
		handler.render_obj = nil
	end

	if (not refused) and handler.last_belt and handler.last_belt.valid and not entity.linked_belt_neighbour then
		-- second linked belt
		handler.last_belt.linked_belt_type = "input"
		entity.linked_belt_type = "output"
		entity.connect_linked_belts(handler.last_belt)
		if handler.render_obj and handler.render_obj.valid then
			handler.render_obj.destroy() -- remove the warning that the belt is not linked yet
		end
		draw_link(handler.last_belt, entity)
		handler.last_belt = nil
		handler.render_obj = nil
	elseif not entity.linked_belt_neighbour then
		-- first linked belt
		entity.linked_belt_type = "input"
		if handler.render_obj and handler.render_obj.valid then
			handler.render_obj.destroy() -- the previous belt was removed before it got a partner
		end
		handler.last_belt = entity
		handler.render_obj = rendering.draw_sprite{
			target = entity,
			sprite = "utility/crafting_machine_recipe_not_unlocked",
			surface = entity.surface,
			forces = {entity.force.name},
			only_in_alt_mode = true,
			x_scale = 0.6, y_scale = 0.6,
			tint = {b = 1} -- marks the belt as ready to link
		}
	end
	-- otherwise this is a fast replace, an upgrade or an instant blueprint build,
	-- the connection already exists and must not be touched
end)

script.on_event(defines.events.on_selected_entity_changed, function(event)
	local player = game.get_player(event.player_index)
	if not player then
		return
	end
	local entity = player.selected
	if not is_linked_belt_or_ghost(entity) then
		return
	end
	local neighbour = entity.linked_belt_neighbour
	if neighbour and neighbour.valid then
		draw_link(entity, neighbour)
	end
end)

local function order_deconstruction(entity, player_index)
	if player_index then
		entity.order_deconstruction(entity.force, player_index, 0)
	else
		entity.order_deconstruction(entity.force) -- no player, no undo entry
	end
end

local function cancel_deconstruction(entity, player_index)
	if player_index then
		entity.cancel_deconstruction(entity.force, player_index)
	else
		entity.cancel_deconstruction(entity.force)
	end
end

local function mark_lbn_for_deconstruction(event) -- by heinwintoe
	local entity = event.entity
	if not (entity and entity.valid and entity.type == "linked-belt") then
		return
	end
	local neighbour = entity.linked_belt_neighbour
	if neighbour and neighbour.valid then
		order_deconstruction(neighbour, event.player_index)
	else
		draw_blocked(entity)
	end
end

script.on_event(defines.events.on_player_mined_entity, mark_lbn_for_deconstruction) -- does not undo properly
script.on_event(defines.events.on_marked_for_deconstruction, mark_lbn_for_deconstruction)
script.on_event(defines.events.on_robot_mined_entity, mark_lbn_for_deconstruction) -- no player involved
if defines.events.on_space_platform_mined_entity then
	script.on_event(defines.events.on_space_platform_mined_entity, mark_lbn_for_deconstruction)
end

script.on_event(defines.events.on_cancelled_deconstruction, function(event)
	local entity = event.entity
	if not (entity and entity.valid and entity.type == "linked-belt") then
		return
	end
	local neighbour = entity.linked_belt_neighbour
	if neighbour and neighbour.valid then
		cancel_deconstruction(neighbour, event.player_index)
	else
		draw_blocked(entity)
	end
end)
