function love.load()
	require 'util'
	require 'polygons'
	polygons_load()
	love.graphics.setBackgroundColor(255,255,255)
end

function love.update(dt)
	--Obtener todos los puntos únicos
	points = {}
	for i,v in ipairs(segments) do
		table.insert(points,v.a)
		table.insert(points,v.b)
	end

	uniquePoints = remove_duplicates(points)

	pointAngles = {}
	for i,v in ipairs(uniquePoints) do
		local angle = math.atan2(v.y - love.mouse.getY(), v.x - love.mouse.getX())
		print(angle)
		table.insert(pointAngles,angle - 0.0001)
		table.insert(pointAngles,angle)
		table.insert(pointAngles,angle + 0.0001)
	end

	--Lista de intersecciones
	intersects = {}

	--ciclo de cada ray
	for i,angle in ipairs(pointAngles) do
		--Calculamos el centro desde el mouse
		dx = math.cos(angle)
		dy = math.sin(angle)

		-- Rayo del centro hacia afuera en dirección al mouse
		ray = {
			a = {x = love.mouse.getX(), y = love.mouse.getY()},
			b = {x = love.mouse.getX() + dx, y = love.mouse.getY() + dy}
		}

		--Encontrar intersecciones
		closestIntersect = nil
		for _,v in ipairs(segments) do
			intersect = getIntersection(ray, v)
			if intersect then 
				if not closestIntersect or intersect.param < closestIntersect.param then
					closestIntersect = intersect
				end
			end
		end
		--Añadimos la intersección a la lista
		if closestIntersect then
			closestIntersect.angle = angle
			table.insert(intersects, closestIntersect)
		end
	end

	--Ordenar por angulo
	table.sort(intersects, function(a, b)
		return a.angle < b.angle
	end)

	--Prueba para el dibujado del poligono
	m = {}
	for i,v in ipairs(intersects) do
		table.insert(m,v.x)
		table.insert(m,v.y)
	end
end

function love.draw()
	love.graphics.setColor(70,160,250)
	--Shadow polygon
	--love.graphics.polygon("fill",m)

	--dibujar debugging y poligonos
	love.graphics.setColor(220,90,90)
	for i,v in ipairs(intersects) do
		love.graphics.ellipse("fill",v.x,v.y,5,5)
		love.graphics.line(love.mouse.getX(), love.mouse.getY(), v.x, v.y)
	end

	love.graphics.setColor(0,0,0)
	for i=1,#m,2 do
		love.graphics.ellipse("fill",m[i],m[i+1],2,2)
	end

	love.graphics.setColor(200,200,200)
	for i,v in ipairs(segments) do
		love.graphics.line(v.a.x, v.a.y, v.b.x, v.b.y)
	end
	
end

function remove_duplicates(tab)
	t = tab
	for i,v in ipairs(t) do
		for j,w in ipairs(t) do
			if v == w then
				table.remove(t,i)
				break
			end
		end
	end
	return t
end