/*
 * HPack: "Gradient Fall - Bottom" shader
 *
 * Fades a texture to translucent at the bottom,
 * and scrolls it like a waterfall. Basically
 * just a combo of hp_waterfall and hp_gradientfade.
 */

uniform float timer;

vec4 Process(vec4 color)
{
	vec2 texCoord = vTexCoord.st;
	ivec2 texSize = textureSize(tex, 0);

	// fade
	vec4 fadecolor = color;
	fadecolor.a = clamp(1.0 - texCoord.y, 0.0, 1.0);

	// fall
	texCoord.y = mod(texCoord.y - (timer / texSize.y), 1.0);

	return getTexel(texCoord) * fadecolor;
}
