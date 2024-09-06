/*
 * HPack: "Gradient Fade - Bottom" shader
 *
 * Fades a texture to translucent at the bottom.
 * Good for fading stuff into the void w/sky floors.
 */

vec4 Process(vec4 color)
{
	vec2 texCoord = vTexCoord.st;

	vec4 fadecolor = color;
	fadecolor.a = clamp(1.0 - texCoord.y, 0.0, 1.0);

	return getTexel(texCoord) * fadecolor;
}
