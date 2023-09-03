#version 460 core

#include<flutter/runtime_effect.glsl>

#define border_size .1// The size of the randomness in the border, the larger the value, the more random and wider the border
#define particles_amount .5// The amount of floating particles [0-1], the smaller the value, the more particles
#define border_position .5// The position of the border
#define darkness_start_position .7// The position of the darkness [border_position-1] where the darkness starts to appear, the larger the value, the sooner the darkness appears
#define darkness_color .3// The color of the darkness, the smaller the value, the darker the darkness
#define particals_effect_length_position .7// The length of the floating particles, the smaller the value, the longer the floating particles

uniform vec2 resolution;
uniform float iTime;
uniform sampler2D imageTexture;

out vec4 fragColor;

float hash(float x,float y){
    return fract(sin(dot(vec2(x,y),vec2(12.4139,53.1237)))*52381.1341);
}
float hash2(float x,float y){
    return fract(sin(dot(vec2(x,y),vec2(14.523,127.485)))*2578.316);
}

vec4 disappearing_color(vec3 texColor,vec3 darkness,float border,float opacity_from_border,float original_alpha){
    float darkness_level=smoothstep(darkness_start_position,border_position-.1,border)*original_alpha;
    return vec4(mix(texColor,darkness,darkness_level)*opacity_from_border,opacity_from_border*original_alpha);
}

vec4 particals_effect_color(vec2 uv,float deltaTime,vec3 darkness,float opacity_from_border){
    vec4 texColor=texture(imageTexture,uv);
    float original_alpha=texColor.a;
    float x=uv.x;
    float y=uv.y;
    float border=x+y-deltaTime+hash(x,y)*border_size;
    float opacity_particals_effect=smoothstep(border_position-.1,particals_effect_length_position,border*2)*original_alpha*(1.-opacity_from_border)*step(particles_amount,hash2(x,y));
    return vec4(darkness*opacity_particals_effect,opacity_particals_effect);
}

void main()
{
    vec2 uv=FlutterFragCoord().xy/resolution.xy;
    vec4 texColor=texture(imageTexture,uv);
    vec3 darkness=vec3(darkness_color);
    float original_alpha=texColor.a;
    float deltaTime=iTime*3.-.55;
    float x=uv.x;
    float y=uv.y;
    float border=x+y-deltaTime+hash(x,y)*border_size;
    float opacity_from_border=step(border_position,border);
    
    fragColor=disappearing_color(texColor.rgb,darkness,border,opacity_from_border,original_alpha);
    
    float delta=smoothstep(border_position,1.,1.-border)/10.;
    vec2 uv_particle=vec2(x,y)+vec2(sin(delta*delta)-delta,delta);
    fragColor+=particals_effect_color(uv_particle,deltaTime,darkness,opacity_from_border);
}
