/*
 * HPack: "Waterfall" shader
 *
 * Basically a scroll-down shader. Seems redundant
 * on its own, but it's mainly meant to be used
 * alongside the hp_gradientfall shaders.
 */

uniform float timer;

vec4 Process(vec4 color)
{
	vec2 texCoord = vTexCoord.st;
	ivec2 texSize = textureSize(tex, 0);

	texCoord.y = mod(texCoord.y - (timer / texSize.y), 1.0);

	return getTexel(texCoord) * color;
}
