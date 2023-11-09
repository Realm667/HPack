/*
 * HPack: "Dripple Warp" shader, for H4M8's end sky
 *
 * Basically a quick edit of GZDoom's default warp shader,
 * but a bit less intense and with a clamp on the upper
 * part of the texture so it doesn't leak the sky up top.
 */

uniform float timer;
vec4 Process(vec4 color)
{
	vec2 texCoord = gl_TexCoord[0].st;
	const float pi = 3.14159265358979323846;
	vec2 offset = vec2(0,0);
	offset.y = max(sin(pi * 2.0 * (texCoord.x + timer * 0.125)) * 0.05, 0.0);
	offset.x =     sin(pi * 2.0 * (texCoord.y + timer * 0.125)) * 0.05;
	texCoord += offset;
	return getTexel(texCoord) * color;
}
