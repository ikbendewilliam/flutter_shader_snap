#version 460 core

#include<flutter/runtime_effect.glsl>

#define split_amount 4// The size of the split, the larger the value, the wider the particles will be
#define border_size .1// The size of the randomness in the border, the larger the value, the more random and wider the border
#define particles_amount .0// The amount of floating particles [0-1], the smaller the value, the more particles
#define border_position .5// The position of the border
#define particals_effect_length_position .8// The length of the floating particles, the smaller the value, the longer the floating particles

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
float hash3(float x,float y){
    return fract(sin(dot(vec2(x,y),vec2(54.342,53.124)))*21341.234);
}

vec4 particals_effect_color(vec2 uv,float deltaTime,float opacity_from_border){
    vec4 texColor=texture(imageTexture,vec2(1-uv.x,uv.y));
    float original_alpha=texColor.a;
    float x=uv.x;
    float y=uv.y;
    float border=x+x-deltaTime+hash(x,y)*border_size;
    float opacity_particals_effect=smoothstep(border_position-.1,particals_effect_length_position,border*2)*original_alpha*(1.-opacity_from_border)*step(particles_amount,hash2(x,y));
    return vec4(texColor.rgb*opacity_particals_effect,opacity_particals_effect);
}

void main()
{
    vec2 uv=FlutterFragCoord().xy/resolution.xy;
    vec4 texColor=texture(imageTexture,uv);
    float original_alpha=texColor.a;
    float deltaTime=iTime*3.-.55;
    float x=1-uv.x;
    float y=uv.y;
    float border=x+x-deltaTime+hash(x,y)*border_size;
    float opacity_from_border=step(border_position,border);
    
    fragColor=vec4(texColor.rgb*opacity_from_border,opacity_from_border*original_alpha);
    
    float delta=smoothstep(border_position,1.,1.-border)/10.;
    vec2 uv_particle=vec2(x+delta*.3,y+delta*split_amount*(hash3(x,y)-.5));
    fragColor+=particals_effect_color(uv_particle,deltaTime,opacity_from_border);
}
