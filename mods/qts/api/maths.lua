



function qts.nearly_equal(a, b, degree)
	return (a >= b-degree and a <= b+degree)
end

function qts.nearly_equal_vec(a, b, degree)
	if not degree then degree = 0.001 end
	return (qts.nearly_equal(a.x, b.x, degree) and qts.nearly_equal(a.y, b.y, degree) and qts.nearly_equal(a.z, b.z, degree))
end
vector.nearly_equal = qts.nearly_equal_vec

function qts.nearly_equal_vec_xz(a, b, degree)
	if not degree then degree = 0.001 end
	return (qts.nearly_equal(a.x, b.x, degree) and qts.nearly_equal(a.z, b.z, degree))
end
vector.nearly_equal_xz = qts.nearly_equal_vec_xz

function qts.rotateVectorYaw(vec, angle)
	return {x = (vec.x * math.cos(angle) - vec.z * math.sin(angle)), y = vec.y, z = (vec.x * math.sin(angle) + vec.z * math.cos(angle))}
end
vector.rotate_yaw = qts.rotateVectorYaw