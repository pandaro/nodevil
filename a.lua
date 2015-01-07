a={}
a.colour=tostring(math.random(5))..'.png'
a.replace=function (pos,top)
	minetest.remove_node(pos)
	minetest.add_node(top, {name="a:core",param2=to_face})
	return
end
a.pos6=function(pos)
	local sides={}
	sides.u={x=pos.x,y=pos.y+1,z=pos.z}
	sides.d={x=pos.x,y=pos.y-1,z=pos.z}
	sides.n={x=pos.x,y=pos.y,z=pos.z+1}
	sides.s={x=pos.x,y=pos.y,z=pos.z-1}
	sides.e={x=pos.x+1,y=pos.y,z=pos.z}
	sides.w={x=pos.x-1,y=pos.y,z=pos.z}
	return sides
end
minetest.register_node("a:core",{
	drawtype="normal",
	tiles={a.colour,a.colour,a.colour,a.colour,"ummface.png",a.colour},
	paramtype2="facedir",
	groups = {cracky=3, stone=1,},
	light_source = 5,
	on_construct=function(pos)
		print(tostring('on_construct'))
		local meta=minetest.get_meta(pos)
		meta:set_int('status',0)
	end,
	on_punch=function(pos)
		minetest.remove_node(pos)
	end,
}) 

minetest.register_abm({
nodenames={"a:core"},
neighbors={'air'},
interval=1,
chance=1,

	action=function(pos, node, active_object_count, active_object_count_wider)
	print(tostring('neighbors: ')..dump(neighbors))
	a.colour=tostring(math.random(5))..'.png'
	minetest.override_item("a:core", {light_source=math.random(0,1)})
	local meta=minetest.get_meta(pos)
	local status=meta:get_int('status')
	if status==1 then
		print(tostring('££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££'))
		local target=minetest.get_objects_inside_radius(pos, 20)
		if target[1] then target=target[1]:getpos() end
		local nodes=minetest.find_nodes_in_area({x=pos.x-1,y=pos.y-1,z=pos.z-1}, {x=pos.x+1,y=pos.y+1,z=pos.z+1},"air")
		local valid={}
			for i,v in pairs(nodes) do
				local grip=a.pos6(v) 
				for ii,vv in pairs(grip) do
					local name=minetest.get_node(vv).name
					local walk=minetest.registered_nodes[name].walkable
					if walk==true and name ~='a:core' then
						table.insert(valid,v)
						break
					end
				
				end	
			end
		local top=nil
		for i,v in pairs(valid) do
			if target.x then
				if top==nil  then
					top=v 
				else
					if vector.distance(v,target)<vector.distance(top,target	) then
						top=v
					end
				end
			else
				return
			end	
		end
		local to_dir=vector.direction(pos,top)
		to_face=minetest.dir_to_facedir(to_dir)
		for i= 1,1 do
			a.replace(pos,top)
			break
		end	
	elseif	status==0 then
		
		meta:set_int('status',1)
				
	end
	end,	
})