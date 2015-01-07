func={}
func.replace=function (pos,top)
	minetest.remove_node(pos)
	minetest.add_node(top, {name="a:core",param2=to_face})
	return
end

func.pos6=function(pos)
	local sides={}
	sides.u={x=pos.x,y=pos.y+1,z=pos.z}
	sides.d={x=pos.x,y=pos.y-1,z=pos.z}
	sides.n={x=pos.x,y=pos.y,z=pos.z+1}
	sides.s={x=pos.x,y=pos.y,z=pos.z-1}
	sides.e={x=pos.x+1,y=pos.y,z=pos.z}
	sides.w={x=pos.x-1,y=pos.y,z=pos.z}
	return sides
end

func.top_pos(pos,list,target,)
	local top=nil
	for i,v in pairs(list) do
		if target.x then
			if top==nil  then
				top=v 
			else
				if vector.distance(v,target)<vector.distance(top,target	) then
					top=v
				end
			end
		else
			return 'no taget avaible'
		end	
	end
	return top
end

func.player_target=function(pos)
	local target=nil
	local players=minetest.get_connected_players()
	if table.getn(a)=0 then return 0 end
	for i,v in pairs(players) do
		local player=v:getpos()
		local dist=vector.distance(pos,player)
		if target==nil then
			target=v
		elseif dist<vector.distance(pos,target) then
			target=v
		end
	end
end

func.to_facedir=function(pos,target)
	local to_dir=vector.direction(pos,target)
	local to_face=minetest.dir_to_facedir(to_dir)
end