function getIntersection(ray, segment)
	-- Ray: point + dir * T1
	r_px = ray.a.x
	r_py = ray.a.y
	r_dx = ray.b.x - ray.a.x
	r_dy = ray.b.y - ray.a.y

	-- Segmento = point + dir * T2
	s_px = segment.a.x
	s_py = segment.a.y
	s_dx = segment.b.x - segment.a.x
	s_dy = segment.b.y - segment.a.y

	-- Son paralelos? si es así, intersecta
	r_mag = math.sqrt(r_dx * r_dx + r_dy * r_dy)
	s_mag = math.sqrt(s_dx * s_dx + s_dy * s_dy)
	if r_dx / r_mag == s_dx / s_mag and r_dy / r_mag == s_dy / s_mag then
		return nil
	end

	--Resolver T1 y T2
	T2 = (r_dx * (s_py - r_py) + r_dy * (r_px - s_px)) / (s_dx * r_dy - s_dy * r_dx)
	T1 = (s_px + s_dx * T2 - r_px) / r_dx

	--Tiene que estar dentro del res parametrico para ray / segmento
	if T1 < 0 then return nil end
	if T2 < 0 or T2 > 1 then return nil end

	--retorna el punto de intersección
	return {
		x = r_px + r_dx * T1,
		y = r_py + r_dy * T1,
		param = T1
	}
end
--variables 
center = {
	x = love.graphics.getWidth() / 2,
	y = love.graphics.getHeight() / 2
}