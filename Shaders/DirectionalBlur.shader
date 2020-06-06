shader_type canvas_item;
render_mode blend_mix;

uniform float angle_degrees ;
uniform sampler2D noise;
uniform int Samples = 8; //MUST BE A MULTIPLE OF 2
uniform float strength : hint_range(0,1.0, 0.0001);

uniform sampler2D emission_teture;
uniform vec4 glow_color : hint_color = vec4(1.0);

//	Directional Blur Shader
// Adapted from https://www.shadertoy.com/view/ldBXWG

vec4 DirectionalBlur(in vec2 uv, in vec2 MotionVector, in sampler2D Texture)
{
    vec4 Color = vec4(0.0);  
    float Noise = texture(noise,uv*20.0).x-0.485;
 
    for (int i=1; i<=Samples/2; i++)
    {
	Color += texture(Texture,uv+ (float(i)*MotionVector ) /float(Samples/2)*Noise*2.0);
	Color += texture(Texture,uv- (float(i)*MotionVector ) /float(Samples/2)*Noise*2.0);
    }    
    return Color/(float(Samples));    
}


void fragment(){
	vec2 blur_vector = vec2(cos(radians(angle_degrees)),sin(radians(angle_degrees)))*strength;
	COLOR=DirectionalBlur(UV, blur_vector*strength, TEXTURE);
	vec4 current_color = texture(TEXTURE,UV); // what's our current sprite pixel
	vec4 emission_color = texture(emission_teture,UV); // what's our current emission pixel
	
	if(emission_color.r > 0f) // check if we're not black in the emission color.
	{
		COLOR = (emission_color + glow_color) + DirectionalBlur(UV, blur_vector*strength, TEXTURE)// add brightness corrosponding with the emission pixel
	}
	else
	{
		COLOR = current_color + DirectionalBlur(UV, blur_vector*strength, TEXTURE); // we arent over an emission pixel leave alone
	}
	
}